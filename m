Return-Path: <linux-kernel-owner+w=401wt.eu-S1752212AbYAII7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbYAII7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 03:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYAII7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 03:59:40 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:35007 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYAII7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 03:59:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=ieLxDuTrolW5CxTMbvES50ytUsn2cBMV4Ev0lNR8up7KMbKn4AUC8d73KFcyLzO3v8w+sdjd1I8xFb1UUfkB7yUL7US26aIWpcouguIB29PLS/Bw2ZUU3sh4Wg2JvQpfzO0tjZQB6h5/wsunbJG7AA8qqNZ18jcdd2UbKaVg4DM=
Message-ID: <47848CF5.8000107@gmail.com>
Date: Wed, 09 Jan 2008 09:59:33 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@mail.ru>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org
Subject: evdev soft lockup 2.6.24-rc5-mm1
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this after resume (finally untainted version):

usb 4-1: new full speed USB device using uhci_hcd and address 14
usb 4-1: configuration #1 chosen from 1 choice
hub 4-1:1.0: USB hub found
hub 4-1:1.0: 3 ports detected
usb 4-1.1: new full speed USB device using uhci_hcd and address 15
usb 4-1.1: configuration #1 chosen from 1 choice
input: ABBHOME USB Keyboard as 
/devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.1/4-1.1:1.0/input/input14
BUG: soft lockup - CPU#1 stuck for 11s! [X:2887]
CPU 1:
Modules linked in: tun bitrev ipv6 arc4 ecb crypto_blkcipher cryptomgr 
crypto_algapi ath5k mac80211 rtc_cmos cfg80211 floppy rtc_core crc32 rtc_lib 
ehci_hcd sr_mod cdrom
Pid: 2887, comm: X Not tainted 2.6.24-rc5-mm1_64 #354
RIP: 0010:[<ffffffff804e87fb>]  [<ffffffff804e87fb>] _spin_lock+0xb/0x20
RSP: 0018:ffff810070f85dd8  EFLAGS: 00000286
RAX: 0000000000000000 RBX: ffff810070f85dd8 RCX: 0000000000000000
RDX: ffff810070f85fd8 RSI: ffff81007d060000 RDI: ffff81001f7176cc
RBP: ffff810070f85db8 R08: ffff810070f84000 R09: 00000000ffffffff
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81007c6acd00
R13: ffff810070f85e50 R14: 0000000000000002 R15: 7fffffffffffffff
FS:  00007fbfa053a780(0000) GS:ffff81007d011500(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000f1f600c4 CR3: 0000000070cc8000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
  [<ffffffff804e7648>] __mutex_lock_slowpath+0x38/0xd0
  [<ffffffff804e747e>] mutex_lock+0x1e/0x30
  [<ffffffff8040c497>] input_release_device+0x27/0x50
  [<ffffffff804102aa>] evdev_ungrab+0x3a/0x50
  [<ffffffff804103eb>] evdev_release+0xcb/0xd0
  [<ffffffff80293460>] __fput+0xc0/0x230
  [<ffffffff802938a6>] fput+0x16/0x20
  [<ffffffff80290296>] filp_close+0x56/0x90
  [<ffffffff80291afa>] sys_close+0x9a/0xf0
  [<ffffffff8020ba4e>] system_call+0x7e/0x83

I was not able to use sysrq keys, the keyboard is obviously defunct. If this is 
not known, I'll try to turn lockdep on and maybe connect through ssh next time 
it happens.

regards,
-- 
Jiri Slaby
Faculty of Informatics, Masaryk University
Suse Labs
