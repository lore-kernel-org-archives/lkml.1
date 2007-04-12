Return-Path: <linux-kernel-owner+w=401wt.eu-S1422662AbXDLFSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422662AbXDLFSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 01:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422663AbXDLFSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 01:18:37 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:47835 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422662AbXDLFSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 01:18:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tW8b0Sz5J64/Igilm9GsuKAJQdx2mqPxx4xFYE/VStgEMs7P4+4lKNys4x+uuoyW44TvIJSsUvkhIjNqzKp09VI1VMMqyW3zZlhvGsuiAUKDxIXWcfMQjYkcDcwwL/BQsbAnvWX+KfxY4Y5uzzBB2/wBe6P+i0WahY1cW/Vw8r4=
Message-ID: <19061b0b0704112218j13688c16xc755d66147f8fe6a@mail.gmail.com>
Date: Thu, 12 Apr 2007 07:18:35 +0200
From: Bartek <poemann@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at net/core/skbuff.c in linux-2.6.21-rc6
In-Reply-To: <9a8748490704100425t34ebafcdq866a923df80b9aca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19061b0b0704071111m65c70d1ei736de86ad2f09a82@mail.gmail.com>
	 <20070407.234708.93384523.davem@davemloft.net>
	 <19061b0b0704081315g3593d652s70e9b5b0dcfcf966@mail.gmail.com>
	 <19061b0b0704100219w4749e5fby9b400edca9bf334d@mail.gmail.com>
	 <9a8748490704100425t34ebafcdq866a923df80b9aca@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It is not enough to unload proprietary modules. As long as they have
> ever been loaded at all the kernel is tainted.
> You need to ensure that the proprietary modules never get loaded at
> all. I guess you probably already worked that out, just wanted to
> point it out just in case :-)

Hopefully, this time it my bug report should be ok :):

Apr 11 23:53:38 localhost pppd[31289]: rcvd [proto=0x7689] e1 cd 33 f6
fd f7 52 e6 58 c9 73 98 bc ff ad d5 b5 a3 e5 d9 1e 77 76 0a 1c 87 59
bf 44 cc ac 3b ...
Apr 11 23:53:38 localhost pppd[31289]: Unsupported protocol 0x7689 received
Apr 11 23:53:38 localhost pppd[31289]: sent [LCP ProtRej id=0x9 76 89
e1 cd 33 f6 fd f7 52 e6 58 c9 73 98 bc ff ad d5 b5 a3 e5 d9 1e 77 76
0a 1c 87 59 bf 44 cc ...]
Apr 11 23:53:38 localhost pppd[31289]: rcvd [proto=0xda7d] 15 19 45 3c
e0 ac 44 92 3b c4 8e 75 6b b8 4a 9f 4a 3a 22 63 d3 a1 56 98 47 62 bc
cd a6 8e d5 77 ...
Apr 11 23:53:38 localhost pppd[31289]: Unsupported protocol 0xda7d received
Apr 11 23:53:38 localhost pppd[31289]: sent [LCP ProtRej id=0xa da 7d
15 19 45 3c e0 ac 44 92 3b c4 8e 75 6b b8 4a 9f 4a 3a 22 63 d3 a1 56
98 47 62 bc cd a6 8e ...]
Apr 11 23:53:40 localhost kernel: skb_under_panic: text:f8c62c0e
len:291 put:1 head:ddc94800 data:ddc947ff tail:ddc94922 end:ddc94e00
dev:<NULL>
Apr 11 23:53:40 localhost kernel: ------------[ cut here ]------------
Apr 11 23:53:40 localhost kernel: kernel BUG at net/core/skbuff.c:111!
Apr 11 23:53:40 localhost kernel: invalid opcode: 0000 [#1]
Apr 11 23:53:40 localhost kernel: Modules linked in: nfs nfsd exportfs
lockd nfs_acl sunrpc button xt_TCPMSS xt_limit xt_tcpudp nf_nat_irc
nf_nat_ftp iptable_nat iptable_mangle ipt_LOG ipt_MASQUERADE nf_nat
ipt_TOS ipt_REJECT nf_conntrack_irc nf_conntrack_ftp nf_conntrack_ipv4
xt_state nf_conntrack nfnetlink iptable_filter ip_tables x_tables
ppp_async ipv6 ppp_generic slhc xfs fuse eeprom w83781d w83627hf
hwmon_vid i2c_isa ide_generic parport_pc parport i2c_viapro floppy
i2c_core serio_raw snd_via82xx snd_ac97_codec ac97_bus snd_pcm
snd_timer snd_page_alloc snd_mpu401_uart via_ircc snd_rawmidi
snd_seq_device irda rtc psmouse via_agp agpgart snd soundcore pcspkr
crc_ccitt evdev ext3 jbd mbcache usbhid ide_cd cdrom ide_disk generic
uhci_hcd usbcore via82cxxx ide_core e100 mii thermal processor fan
Apr 11 23:53:40 localhost kernel: CPU:    0
Apr 11 23:53:40 localhost kernel: EIP:    0060:[<c021b4d7>]    Not tainted VLI
Apr 11 23:53:40 localhost kernel: EFLAGS: 00010096   (2.6.21-rc6 #3)
Apr 11 23:53:40 localhost kernel: EIP is at skb_under_panic+0x59/0x5d
Apr 11 23:53:40 localhost kernel: eax: 00000072   ebx: ddc94800   ecx:
00000000   edx: 00000000
Apr 11 23:53:40 localhost kernel: esi: 00000000   edi: ddc94924   ebp:
ddc9491e   esp: c1ce5ed8
Apr 11 23:53:40 localhost kernel: ds: 007b   es: 007b   fs: 00d8  gs:
0000  ss: 0068
Apr 11 23:53:40 localhost kernel: Process events/0 (pid: 3,
ti=c1ce4000 task=dfd02030 task.ti=c1ce4000)
Apr 11 23:53:40 localhost kernel: Stack: c02c47d0 f8c62c0e 00000123
00000001 ddc94800 ddc947ff ddc94922 ddc94e00
Apr 11 23:53:40 localhost kernel:        c02b7ed8 dfd23a60 000000ff
f8c62c13 00000282 dfff5c20 f7e67c00 00000208
Apr 11 23:53:40 localhost kernel:        f0e45d34 f0e45c34 f7e67c00
00000202 e0f7d600 00000006 f0e45c00 f7e67c0c
Apr 11 23:53:40 localhost kernel: Call Trace:
Apr 11 23:53:40 localhost kernel:  [<f8c62c0e>]
ppp_asynctty_receive+0x3b0/0x584 [ppp_async]
Apr 11 23:53:40 localhost kernel:  [<f8c62c13>]
ppp_asynctty_receive+0x3b5/0x584 [ppp_async]
Apr 11 23:53:40 localhost kernel:  [<c01eacd2>] flush_to_ldisc+0xe6/0x124
Apr 11 23:53:40 localhost kernel:  [<c01eabec>] flush_to_ldisc+0x0/0x124
Apr 11 23:53:40 localhost kernel:  [<c0122b7f>] run_workqueue+0x70/0x101
Apr 11 23:53:40 localhost kernel:  [<c01230c8>] worker_thread+0x105/0x12e
Apr 11 23:53:40 localhost kernel:  [<c0114c86>] default_wake_function+0x0/0xc
Apr 11 23:53:40 localhost kernel:  [<c0122fc3>] worker_thread+0x0/0x12e
Apr 11 23:53:40 localhost kernel:  [<c012528c>] kthread+0xa0/0xc8
Apr 11 23:53:40 localhost kernel:  [<c01251ec>] kthread+0x0/0xc8
Apr 11 23:53:40 localhost kernel:  [<c0104657>] kernel_thread_helper+0x7/0x10
Apr 11 23:53:40 localhost kernel:  =======================
Apr 11 23:53:40 localhost kernel: Code: 00 00 89 5c 24 14 8b 98 a0 00
00 00 89 54 24 0c 89 5c 24 10 8b 40 60 89 4c 24 04 c7 04 24 d0 47 2c
c0 89 44 24 08 e8 af c5 ef ff <0f> 0b eb fe 56 53 bb d8 7e 2b c0 83 ec
24 8b 70 14 85 f6 0f 45
Apr 11 23:53:40 localhost kernel: EIP: [<c021b4d7>]
skb_under_panic+0x59/0x5d SS:ESP 0068:c1ce5ed8
Apr 11 23:54:01 localhost /USR/SBIN/CRON[32147]: (root) CMD
(/usr/local/bin/pppd_test.sh)
Apr 11 23:54:31 localhost pppd[31289]: No response to 5 echo-requests
Apr 11 23:54:31 localhost pppd[31289]: Serial link appears to be disconnected.
Apr 11 23:54:31 localhost pppd[31289]: Connect time 34.0 minutes.
Apr 11 23:54:31 localhost pppd[31289]: Sent 6451377 bytes, received
21004296 bytes.
Apr 11 23:54:31 localhost pppd[31289]: Script /etc/ppp/ip-down started
(pid 32149)
Apr 11 23:54:31 localhost pppd[31289]: sent [LCP TermReq id=0xb "Peer
not responding"]
Apr 11 23:54:31 localhost pppd[31289]: Script /etc/ppp/ip-down
finished (pid 32149), status = 0x0
Apr 11 23:54:34 localhost pppd[31289]: sent [LCP TermReq id=0xc "Peer
not responding"]
Apr 11 23:54:37 localhost pppd[31289]: Connection terminated.
