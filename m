Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbYHLMTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbYHLMTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 08:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYHLMTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 08:19:00 -0400
Received: from mail001.aei.ca ([206.123.6.130]:55581 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbYHLMS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 08:18:59 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Aug 2008 08:18:59 EDT
From: Ed Tomlinson <edt@aei.ca>
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org
Subject: 2.6.26-2 BUG: unable to handle kernel paging request (em28xx)
Date: Tue, 12 Aug 2008 08:12:15 -0400
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808120812.16739.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On x86_64, UP, 1.2G Ram with a Hauppauge WinTV-HVR 950, v4l2, and mplayer I encounted the following panic:

(arg: 2) [107637.465310] BUG: unable to handle kernel paging request at ffffc208[107637.466007] IP: [<ffffffff80332dbb>] memcpy_c+0xb/0x20
[107637.466007] PGD 4f810067 PUD 4f811067 PMD 4fbb4067 PTE 0
[107637.466007] Oops: 0002 [1] PREEMPT
[107637.466007] CPU 0
[107637.466007] Modules linked in: lgdt330x em28xx_dvb dvb_core tuner_xc2028 fix[107637.466007] Pid: 31414, comm: konsole Not tainted 2.6.26.2-crc-00005-gdc0057[107637.466007] RIP: 0010:[<ffffffff80332dbb>]  [<ffffffff80332dbb>] memcpy_c+00[107637.466007] RSP: 0000:ffffffff80654d70  EFLAGS: 00010002
[107637.466007] RAX: ffffc200005e2388 RBX: 0000000000003594 RCX: 000000001fffe5e[107637.466007] RDX: 0000000000000004 RSI: ffff810014c64000 RDI: ffffc200005e238[107637.466007] RBP: ffffffff80654de8 R08: 0000000000000002 R09: 000000000000000[107637.466007] R10: 0000000000000040 R11: 0000000000000020 R12: 000000000000004[107637.466007] R13: 00000000ffffca9d R14: ffff810028e28000 R15: ffff810028e2800[107637.466007] FS:  00007f8116727760(0000) GS:ffffffff8060e000(0000) knlGS:0000[107637.466007] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[107637.466007] CR2: ffffc200005e2388 CR3: 0000000049dfc000 CR4: 000000000000060[107637.466007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000000000[107637.466007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000000040[107637.466007] Process konsole (pid: 31414, threadinfo ffff810046430000, task )[107637.466007] Stack:  ffffffffa0255afc ffffffff8046d9b5 ffff81001c780400 ffff0[107637.466007]  0000f11300000000 ffff810024971000 0000000080654dc0 000000000002[107637.466007]  ffff810014c64000 ffff8100001f1800 ffff810028e28000 000000000000107637.466007] Call Trace:
[107637.466007]  <IRQ>  [<ffffffffa0255afc>] ? :em28xx_alsa:em28xx_audio_isocir0[107637.466007]  [<ffffffff8046d9b5>] ? udp_rcv+0x15/0x20
[107637.466007]  [<ffffffff803e52e3>] usb_hcd_giveback_urb+0x43/0xa0
[107637.466007]  [<ffffffffa00489a8>] :ehci_hcd:ehci_urb_done+0x98/0xe0
[107637.466007]  [<ffffffffa004ade9>] :ehci_hcd:ehci_work+0x789/0x8f0
[107637.466007]  [<ffffffffa004e01f>] :ehci_hcd:ehci_irq+0x10f/0x1e0
[107637.466007]  [<ffffffff803e5758>] usb_hcd_irq+0x38/0x80
[107637.466007]  [<ffffffff8025e2a5>] handle_IRQ_event+0x35/0x70
[107637.466007]  [<ffffffff8026000b>] handle_fasteoi_irq+0x8b/0x130
[107637.466007]  [<ffffffff8020dc2d>] do_IRQ+0x5d/0xc0
[107637.466007]  [<ffffffff8020bb61>] ret_from_intr+0x0/0xa
[107637.466007]  <EOI>
[107637.466007]
[107637.466007] Code: 48 8b 11 31 c0 c3 48 83 e9 07 eb 00 31 d2 48 c7 c0 f2 ff
[107637.466007] RIP  [<ffffffff80332dbb>] memcpy_c+0xb/0x20
[107637.466007]  RSP <ffffffff80654d70>
[107637.466007] CR2: ffffc200005e2388
[107637.466007] ---[ end trace d9d0567563e49120 ]---
[107637.466007] Kernel panic - not syncing: Aiee, killing interrupt handler!

Interestingly it occured after a round of experimenting when I found the mplayer command that, after a reboot, worked:

mplayer -tv norm=NTSC:chanlist=us-bcast:alsa=yes:audiorate=48000:amode=1:adevice=hw.1,0:volume=80:immediatemode=0 -ao alsa tv://

Thanks
Ed
