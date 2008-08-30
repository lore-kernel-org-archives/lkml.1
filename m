Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbYH3Vwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbYH3Vwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbYH3Vwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:52:46 -0400
Received: from ikar.perftech.si ([195.246.0.20]:1905 "EHLO ikar.perftech.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829AbYH3Vwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:52:45 -0400
X-ASG-Debug-ID: 1220133159-390200080000-xx1T2L
X-Barracuda-URL: http://10.12.0.14:5000/cgi-bin/mark.cgi
X-Spam-Processed: dedal.perftech.si, Sat, 30 Aug 2008 23:52:39 +0200
	(not processed: spam filter heuristic analysis disabled)
X-Authenticated-Sender: xerces8@butn.net
X-Return-Path: xerces8@butn.net
X-Envelope-From: xerces8@butn.net
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Date: Sat, 30 Aug 2008 23:52:33 +0200
From: "xerces8" <xerces8@butn.net>
To: linux-kernel@vger.kernel.org
X-ASG-Orig-Subj: oops during reboot in device_shutdown()
Subject: oops during reboot in device_shutdown()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <WorldClient-F200808302352.AA52330038@butn.net>
X-Mailer: WorldClient 9.6.4
X-MDAV-Processed: dedal.perftech.si, Sat, 30 Aug 2008 23:52:39 +0200
X-Barracuda-Connect: UNKNOWN[10.12.0.44]
X-Barracuda-Start-Time: 1220133160
X-Barracuda-Virus-Scanned: by OUTBOUND - ikar.perftech.si at perftech.si
X-Barracuda-Spam-Score: 0.50
X-Barracuda-Spam-Status: No, SCORE=0.50 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=BSF_RULE7568M
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.1.4187
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.50 BSF_RULE7568M          Custom Rule 7568M
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

While running RIPLinux* 6.3, I got the below oops.

What I did was boot up riplinux from USB key, start X, the run "reboot -f" on VT2.

* - http://www.tux.org/pub/people/kent-robotti/looplinux/rip/

After the oops I run "reboot" again and got the same oops again.
Note: I am not sure if I ran the 32 or 64 bit kernel.

For kernel config and (3 smallish) patches see:
http://www.tux.org/pub/people/kent-robotti/looplinux/rip/docs/kernel.txt
(or http://www.tux.org/pub/people/kent-robotti/looplinux/rip/docs/kernel64.txt)


HW: Asus P5K-E WiFi maonboard, BIOS version 1013
(Intel P35/ICH9R), CPU: Intel Core2 Q6600

The oops (both):

md: stopping all md devices.
BUG: unable to handle kernel NULL pointer dereference at 00000004
IP: [<c030b110>] device_shutdown+0x39/0x4c
*pde = 00000000 
Oops: 0000 [#1] 
Modules linked in: snd_mixer_oss snd_hda_intel snd_pcm snd_timer snd_page_alloc snd_hwdep snd
soundcore rtl8187 eeprom_93cx6

Pid: 1982, comm: reboot Not tainted (2.6.26 #8)
EIP: 0060:[<c030b110>] EFLAGS: 00010246 CPU: 0
EIP is at device_shutdown+0x39/0x4c
EAX: 00000000 EBX: ffffff90 ECX: 00000000 EDX: ffffff90
ESI: 28121969 EDI: b7fb2ff4 EBP: f7d0c000 ESP: f7d0de98
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process reboot (pid: 1982, ti=f7d0c000 task=f3052740 task.ti=f7d0c000)
Stack: 00000000 c011e1bd c011e2ad 01234567 c011e3ec f7d0df14 f7d0df3c 0000002b 
       f28d552c c0149ba1 f28d55c8 c0150d11 ffffff9c ffffff9c 00000401 ffffff9c 
       f28d552c c0949308 00000001 f30528a4 f3052768 c0111cc7 c0111bc9 f30d6ac8 
Call Trace:
 [<c011e1bd>] kernel_restart_prepare+0x20/0x25
 [<c011e2ad>] kernel_restart+0x8/0x2e
 [<c011e3ec>] sys_reboot+0x112/0x14f
 [<c0149ba1>] put_filp+0x14/0x31
 [<c0150d11>] __path_lookup_intent_open+0x6a/0x72
 [<c0111cc7>] dequeue_entity+0xf/0x8d
 [<c0111bc9>] __dequeue_entity+0x1f/0x71
 [<c0111c2c>] set_next_entity+0x11/0x38
 [<c065eb56>] schedule+0x22e/0x24a
 [<c01241d1>] hrtimer_cancel+0xa/0x14
 [<c065f085>] do_nanosleep+0x4e/0x7b
 [<c01244ba>] hrtimer_nanosleep+0x50/0xab
 [<c012412a>] hrtimer_wakeup+0x0/0x18
 [<c0124556>] sys_nanosleep+0x41/0x51
 [<c01036f2>] syscall_call+0x7/0xb
 =======================
Code: 74 eb 2b 8b 82 b4 00 00 00 85 c0 74 07 8b 48 20 85 c9 75 11 8b 82 b8 00 00 00 85 c0 74 0b 8b
48 18 85 c9 74 04 89 d0 ff d1 89 da <8b> 5b 74 83 eb 70 8d 42 70 3b 05 a4 bc 96 c0 75 c7 5b c3 55 89 
EIP: [<c030b110>] device_shutdown+0x39/0x4c SS:ESP 0068:f7d0de98
---[ end trace e0383ca117e3155e ]---
md: stopping all md devices.
BUG: unable to handle kernel NULL pointer dereference at 00000004
IP: [<c030b110>] device_shutdown+0x39/0x4c
*pde = 00000000 
Oops: 0000 [#2] 
Modules linked in: snd_mixer_oss snd_hda_intel snd_pcm snd_timer snd_page_alloc snd_hwdep snd
soundcore rtl8187 eeprom_93cx6

Pid: 2007, comm: reboot Tainted: G      D   (2.6.26 #8)
EIP: 0060:[<c030b110>] EFLAGS: 00010246 CPU: 0
EIP is at device_shutdown+0x39/0x4c
EAX: 00000000 EBX: ffffff90 ECX: 00000000 EDX: ffffff90
ESI: 28121969 EDI: b7f2cff4 EBP: f7d22000 ESP: f7d23e98
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process reboot (pid: 2007, ti=f7d22000 task=f30aeb60 task.ti=f7d22000)
Stack: 00000000 c011e1bd c011e2ad 01234567 c011e3ec f7d23f14 f7d23f3c 0000002b 
       f28d552c c0149ba1 f28d55c8 c0150d11 ffffff9c ffffff9c 00000401 ffffff9c 
       f28d552c c0949308 00000001 f30aecc4 f30aeb88 c0111cc7 c0111bc9 f30d6ac8 
Call Trace:
 [<c011e1bd>] kernel_restart_prepare+0x20/0x25
 [<c011e2ad>] kernel_restart+0x8/0x2e
 [<c011e3ec>] sys_reboot+0x112/0x14f
 [<c0149ba1>] put_filp+0x14/0x31
 [<c0150d11>] __path_lookup_intent_open+0x6a/0x72
 [<c0111cc7>] dequeue_entity+0xf/0x8d
 [<c0111bc9>] __dequeue_entity+0x1f/0x71
 [<c0111c2c>] set_next_entity+0x11/0x38
 [<c065eb56>] schedule+0x22e/0x24a
 [<c01241d1>] hrtimer_cancel+0xa/0x14
 [<c065f085>] do_nanosleep+0x4e/0x7b
 [<c01244ba>] hrtimer_nanosleep+0x50/0xab
 [<c012412a>] hrtimer_wakeup+0x0/0x18
 [<c0124556>] sys_nanosleep+0x41/0x51
 [<c01036f2>] syscall_call+0x7/0xb
 =======================
Code: 74 eb 2b 8b 82 b4 00 00 00 85 c0 74 07 8b 48 20 85 c9 75 11 8b 82 b8 00 00 00 85 c0 74 0b 8b
48 18 85 c9 74 04 89 d0 ff d1 89 da <8b> 5b 74 83 eb 70 8d 42 70 3b 05 a4 bc 96 c0 75 c7 5b c3 55 89 
EIP: [<c030b110>] device_shutdown+0x39/0x4c SS:ESP 0068:f7d23e98
---[ end trace e0383ca117e3155e ]---



Regards,
David


