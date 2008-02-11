Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYBKApA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYBKApA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 19:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755658AbYBKAow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 19:44:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754201AbYBKAow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 19:44:52 -0500
Date: Sun, 10 Feb 2008 16:44:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.25-rc1
Message-ID: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, it's a bloody large -rc (as was 24-rc1, for that matter), probably 
because the 2.6.24 release cycle dragged out, so people had a lot of 
things pending.

The full diff is something like 11MB and 1.4M lines of diffs, with the 
bulk of the stuff being in architecture updates and drivers.

Just to have some fun, I did trivial statistics, and of the 1.4M lines of 
diffs, about 38% - 530k lines - were in architecture files (400k+ lines of 
diffs in arch/, 100k+ lines of diffs in include/asm-*), and another big 
chunk is in drivers (including sound) at about 44% - 610k lines - of 
changes.

The rest comes in much smaller, but still noticeable is networking (8% - 
110k lines), with filesystems at 4%, and documentation at about 2%. The 
remaining crumbles being spread out mostly over block layer, crypto, 
kernel core, and security layer updates (ie SElinux and smack).

[ Just to make it more obvious how driver and architecture-dominated the 
  kernel changelogs are: just the network driver changes were 200kloc, and 
  even just infiniband - which came way behind not just networking 
  drivers, but also DVB, SCSI, char and ide - generated more lines of code 
  changed than the "core" kernel code under the kernel/ subdirectory. 

  And that's despite the fact that the "core" code was actually under a 
  fairly active merge cycle, with a lot of namespace- and scheduling-
  related stuff. ]

Now, some of that is files moving about and other reorganizations (SH and 
to a lesser degree sparc starting to merge 32-bit and 64-bit 
architectures), but most of it really is just the normal flood of changes 
and new driver or platform support.

The full shortlog is half a meg in size (and the diffstat is even bigger), 
so I won't be including that here, but some things that may be worth 
pointing out not because they are big in line sizes, but because they have 
potential to be noticed by more people:

 - the intel graphics driver is starting to do suspend/resume natively 
   (ie even without X support), which is a welcome sign of the times and 
   may help some people. It helped on my laptop.

 - Other suspend/resume changes in device access ordering etc, and the 
   usual ACPI changes means that we really want reports from people about 
   this all even if you don't have intel graphics.

 - Lots of cleanups from the x86 merge (making more and more use of common 
   files), but also the big page attribute stuff is in and caused a fair 
   amount of churn, and while most of the issues should have been very 
   obvious and all got fixed, this is definitely one of those things that 
   we want a lot of very wide testing of to make sure nothing regressed.

 - fair number of changes to things like the legacy IDE drivers too, and a 
   totally new driver for the very common PCIE version of the Intel e1000 
   network card etc.

 - .. and I've probably totally forgotten about tons of other stuff I 
   should have mentioned, but the point is that not only do we have lots 
   of new core, we do have a fair amout of changes to basic stuff that can 
   actually affect perfectly bog-standard hardware setups.

So give it all a good testing. 

		Linus
