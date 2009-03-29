Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbZC2I36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbZC2I36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 04:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZC2I3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 04:29:46 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:54838 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZC2I3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 04:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xkh0KiECj10Ka8Y6yfIsHpuEc0+k0z2xF3dy3Taps1YEN9uk4rIjoRstEljT2pRvwC
         dwE+yIh0A3odXzEnV8wm1W03GqqEn5iJuuA02aXZW/uLKIuRV+dsOArlpGSLQibRIyUS
         FSvBQIGDPAsiSOt2OCN2JDLP5LZWmySrvZKYI=
Message-ID: <49CF316D.6040903@gmail.com>
Date: Sun, 29 Mar 2009 10:29:33 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Collins <paul@burly.ondioline.org>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net
Subject: Re: soft lockup apparently in ath5k_hw_update_mib_counters (or ioread32?)
 with 2.6.29
References: <87tz5ckfye.fsf@burly.wgtn.ondioline.org>
In-Reply-To: <87tz5ckfye.fsf@burly.wgtn.ondioline.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2009 08:20 AM, Paul Collins wrote:
> After about two days of uptime with 2.6.29 I got this:
> 
> BUG: soft lockup - CPU#0 stuck for 61s! [swapper:0]
> Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables vfat fat usb_storage sch_sfq i915 drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect btusb rfcomm hidp l2cap bluetooth tun cpufreq_stats rpcsec_gss_krb5 nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc fuse cbc aes_x86_64 aes_generic xts gf128mul dm_crypt dm_mod fbcon font bitblit softcursor fb kvm_intel kvm acpi_cpufreq firewire_sbp2 loop snd_hda_intel snd_pcm arc4 snd_seq_midi snd_rawmidi ecb snd_seq_midi_event snd_seq snd_timer ath5k snd_seq_device snd mac80211 soundcore firewire_ohci firewire_core thermal snd_page_alloc cfg80211 i2c_i801 crc_itu_t button processor evdev
> CPU 0:
> Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables vfat fat usb_storage sch_sfq i915 drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect btusb rfcomm hidp l2cap bluetooth tun cpufreq_stats rpcsec_gss_krb5 nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc fuse cbc aes_x86_64 aes_generic xts gf128mul dm_crypt dm_mod fbcon font bitblit softcursor fb kvm_intel kvm acpi_cpufreq firewire_sbp2 loop snd_hda_intel snd_pcm arc4 snd_seq_midi snd_rawmidi ecb snd_seq_midi_event snd_seq snd_timer ath5k snd_seq_device snd mac80211 soundcore firewire_ohci firewire_core thermal snd_page_alloc cfg80211 i2c_i801 crc_itu_t button processor evdev
> Pid: 0, comm: swapper Not tainted 2.6.29-00003-g0be8685 #163 Macmini2,1
> RIP: 0010:[<ffffffff803950f0>]  [<ffffffff803950f0>] ioread32+0xf/0x32

Huh. I see no reason for this to happen. I suppose this is a regression,
which kernel worked?

There is nothing like "too many interrupts, giving up for now" in dmesg,
right?

> RSP: 0018:ffffffff807dfc30  EFLAGS: 00000296
> RAX: 0000000000000000 RBX: ffffffff807dfc30 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffff88007cb51a68 RDI: ffffc200109e8094
> RBP: ffffffff8020d033 R08: ffffffff8070a600 R09: 0000000000000064
> R10: ffffffff807dfd60 R11: ffff88007cb51980 R12: ffffffff807dfbb0
> R13: ffff88007c916000 R14: 000000000076b647 R15: ffffffff8051966c
> FS:  0000000000000000(0000) GS:ffffffff807e8000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00007feefddbb0d0 CR3: 000000007a74e000 CR4: 00000000000026e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Call Trace:
>  <IRQ>  [<ffffffffa009a884>] ? ath5k_hw_update_mib_counters+0xd9/0x15a [ath5k]
>  [<ffffffffa00a0707>] ? ath5k_intr+0x24c/0x2bd [ath5k]
>  [<ffffffff8021dcfb>] ? lapic_timer_broadcast+0x18/0x1a
>  [<ffffffff8025f22c>] ? tick_handle_oneshot_broadcast+0xf3/0x101
>  [<ffffffff80278e07>] ? handle_IRQ_event+0x33/0x6a
>  [<ffffffff8027a248>] ? handle_fasteoi_irq+0x9b/0xe0
>  [<ffffffff8027a1a3>] ? handle_edge_irq+0x126/0x130
>  [<ffffffff80519565>] ? __irqentry_text_start+0x75/0xe9
>  [<ffffffff8020cdd3>] ? ret_from_intr+0x0/0x29
>  [<ffffffff804a6b19>] ? neigh_timer_handler+0x0/0x31b
>  [<ffffffff8024a038>] ? round_jiffies_common+0x28/0x5a
>  [<ffffffff804a593e>] ? neigh_periodic_timer+0x146/0x191
>  [<ffffffff8024a0b5>] ? round_jiffies+0x18/0x1a
>  [<ffffffff804a5955>] ? neigh_periodic_timer+0x15d/0x191
>  [<ffffffff804a57f8>] ? neigh_periodic_timer+0x0/0x191
>  [<ffffffff8024a4e7>] ? run_timer_softirq+0x19c/0x21d
>  [<ffffffff8024679a>] ? __do_softirq+0x8f/0x159
>  [<ffffffff8020d65c>] ? call_softirq+0x1c/0x28
>  [<ffffffff8020e6f1>] ? do_softirq+0x49/0x94
>  [<ffffffff8024647c>] ? irq_exit+0x44/0x7e
>  [<ffffffff805195b8>] ? __irqentry_text_start+0xc8/0xe9
>  [<ffffffff8020cdd3>] ? ret_from_intr+0x0/0x29
>  <EOI>  [<ffffffff80260174>] ? tick_nohz_restart_sched_tick+0x140/0x149
>  [<ffffffff80260146>] ? tick_nohz_restart_sched_tick+0x112/0x149
>  [<ffffffff8020b2d0>] ? cpu_idle+0x98/0x9f
>  [<ffffffff80501157>] ? rest_init+0x6b/0x6d
> 
> Hardware:
> 
>         ath5k phy0: Atheros AR5414 chip found (MAC: 0xa3, PHY: 0x61)
> 
> 02:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter [168c:001c] (rev 01)
> 	Subsystem: Apple Computer Inc. Device [106b:0086]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 256 bytes
> 	Interrupt: pin A routed to IRQ 17
> 	Region 0: Memory at 90100000 (64-bit, non-prefetchable) [size=64K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ath5k
> 

