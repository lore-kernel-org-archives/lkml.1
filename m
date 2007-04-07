Return-Path: <linux-kernel-owner+w=401wt.eu-S966235AbXDGSLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966235AbXDGSLR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 14:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966236AbXDGSLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 14:11:16 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:59273 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966235AbXDGSLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 14:11:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=JuF0pe3q/QmgUuJYhjbQxW62S19w7GyZs/yHoGpCrtArvJ3t7/Lu6Qi/r4NjBglqBtFPA1DHrUDuOU0l3QdAANaqUY2KS2ZuZbE3eOfX+G5xaX+1SrHBrszLGV5iVJ7pmbDRIuh62ScSZDDytZvALTfq3+OQFqU9P2YjUQw4Qs0=
Message-ID: <19061b0b0704071111m65c70d1ei736de86ad2f09a82@mail.gmail.com>
Date: Sat, 7 Apr 2007 20:11:13 +0200
From: Bartek <poemann@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at net/core/skbuff.c in linux-2.6.21-rc6
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo

I have problem with a Linux kernel oops. It mostly appears when I
download files using bittorrent or other large file. I have a phone
modem based Internet access using Home Internet Solution
(http://en.wikipedia.org/wiki/Home_internet_Solution). I use Debian
testing, Linux vanilla version: 2.6.21-rc6 (however I noticed that
problem since Linux ver. 2.6.15, doesn't matter if that was vanilla
kernel or from Debian distro), Here my sys info:

Linux mars 2.6.21-rc6 #3 Sat Apr 7 16:11:12 CEST 2007 i686 GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.3-pre2
e2fsprogs              1.40-WIP
xfsprogs               2.8.11
PPP                    2.4.4
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   105
Modules Loaded         nvidia vmnet vmmon nfs nfsd exportfs lockd
nfs_acl sunrpc button xt_TCPMSS xt_limit xt_tcpudp nf_nat_irc
nf_nat_ftp iptable_nat iptable_mangle ipt_LOG ipt_MASQUERADE nf_nat
ipt_TOS ipt_REJECT nf_conntrack_irc nf_conntrack_ftp nf_conntrack_ipv4
xt_state nf_conntrack nfnetlink iptable_filter ip_tables x_tables
ppp_async ipv6 ppp_generic slhc xfs eeprom w83781d w83627hf hwmon_vid
i2c_isa ide_generic parport_pc parport rtc floppy serio_raw pcspkr
psmouse i2c_viapro snd_via82xx snd_ac97_codec ac97_bus snd_pcm
snd_timer snd_page_alloc snd_mpu401_uart i2c_core via_ircc snd_rawmidi
snd_seq_device via_agp agpgart snd irda crc_ccitt soundcore evdev ext3
jbd mbcache usbhid ide_cd cdrom ide_disk generic uhci_hcd usbcore
via82cxxx ide_core e100 mii thermal processor fan

If there are needs for more info, don't hesitate to ask. If anyone can
help me and write a patch, I'll be appreciated.
Here is a log from syslog:

Apr  7 17:45:52 localhost kernel: skb_under_panic: text:f8e36c0e
len:107 put:1 head:df928000 data:df927fff tail:df92806a end:df928600
dev:<NULL>
Apr  7 17:45:52 localhost kernel: ------------[ cut here ]------------
Apr  7 17:45:52 localhost kernel: kernel BUG at net/core/skbuff.c:111!
Apr  7 17:45:52 localhost kernel: invalid opcode: 0000 [#1]
Apr  7 17:45:52 localhost kernel: Modules linked in: w83781d w83627hf
i2c_dev nvidia(P) nfs nfsd exportfs lockd nfs_acl sunrpc button
xt_TCPMSS xt_limit xt_tcpudp nf_nat_irc nf_nat_ftp iptable_nat
iptable_mangle ipt_LOG ipt_MASQUERADE nf_nat ipt_TOS ipt_REJECT
nf_conntrack_irc nf_conntrack_ftp nf_conntrack_ipv4 xt_state
nf_conntrack nfnetlink iptable_filter ip_tables x_tables ppp_async
ipv6 ppp_generic slhc xfs eeprom hwmon_vid i2c_isa ide_generic rtc
snd_via82xx snd_ac97_codec ac97_bus snd_pcm snd_timer snd_page_alloc
snd_mpu401_uart i2c_viapro i2c_core serio_raw snd_rawmidi
snd_seq_device via_ircc psmouse pcspkr floppy irda snd crc_ccitt
soundcore via_agp agpgart evdev ext3 jbd mbcache usbhid ide_cd cdrom
ide_disk generic uhci_hcd usbcore via82cxxx ide_core e100 mii thermal
processor fan
Apr  7 17:45:52 localhost kernel: CPU:    0
Apr  7 17:45:52 localhost kernel: EIP:    0060:[<c021af98>]
Tainted: P       VLI
Apr  7 17:45:52 localhost kernel: EFLAGS: 00010096   (2.6.21-rc6 #2)
Apr  7 17:45:52 localhost kernel: EIP is at skb_under_panic+0x59/0x5d
Apr  7 17:45:52 localhost kernel: eax: 00000072   ebx: df928000   ecx:
00000000   edx: 00000000
Apr  7 17:45:52 localhost kernel: esi: 00000000   edi: df92806c   ebp:
df92806b   esp: c17e5ed8
Apr  7 17:45:52 localhost kernel: ds: 007b   es: 007b   fs: 00d8  gs:
0000  ss: 0068
Apr  7 17:45:52 localhost kernel: Process events/0 (pid: 3,
ti=c17e4000 task=dfd02030 task.ti=c17e4000)
Apr  7 17:45:52 localhost kernel: Stack: c02c4d51 f8e36c0e 0000006b
00000001 df928000 df927fff df92806a df928600
Apr  7 17:45:52 localhost kernel:        c02b83d5 e366f8e0 000000ff
f8e36c13 ffffffff c01044d7 00000000 c17e4000
Apr  7 17:45:52 localhost kernel:        f7f9f576 f7f9f476 f6b9a800
00000202 dfe60c00 00000001 f7f9f400 f6b9a80c
Apr  7 17:45:52 localhost kernel: Call Trace:
Apr  7 17:45:52 localhost kernel:  [<f8e36c0e>]
ppp_asynctty_receive+0x3b0/0x584 [ppp_async]
Apr  7 17:45:52 localhost kernel:  [<f8e36c13>]
ppp_asynctty_receive+0x3b5/0x584 [ppp_async]
Apr  7 17:45:52 localhost kernel:  [<c01044d7>] common_interrupt+0x23/0x28
Apr  7 17:45:52 localhost kernel:  [<c01ea3c6>] flush_to_ldisc+0xe6/0x124
Apr  7 17:45:52 localhost kernel:  [<c01ea2e0>] flush_to_ldisc+0x0/0x124
Apr  7 17:45:52 localhost kernel:  [<c0122983>] run_workqueue+0x70/0x101
Apr  7 17:45:52 localhost kernel:  [<c0122ecc>] worker_thread+0x105/0x12e
Apr  7 17:45:52 localhost kernel:  [<c0114a9e>] default_wake_function+0x0/0xc
Apr  7 17:45:52 localhost kernel:  [<c0122dc7>] worker_thread+0x0/0x12e
Apr  7 17:45:52 localhost kernel:  [<c0125090>] kthread+0xa0/0xc8
Apr  7 17:45:52 localhost kernel:  [<c0124ff0>] kthread+0x0/0xc8
Apr  7 17:45:52 localhost kernel:  [<c0104657>] kernel_thread_helper+0x7/0x10
Apr  7 17:45:52 localhost kernel:  =======================
Apr  7 17:45:52 localhost kernel: Code: 00 00 89 5c 24 14 8b 98 a0 00
00 00 89 54 24 0c 89 5c 24 10 8b 40 60 89 4c 24 04 c7 04 24 51 4d 2c
c0 89 44 24 08 e8 f2 c8 ef ff <0f> 0b eb fe 56 53 bb d5 83 2b c0 83 ec
24 8b 70 14 85 f6 0f 45
Apr  7 17:45:52 localhost kernel: EIP: [<c021af98>]
skb_under_panic+0x59/0x5d SS:ESP 0068:c17e5ed8
Apr  7 17:46:01 localhost /USR/SBIN/CRON[16193]: (root) CMD
(/usr/local/bin/pppd_test.sh)
Apr  7 17:46:41 localhost pppd[2132]: No response to 5 echo-requests
Apr  7 17:46:41 localhost pppd[2132]: Serial link appears to be disconnected.
Apr  7 17:46:41 localhost pppd[2132]: Connect time 423.3 minutes.
Apr  7 17:46:41 localhost pppd[2132]: Sent 72441222 bytes, received
121032582 bytes.
Apr  7 17:46:41 localhost pppd[2132]: Script /etc/ppp/ip-down started
(pid 16196)
Apr  7 17:46:41 localhost pppd[2132]: sent [LCP TermReq id=0x3d "Peer
not responding"]
Apr  7 17:46:41 localhost pppd[2132]: Script /etc/ppp/ip-down finished
(pid 16196), status = 0x0
Apr  7 17:46:44 localhost pppd[2132]: sent [LCP TermReq id=0x3e "Peer
not responding"]
Apr  7 17:46:47 localhost pppd[2132]: Connection terminated.

Bartek
