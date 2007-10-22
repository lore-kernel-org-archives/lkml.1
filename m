Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbXJVQnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbXJVQnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 12:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbXJVQne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 12:43:34 -0400
Received: from mail43.e.nsc.no ([193.213.115.43]:52038 "EHLO mail43.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbXJVQnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 12:43:33 -0400
X-Greylist: delayed 3399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2007 12:43:33 EDT
To: linux-kernel@vger.kernel.org
Subject: USB Disconnect BUG with RT Kernels (linux-2.6.23-rt1)
From: Esben Stien <b0ef@esben-stien.name>
X-Home-Page: http://www.esben-stien.name
Date: Mon, 22 Oct 2007 19:38:13 +0200
Message-ID: <87640zgid6.fsf@esben-stien.name>
User-Agent: Gnus/5.1006 (Gnus v5.10.6) Emacs/22.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I also saw this in 2.6.22-rt9. When I disconnect a USB device the
whole USB system goes down and I'm not able to insert any other USB
device until I reboot.

This happens every time. I'm on a P4.

usb 1-1.3: USB disconnect, address 11
BUG: unable to handle kernel paging request at virtual address 00100100
 printing eip:
c031c3d9
*pde = 00000000
stopped custom tracer.
Oops: 0000 [#1]
PREEMPT 
Modules linked in: snd_seq_midi snd_rtctimer rtc radeon snd_hdsp snd_rawmidi firmware_class snd_hwdep
CPU:    0
EIP:    0060:[<c031c3d9>]    Not tainted VLI
EFLAGS: 00010206   (2.6.23-rt1 #1)
EIP is at evdev_disconnect+0x5b/0x96
eax: 00000000   ebx: 000ffcf0   ecx: 00000073   edx: c1e03450
esi: f7540000   edi: f754006c   ebp: f7bb9800   esp: c1e07e84
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068  preempt:00000001
Process khubd (pid: 82, ti=c1e06000 task=c1e03450 task.ti=c1e06000)
Stack: f7f1d400 f7ea4000 f7ea47f4 f7ea7000 c0319a64 00000000 f7ea6000 f7ea7000 
       f7bb9800 f6ac3b00 f7ea7c58 c032a139 f7ea601c f7ea6000 f7ea7000 c032d697 
       f7bb9800 f7bb981c c04afd40 f66f3858 c02fd799 f7bb981c c04afd88 00000000 
Call Trace:
 [<c0319a64>] input_unregister_device+0x67/0xfc
 [<c032a139>] hidinput_disconnect+0x2e/0x47
 [<c032d697>] hid_disconnect+0x76/0xce
 [<c02fd799>] usb_unbind_interface+0x2d/0x6e
 [<c02b7ba4>] __device_release_driver+0x71/0x8e
 [<c02b7c65>] device_release_driver+0x18/0x21
 [<c02b76f3>] bus_remove_device+0x70/0x80
 [<c02b5ddf>] device_del+0x1bb/0x22f
 [<c02fb4f1>] usb_disable_device+0x5c/0xbb
 [<c02f807d>] usb_disconnect+0x7a/0xd3
 [<c02f85a9>] hub_thread+0x30f/0x9ea
 [<c010d79a>] update_stats_wait_end+0x9b/0xbe
 [<c03c4c32>] __schedule+0x27e/0x36d
 [<c01214e5>] autoremove_wake_function+0x0/0x35
 [<c02f829a>] hub_thread+0x0/0x9ea
 [<c012142e>] kthread+0x36/0x5c
 [<c01213f8>] kthread+0x0/0x5c
 [<c0102913>] kernel_thread_helper+0x7/0x10
 =======================
Code: e8 3c c5 ff ff 8b 5e 64 eb 1b 8d 83 08 04 00 00 b9 06 00 02 00 ba 1d 00 00 00 e8 d7 fc e3 ff 8b 9b 10 04 00 00 81 eb 10 04 00 00 <8b> 83 10 04 00 00 0f 18 00 90 8d 93 10 04 00 00 8d 46 64 39 c2 
EIP: [<c031c3d9>] evdev_disconnect+0x5b/0x96 SS:ESP 0068:c1e07e84

-- 
Esben Stien is b0ef@e     s      a             
         http://www. s     t    n m
          irc://irc.  b  -  i  .   e/%23contact
           sip:b0ef@   e     e 
           jid:b0ef@    n     n
