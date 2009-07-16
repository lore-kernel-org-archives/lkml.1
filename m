Return-Path: <linux-kernel-owner+w=401wt.eu-S933488AbZGPWa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbZGPWa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 18:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933479AbZGPWa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 18:30:27 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:62791 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933465AbZGPWa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 18:30:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=REkvrsYnzO4qiEX4geqe4ww6Xv4Y5XqhjlPN9Sl0yWXz4f11cmLeLsZANEl1QBlRZ8
         XAn0+iusXqSIzxf+zU2vEYL+4ZZed1A2jPkekxiYnT3+Ca4QI+nbtHQywJybD58k5aC1
         Yhi30Lwh9M4CyWUhOnTehDrcAjm9FR37u6z88=
MIME-Version: 1.0
Date: Thu, 16 Jul 2009 15:30:24 -0700
Message-ID: <dd18b0c30907161530r11b0ff56u12368bc647ba53a@mail.gmail.com>
Subject: BUG: unable to handle kernel NULL pointer dereference at 00000004
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems This is the first time seeing this.
steps to recreate(not sure) What I was doing was simple
exited out of fluxbox(killed the xserver) to read some
debug messages in bash for a few minuets. Once done
pressing the powerbutton(which is a simple custom rule:
shutdown -h now no more no less) resulted in this:

[22629.384502] BUG: unable to handle kernel NULL pointer dereference at 00000004
[22629.390005] IP: [<c11aaf5c>] tty_ldisc_wait_idle+0x75/0xcd
[22629.390005] *pde = 00000000
[22629.390005] Oops: 0000 [#1] SMP
[22629.390005] last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/net/wlan0/statistics/tx_bytes
[22629.390005] Modules linked in: radeon iptable_nat nf_nat ipt_LOG
xt_state nf_conntrack_ftp snd_hda_codec_idt snd_hda_intel
snd_hda_codec firewire_ohci ath9k snd_hwdep firewire_core snd_pcm
ohci1394 snd_timer ieee1394 ath sky2 joydev i2c_i801 evdev
snd_page_alloc battery button video ac thermal drm agpgart uhci_hcd
ehci_hcd hci_uart rfcomm btusb hidp l2cap bluetooth ipmi_watchdog
ipmi_msghandler uvcvideo isight_firmware uinput arpt_mangle
arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables
coretemp acpi_cpufreq processor appletouch applesmc
[22629.390005]
[22629.390005] Pid: 1581, comm: login Not tainted
(2.6.31-rc2-00002-g9c8ccd8 #7) MacBookPro2,2
[22629.390005] EIP: 0060:[<c11aaf5c>] EFLAGS: 00010246 CPU: 0
[22629.390005] EIP is at tty_ldisc_wait_idle+0x75/0xcd
[22629.390005] EAX: 00000000 EBX: f4a149b0 ECX: f48ede04 EDX: 00000029
[22629.390005] ESI: 000001f4 EDI: f48ede0c EBP: f48ede18 ESP: f48eddf4
[22629.390005]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[22629.390005] Process login (pid: 1581, ti=f48ec000 task=f4990ed0
task.ti=f48ec000)
[22629.390005] Stack:
[22629.390005]  f48eddf8 00000000 f4990ed0 c103b239 c1486b94 c1486b94
f4a149b0 f4a149c4
[22629.390005] <0> f4a14b48 f48ede30 c11ab528 00000000 f4a149b0
f4a14b48 f4a14b48 f48ede5c
[22629.390005] <0> c11a5a7f 00000001 00000286 00000000 00000001
00000001 00000000 f7199d80
[22629.390005] Call Trace:
[22629.390005]  [<c103b239>] ? autoremove_wake_function+0x0/0x2f
[22629.390005]  [<c11ab528>] ? tty_ldisc_hangup+0xac/0x159
[22629.390005]  [<c11a5a7f>] ? do_tty_hangup+0xd5/0x2b3
[22629.390005]  [<c11a5f40>] ? disassociate_ctty+0x3e/0x1d8
[22629.390005]  [<c102c886>] ? do_exit+0x1a8/0x573
[22629.390005]  [<c1034f16>] ? dequeue_signal+0xb1/0x124
[22629.390005]  [<c102ccb0>] ? do_group_exit+0x5f/0x86
[22629.390005]  [<c103547e>] ? get_signal_to_deliver+0x2e6/0x300
[22629.390005]  [<c1001d6b>] ? do_notify_resume+0x77/0x6ae
[22629.390005]  [<c103b411>] ? remove_wait_queue+0x31/0x36
[22629.390005]  [<c102c4f7>] ? do_wait+0x1ba/0x253
[22629.390005]  [<c1025ff7>] ? default_wake_function+0x0/0xd
[22629.390005]  [<c10599b0>] ? audit_syscall_exit+0x2da/0x2f2
[22629.390005]  [<c10029f6>] ? work_notifysig+0x13/0x19
[22629.390005] Code: 00 f3 ab 89 55 e4 c7 45 e8 39 b2 03 c1 8d 55 ec
89 55 ec 89 55 f0 b8 84 6b 48 c1 b9 02 00 00 00 8d 55 e0 e8 40 04 e9
ff 8b 43 3c <83> 78 04 00 74 0d 89 f0 e8 5c 39 15 00 89 c6 85 c0 75 d8
8d 55
[22629.390005] EIP: [<c11aaf5c>] tty_ldisc_wait_idle+0x75/0xcd SS:ESP
0068:f48eddf4
[22629.390005] CR2: 0000000000000004
[22629.848586] ---[ end trace 8e9b6fafeaa6890a ]---
[22629.860085] Fixing recursive fault but reboot is needed!

must have exited to bash for at least a half hour or so before
pressing the power button.



-- 
Justin P. Mattock
