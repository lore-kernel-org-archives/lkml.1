Return-Path: <linux-kernel-owner+w=401wt.eu-S1030298AbXFHIKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030298AbXFHIKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939986AbXFHH70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:59:26 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:56433 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939991AbXFHH7Z (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:59:25 -0400
Message-ID: <46690C58.7090304@de.ibm.com>
Date: Fri, 08 Jun 2007 09:59:20 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, carsteno@de.ibm.com,
       Jared Hulbert <jaredeh@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <4666DD88.5030708@de.ibm.com> <20070606162305.GA20600@infradead.org> <46683B6A.6030306@de.ibm.com> <20070607193844.GB17144@infradead.org> <4669027E.3070406@de.ibm.com> <20070608072609.GA13115@infradead.org> <46690A39.3010402@de.ibm.com> <20070608075717.GA16927@infradead.org>
In-Reply-To: <20070608075717.GA16927@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> Jared's patch currently does ioremap on mount (and no iounmap at all).
> That mapping needs to move from the filesystem to the device driver.
The device driver needs to do ioremap on open(), and iounmap() on 
release. That's effectively what our block driver does.
