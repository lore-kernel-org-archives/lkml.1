Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbXLFInr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbXLFInr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 03:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbXLFInh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 03:43:37 -0500
Received: from mout2.freenet.de ([195.4.92.92]:39859 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbXLFIng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 03:43:36 -0500
Message-ID: <4757B62F.2040608@de.ibm.com>
Date: Thu, 06 Dec 2007 09:43:27 +0100
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: carsteno@de.ibm.com, Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] ext2: xip check fix
References: <20071204042628.GA26636@wotan.suse.de> <200712041054.51599.borntraeger@de.ibm.com> <20071204101009.GB9618@wotan.suse.de> <20071204112100.GA20420@wotan.suse.de> <20071204112327.GB20420@wotan.suse.de> <4756C714.2040809@de.ibm.com> <20071205233345.GB5617@wotan.suse.de>
In-Reply-To: <20071205233345.GB5617@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Warning: de.ibm.com is listed at abuse.rfc-ignorant.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>> Xip does only work, if both do match PAGE_SIZE because it 
>> does'nt support multiple calls to direct_access in the get_xip_page 
>> address space operation. Thus we check both here, actually this was 
>> changed from how it looks after your patch as a bugfix where our 
>> tester tried a 4k filesystem on a 2k blockdev.
>> Did I miss something?
> 
> However, the bdev block size may be changed with sb_set_blocksize. It
> doesn't actually have to match the hardware sector size -- if this
> does matter for XIP, then I think you need some other check here.
Hmmmmhh. For a bdev with PAGE_SIZE hardsect size, there is no other 
valid value then PAGE_SIZE that one could set it to. Or can it indeed 
be changed to a value greater then PAGE_SIZE or smaller then hardsect 
size?

