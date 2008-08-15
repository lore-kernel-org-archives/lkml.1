Return-Path: <linux-kernel-owner+w=401wt.eu-S1751317AbYHOWQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbYHOWQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 18:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYHOWQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 18:16:33 -0400
Received: from bu3sch.de ([62.75.166.246]:40036 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYHOWQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:16:32 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: oops in exit_mmap
Date: Sat, 16 Aug 2008 00:14:23 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808160014.23922.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just had the following oops on a wireless-testing.git kernel, which
is based on 2.6.27-rc2.
The oops happened while copying files.


[27931.315928] Unable to handle kernel paging request for data at address 0x00000595
[27931.317713] Faulting instruction address: 0xc0082db0
[27931.318841] Oops: Kernel access of bad area, sig: 11 [#1]
[27931.319341] PREEMPT PowerMac
[27931.319784] Modules linked in: b43 ssb mac80211 appletouch rfkill_input rfkill led_class input_polldev af_packet ohci_hcd pcmcia unix [last unloaded: mac80211]
[27931.321217] NIP: c0082db0 LR: c0082da0 CTR: 00000000
[27931.321787] REGS: ef32fda0 TRAP: 0300   Tainted: G        W  (2.6.27-rc2-wl-wltest)
[27931.322449] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000482  XER: 00000000
[27931.323197] DAR: 00000595, DSISR: 40000000
[27931.323765] TASK = ee29adf0[23865] 'cp' THREAD: ef32e000
[27931.323942] GPR00: c0082da0 ef32fe50 ee29adf0 00000000 bbbbbbbb 00000004 ef308ed4 c0cd5100 
[27931.324796] GPR08: 0000005a 00000000 00000000 ef32fe50 0fedaad0 10028bc8 10040000 00000002 
[27931.325665] GPR16: 10040000 10018875 bf9fbfc8 00000000 00000000 00000000 00000000 10020000 
[27931.326560] GPR24: 00000000 20000000 28000482 00000000 00000501 00000000 ef32e000 ef32fe50 
[27931.328037] NIP [c0082db0] exit_mmap+0xf4/0x11c
[27931.328737] LR [c0082da0] exit_mmap+0xe4/0x11c
[27931.329439] Call Trace:
[27931.330084] [ef32fe50] [c0082da0] exit_mmap+0xe4/0x11c (unreliable)
[27931.330885] [ef32fe80] [c003390c] mmput+0x58/0xe4
[27931.331631] [ef32fea0] [c003784c] exit_mm+0x128/0x140
[27931.332395] [ef32fed0] [c00392a8] do_exit+0x1fc/0x720
[27931.333168] [ef32ff10] [c0039850] do_group_exit+0x84/0xb0
[27931.333956] [ef32ff30] [c0039898] sys_exit_group+0x1c/0x34
[27931.334758] [ef32ff40] [c0015584] ret_from_syscall+0x0/0x38
[27931.335574] --- Exception: c01 at 0xfec7008
[27931.335576]     LR = 0xfec6fd8
[27931.337066] Instruction dump:
[27931.337813] 3929ffff 913e000c 801e0034 70090004 41a20014 483e1b31 4800000c 4bfffe7d 
[27931.338839] 7c7d1b78 2f9d0000 7fa3eb78 409efff0 <801c0094> 3140ffff 7d2a0110 0f090000 
[27931.359143] ---[ end trace 633dedc970f0cb02 ]---
[27931.360589] Fixing recursive fault but reboot is needed!
