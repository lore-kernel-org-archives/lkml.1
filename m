Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbXLFJ7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbXLFJ7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 04:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXLFJ7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 04:59:13 -0500
Received: from mout0.freenet.de ([195.4.92.90]:36606 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbXLFJ7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 04:59:12 -0500
Message-ID: <4757C7E6.7050405@de.ibm.com>
Date: Thu, 06 Dec 2007 10:59:02 +0100
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
References: <20071204042628.GA26636@wotan.suse.de> <200712041054.51599.borntraeger@de.ibm.com> <20071204101009.GB9618@wotan.suse.de> <20071204112100.GA20420@wotan.suse.de> <20071204112327.GB20420@wotan.suse.de> <4756C714.2040809@de.ibm.com> <20071205233345.GB5617@wotan.suse.de> <4757B62F.2040608@de.ibm.com> <20071206085223.GA25202@wotan.suse.de>
In-Reply-To: <20071206085223.GA25202@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Warning: de.ibm.com is listed at abuse.rfc-ignorant.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> After my patch, we can do XIP in a hardsect size < PAGE_SIZE block
> device -- this seems to be a fine thing to do at least for the
> ramdisk code. Would this situation be problematic for existing drivers,
> and if so, in what way?
I have done some archeology, and our ancient CVS logs show this check 
was introduced in early 2005 into our 2.6.x. codebase. However, it 
existed way before, and was copied from our prehistorical ext2 split 
named xip2 back in the old days of 2.4.x where we did not really have 
a block device behind because that one was scamped into the file 
system in a very queer way.
After all, I don't see any risk in removing the check. The only driver 
we have that does direct_access is drivers/s390/block/dcssblk.c, and 
that one only supports block_size == PAGE_SIZE. I think the patch 
should go into mainline.

Acked-by: Carsten Otte <cotte@de.ibm.com>

