Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYBEPIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYBEPIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbYBEPI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:08:27 -0500
Received: from aun.it.uu.se ([130.238.12.36]:54891 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYBEPI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:08:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18344.31682.388710.182172@harpo.it.uu.se>
Date: Tue, 5 Feb 2008 16:07:46 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Doug Kehn <rdkehn@yahoo.com>
Cc: linux-kernel@vger.kernel.org, uClinux <uclinux-dev@uclinux.org>
Subject: Re: Soft lockup 2.6.23.14-uc0
In-Reply-To: <394206.41470.qm@web52009.mail.re2.yahoo.com>
References: <394206.41470.qm@web52009.mail.re2.yahoo.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Kehn writes:
 > Hi All,
 > 
 > I am observing kernel soft lockups when running
 > network throughput tests with NUTTCP.  The kernel is a
 > stock 2.6.23 kernel with patches from uClinux.org.  I
 > have applied the incremental 2.6.23 patches to produce
 > the resulting 2.6.23.14-uc0 kernel.  This kernel is
 > executing on a 266MHz Intel XScale IXP420 processor
 > with 16MB flash (JFFS2) and 64MB RAM.  I am also using
 > the Intel Access Library v2.4 with patches from
 > snapgear.org.  (The Intel Access Library is the reason
 > for the tainted kernel.)  The toolchain to build the
 > kernel and all applications is comprised of:
 > 
 > binutils-2.16.tar.gz
 > gcc-3.4.4.tar.gz
 > glibc-2.3.3.tar.gz
 > glibc-linuxthreads-2.3.3.tar.gz
 > 
 > All applications are compiled against uClibc-0.9.27.
 > 
 > A soft lockup dump is provided below.  Any help in
 > determining the cause of the soft lock will be
 > appreciated.
 > 
 > Regards,
 > ...doug
 > 
 > 
 > # BUG: soft lockup - CPU#0 stuck for 11s! [awk:2960]
 > 
 > Pid: 2960, comm:                  awk
 > CPU: 0    Tainted: P         (2.6.23.14-uc0 #1)
 > PC is at handle_IRQ_event+0x34/0x80
 > LR is at handle_level_irq+0x98/0xec
 > pc : [<c0058b30>]    lr : [<c0059eb0>]    psr:
 > 40000013
 > sp : c353deb0  ip : c353ded0  fp : c353decc
 > r10: 4000d090  r9 : c353c000  r8 : 4000515c
 > r7 : 00000012  r6 : 00000000  r5 : 00000000  r4 :
 > c3f68a60
 > r3 : 40000013  r2 : c025151c  r1 : c3f68a60  r0 :
 > 00000012
 > Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM 
 > Segment user
 > Control: 000039ff  Table: 03500000  DAC: 00000015
 > [<c0020b60>] (show_regs+0x0/0x4c) from [<c005865c>]
 > (softlockup_tick+0xe8/0x114)
 >  r4:00001e13
 > [<c0058574>] (softlockup_tick+0x0/0x114) from
 > [<c00401b0>] (run_local_timers+0x1
 > 8/0x1c)

Is this a new ixp4xx platform or one of the existing
ones in arch/arm/mach-ixp4xx?

Anyway, I can think of two things:

1. There was some very recent patches by Peter Zijlstra
   addressing hrtimer breakage on arm and some other
   archs in 2.6.24-git. If uclinux has backported some
   of that stuff then it might explain this issue.

2. There is a new native Linux driver for ixp4xx
   ethernet. Patches for the 2.6.23.14 kernel can
   be found in the nslu2-linux group's subversion
   repository. (You'll need new firmware files though.)
   Replacing Intel's IXP400 drivers with this driver
   should at least tell you if the lockups are
   related to your use of the Intel drivers.

   FWIW, I've never seen these lockups on my ixp4xx
   boxes, with the Intel IXP400 drivers or with
   the new native Linux drivers.

You should also Cc: the linux arm kernel mailing list,
as the issue probably is platform specific.
