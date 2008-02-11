Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbYBKDOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbYBKDOu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 22:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYBKDOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 22:14:42 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:64000 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbYBKDOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 22:14:41 -0500
Date: Sun, 10 Feb 2008 22:14:08 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Linux 2.6.25-rc1
In-reply-to: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802102214.08860.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 February 2008, Linus Torvalds wrote:
>Ok, it's a bloody large -rc (as was 24-rc1, for that matter), probably
>because the 2.6.24 release cycle dragged out, so people had a lot of
>things pending.
>
>The full diff is something like 11MB and 1.4M lines of diffs, with the
>bulk of the stuff being in architecture updates and drivers.
>
>Just to have some fun, I did trivial statistics, and of the 1.4M lines of
>diffs, about 38% - 530k lines - were in architecture files (400k+ lines of
>diffs in arch/, 100k+ lines of diffs in include/asm-*), and another big
>chunk is in drivers (including sound) at about 44% - 610k lines - of
>changes.
>
>The rest comes in much smaller, but still noticeable is networking (8% -
>110k lines), with filesystems at 4%, and documentation at about 2%. The
>remaining crumbles being spread out mostly over block layer, crypto,
>kernel core, and security layer updates (ie SElinux and smack).
>
>[ Just to make it more obvious how driver and architecture-dominated the
>  kernel changelogs are: just the network driver changes were 200kloc, and
>  even just infiniband - which came way behind not just networking
>  drivers, but also DVB, SCSI, char and ide - generated more lines of code
>  changed than the "core" kernel code under the kernel/ subdirectory.
>
>  And that's despite the fact that the "core" code was actually under a
>  fairly active merge cycle, with a lot of namespace- and scheduling-
>  related stuff. ]
>
>Now, some of that is files moving about and other reorganizations (SH and
>to a lesser degree sparc starting to merge 32-bit and 64-bit
>architectures), but most of it really is just the normal flood of changes
>and new driver or platform support.
>
>The full shortlog is half a meg in size (and the diffstat is even bigger),
>so I won't be including that here, but some things that may be worth
>pointing out not because they are big in line sizes, but because they have
>potential to be noticed by more people:
>
> - the intel graphics driver is starting to do suspend/resume natively
>   (ie even without X support), which is a welcome sign of the times and
>   may help some people. It helped on my laptop.
>
> - Other suspend/resume changes in device access ordering etc, and the
>   usual ACPI changes means that we really want reports from people about
>   this all even if you don't have intel graphics.
>
> - Lots of cleanups from the x86 merge (making more and more use of common
>   files), but also the big page attribute stuff is in and caused a fair
>   amount of churn, and while most of the issues should have been very
>   obvious and all got fixed, this is definitely one of those things that
>   we want a lot of very wide testing of to make sure nothing regressed.
>
> - fair number of changes to things like the legacy IDE drivers too, and a
>   totally new driver for the very common PCIE version of the Intel e1000
>   network card etc.
>
> - .. and I've probably totally forgotten about tons of other stuff I
>   should have mentioned, but the point is that not only do we have lots
>   of new core, we do have a fair amout of changes to basic stuff that can
>   actually affect perfectly bog-standard hardware setups.
>
>So give it all a good testing.

I just did, and while non-x seems stable, the latest nvidia driver, about a 
week old, will not build a valid kernel module, so X bails out with a failed 
to load it, even though its sitting  
in /lib/modules/`uname -r`/kernel/drivers/video with exactly the same length 
as the one built for 2.6.24.  The nvidia-installer log recommends doing 
a 'make prepare' which I did, but nvidia still errors out during the module 
build.  So obviously I am back to 2.6.24, and my next stop is the nvidia web 
site to see if they have a fix.

Other than that, it feels good.

>		Linus
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Idleness is the holiday of fools.
