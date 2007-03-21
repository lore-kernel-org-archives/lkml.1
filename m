Return-Path: <linux-kernel-owner+w=401wt.eu-S933193AbXCUWJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193AbXCUWJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933161AbXCUWJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:09:38 -0400
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:34936 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933193AbXCUWJh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:09:37 -0400
Date: Thu, 22 Mar 2007 00:09:34 +0200
From: Sami Farin <7atbggg02@sneakemail.com>
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.19.7 + oprofile = BUG: unable to handle kernel NULL
	pointer dereference at virtual address 00000020
Message-ID: <20070321220934.yiiw2kyhreclh7l6@m.safari.iki.fi>
Mail-Followup-To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is oprofile's fault, but I got this
when I started opreport.
10 min after BUG system needed to be rebooted (cycling power).
With earlier kernel (without oprofile) everything worked for a month
without hiccups.

[295318.822839] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000020
[295318.822847]  printing eip:
[295318.822850] c0182530
[295318.822852] *pde = 2ed68001
[295318.822858] *pte = 00000000
[295318.822862] Oops: 0000 [#1]
[295318.822864] SMP 
[295318.822867] Modules linked in: oprofile perfctr dccp_diag dccp_ccid2 dccp_ipv4 i915 dccp xt_CLASSIFY ipt_ECN xt_CONNMARK ipt_connlimit ipt_TARPIT xt_length ipt_set xt_multiport ip_set_iphash ip_set_nethash ip_set_portmap sch_esfq ipt_REJECT ip6t_LOG xt_limit ipt_LOG ipt_hashlimit ip6table_mangle iptable_mangle iptable_raw ipt_owner xt_tcpudp xt_state ip_conntrack ip6table_filter ip6_tables iptable_filter ip_tables x_tables tcp_highspeed tcp_htcp tcp_hybla tcp_scalable tcp_vegas tcp_westwood ip_set sch_netem sch_hfsc sch_htb sch_sfq cls_fw cls_u32 cls_route sch_ingress sch_red sch_tbf sch_teql sch_prio sch_gred cls_rsvp cls_rsvp6 cls_tcindex sch_cbq sch_dsmark ioatdma cmtp kernelcapi l2cap bluetooth intelfb i2c_algo_bit i810 i2c_dev usb_storage eeprom ohci_hcd irlan irda crc_ccitt binfmt_misc loop dm_mod video button battery asus_acpi ac tcp_cubic lp nvram snd_hda_intel snd_hda_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ohci1394 i2c_i801 snd_pcm ieee1394 pcspkr snd_timer snd i2c_core soundcore iTCO_wdt ehci_hcd snd_page_alloc e1000 parport_pc parport uhci_hcd
[295318.822998] CPU:    0
[295318.822999] EIP:    0060:[<c0182530>]    Not tainted VLI
[295318.823000] EFLAGS: 00010282   (2.6.19.7-exec-shield-1 #137)
[295318.823008] EIP is at iput+0x17/0x69
[295318.823016] eax: 00000000   ebx: cafdd31c   ecx: cafdd334   edx: cafdd334
[295318.823019] esi: cafdd31c   edi: 0000003f   ebp: c1ac7e64   esp: c1ac7e60
[295318.823022] ds: 007b   es: 007b   ss: 0068
[295318.823026] Process kswapd0 (pid: 217, ti=c1ac6000 task=c1a12550 task.ti=c1ac6000)
[295318.823029] Stack: ddbcc42c c1ac7e7c c017f259 c1ac7e7c c017f2c6 ddbcc42c ddbcc42c c1ac7e8c 
[295318.823042]        c017f6d3 f7624c3c ddbcc42c c1ac7ea4 c017f7f3 00000000 00000000 00004970 
[295318.823059]        00000086 c1ac7eac c017fd29 c1ac7ef8 c0155fc0 00000000 00000000 c0592680 
[295318.823068] Call Trace:
[295318.823358]  [<c017f259>] dentry_iput+0x53/0x9f
[295318.823627]  [<c017f6d3>] prune_one_dentry+0x57/0x7a
[295318.823900]  [<c017f7f3>] prune_dcache+0xfd/0x152
[295318.824177]  [<c017fd29>] shrink_dcache_memory+0x19/0x3d
[295318.824446]  [<c0155fc0>] shrink_slab+0x123/0x1b5
[295318.824652]  [<c01572c4>] balance_pgdat+0x203/0x30b
[295318.824852]  [<c0157486>] kswapd+0xba/0x10a
[295318.825064]  [<c0135b7f>] kthread+0xa0/0xcd
[295318.825209]  [<c0103a63>] kernel_thread_helper+0x7/0x10
[295318.825237]  =======================
[295318.825239] Code: 85 c9 89 e5 75 07 e8 6e fd ff ff 5d c3 e8 a1 fe ff ff 5d c3 55 85 c0 89 e5 53 89 c3 74 4c 8b 80 a8 00 00 00 83 bb 50 01 00 00 20 <8b> 40 20 74 43 85 c0 74 07 8b 50 14 85 d2 75 32 8d 43 24 ba 1c 
[295318.825295] EIP: [<c0182530>] iput+0x17/0x69 SS:ESP 0068:c1ac7e60

-- 
