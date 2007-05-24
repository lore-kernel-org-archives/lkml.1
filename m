Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbXEXGq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbXEXGq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 02:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbXEXGqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 02:46:21 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:16485 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbXEXGqV (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 02:46:21 -0400
Message-ID: <465534B9.2030105@de.ibm.com>
Date: Thu, 24 May 2007 08:46:17 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: richard.griffiths@windriver.com
CC: carsteno@de.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <1179871779.24163.11.camel@localhost.localdomain> <20070522154905.1d7e8a2e.akpm@linux-foundation.org> <4653F264.1030807@de.ibm.com> <1179933916.8223.5.camel@localhost.localdomain>
In-Reply-To: <1179933916.8223.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Griffiths (wrs) wrote:
> One question I have is the difference in the two models. If I understand
> correctly the filemap_xip expects the ext2 to mount as XIP while the
> Linear Cramfs only enables XIP for apps that have the sticky bit set.
> Hence the Application XIP moniker.
> Does the filemap_xip expect the entire filesystem is XIP?
The file operations from filemap_xip are only effective if the struct 
file_operations vector refers to them (see ext2_xip_file_operations in 
fs/ext2/file.c as example). In oder to function proper, the 
corresponding address_space_operations vector needs to provide an 
implementation of get_xip_page (see ext2_get_xip_page in 
fs/ext2/xip.c). Both vectors are per inode, one can chose to have XIP 
for individual files in a file system.

so long,
Carsten
