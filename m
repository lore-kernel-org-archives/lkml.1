Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZGDHQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZGDHQF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 03:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbZGDHPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 03:15:53 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62141 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbZGDHPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 03:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Z1X+vQUd9KtwyexXiTTZAyVQPP9YS9pbMaTmjH7ultlYkM/djxDIR+X1Ctg1a9zU5I
         QQ7m47MOVE/jISViVQ4xcwGMYiDOsPhliK5KbTRGbwuVcx24YgaBJuufLI/Y5900sHM3
         f3EorpXjkIJTjXnwZWxlNts0pIh5VTqbV2upA=
Message-ID: <4A4F0FD4.7070009@gmail.com>
Date: Sat, 04 Jul 2009 10:16:20 +0200
From: "Mikko C." <mikko.cal@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: kernel BUG at fs/notify/notification.c:93!
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
since upgrading to 2.6.31-rc1 I randomly get this:

kernel BUG at 
fs/notify/notification.c:93!                                                                                   

invalid opcode: 0000 [#1] PREEMPT 
SMP                                                                                        

last sysfs file: 
/sys/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT0/charge_full                                 

CPU 
0                                                                                                                        

Modules linked in: radeon drm snd_seq snd_seq_device vfat fat coretemp 
hwmon cpufreq_ondemand fan snd_hda_codec_idt iwl3945 iwlcore mac80211 
snd_hda_intel snd_hda_codec led_class usb_storage snd_pcm snd_timer 
cfg80211 psmouse dell_laptop snd uhci_hcd evdev rfkill soundcore 
ehci_hcd snd_page_alloc ac thermal wmi battery 
button                                               
Pid: 5658, comm: krunner Not tainted 2.6.31-rc1 #2 
MM061                                                                    
RIP: 0010:[<ffffffff810db63a>]  [<ffffffff810db63a>] 
fsnotify_put_event+0x5a/0x60                                           
RSP: 0018:ffff8800658b9e58  EFLAGS: 
00010287                                                                                 

RAX: ffff880073fd4c18 RBX: ffff880073fd4bc0 RCX: 
0000000000000000                                                           
RDX: 0000000000000001 RSI: ffffffff8162bf53 RDI: 
ffff880073fd4bc0                                                           
RBP: 0000000000000040 R08: 0000000001b47300 R09: 
ffff88007efd1f00                                                           
R10: 0000000001a92490 R11: 0000000000000246 R12: 
ffff880073fd4bc0                                                           
R13: 00007fffa83d7e80 R14: 0000000000000003 R15: 
ffff88007ef599c0                                                           
FS:  00007f824ea26750(0000) GS:ffff880001651000(0000) 
knlGS:0000000000000000                                                
CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b                                                                            

CR2: 00007f63b12c5000 CR3: 00000000658c4000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process krunner (pid: 5658, threadinfo ffff8800658b8000, task 
ffff88007f9ead20)
Stack:
 0000000000000030 ffffffff810ddf35 0000000000000240 00007fffa83d7e80
<0> ffff88007efd1f00 ffff88007ef59a18 ffff88007ef599e8 0000002da83d91ac
<0> 0000000000000000 ffff88007f9ead20 ffffffff81051b90 ffff88007ef59a20
Call Trace:
 [<ffffffff810ddf35>] ? inotify_read+0x2e5/0x310
 [<ffffffff81051b90>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff810ba30b>] ? do_vfs_ioctl+0x3fb/0x580
 [<ffffffff810ac028>] ? vfs_read+0xc8/0x1a0
 [<ffffffff810ac203>] ? sys_read+0x53/0xa0
 [<ffffffff8100b3eb>] ? system_call_fastpath+0x16/0x1b
Code: ff 48 89 de 48 8b 3d 4e 08 55 00 5b e9 a0 a7 fc ff 5b c3 66 0f 1f 
44 00 00 48 8d 7f 28 e8 4f 8d fd ff 0f 1f 80 00 00 00 00 eb c3 <0f> 0b 
eb fe 66 90 41 57 4c 8d 7f 28 41 56 41 55 41 54 55 48 89
RIP  [<ffffffff810db63a>] fsnotify_put_event+0x5a/0x60
 RSP <ffff8800658b9e58>
---[ end trace b3964c675905b0bb ]---

Sorry if it's been reported already, I couldn't find it.
I'm not subscribed so please CC me if you answer.
Thanks.

Mikko
