Return-Path: <linux-kernel-owner+w=401wt.eu-S1765072AbYEHUto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765072AbYEHUto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbYEHUtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:49:33 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44694 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbYEHUtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:49:31 -0400
Subject: Re: [Cbe-oss-dev] [PATCH] Updated: Reworked Cell OProfile: SPU
	mutex lock fix
From: Carl Love <cel@us.ibm.com>
To: jroth@linux.vnet.ibm.com, linux-kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <4822B03B.5060509@linux.vnet.ibm.com>
References: <1209587712.7531.42.camel@carll-linux-desktop>
	 <4821DEB0.7050308@linux.vnet.ibm.com>
	 <1210199526.7726.43.camel@carll-linux-desktop>
	 <4822B03B.5060509@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 08 May 2008 13:47:07 -0700
Message-Id: <1210279627.7726.62.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-08 at 09:48 +0200, Jochen Roth wrote:
> >> Unable to handle kernel paging request for data at address 
> >> 0xd0000000004fe9a8
> >> Faulting instruction address: 0xd000000000330ad8
> >> cpu 0x0: Vector: 300 (Data Access) at [c00000003c337680]
> >>      pc: d000000000330ad8: .alloc_cpu_buffers+0x7c/0x12c [oprofile]
> >>      lr: d000000000330abc: .alloc_cpu_buffers+0x60/0x12c [oprofile]
> >>      sp: c00000003c337900
> >>     msr: 9000000000009032
> >>     dar: d0000000004fe9a8
> >>   dsisr: 42000000
> >>    current = 0xc00000003e128600
> >>    paca    = 0xc0000000005b3480
> >>      pid   = 2356, comm = oprofiled
> >> enter ? for help
> >> [c00000003c3379a0] d0000000003302ac .oprofile_setup+0x2c/0x134 [oprofile]
> >> [c00000003c337a30] d00000000033176c .event_buffer_open+0x7c/0xc8 [oprofile]
> >> [c00000003c337ac0] c0000000000d6ca8 .__dentry_open+0x190/0x308
> >> [c00000003c337b70] c0000000000e7a5c .do_filp_open+0x3c4/0x8e8
> >> [c00000003c337d00] c0000000000d6a1c .do_sys_open+0x80/0x14c
> >> [c00000003c337db0] c0000000001192f4 .compat_sys_open+0x24/0x38
> >> [c00000003c337e30] c0000000000076b4 syscall_exit+0x0/0x40
> >> --- Exception: c01 (System Call) at 000000000ff006f8
> >> SP (ffc6f6a0) is in userspace
> >>
> 
> Btw, I get this crash even without the patch applied. So it might be 
> something unrelated. Shall I open a separate bugzilla for that?
> 
> > A couple of things, first I am not finding a 2.6.25 Jeremy tree that you
> > refer to.  The best that I see is a 2.6.23 tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/jermey/xen.git.  Can you
> > either send me a location to get the jeremy tree you used or
> > tar/compress it an email it to me.  A link would be preferred.  

I pulled down the jeremy tree.  I tried compiling and booting it.  It
also crashes for me without my patch. The tree is clearly bad.

I looked at the jeremy tree.  The oprofile code is different then the
Arnd tree.  My patch is consistent with the code in Arnd's tree.  The
oprofile cpu_buffer has been changed in the Jeremy tree from what is in
Arnd's tree.

It is my understanding that Arnd is the official CELL kernel maintainer.
I have no idea where the jeremy tree comes from.  My patch was done
against the latest Arnd tree.  I would recommend you use Arnd's tree.
Let me know if you find any issues with my patch with Arnd's tree.

> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jk/spufs.git
> 
> > 
> > I use Arnd's git tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/arnd/cell-2.6.git
> 
> I'll clone Arnd's git and apply your patch.
> 
> > The second thing is the function that you changed is used when adding a
> > sample to the CPU buffer.  It is only called when OProfile is running.
> > The crash that you sent above looks like it occurred when the module was
> > loading since it failed in the alloc_cpu_buffer call.  This would appear
> > to me to be completely separate from the oprofile_add_value() function.
> > The patch does make some changes in the oprofile arch specific sync init
> > code.  Perhaps something is failing as part of the sync start
> > (drivers/oprofile/oprof.c) and resulting in the crash.  There are no
> > buffer creation specific changes in the patch so I am puzzled by the
> > crash.  I would like to see if I can reproduce the crash on my system.
> > I have a qs20.  What are you running on?
> > 
> 
> Thanks for the explanation. It also crashed before applying your patch.
> I'm using a QS21.
> 
> --
> Kind regards,
> Jochen

