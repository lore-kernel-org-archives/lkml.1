Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbYFVSWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbYFVSWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 14:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYFVSWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 14:22:10 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:48972 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbYFVSWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 14:22:08 -0400
Message-ID: <485E984B.1030306@aitel.hist.no>
Date: Sun, 22 Jun 2008 20:22:03 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
Organization: HiST
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: 2.6.26-rc2 WARNING from usb-serial, and then my gps is dead
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is what I got:
------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:306 serial_write+0x62/0x89 
[usbserial]()
Modules linked in: pl2303 usbserial sbs sbshc coretemp piix pcmcia 
ata_piix iTCO_wdt ata_generic bay hci_usb intel_agp
Pid: 10, comm: events/1 Tainted: G        W 2.6.26-rc2-hh1 #1

Call Trace:
  [<ffffffff80236b54>] warn_on_slowpath+0x51/0x7a
  [<ffffffff8022c207>] __wake_up+0x38/0x4f
  [<ffffffff8024565c>] __queue_work+0x23/0x33
  [<ffffffff802456c8>] queue_work+0x37/0x40
  [<ffffffffa0045fa3>] :pl2303:pl2303_write+0xf2/0x101
  [<ffffffffa003c368>] :usbserial:serial_write+0x62/0x89
  [<ffffffff803a8e81>] tty_put_char+0x2b/0x2d
  [<ffffffff803ad3ca>] echo_char+0x47/0x60
  [<ffffffff803ade97>] n_tty_receive_buf+0x2b4/0xd76
  [<ffffffff8020a87e>] __switch_to+0xa2/0x396
  [<ffffffff8023028d>] hrtick_set+0x88/0xf6
  [<ffffffff80590b44>] thread_return+0x70/0xb4
  [<ffffffff8023f013>] lock_timer_base+0x26/0x4c
  [<ffffffff803a9abd>] flush_to_ldisc+0xf8/0x185
  [<ffffffff803a99c5>] flush_to_ldisc+0x0/0x185
  [<ffffffff8024520b>] run_workqueue+0x80/0x112
  [<ffffffff80245afe>] worker_thread+0xd9/0xe8
  [<ffffffff80248380>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80245a25>] worker_thread+0x0/0xe8
  [<ffffffff80248264>] kthread+0x47/0x73
  [<ffffffff802318c1>] schedule_tail+0x28/0x5d
  [<ffffffff8020cf88>] child_rip+0xa/0x12
  [<ffffffff8024821d>] kthread+0x0/0x73
  [<ffffffff8020cf7e>] child_rip+0x0/0x12

---[ end trace 656e180042992f9e ]---
I looked at the dmesg log because I have had lots of trouble with my gps 
lately. I first suspected the cable, but then I saw this.

After this, I have to restart gpsd, and perhaps replug the cable to get
things going again. Until it happens again. This is a 64-bit dualcore 
laptop.

Helge Hafting
