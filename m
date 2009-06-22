Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbZFVN1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbZFVN1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZFVN1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:27:24 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:56907 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZFVN1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:27:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h5INTsYN+zpgJ1PBTsHcpb6SKRKqzWdBc4NifoZhe9TpCnQnQnZeWgf0XX9YDJJ9ug
         keUvqvo1Dp4hTr9Tx317nGPKQd3gVx0J22rvrI7O+NGzlHwz5n+ziUDAS9Wi7V+0NjMp
         H928FeV9K0pX9rhtlonKgdDUKapjP6+uTSOiE=
MIME-Version: 1.0
In-Reply-To: <4A3F7A93.5080004@linux.intel.com>
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
	 <4A3E7F38.7030300@linux.intel.com>
	 <8db1092f0906211313x73ac9340n9af5775b56cfd189@mail.gmail.com>
	 <4A3EE668.5090400@jp.fujitsu.com>
	 <8db1092f0906220019x1560c26dsd5a6daa3ea612ec@mail.gmail.com>
	 <4A3F55C7.4030909@linux.intel.com>
	 <8db1092f0906220453k5595998er1400567cbcdf3e12@mail.gmail.com>
	 <4A3F7A93.5080004@linux.intel.com>
Date: Mon, 22 Jun 2009 15:27:24 +0200
Message-ID: <8db1092f0906220627w61d9f97g88c91f770f732f03@mail.gmail.com>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend to 
	disk, mce related?
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/22 Andi Kleen <ak@linux.intel.com>:

> Was this with check_interval = 1 ?
>
> Do you see something when you set it to 60 or so (you need to wait 60
> seconds)?

I try check_interval=10 before suspend fot machinecheck0 and
mechinecheck1. Suspend to disk works (not hangs like for "1"). System
hangs few seconds after resume:
[...]
[   68.071137] CPU1 is up
[   68.073336] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[   68.126110] usb usb3: root hub lost power or was reset
[   68.126249] ehci_hcd 0000:00:1d.7: PME# disabled
[   68.132082] r8169 0000:02:00.0: PME# disabled
[   68.132935] serial 00:07: activated
[   68.136433] r8169: eth0: link up
[   68.287417] ata2.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
[   68.290331] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[   68.302257] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
[   68.324357] ata1.00: configured for UDMA/133
[   69.656127] btusb 4-1:1.0: no reset_resume for driver btusb?
[   70.708015] usb 5-2: reset low speed USB device using uhci_hcd and address 3

It seems, that resume isn't resume completely.


Also I try 20 seconds and find this in netconsole:
[  532.576128] BUG: soft lockup - CPU#1 stuck for 61s! [ksensors:2670]
[  532.576128] Modules linked in: i915 drm i2c_algo_bit video
backlight output ppdev lp rfcomm l2cap xt_tcpudp xt_limit snd[
532.576128]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  532.576128]  [<c01a266d>] sys_read+0x3d/0x70
^[[B^[[A[  598.075129] Modules linked in: i915 drm i2c_algo_bit video
backlight output ppdev lp rfcomm l2cap xt_tcpudp xt_limit xt_state
snd_seq_device[  598.075129] EAX: 00000001 EBX: c28023e0 ECX: 00000292
EDX: 000008fb
[  598.075129]  [<c01a24f9>] vfs_read+0x99/0x150
[  663.573129] Modules linked in: i915 drm i2c_algo_bit video
backlight output ppdev lp rfcomm l2cap xt_tcpudp xt_limit xt_state
snd_timer[  663.573129] EIP is at generic_exec_single+0x5e/0x90
[  663.573129]  [<c01a24f9>] vfs_read+0x99/0x150
[  729.071129] Modules linked in: i915 drm i2c_algo_bit video
backlight output ppdev lp rfcomm l2cap xt_tcpudp xt_limit xt_state
snd_seq[  729.071129] EIP: 0060:[<c015979a>] EFLAGS: 00000202 CPU: 1
[  729.071129]  [<c0226aaf>] ? security_file_permission+0xf/0x20
[  794.569130] Modules linked in: i915 drm i2c_algo_bit video
backlight output ppdev lp rfcomm l2cap xt_tcpudp xt_limit xt_state
iptable_filter nf_defrag_ipv4 fuse coretemp loop bluetooth
snd_hda_codec[  860.068130] BUG: softlockup - CPU#1 stuck for 61s!
[ksensors:2670]
[  860.068130] Modules linked in: i915 drm i2c_algo_bit video
backlight output ppdev lp rfcomm l2cap xt_tcpudp xt_limit xt_state
nf_conntrack x_tables dm_mod hwmon_vid btusb snd_hda_intel[
925.566131] Modules linked in: i915drm i2c_algo_bit video backlight
output ppdev lp rfcomm l2cap xt_tcpudp xt_limit xt_state
iptable_filter nf_conntrack x_tables dm_mod loop btusb snd_hda_intel[
991.064131] Modules linked in: i915 drm i2c_algo_bit video backlight
output ppdev lp rfcomm l2cap xt_tcpudp xt_limit xt_state snd_seq[
991.064131] EIP: 0060:[<c0159798>] EFLAGS: 00000202 CPU: 1
[  991.064131]  [<c0226aaf>] ? security_file_permission+0xf/0x20
[ 1056.562131] Modules linked in: i915 drm i2c_algo_bit video
backlight output ppdev lp rfcomm l2cap xt_tcpudp xt_limit xt_state
snd_seq_midi_event[ 1056.562131] EIP: 0060:[<c015979a>] EFLAGS:
00000202 CPU: 1
[ 1056.562131]  [<c01ec20d>] sysfs_read_file+0x7d/0x110
[ 1122.061132] Modules linked in: i915 drm i2c_algo_bit video
backlight output ppdev lp rfcomm l2cap xt_tcpudp xt_limit xt_state
snd_seq_device[ 1122.061132] EAX: 00000001 EBX: c28023e0 ECX: 00000292
EDX: 000008fb
[ 1122.061132]  [<c01a24f9>] vfs_read+0x99/0x150
[ 1187.559132] Modules linked in: i915 drm i2c_algo_bit video
backlight output ppdev lp rfcomm l2cap xt_tcpudp xt_limit xt_state
snd_seq_device[ 1187.559132] EAX: 00000001 EBX: c28023e0 ECX: 00000292
EDX: 000008fb
[ 1187.559132]  [<c01a24f9>] vfs_read+0x99/0x150
[ 1253.057133] Modules linked in: i915 drm i2c_algo_bit video
backlight output ppdev lp rfcomm l2cap xt_tcpudp xt_limit xt_state
snd_timer[ 1253.057133] EIP is at generic_exec_single+0x5e/0x90
[ 1253.057133]  [<c01a24f9>] vfs_read+0x99/0x150
[ 1318.555133] Modules linked in: i915 drm i2c_algo_bit video
backlight output ppdev lp rfcomm l2cap xt_tcpudp xt_limit xt_state
snd_seq[ 1318.555133] EIP is at generic_exec_single+0x5a/0x90
[ 1318.555133]  [<c0226aaf>] ? security_file_permission+0xf/0x20
[ 1384.054133] Modules linked in: i915 drm i2c_algo_bit video
backlight output ppdev lp rfcomm l2cap xt_tcpudp xt_limit xt_state
snd[ 1384.054133] EAX: 00000001 EBX: c28023e0 ECX: 00000292 EDX:
000008fb
[ 1384.054133]  [<c01ec190>] ? sysfs_read_file+0x0/0x110
[ 1449.552134] Modules linked in: i915 drm i2c_algo_bit video
backlight output ppdev lp rfcomm l2cap xt_tcpudp xt_limit xt_state
snd_seq_device[ 1449.552134] EAX: 00000001 EBX: c28023e0 ECX: 00000292
EDX: 000008fb
[ 1449.552134]  [<c01a24f9>] vfs_read+0x99/0x150

Message appears very slowly.


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
