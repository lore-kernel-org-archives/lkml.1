Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZBVNVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZBVNVA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 08:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbZBVNUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 08:20:51 -0500
Received: from www17.your-server.de ([213.133.104.17]:58423 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZBVNUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 08:20:49 -0500
Subject: Re: [Announce] 2.6.29-rc4-rt2
From: Thomas Meyer <thomas@m3y3r.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 22 Feb 2009 14:20:19 +0100
Message-Id: <1235308819.3449.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 12.02.2009, 23:56 +0100 schrieb Thomas Gleixner:
> We are pleased to announce the first update to our new preempt-rt
> series. It fixes the reported bugs and some more.
> 
> Download locations:
> 
>    http://rt.et.redhat.com/download/
>    http://www.kernel.org/pub/linux/kernel/projects/rt/
>  
> Information on the RT patch can be found at:
> 
>   http://rt.wiki.kernel.org/index.php/Main_Page
> 
> to build the 2.6.29-rc4-rt2 tree, the following patches should be
> applied:
> 
>   http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc4.tar.bz2
>   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rc4-rt2.bz2
> 
> The broken out patches are also available at the same download
> locations.
> 
> Enjoy !
> 
>       Thomas, Ingo

Hi,

Is this one probably rt-preempt related?

BUG: unable to handle kernel paging request at 00100100
IP: [<f8aa431c>] __nf_conntrack_find+0xd6/0x109 [nf_conntrack]
*pde = 34ece067 *pte = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT0/energy_full
Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack_ipv6 xt_state nf_conntrack ath5k mac80211 cfg80211 video [last unloaded: scsi_wait_scan]

Pid: 5, comm: sirq-timer/0 Tainted: G        W  (2.6.29-rc4-rt2-tip #60) MacBookPro1,1
EIP: 0060:[<f8aa431c>] EFLAGS: 00010206 CPU: 0
EIP is at __nf_conntrack_find+0xd6/0x109 [nf_conntrack]
EAX: f4853240 EBX: f7053d38 ECX: 00100100 EDX: f4f5c640
ESI: ea190868 EDI: c0e07ec0 EBP: f7053cc8 ESP: f7053cb8
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00000001
Process sirq-timer/0 (pid: 5, ti=f7053000 task=f7064dc0 task.ti=f7053000)
Stack:
 985792de f7053d38 c0e07ec0 c0e07ec0 f7053ce0 f8aa4731 985792de f7053d38
 f8ba3bb8 c0e07ec0 f7053d70 f8aa59c5 f6b81a00 f1ec5ef4 00000003 00000002
 f8ab132c 00000014 f7053d94 00000014 f7053d30 06053d4e f5a92000 f67f2980
Call Trace:
 [<f8aa4731>] ? nf_conntrack_find_get+0x26/0x75 [nf_conntrack]
 [<f8aa59c5>] ? nf_conntrack_in+0x15a/0x45d [nf_conntrack]
 [<f8ba2472>] ? ipv4_conntrack_local+0x3d/0x58 [nf_conntrack_ipv4]
 [<c089cdaf>] ? nf_iterate+0x4f/0x93
 [<c08b3938>] ? dst_output+0x0/0x2b
 [<c08b3938>] ? dst_output+0x0/0x2b
 [<c089cf84>] ? nf_hook_slow+0x65/0xd3
 [<c08b3938>] ? dst_output+0x0/0x2b
 [<c08b3938>] ? dst_output+0x0/0x2b
 [<c08b5292>] ? __ip_local_out+0x9f/0xba
 [<c08b3938>] ? dst_output+0x0/0x2b
 [<c08b52c8>] ? ip_local_out+0x1b/0x3d
 [<c08b5b31>] ? ip_queue_xmit+0x2cf/0x358
 [<c0442c7c>] ? enqueue_task+0x70/0x8e
 [<c08ca3de>] ? tcp_v4_send_check+0x85/0xd0
 [<c08c680e>] ? tcp_transmit_skb+0x5f9/0x642
 [<c08c5d35>] ? tcp_current_mss+0x66/0xeb
 [<c08c81b0>] ? tcp_retransmit_skb+0x4f2/0x632
 [<c08c99b0>] ? tcp_write_timer+0x3c2/0x592
 [<c045c17c>] ? run_timer_softirq+0x201/0x2a3
 [<c08c95ee>] ? tcp_write_timer+0x0/0x592
 [<c08c95ee>] ? tcp_write_timer+0x0/0x592
 [<c04575e3>] ? ksoftirqd+0x12d/0x223
 [<c04574b6>] ? ksoftirqd+0x0/0x223
 [<c0467022>] ? kthread+0x4a/0x82
 [<c0466fd8>] ? kthread+0x0/0x82
 [<c0420b67>] ? kernel_thread_helper+0x7/0x10
Code: 8b 97 30 03 00 00 74 10 f7 d2 64 a1 b4 64 d6 c0 8b 04 82 ff 40 04 eb 2d f7 d2 64 a1 b4 64 d6 c0 8b 04 82 ff 00 8b 09 85 c9 74 18 <8b> 01 0f 18 00 90 8b 03 89 ce 3b 41 08 0f 85 78 ff ff ff e9 4d 
EIP: [<f8aa431c>] __nf_conntrack_find+0xd6/0x109 [nf_conntrack] SS:ESP 0068:f7053cb8
---[ end trace a7919e7f17c0a727 ]---


