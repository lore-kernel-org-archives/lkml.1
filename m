Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbZKWCm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbZKWCm2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 21:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbZKWCm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 21:42:28 -0500
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:45737 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756085AbZKWCm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 21:42:27 -0500
Message-ID: <4B09F685.2080201@internode.on.net>
Date: Mon, 23 Nov 2009 13:12:13 +1030
From: indexer <indexer@internode.on.net>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Feng Tang <feng.tang@intel.com>, bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 14658] Regression in efi.c
References: <bug-14658-6666@http.bugzilla.kernel.org/> <200911212017.nALKHLSC029634@demeter.kernel.org> <alpine.LFD.2.00.0911221817200.24119@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911221817200.24119@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sat, 21 Nov 2009, bugzilla-daemon@bugzilla.kernel.org wrote:
>
> Switched to email. Please reply by mail (reply-to-all) and not in the
> bugzilla.
>
>   
>> --- Comment #1 from Rafael J. Wysocki <rjw@sisk.pl>  2009-11-21 20:17:21 ---
>> Caused by:
>>
>> commit 7bd867dfb4e0357e06a3211ab2bd0e714110def3
>>     
>
> That's completely bogus. That commit is not in 2.6.31. It was merged in the
> 2.6.32 merge window.
>
> From the original bug report:
>
> http://marc.info/?l=linux-kernel&m=125846988820120&w=4
>
>   
>> I would like to report a possible regression in efi.c with kernels
>> 2.6.31 , 2.6.32-rc5 and 2.6.32.rc7.
>>
>> Attempting to boot x86_64 with elilo succeeds using 2.6.30 . Using the
>> same config cannot boot with any of the 3 afore mentioned kernels.
>>     
>
> So the problem exists with 2.6.31 already which excludes the above
> commit.
>
> The above commit indeed caused problems on 64bit efi systems in
> 2.6.32-rc. The fix was merged between 32-rc5 and 32-rc6.
>
> The bisect was done with:
>
> git bisect start
> # good: [59a3759d0fe8d969888c741bb33f4946e4d3750d] Linux 2.6.30-rc7
> git bisect good 59a3759d0fe8d969888c741bb33f4946e4d3750d
> # bad: [156171c71a0dc4bce12b4408bb1591f8fe32dc1a] Linux 2.6.32-rc7
>
> while the bisect should have be done with
>
> good 2.6.30
> bad  2.6.31
>
> William, could you please go through the bisect pain again?
>
> Thanks,
>
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
Thomas

I had already done a similar bisect to this in private conversation to 
Huang Ying, and is what prompted me to expand my bisect out. I redid it 
regardless and will send you the information.

commit 74fca6a42863ffacaf7ba6f1936a9f228950f657
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Sep 9 15:13:59 2009 -0700

    Linux 2.6.31

 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


git bisect start
# good: [07a2039b8eb0af4ff464efd3dfd95de5c02648c6] Linux 2.6.30
git bisect good 07a2039b8eb0af4ff464efd3dfd95de5c02648c6
# bad: [74fca6a42863ffacaf7ba6f1936a9f228950f657] Linux 2.6.31
git bisect bad 74fca6a42863ffacaf7ba6f1936a9f228950f657
# good: [925d74ae717c9a12d3618eb4b36b9fb632e2cef3] V4L/DVB (11736): 
videobuf: modify return value of VIDIOC_REQBUFS ioctl
git bisect good 925d74ae717c9a12d3618eb4b36b9fb632e2cef3
# good: [a380137900fca5c79e6daa9500bdb6ea5649188e] ixgbe: Fix device 
capabilities of 82599 single speed fiber NICs.
git bisect good a380137900fca5c79e6daa9500bdb6ea5649188e
# good: [b54c3835469c9548d470e7788cb22a2fd7e21133] Merge branch 
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
git bisect good b54c3835469c9548d470e7788cb22a2fd7e21133
# good: [7b2aa037e878c939676675969983284a02958ae3] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
git bisect good 7b2aa037e878c939676675969983284a02958ae3
# good: [8486a0f95c844b27ecc855cfec89b7e34f831cad] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
git bisect good 8486a0f95c844b27ecc855cfec89b7e34f831cad
# good: [f415c413f458837bd0c27086b79aca889f9435e4] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
git bisect good f415c413f458837bd0c27086b79aca889f9435e4
# good: [37d0892c5a94e208cf863e3b7bac014edee4346d] autofs4 - fix missed 
case when changing to use struct path
git bisect good 37d0892c5a94e208cf863e3b7bac014edee4346d
# good: [0edfa2b1b5a5e1475e76dd3c792447687d966de4] Merge branch 
'for-linus' of git://oss.sgi.com/xfs/xfs
git bisect good 0edfa2b1b5a5e1475e76dd3c792447687d966de4
# good: [5136a6c0fd5b26bbf39ad761cf7a4fc563ad83a3] Merge 
git://git.infradead.org/~dwmw2/mtd-2.6.31
git bisect good 5136a6c0fd5b26bbf39ad761cf7a4fc563ad83a3
# good: [f69fb9c39868463f6b0b8306824341bd5610250b] Merge branch 
'for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel
git bisect good f69fb9c39868463f6b0b8306824341bd5610250b
# good: [755ae761c5519929a97567d61a379b87352c337c] Merge branch 
'for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6
git bisect good 755ae761c5519929a97567d61a379b87352c337c
# good: [7c8460db30dfd085ef3837c8fb02ecf2e718b983] drm/i915: fix mask 
bits setting
git bisect good 7c8460db30dfd085ef3837c8fb02ecf2e718b983
# good: [7135a71b19be1faf48b7148d77844d03bc0717d6] aoe: allocate unused 
request_queue for sysfs
git bisect good 7135a71b19be1faf48b7148d77844d03bc0717d6
 Sincerely

William

PS - The fact remains i still cant efi boot in 2.6.32-rc7, so this bug 
still exists, and I will keep doing what i can to help track this down.
