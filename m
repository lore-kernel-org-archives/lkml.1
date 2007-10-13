Return-Path: <linux-kernel-owner+w=401wt.eu-S1761713AbXJMHSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761713AbXJMHSd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbXJMHS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:18:26 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20106 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbXJMHSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:18:25 -0400
Date: Sat, 13 Oct 2007 09:18:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Paul Jackson <pj@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <willy@debian.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       Vladimir Saveliev <vs@namesys.com>,
       Edward Shishkin <edward@namesys.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: git-block patches broken on 2.6.23-mm1 ia64 SN
Message-ID: <20071013071821.GC969@kernel.dk>
References: <20071013001356.304b505f.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071013001356.304b505f.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13 2007, Paul Jackson wrote:
> [Try again, with a Subject this time ...]
> 
> The git-block patches in 2.6.23-mm1 freeze my ia64 SN Altix hard on boot.
> Not good (tm).
> 
> Something broke between the git-block patch of Sept 26 in 2.6.23-rc8-mm2
> and the git-block patches of Oct 10-11 in 2.6.23-mm1 on my ia64 SN Altix
> system using sn2_defconfig.
> 
> Bisecting 2.6.23-mm1 narrows the problem down to the git-block patches:
> 
>     git-block.patch
>     git-block-fixup-1.patch
>     git-block-fixup.patch
>     git-block-fixup-fix.patch
>     git-block-borkages.patch
>     git-block-s390-fix.patch
> 
> I can boot 2.6.23-rc8-mm2 fine, but I freeze early in boot
> on 2.6.23-mm1, after the following prints on the console:
> 
>     McKinley Errata 9 workaround not needed; disabling it
>     SLUB: Genslabs=26, HWalign=128, Order=0-2, MinObjects=8, CPUs=8, Nodes=1024
>     Dentry cache hash table entries: 1048576 (order: 9, 8388608 bytes)
>     Inode-cache hash table entries: 524288 (order: 8, 4194304 bytes)
>     Mount-cache hash table entries: 1024
>     ACPI: Core revision 20070126
>     Boot processor id 0x0/0x0
>     Brought up 8 CPUs
>     Total of 8 processors activated (15564.80 BogoMIPS).
> 
> The next output that I -would- have expected, based on successful boots
> without these patches, but never get, is:
> 
>     net_namespace: 120 bytes
>     DMI not present or invalid.
>     xor: measuring software checksum speed
>        ia64      :  2692.000 MB/sec
>     xor: using function: ia64 (2692.000 MB/sec)
>     NET: Registered protocol family 16
>     ACPI  DSDT OEM Rev 0x20101

Can you try with init call debugging, perhaps that'll show where it
stalls? Sounds a bit odd that the block changes would cause a failure so
early in the boot, it hasn't done anything yet. But it could be some
error in the init functions.

-- 
Jens Axboe

