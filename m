Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbXCTMdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbXCTMdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 08:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933133AbXCTMdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 08:33:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56990 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933102AbXCTMdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 08:33:13 -0400
Date: Tue, 20 Mar 2007 13:32:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, tiwai@suse.de
Cc: Ingo Molnar <mingo@elte.hu>
Subject: BUG: soft lockup during suspend
Message-ID: <20070320123253.GB19019@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I got this nastinness in my syslog... perhaps HDA intel takes too long
to play with its hardware? Or should we just kill the softlockup
watchdog since Linux is not realtime system, yet?
								Pavel 

HDA Intel 0000:00:1b.0: freeze
BUG: soft lockup detected on CPU#0!
 [<c014fdd9>] softlockup_tick+0xa9/0xd0
 [<c0131d63>] update_process_times+0x33/0x80
 [<c0142f52>] tick_periodic+0x22/0x70
 [<c0142fb7>] tick_handle_periodic+0x17/0x80
 [<c014359a>] tick_do_broadcast+0x6a/0x80
 [<c01435cc>] tick_do_periodic_broadcast+0x1c/0x30
 [<c01435fb>] tick_handle_periodic_broadcast+0x1b/0x60
 [<c01435cc>] tick_do_periodic_broadcast+0x1c/0x30
 [<c01077cc>] timer_interrupt+0x2c/0x40
 [<c0150005>] handle_IRQ_event+0x25/0x60
 [<c0151d87>] handle_edge_irq+0xe7/0x130
 [<c0106adb>] do_IRQ+0x3b/0x80
 [<c0106ae0>] do_IRQ+0x40/0x80
 [<c01049eb>] common_interrupt+0x23/0x28
 [<c063007b>] ieee80211_wx_get_scan+0x2b/0x130
 [<c02588f4>] delay_tsc+0x14/0x20
 [<c0258936>] __delay+0x6/0x10
 [<c052f3da>] azx_send_cmd+0xfa/0x110
 [<c053089e>] snd_hda_codec_write+0x3e/0x60
 [<c05314fb>] hda_set_power_state+0xab/0xe0
 [<c0532518>] snd_hda_suspend+0x48/0x60
 [<c0530302>] azx_suspend+0x52/0xd0
 [<c0266b13>] pci_device_suspend+0x23/0x70
 [<c0332dbb>] suspend_device+0x11b/0x2e0
 [<c0333032>] device_suspend+0xb2/0x170
 [<c012a28b>] printk+0x1b/0x20
 [<c014c7ad>] pm_suspend_disk+0x4d/0x2b0
 [<c014b395>] enter_state+0x195/0x220
 [<c014b4c9>] state_store+0xa9/0xc0
 [<c014b420>] state_store+0x0/0xc0
 [<c01ae789>] subsys_attr_store+0x29/0x40
 [<c01af07c>] sysfs_write_file+0xac/0x130
 [<c0172156>] vfs_write+0xa6/0x140
 [<c01aefd0>] sysfs_write_file+0x0/0x130
 [<c0104050>] syscall_call+0x7/0xb
 [<c0630000>] ieee80211_translate_scan+0xa00/0xa50
 =======================
ACPI: PCI interrupt for device 0000:00:1b.0 disabled

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
