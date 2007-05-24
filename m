Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbXEXG5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbXEXG5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 02:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbXEXG5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 02:57:12 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:60446 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbXEXG5L (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 02:57:11 -0400
Message-ID: <46553744.4000403@de.ibm.com>
Date: Thu, 24 May 2007 08:57:08 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jared Hulbert <jaredeh@gmail.com>
CC: carsteno@de.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <1179871779.24163.11.camel@localhost.localdomain> <20070522154905.1d7e8a2e.akpm@linux-foundation.org> <4653F264.1030807@de.ibm.com> <6934efce0705231021x6cc45c61kf253eae185504611@mail.gmail.com>
In-Reply-To: <6934efce0705231021x6cc45c61kf253eae185504611@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
>> To me, it looks like this
>> work can be modified to use filemap_xip.
> 
> How?
First, get a struct page behind the subject file system image. A good 
idea to get there is to use vmem_map, which allows have a 
discontiguous mem_map array in virtual storage. Then add the memory 
segment's address range to it. Sparsemem also helps, if vmem_map is 
not available.

Second, implement get_xip_page for this file system. This address 
space operation needs to be provided for all files that are supposed 
to be XIP. readpage(s)/writepage(s) should not be provided for these 
files, becuase they rely on using the page cache.

Third, use file operations from mm/filemap_xip.c.

so long,
Carsten
