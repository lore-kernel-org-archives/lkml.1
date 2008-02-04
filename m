Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbYBDPwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbYBDPwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 10:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYBDPwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 10:52:37 -0500
Received: from web52009.mail.re2.yahoo.com ([206.190.48.58]:22399 "HELO
	web52009.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751520AbYBDPwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 10:52:35 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2008 10:52:35 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=tHYo51kQIt3OIMnE7dULuMh8+YXm8Ojkul20hFGnok5gTcDNMOm82Q5rWPSQ3aXNLRPaPTZ54Sfgh1mzBb4Bj+E2YLqIG5Mg5bDINH9HSNiK+MsC71ssnvrCfiXk/q1FeOQaIgbfyBU9r/FCv5NnCneuDmgTFdRFtAPbgR5/1gk=;
X-YMail-OSG: pnipTMQVM1la.GPr40vzg2yW514AGihAYg1raXY.y2TCNl.dWrK4eujgMap_38XyekD8ramBSf5pWX3K0V.7.A6q1BpKi_YmZjiEWyl26gJAHFHt0Hc-
Date: Mon, 4 Feb 2008 07:45:54 -0800 (PST)
From: Doug Kehn <rdkehn@yahoo.com>
Subject: Soft lockup 2.6.23.14-uc0
To: linux-kernel@vger.kernel.org, uClinux <uclinux-dev@uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <394206.41470.qm@web52009.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am observing kernel soft lockups when running
network throughput tests with NUTTCP.  The kernel is a
stock 2.6.23 kernel with patches from uClinux.org.  I
have applied the incremental 2.6.23 patches to produce
the resulting 2.6.23.14-uc0 kernel.  This kernel is
executing on a 266MHz Intel XScale IXP420 processor
with 16MB flash (JFFS2) and 64MB RAM.  I am also using
the Intel Access Library v2.4 with patches from
snapgear.org.  (The Intel Access Library is the reason
for the tainted kernel.)  The toolchain to build the
kernel and all applications is comprised of:

binutils-2.16.tar.gz
gcc-3.4.4.tar.gz
glibc-2.3.3.tar.gz
glibc-linuxthreads-2.3.3.tar.gz

All applications are compiled against uClibc-0.9.27.

A soft lockup dump is provided below.  Any help in
determining the cause of the soft lock will be
appreciated.

Regards,
...doug


# BUG: soft lockup - CPU#0 stuck for 11s! [awk:2960]

Pid: 2960, comm:                  awk
CPU: 0    Tainted: P         (2.6.23.14-uc0 #1)
PC is at handle_IRQ_event+0x34/0x80
LR is at handle_level_irq+0x98/0xec
pc : [<c0058b30>]    lr : [<c0059eb0>]    psr:
40000013
sp : c353deb0  ip : c353ded0  fp : c353decc
r10: 4000d090  r9 : c353c000  r8 : 4000515c
r7 : 00000012  r6 : 00000000  r5 : 00000000  r4 :
c3f68a60
r3 : 40000013  r2 : c025151c  r1 : c3f68a60  r0 :
00000012
Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM 
Segment user
Control: 000039ff  Table: 03500000  DAC: 00000015
[<c0020b60>] (show_regs+0x0/0x4c) from [<c005865c>]
(softlockup_tick+0xe8/0x114)
 r4:00001e13
[<c0058574>] (softlockup_tick+0x0/0x114) from
[<c00401b0>] (run_local_timers+0x1
8/0x1c)
[<c0040198>] (run_local_timers+0x0/0x1c) from
[<c00401f8>] (update_process_times
+0x44/0x6c)
[<c00401b4>] (update_process_times+0x0/0x6c) from
[<c00512c0>] (tick_periodic+0x
94/0xc0)
 r5:c0257900 r4:00989680
[<c005122c>] (tick_periodic+0x0/0xc0) from
[<c0051308>] (tick_handle_periodic+0x
1c/0xc4)
 r5:00000000 r4:00000001
[<c00512ec>] (tick_handle_periodic+0x0/0xc4) from
[<c0029c7c>] (ixp4xx_timer_int
errupt+0x28/0x38)
[<c0029c54>] (ixp4xx_timer_interrupt+0x0/0x38) from
[<c0058b40>] (handle_IRQ_eve
nt+0x44/0x80)
 r4:c0242734
[<c0058afc>] (handle_IRQ_event+0x0/0x80) from
[<c0059eb0>] (handle_level_irq+0x9
8/0xec)
 r7:c353df08 r6:c025a5c0 r5:00000005 r4:c0244bd8
[<c0059e18>] (handle_level_irq+0x0/0xec) from
[<c001f044>] (asm_do_IRQ+0x44/0x5c
)
 r5:00000005 r4:c0244bd8
[<c001f000>] (asm_do_IRQ+0x0/0x5c) from [<c001fa04>]
(__irq_svc+0x24/0x60)
Exception stack(0xc353de68 to 0xc353deb0)
de60:                   00000012 c3f68a60 c025151c
40000013 c3f68a60 00000000
de80: 00000000 00000012 4000515c c353c000 4000d090
c353decc c353ded0 c353deb0
dea0: c0059eb0 c0058b30 40000013 ffffffff
 r7:00000012 r6:00000028 r5:0000001f r4:ffffffff
[<c0058afc>] (handle_IRQ_event+0x0/0x80) from
[<c0059eb0>] (handle_level_irq+0x9
8/0xec)
 r7:c353dfb0 r6:c025a5c0 r5:00000012 r4:c0244eb0
[<c0059e18>] (handle_level_irq+0x0/0xec) from
[<c001f044>] (asm_do_IRQ+0x44/0x5c
)
 r5:00000012 r4:c0244eb0
[<c001f000>] (asm_do_IRQ+0x0/0x5c) from [<c001fa04>]
(__irq_svc+0x24/0x60)
Exception stack(0xc353df08 to 0xc353df50)
df00:                   ffbee004 c353c000 00000100
20000013 00000022 00000005
df20: 0000000a c0256300 4000515c c353c000 4000d090
c353df6c c353df70 c353df50
df40: c003c34c c003c29c 20000013 ffffffff
 r7:c0256300 r6:00040008 r5:0000001f r4:ffffffff
[<c003c258>] (__do_softirq2+0x0/0xc8) from
[<c003c34c>] (__do_softirq+0x2c/0x34)
 r7:00000000 r6:c025a5c0 r5:00000005 r4:c0244bd8
[<c003c320>] (__do_softirq+0x0/0x34) from [<c003c518>]
(irq_exit+0x40/0x48)
[<c003c4d8>] (irq_exit+0x0/0x48) from [<c001f048>]
(asm_do_IRQ+0x48/0x5c)
[<c001f000>] (asm_do_IRQ+0x0/0x5c) from [<c001fbc0>]
(__irq_usr+0x40/0x80)
Exception stack(0xc353dfb0 to 0xc353dff8)
dfa0:                                     000000f0
0000007a 00000000 00008138
dfc0: 40005060 00008aa4 4000513c 00009fe4 4000515c
40016ee4 4000d090 00000000
dfe0: 00000002 bed765b4 40000ccc 40000dd8 80000010
ffffffff
 r7:00009fe4 r6:00000020 r5:0000001f r4:ffffffff
BUG: soft lockup - CPU#0 stuck for 11s! [awk:2960]

Pid: 2960, comm:                  awk
CPU: 0    Tainted: P         (2.6.23.14-uc0 #1)
PC is at handle_IRQ_event+0x34/0x80
LR is at handle_level_irq+0x98/0xec
pc : [<c0058b30>]    lr : [<c0059eb0>]    psr:
40000013
sp : c353deb0  ip : c353ded0  fp : c353decc
r10: 4000d090  r9 : c353c000  r8 : 4000515c
r7 : 00000012  r6 : 00000000  r5 : 00000000  r4 :
c3f68a60
r3 : 40000013  r2 : c025151c  r1 : c3f68a60  r0 :
00000012
Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM 
Segment user
Control: 000039ff  Table: 03500000  DAC: 00000015
[<c0020b60>] (show_regs+0x0/0x4c) from [<c005865c>]
(softlockup_tick+0xe8/0x114)
 r4:00001e1e
[<c0058574>] (softlockup_tick+0x0/0x114) from
[<c00401b0>] (run_local_timers+0x1
8/0x1c)
[<c0040198>] (run_local_timers+0x0/0x1c) from
[<c00401f8>] (update_process_times
+0x44/0x6c)
[<c00401b4>] (update_process_times+0x0/0x6c) from
[<c00512c0>] (tick_periodic+0x
94/0xc0)
 r5:c0257900 r4:00989680
[<c005122c>] (tick_periodic+0x0/0xc0) from
[<c0051308>] (tick_handle_periodic+0x
1c/0xc4)
 r5:00000000 r4:00000001
[<c00512ec>] (tick_handle_periodic+0x0/0xc4) from
[<c0029c7c>] (ixp4xx_timer_int
errupt+0x28/0x38)
[<c0029c54>] (ixp4xx_timer_interrupt+0x0/0x38) from
[<c0058b40>] (handle_IRQ_eve
nt+0x44/0x80)
 r4:c0242734
[<c0058afc>] (handle_IRQ_event+0x0/0x80) from
[<c0059eb0>] (handle_level_irq+0x9
8/0xec)
 r7:c353df08 r6:c025a5c0 r5:00000005 r4:c0244bd8
[<c0059e18>] (handle_level_irq+0x0/0xec) from
[<c001f044>] (asm_do_IRQ+0x44/0x5c
)
 r5:00000005 r4:c0244bd8
[<c001f000>] (asm_do_IRQ+0x0/0x5c) from [<c001fa04>]
(__irq_svc+0x24/0x60)
Exception stack(0xc353de68 to 0xc353deb0)
de60:                   00000012 c3f68a60 c025151c
40000013 c3f68a60 00000000
de80: 00000000 00000012 4000515c c353c000 4000d090
c353decc c353ded0 c353deb0
dea0: c0059eb0 c0058b30 40000013 ffffffff
 r7:00000012 r6:00000028 r5:0000001f r4:ffffffff
[<c0058afc>] (handle_IRQ_event+0x0/0x80) from
[<c0059eb0>] (handle_level_irq+0x9
8/0xec)
 r7:c353dfb0 r6:c025a5c0 r5:00000012 r4:c0244eb0
[<c0059e18>] (handle_level_irq+0x0/0xec) from
[<c001f044>] (asm_do_IRQ+0x44/0x5c
)
 r5:00000012 r4:c0244eb0
[<c001f000>] (asm_do_IRQ+0x0/0x5c) from [<c001fa04>]
(__irq_svc+0x24/0x60)
Exception stack(0xc353df08 to 0xc353df50)
df00:                   ffbee004 c353c000 00000100
20000013 00000022 00000005
df20: 0000000a c0256300 4000515c c353c000 4000d090
c353df6c c353df70 c353df50
df40: c003c34c c003c29c 20000013 ffffffff
 r7:c0256300 r6:00040008 r5:0000001f r4:ffffffff
[<c003c258>] (__do_softirq2+0x0/0xc8) from
[<c003c34c>] (__do_softirq+0x2c/0x34)
 r7:00000000 r6:c025a5c0 r5:00000005 r4:c0244bd8
[<c003c320>] (__do_softirq+0x0/0x34) from [<c003c518>]
(irq_exit+0x40/0x48)
[<c003c4d8>] (irq_exit+0x0/0x48) from [<c001f048>]
(asm_do_IRQ+0x48/0x5c)
[<c001f000>] (asm_do_IRQ+0x0/0x5c) from [<c001fbc0>]
(__irq_usr+0x40/0x80)
Exception stack(0xc353dfb0 to 0xc353dff8)
dfa0:                                     000000f0
0000007a 00000000 00008138
dfc0: 40005060 00008aa4 4000513c 00009fe4 4000515c
40016ee4 4000d090 00000000
dfe0: 00000002 bed765b4 40000ccc 40000dd8 80000010
ffffffff
 r7:00009fe4 r6:00000020 r5:0000001f r4:ffffffff
BUG: soft lockup - CPU#0 stuck for 11s! [awk:2960]

Pid: 2960, comm:                  awk
CPU: 0    Tainted: P         (2.6.23.14-uc0 #1)
PC is at __aeabi_idiv+0x3c/0xcc
LR is at do_gettimeofday+0x108/0x130
pc : [<c00fa418>]    lr : [<c004eae0>]    psr:
20000013
sp : c353ddc4  ip : 34bd5d15  fp : c353ddfc
r10: a6e5d944  r9 : 0000007f  r8 : ffffffff
r7 : 00000000  r6 : 00f24ddf  r5 : 00000000  r4 :
000ef02f
r3 : 34bd5efd  r2 : 00000016  r1 : 000003e8  r0 :
00000014
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM 
Segment user
Control: 000039ff  Table: 03500000  DAC: 00000015
[<c0020b60>] (show_regs+0x0/0x4c) from [<c005865c>]
(softlockup_tick+0xe8/0x114)
 r4:00001e29
[<c0058574>] (softlockup_tick+0x0/0x114) from
[<c00401b0>] (run_local_timers+0x1
8/0x1c)
[<c0040198>] (run_local_timers+0x0/0x1c) from
[<c00401f8>] (update_process_times
+0x44/0x6c)
[<c00401b4>] (update_process_times+0x0/0x6c) from
[<c00512c0>] (tick_periodic+0x
94/0xc0)
 r5:c0257900 r4:00989680
[<c005122c>] (tick_periodic+0x0/0xc0) from
[<c0051308>] (tick_handle_periodic+0x
1c/0xc4)
 r5:00000000 r4:00000001
[<c00512ec>] (tick_handle_periodic+0x0/0xc4) from
[<c0029c7c>] (ixp4xx_timer_int
errupt+0x28/0x38)
[<c0029c54>] (ixp4xx_timer_interrupt+0x0/0x38) from
[<c0058b40>] (handle_IRQ_eve
nt+0x44/0x80)
 r4:c0242734
[<c0058afc>] (handle_IRQ_event+0x0/0x80) from
[<c0059eb0>] (handle_level_irq+0x9
8/0xec)
 r7:c353de68 r6:c025a5c0 r5:00000005 r4:c0244bd8
[<c0059e18>] (handle_level_irq+0x0/0xec) from
[<c001f044>] (asm_do_IRQ+0x44/0x5c
)
 r5:00000005 r4:c0244bd8
[<c001f000>] (asm_do_IRQ+0x0/0x5c) from [<c001fa04>]
(__irq_svc+0x24/0x60)
Exception stack(0xc353dd7c to 0xc353ddc4)
dd60:                                                 
              00000014
dd80: 000003e8 00000016 34bd5efd 000ef02f 00000000
00f24ddf 00000000 ffffffff
dda0: 0000007f a6e5d944 c353ddfc 34bd5d15 c353ddc4
c004eae0 c00fa418 20000013
ddc0: ffffffff
 r7:00000000 r6:00000020 r5:0000001f r4:ffffffff
[<c004e9d8>] (do_gettimeofday+0x0/0x130) from
[<bf0ad708>] (0xbf0ad708)
[<bf0ad6f4>] (0xbf0ad6f4) from [<c0058b40>]
(handle_IRQ_event+0x44/0x80)
[<c0058afc>] (handle_IRQ_event+0x0/0x80) from
[<c0059eb0>] (handle_level_irq+0x9
8/0xec)
 r7:c353df08 r6:c025a5c0 r5:00000003 r4:c0244b68
[<c0059e18>] (handle_level_irq+0x0/0xec) from
[<c001f044>] (asm_do_IRQ+0x44/0x5c
)
 r5:00000003 r4:c0244b68
[<c001f000>] (asm_do_IRQ+0x0/0x5c) from [<c001fa04>]
(__irq_svc+0x24/0x60)
Exception stack(0xc353de68 to 0xc353deb0)
de60:                   00000012 c3f68a60 c025151c
40000013 c3f68a60 00000000
de80: 00000000 00000012 4000515c c353c000 4000d090
c353decc c353ded0 c353deb0
dea0: c0059eb0 c0058b30 40000013 ffffffff
 r7:00000012 r6:00000008 r5:0000001f r4:ffffffff
[<c0058afc>] (handle_IRQ_event+0x0/0x80) from
[<c0059eb0>] (handle_level_irq+0x9
8/0xec)
 r7:c353dfb0 r6:c025a5c0 r5:00000012 r4:c0244eb0
[<c0059e18>] (handle_level_irq+0x0/0xec) from
[<c001f044>] (asm_do_IRQ+0x44/0x5c
)
 r5:00000012 r4:c0244eb0
[<c001f000>] (asm_do_IRQ+0x0/0x5c) from [<c001fa04>]
(__irq_svc+0x24/0x60)
Exception stack(0xc353df08 to 0xc353df50)
df00:                   ffbee004 c353c000 00000100
20000013 00000022 00000005
df20: 0000000a c0256300 4000515c c353c000 4000d090
c353df6c c353df70 c353df50
df40: c003c34c c003c29c 20000013 ffffffff
 r7:c0256300 r6:00040008 r5:0000001f r4:ffffffff
[<c003c258>] (__do_softirq2+0x0/0xc8) from
[<c003c34c>] (__do_softirq+0x2c/0x34)
 r7:00000000 r6:c025a5c0 r5:00000005 r4:c0244bd8
[<c003c320>] (__do_softirq+0x0/0x34) from [<c003c518>]
(irq_exit+0x40/0x48)
[<c003c4d8>] (irq_exit+0x0/0x48) from [<c001f048>]
(asm_do_IRQ+0x48/0x5c)
[<c001f000>] (asm_do_IRQ+0x0/0x5c) from [<c001fbc0>]
(__irq_usr+0x40/0x80)
Exception stack(0xc353dfb0 to 0xc353dff8)
dfa0:                                     000000f0
0000007a 00000000 00008138
dfc0: 40005060 00008aa4 4000513c 00009fe4 4000515c
40016ee4 4000d090 00000000
dfe0: 00000002 bed765b4 40000ccc 40000dd8 80000010
ffffffff
 r7:00009fe4 r6:00000020 r5:0000001f r4:ffffffff
BUG: soft lockup - CPU#0 stuck for 11s! [awk:2960]

Pid: 2960, comm:                  awk
CPU: 0    Tainted: P         (2.6.23.14-uc0 #1)
PC is at __aeabi_idiv+0x54/0xcc
LR is at do_gettimeofday+0x108/0x130
pc : [<c00fa430>]    lr : [<c004eae0>]    psr:
80000013
sp : c353ddc4  ip : 03440146  fp : c353ddfc
r10: d6cc15eb  r9 : 0000007f  r8 : ffffffff
r7 : 00000000  r6 : 00f24de0  r5 : 00000000  r4 :
000ee69f
r3 : 000012ae  r2 : 00000010  r1 : 00003e80  r0 :
0000d600
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM 
Segment user
Control: 000039ff  Table: 03500000  DAC: 00000015
[<c0020b60>] (show_regs+0x0/0x4c) from [<c005865c>]
(softlockup_tick+0xe8/0x114)
 r4:00001e34
[<c0058574>] (softlockup_tick+0x0/0x114) from
[<c00401b0>] (run_local_timers+0x1
8/0x1c)
[<c0040198>] (run_local_timers+0x0/0x1c) from
[<c00401f8>] (update_process_times
+0x44/0x6c)
[<c00401b4>] (update_process_times+0x0/0x6c) from
[<c00512c0>] (tick_periodic+0x
94/0xc0)
 r5:c0257900 r4:00989680
[<c005122c>] (tick_periodic+0x0/0xc0) from
[<c0051308>] (tick_handle_periodic+0x
1c/0xc4)
 r5:00000000 r4:00000001
[<c00512ec>] (tick_handle_periodic+0x0/0xc4) from
[<c0029c7c>] (ixp4xx_timer_int
errupt+0x28/0x38)
[<c0029c54>] (ixp4xx_timer_interrupt+0x0/0x38) from
[<c0058b40>] (handle_IRQ_eve
nt+0x44/0x80)
 r4:c0242734
[<c0058afc>] (handle_IRQ_event+0x0/0x80) from
[<c0059eb0>] (handle_level_irq+0x9
8/0xec)
 r7:c353de68 r6:c025a5c0 r5:00000005 r4:c0244bd8
[<c0059e18>] (handle_level_irq+0x0/0xec) from
[<c001f044>] (asm_do_IRQ+0x44/0x5c
)
 r5:00000005 r4:c0244bd8
[<c001f000>] (asm_do_IRQ+0x0/0x5c) from [<c001fa04>]
(__irq_svc+0x24/0x60)
Exception stack(0xc353dd7c to 0xc353ddc4)
dd60:                                                 
              0000d600
dd80: 00003e80 00000010 000012ae 000ee69f 00000000
00f24de0 00000000 ffffffff
dda0: 0000007f d6cc15eb c353ddfc 03440146 c353ddc4
c004eae0 c00fa430 80000013
ddc0: ffffffff
 r7:00000000 r6:00000020 r5:0000001f r4:ffffffff
[<c004e9d8>] (do_gettimeofday+0x0/0x130) from
[<bf0ad708>] (0xbf0ad708)
[<bf0ad6f4>] (0xbf0ad6f4) from [<c0058b40>]
(handle_IRQ_event+0x44/0x80)
[<c0058afc>] (handle_IRQ_event+0x0/0x80) from
[<c0059eb0>] (handle_level_irq+0x9
8/0xec)
 r7:c353df08 r6:c025a5c0 r5:00000003 r4:c0244b68
[<c0059e18>] (handle_level_irq+0x0/0xec) from
[<c001f044>] (asm_do_IRQ+0x44/0x5c
)
 r5:00000003 r4:c0244b68
[<c001f000>] (asm_do_IRQ+0x0/0x5c) from [<c001fa04>]
(__irq_svc+0x24/0x60)
Exception stack(0xc353de68 to 0xc353deb0)
de60:                   00000012 c3f68a60 c025151c
40000013 c3f68a60 00000000
de80: 00000000 00000012 4000515c c353c000 4000d090
c353decc c353ded0 c353deb0
dea0: c0059eb0 c0058b30 40000013 ffffffff
 r7:00000012 r6:00000008 r5:0000001f r4:ffffffff
[<c0058afc>] (handle_IRQ_event+0x0/0x80) from
[<c0059eb0>] (handle_level_irq+0x9
8/0xec)
 r7:c353dfb0 r6:c025a5c0 r5:00000012 r4:c0244eb0
[<c0059e18>] (handle_level_irq+0x0/0xec) from
[<c001f044>] (asm_do_IRQ+0x44/0x5c
)
 r5:00000012 r4:c0244eb0
[<c001f000>] (asm_do_IRQ+0x0/0x5c) from [<c001fa04>]
(__irq_svc+0x24/0x60)
Exception stack(0xc353df08 to 0xc353df50)
df00:                   ffbee004 c353c000 00000100
20000013 00000022 00000005
df20: 0000000a c0256300 4000515c c353c000 4000d090
c353df6c c353df70 c353df50
df40: c003c34c c003c29c 20000013 ffffffff
 r7:c0256300 r6:00040008 r5:0000001f r4:ffffffff
[<c003c258>] (__do_softirq2+0x0/0xc8) from
[<c003c34c>] (__do_softirq+0x2c/0x34)
 r7:00000000 r6:c025a5c0 r5:00000005 r4:c0244bd8
[<c003c320>] (__do_softirq+0x0/0x34) from [<c003c518>]
(irq_exit+0x40/0x48)
[<c003c4d8>] (irq_exit+0x0/0x48) from [<c001f048>]
(asm_do_IRQ+0x48/0x5c)
[<c001f000>] (asm_do_IRQ+0x0/0x5c) from [<c001fbc0>]
(__irq_usr+0x40/0x80)
Exception stack(0xc353dfb0 to 0xc353dff8)
dfa0:                                     000000f0
0000007a 00000000 00008138
dfc0: 40005060 00008aa4 4000513c 00009fe4 4000515c
40016ee4 4000d090 00000000
dfe0: 00000002 bed765b4 40000ccc 40000dd8 80000010
ffffffff
 r7:00009fe4 r6:00000020 r5:0000001f r4:ffffffff




      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
