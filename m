Return-Path: <linux-kernel-owner+w=401wt.eu-S1751834AbZH0IwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbZH0IwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 04:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbZH0IwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 04:52:06 -0400
Received: from mail-qy0-f198.google.com ([209.85.221.198]:60240 "EHLO
	mail-qy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZH0IwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 04:52:03 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Aug 2009 04:52:03 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=JF83TwEc02l/e4COZ3UrwYfhkaO/FRzt/Q96rXPBaSlfSdxabJyzGknCLUrfiByjjz
         DSxNFkSO2IPmmwejBboWxQSsCj2mDM4MdOYNdwiEhSmc1Lou6GhsBeoDaQ2ReO0qUhbr
         Ne8L4woPWxyQAut05acR4+teZSfFUdEcIxuns=
MIME-Version: 1.0
Date: Thu, 27 Aug 2009 16:45:03 +0800
Message-ID: <df9815e70908270145q381ce8acxa3770480431ac526@mail.gmail.com>
Subject: BUG UNIX: Poison overwritten with 2.6.31-rc6-00223-g6c30c53
From: Jike Song <albcamus@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, I hit this with vnc. Below is part of dmesg :



general protection fault: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/tty/tty9/uevent
CPU 1
Modules linked in: fuse ipv6 cpufreq_ondemand acpi_cpufreq freq_table
dm_multipath uinput snd_hda_codec_atihdmi snd_hda_codec_realtek radeon
snd_hda_intel btusb bluetooth snd_hda_codec snd_hwdep ttm drm snd_pcm
snd_timer usb_storage snd i2c_i801 i2c_algo_bit e1000e soundcore
pcspkr i2c_core firewire_ohci firewire_core crc_itu_t dcdbas serio_raw
snd_page_alloc joydev iTCO_wdt iTCO_vendor_support ata_generic
pata_acpi [last unloaded: microcode]
Pid: 2663, comm: gvfsd-trash Not tainted 2.6.31-rc6-00223-g6c30c53 #1
Studio XPS 435MT
RIP: 0010:[<ffffffff814f89fa>]  [<ffffffff814f89fa>] unix_write_space+0x52/0x9d
RSP: 0018:ffff88019b3a7c48  EFLAGS: 00010202
RAX: 6b6b6b6b6b6b6bab RBX: ffff88019150a080 RCX: ffffffff814f89d9
RDX: ffff8800323f0500 RSI: ffffffff814f89d9 RDI: 6b6b6b6b6b6b6b6b
RBP: ffff88019b3a7c68 R08: ffff88019b11abb0 R09: 0000000000000000
R10: ffffffff81dfb3f0 R11: 0000000000000000 R12: ffff88019150a3a8
R13: 0000000000000139 R14: ffff88018edc7401 R15: ffff880194842140
FS:  00007f65e4dbb790(0000) GS:ffff8800323df000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000f1a020 CR3: 000000019b038000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process gvfsd-trash (pid: 2663, threadinfo ffff88019b3a6000, task
ffff88019b11a3f0)
Stack:
 ffff88019b3a7c58 00000000a3909618 ffff88019150a080 00000000fffffec8
<0> ffff88019b3a7ca8 ffffffff8145bc76 ffff880191508190 00000000a3909618
<0> ffff88019b3a7cb8 ffff880194842140 0000000000000000 ffffffff814f8e4b
Call Trace:
 [<ffffffff8145bc76>] sock_wfree+0x55/0x86
 [<ffffffff814f8e4b>] ? unix_release_sock+0x1cd/0x23f
 [<ffffffff814601e0>] skb_release_head_state+0x89/0xfd
 [<ffffffff8145fea3>] __kfree_skb+0x25/0xa7
 [<ffffffff8145fff4>] kfree_skb+0x79/0x98
 [<ffffffff814f8e4b>] unix_release_sock+0x1cd/0x23f
 [<ffffffff814f8e43>] unix_release_sock+0x1c5/0x23f
 [<ffffffff814f8ef4>] unix_release+0x37/0x4d
 [<ffffffff814579f6>] sock_release+0x32/0x98
 [<ffffffff81457a94>] sock_close+0x38/0x50
 [<ffffffff8113c92b>] __fput+0x137/0x1f8
 [<ffffffff8113ca19>] fput+0x2d/0x43
 [<ffffffff81138c14>] filp_close+0x77/0x97
 [<ffffffff81138cf4>] sys_close+0xc0/0x110
 [<ffffffff81012f02>] system_call_fastpath+0x16/0x1b
Code: 31 c0 4c 89 e7 e8 99 77 03 00 8b 83 84 01 00 00 c1 e0 02 3b 83
8c 01 00 00 7f 37 48 8b bb 20 01 00 00 48 85 ff 74 19 48 8d 47 40 <48>
39 47 40 74 0f ba 01 00 00 00 be 01 00 00 00 e8 ab 81 b5 ff
RIP  [<ffffffff814f89fa>] unix_write_space+0x52/0x9d
 RSP <ffff88019b3a7c48>
---[ end trace 1fa193deb8611c3d ]---
=============================================================================
BUG UNIX: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xffff88019150a3a8-0xffff88019150a3e7. First byte 0x6a instead of 0x6b
INFO: Allocated in sk_prot_alloc+0x48/0x111 age=192 cpu=4 pid=3562
INFO: Freed in __sk_free+0xe8/0x119 age=191 cpu=4 pid=3562
INFO: Slab 0xffffea000a308b40 objects=19 used=6 fp=0xffff88019150a080
flags=0x400000000040c3
INFO: Object 0xffff88019150a080 @offset=8320 fp=0xffff88019150ad80

Bytes b4 0xffff88019150a070:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff88019150a080:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a090:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a0a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a0b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a0c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a0d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a0e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a0f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a100:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a110:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a120:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a130:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a140:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a150:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a160:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a170:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a180:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a1a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a1b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a1c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a1d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a1e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a1f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a200:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a210:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a220:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a230:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a240:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a250:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a260:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a270:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a280:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a290:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a2a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a2b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a2c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a2d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a2e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a2f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a300:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a310:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a320:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a330:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a340:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a350:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a360:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a370:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a380:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a390:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a3a0:  6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b
6b 6b 6b kkkkkkkkjkkkkkkk
  Object 0xffff88019150a3b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a3c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a3d0:  6b 6b 6b 6b 6b 6b 6b 6b 01 00 00 00 6b
6b 6b 6b kkkkkkkk....kkkk
  Object 0xffff88019150a3e0:  d9 89 4f 81 ff ff ff ff 6b 6b 6b 6b 6b
6b 6b 6b Ù.O.ÿÿÿÿkkkkkkkk
  Object 0xffff88019150a3f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a400:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a410:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a420:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a430:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a440:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a450:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a460:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a470:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a480:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a490:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a4a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a4b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a4c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a4d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a4e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a4f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a500:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a510:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a520:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a530:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a540:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a550:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a560:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a570:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a580:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a590:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a5a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a5b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a5c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a5d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a5e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a5f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a600:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a610:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a620:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a630:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a640:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a650:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a660:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88019150a670:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b a5 kkkkkkkkkkkkkkk¥
 Redzone 0xffff88019150a680:  bb bb bb bb bb bb bb bb
       »»»»»»»»
 Padding 0xffff88019150a6c0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff88019150a6d0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff88019150a6e0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff88019150a6f0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a ZZZZZZZZZZZZZZZZ
Pid: 3627, comm: gvfsd-trash Tainted: G      D    2.6.31-rc6-00223-g6c30c53 #1
Call Trace:
 [<ffffffff8112c651>] print_trailer+0x153/0x174
 [<ffffffff8112cc89>] check_bytes_and_report+0xc9/0x10e
 [<ffffffff8112cda7>] check_object+0xd9/0x1d3
 [<ffffffff8112f1d3>] __slab_alloc+0x332/0x3f0
 [<ffffffff8145c060>] ? sk_prot_alloc+0x48/0x111
 [<ffffffff8112f50d>] kmem_cache_alloc+0xcb/0x18a
 [<ffffffff8145c060>] ? sk_prot_alloc+0x48/0x111
 [<ffffffff8145c060>] sk_prot_alloc+0x48/0x111
 [<ffffffff811512f1>] ? new_inode+0x43/0x99
 [<ffffffff8145c22a>] sk_alloc+0x3d/0x88
 [<ffffffff814f92e8>] unix_create1+0x5e/0x1a3
 [<ffffffff814f94a5>] unix_create+0x78/0x97
 [<ffffffff81457c4d>] __sock_create+0x1a1/0x270
 [<ffffffff81457bb7>] ? __sock_create+0x10b/0x270
 [<ffffffff81457dac>] sock_create+0x43/0x59
 [<ffffffff8145802f>] sys_socket+0x3a/0x7f
 [<ffffffff81012f02>] system_call_fastpath+0x16/0x1b
FIX UNIX: Restoring 0xffff88019150a3a8-0xffff88019150a3e7=0x6b

FIX UNIX: Marking all objects used
general protection fault: 0000 [#2] SMP
last sysfs file: /sys/devices/virtual/tty/tty9/uevent
CPU 1
Modules linked in: fuse ipv6 cpufreq_ondemand acpi_cpufreq freq_table
dm_multipath uinput snd_hda_codec_atihdmi snd_hda_codec_realtek radeon
snd_hda_intel btusb bluetooth snd_hda_codec snd_hwdep ttm drm snd_pcm
snd_timer usb_storage snd i2c_i801 i2c_algo_bit e1000e soundcore
pcspkr i2c_core firewire_ohci firewire_core crc_itu_t dcdbas serio_raw
snd_page_alloc joydev iTCO_wdt iTCO_vendor_support ata_generic
pata_acpi [last unloaded: microcode]
Pid: 3627, comm: gvfsd-trash Tainted: G      D
2.6.31-rc6-00223-g6c30c53 #1 Studio XPS 435MT
RIP: 0010:[<ffffffff814f89fa>]  [<ffffffff814f89fa>] unix_write_space+0x52/0x9d
RSP: 0018:ffff88018c795c48  EFLAGS: 00010202
RAX: 6b6b6b6b6b6b6bab RBX: ffff8801854ece00 RCX: ffffffff814f89d9
RDX: 0000000000000000 RSI: ffff8801854ed140 RDI: 6b6b6b6b6b6b6b6b
RBP: ffff88018c795c68 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801854ed128
R13: 0000000000000139 R14: ffff88018ec18a01 R15: ffff8801a9896280
FS:  00007f3715d90790(0000) GS:ffff8800323df000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001d0f0e8 CR3: 000000018c4af000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process gvfsd-trash (pid: 3627, threadinfo ffff88018c794000, task
ffff8801b4c20000)
Stack:
 ffff88018c795cb8 00000000e5f5a36f ffff8801854ece00 00000000fffffec8
<0> ffff88018c795ca8 ffffffff8145bc76 ffff88018c795cd8 00000000e5f5a36f
<0> ffff88018c795cb8 ffff8801a9896280 0000000000000000 ffffffff814f8e4b
Call Trace:
 [<ffffffff8145bc76>] sock_wfree+0x55/0x86
 [<ffffffff814f8e4b>] ? unix_release_sock+0x1cd/0x23f
 [<ffffffff814601e0>] skb_release_head_state+0x89/0xfd
 [<ffffffff8145fea3>] __kfree_skb+0x25/0xa7
 [<ffffffff8145fff4>] kfree_skb+0x79/0x98
 [<ffffffff814f8e4b>] unix_release_sock+0x1cd/0x23f
 [<ffffffff814f8e43>] unix_release_sock+0x1c5/0x23f
 [<ffffffff814f8ef4>] unix_release+0x37/0x4d
 [<ffffffff814579f6>] sock_release+0x32/0x98
 [<ffffffff81457a94>] sock_close+0x38/0x50
 [<ffffffff8113c92b>] __fput+0x137/0x1f8
 [<ffffffff81138c7a>] ? sys_close+0x46/0x110
 [<ffffffff8113ca19>] fput+0x2d/0x43
 [<ffffffff81138c14>] filp_close+0x77/0x97
 [<ffffffff81138cf4>] sys_close+0xc0/0x110
 [<ffffffff81012f02>] system_call_fastpath+0x16/0x1b
Code: 31 c0 4c 89 e7 e8 99 77 03 00 8b 83 84 01 00 00 c1 e0 02 3b 83
8c 01 00 00 7f 37 48 8b bb 20 01 00 00 48 85 ff 74 19 48 8d 47 40 <48>
39 47 40 74 0f ba 01 00 00 00 be 01 00 00 00 e8 ab 81 b5 ff
RIP  [<ffffffff814f89fa>] unix_write_space+0x52/0x9d
 RSP <ffff88018c795c48>
---[ end trace 1fa193deb8611c3e ]---
