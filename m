Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbZFBJyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbZFBJyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 05:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbZFBJyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 05:54:12 -0400
Received: from main.gmane.org ([80.91.229.2]:51372 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141AbZFBJyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 05:54:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: 2.6.29: kernel constantly gives warn_slowpath errors (related to
 bridging?)
Date: Tue, 2 Jun 2009 09:53:53 +0000 (UTC)
Message-ID: <h02srg$jgq$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: artipc9.vub.ac.be
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have Debian Lenny's 2.6.29-bpo.2-amd64 kernel installed on a HP DL185 G5
system and my logs are constantly flooded with warn_slowpath backtraces. 

The system is running user space KVM/qemu 85 and libvirt with eth0 and
vnet0 (kvm virtual machine) bridged to br0.

Here are some of backtraces:

[329981.255249] ------------[ cut here ]------------
[329981.255299] WARNING: at /tmp/buildd/linux-2.6-2.6.29/debian/build/source_amd64_none/net/core/dst.c:270 skb_release_head_state+0xd/0xbf()
[329981.255402] Hardware name: ProLiant DL185 G5
[329981.255448] Modules linked in: tun bridge stp kvm_amd kvm ipv6 cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conservative ipmi_devintf ipmi_si ipmi_msghandler powernow_k8 loop snd_pcm snd_timer snd soundcore pcspkr snd_page_alloc psmouse serio_raw i2c_piix4 evdev i2c_core shpchp pci_hotplug container button ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod cdrom ata_generic st osst usbhid hid cciss serverworks mptsas mptscsih mptbase scsi_transport_sas sata_svw ohci_hcd ehci_hcd ide_pci_generic tg3 libphy ide_core libata scsi_mod thermal processor fan thermal_sys
[329981.256040] Pid: 4200, comm: kvm Tainted: G        W  2.6.29-bpo.2-amd64 #1
[329981.256097] Call Trace:
[329981.256142]  [<ffffffff80243a29>] warn_slowpath+0xd8/0x112
[329981.256197]  [<ffffffff802ca697>] pollwake+0x0/0x49
[329981.256250]  [<ffffffff802ca697>] pollwake+0x0/0x49
[329981.256304]  [<ffffffff802ca697>] pollwake+0x0/0x49
[329981.256357]  [<ffffffff802ca697>] pollwake+0x0/0x49
[329981.256409]  [<ffffffff802ca697>] pollwake+0x0/0x49
[329981.256462]  [<ffffffff802ca697>] pollwake+0x0/0x49
[329981.256515]  [<ffffffff802ca697>] pollwake+0x0/0x49
[329981.256567]  [<ffffffff803fcf5b>] memcpy_toiovec+0x34/0x63
[329981.256621]  [<ffffffff803fd5fa>] skb_copy_datagram_iovec+0x49/0x1ca
[329981.256678]  [<ffffffff80479de2>] _spin_lock+0x5/0x7
[329981.256732]  [<ffffffff803fb05f>] skb_release_head_state+0xd/0xbf
[329981.256789]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.256846]  [<ffffffffa036d33a>] tun_chr_aio_read+0x298/0x2c9 [tun]
[329981.256904]  [<ffffffff8023d496>] default_wake_function+0x0/0x9
[329981.256961]  [<ffffffff802c9559>] set_fd_set+0x25/0x29
[329981.257015]  [<ffffffff802ca33d>] core_sys_select+0x1ee/0x21e
[329981.257071]  [<ffffffff802bd343>] do_sync_read+0xce/0x113
[329981.257125]  [<ffffffff80255e02>] autoremove_wake_function+0x0/0x2e
[329981.257184]  [<ffffffff8025ca61>] getnstimeofday+0x56/0xb0
[329981.257239]  [<ffffffff802c93d7>] poll_select_copy_remaining+0xd0/0xf3
[329981.257298]  [<ffffffff802bdc6f>] vfs_read+0xa6/0xff
[329981.257351]  [<ffffffff802bdd84>] sys_read+0x45/0x6e
[329981.257405]  [<ffffffff802110aa>] system_call_fastpath+0x16/0x1b
[329981.257460] ---[ end trace 56068948bb1e5377 ]---
[329981.257538] ------------[ cut here ]------------
[329981.257588] WARNING: at /tmp/buildd/linux-2.6-2.6.29/debian/build/source_amd64_none/net/core/dst.c:270 skb_release_head_state+0xd/0xbf()
[329981.257691] Hardware name: ProLiant DL185 G5
[329981.257737] Modules linked in: tun bridge stp kvm_amd kvm ipv6 cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conservative ipmi_devintf ipmi_si ipmi_msghandler powernow_k8 loop snd_pcm snd_timer snd soundcore pcspkr snd_page_alloc psmouse serio_raw i2c_piix4 evdev i2c_core shpchp pci_hotplug container button ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod cdrom ata_generic st osst usbhid hid cciss serverworks mptsas mptscsih mptbase scsi_transport_sas sata_svw ohci_hcd ehci_hcd ide_pci_generic tg3 libphy ide_core libata scsi_mod thermal processor fan thermal_sys
[329981.258319] Pid: 4200, comm: kvm Tainted: G        W  2.6.29-bpo.2-amd64 #1
[329981.258376] Call Trace:
[329981.258421]  [<ffffffff80243a29>] warn_slowpath+0xd8/0x112
[329981.258476]  [<ffffffff8023d484>] try_to_wake_up+0x1b0/0x1c2
[329981.258531]  [<ffffffff80255e0b>] autoremove_wake_function+0x9/0x2e
[329981.258587]  [<ffffffff80236328>] __wake_up_common+0x44/0x73
[329981.258642]  [<ffffffff80236f90>] __wake_up+0x30/0x44
[329981.258724]  [<ffffffffa0326ef9>] kvm_vcpu_kick+0x3b/0x69 [kvm]
[329981.258806]  [<ffffffffa0325dbd>] ioapic_service+0xaf/0x1a9 [kvm]
[329981.258890]  [<ffffffffa0335c1e>] pic_irq_request+0x1e/0x4f [kvm]
[329981.258972]  [<ffffffffa0335cf8>] pic_unlock+0x28/0x6b [kvm]
[329981.259027]  [<ffffffff803fcf5b>] memcpy_toiovec+0x34/0x63
[329981.259082]  [<ffffffff803fd5fa>] skb_copy_datagram_iovec+0x49/0x1ca
[329981.259141]  [<ffffffff803fb05f>] skb_release_head_state+0xd/0xbf
[329981.259199]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.259272] ------------[ cut here ]------------
[329981.259321] WARNING: at /tmp/buildd/linux-2.6-2.6.29/debian/build/source_amd64_none/net/core/dst.c:270 br_nf_local_in+0x2c/0x3b [bridge]()
[329981.259425] Hardware name: ProLiant DL185 G5
[329981.259471] Modules linked in: tun bridge stp kvm_amd kvm ipv6 cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conservative ipmi_devintf ipmi_si ipmi_msghandler powernow_k8 loop snd_pcm snd_timer snd soundcore pcspkr snd_page_alloc psmouse serio_raw i2c_piix4 evdev i2c_core shpchp pci_hotplug container button ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod cdrom ata_generic st osst usbhid hid cciss serverworks mptsas mptscsih mptbase scsi_transport_sas sata_svw ohci_hcd ehci_hcd ide_pci_generic tg3 libphy ide_core libata scsi_mod thermal processor fan thermal_sys
[329981.260062] Pid: 4200, comm: kvm Tainted: G        W  2.6.29-bpo.2-amd64 #1
[329981.260119] Call Trace:
[329981.260159]  <IRQ>  [<ffffffff80243a29>] warn_slowpath+0xd8/0x112
[329981.260232]  [<ffffffffa035bc78>] br_dev_queue_push_xmit+0x75/0x79 [bridge]
[329981.260306]  [<ffffffffa035feb4>] br_nf_post_routing+0x1b1/0x1c6 [bridge]
[329981.267520]  [<ffffffff8041d1a2>] nf_iterate+0x41/0x7d
[329981.267585]  [<ffffffffa035bc03>] br_dev_queue_push_xmit+0x0/0x79 [bridge]
[329981.267648]  [<ffffffff8041d240>] nf_hook_slow+0x62/0xc3
[329981.267713]  [<ffffffffa035bc03>] br_dev_queue_push_xmit+0x0/0x79 [bridge]
[329981.267774]  [<ffffffff80401b4f>] netif_receive_skb+0x0/0x42e
[329981.267842]  [<ffffffffa035bcba>] br_forward_finish+0x3e/0x54 [bridge]
[329981.267913]  [<ffffffffa03600de>] br_nf_forward_finish+0xaa/0xb1 [bridge]
[329981.267985]  [<ffffffffa036028b>] br_nf_forward_ip+0x1a6/0x1c1 [bridge]
[329981.268060]  [<ffffffffa03603ce>] br_nf_local_in+0x2c/0x3b [bridge]
[329981.268118]  [<ffffffff8041d1a2>] nf_iterate+0x41/0x7d
[329981.268182]  [<ffffffffa035bc7c>] br_forward_finish+0x0/0x54 [bridge]
[329981.268241]  [<ffffffff80401b4f>] netif_receive_skb+0x0/0x42e
[329981.268298]  [<ffffffff8041d240>] nf_hook_slow+0x62/0xc3
[329981.268352]  [<ffffffff80401b4f>] netif_receive_skb+0x0/0x42e
[329981.268421]  [<ffffffffa035c7d0>] br_handle_frame_finish+0x104/0x148 [bridge]
[329981.268520]  [<ffffffffa036086d>] br_nf_pre_routing_finish+0x278/0x285 [bridge]
[329981.268620]  [<ffffffffa03605f5>] br_nf_pre_routing_finish+0x0/0x285 [bridge]
[329981.268706]  [<ffffffff8041d240>] nf_hook_slow+0x62/0xc3
[329981.268772]  [<ffffffffa03605f5>] br_nf_pre_routing_finish+0x0/0x285 [bridge]
[329981.268871]  [<ffffffffa0360e04>] br_nf_pre_routing+0x58a/0x5a5 [bridge]
[329981.268929]  [<ffffffff8041d1a2>] nf_iterate+0x41/0x7d
[329981.268994]  [<ffffffffa035c6cc>] br_handle_frame_finish+0x0/0x148 [bridge]
[329981.269054]  [<ffffffff8041d240>] nf_hook_slow+0x62/0xc3
[329981.269118]  [<ffffffffa035c6cc>] br_handle_frame_finish+0x0/0x148 [bridge]
[329981.269191]  [<ffffffffa035c9b0>] br_handle_frame+0x19c/0x1c0 [bridge]
[329981.269251]  [<ffffffff80401e5b>] netif_receive_skb+0x30c/0x42e
[329981.269319]  [<ffffffffa00c176a>] tg3_poll+0x68e/0x8a9 [tg3]
[329981.269375]  [<ffffffff8040036b>] net_rx_action+0xa9/0x19c
[329981.269430]  [<ffffffff80258aa3>] ktime_get_ts+0x21/0x4a
[329981.269484]  [<ffffffff8024892a>] __do_softirq+0x83/0x129
[329981.269539]  [<ffffffff8021241c>] call_softirq+0x1c/0x30
[329981.269592]  [<ffffffff80213b84>] do_softirq+0x3c/0x85
[329981.269645]  [<ffffffff802486c5>] irq_exit+0x3f/0x7f
[329981.269698]  [<ffffffff80213df3>] do_IRQ+0xb6/0xd7
[329981.269749]  [<ffffffff80211b93>] ret_from_intr+0x0/0x29
[329981.269800]  <EOI>  [<ffffffff80479d3c>] _spin_lock_irqsave+0x24/0x2c
[329981.269860]  [<ffffffff80244601>] vprintk+0x2a2/0x2d4
[329981.269913]  [<ffffffff80479d00>] _write_trylock+0x13/0x1f
[329981.269968]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.270022]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.270076]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.270131]  [<ffffffff80477eac>] printk+0x4e/0x5a
[329981.270182]  [<ffffffff80479d3c>] _spin_lock_irqsave+0x24/0x2c
[329981.270239]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.270293]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.270347]  [<ffffffff80477eac>] printk+0x4e/0x5a
[329981.270400]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.270453]  [<ffffffff80214fde>] print_trace_address+0x1d/0x4b
[329981.270510]  [<ffffffff802150ba>] print_context_stack+0x7c/0xc6
[329981.270567]  [<ffffffff802143a3>] dump_trace+0x247/0x258
[329981.270623]  [<ffffffff8026853f>] kallsyms_lookup+0x3b/0x101
[329981.270679]  [<ffffffff80477d1b>] dump_stack+0x69/0x6f
[329981.270733]  [<ffffffff80243a29>] warn_slowpath+0xd8/0x112
[329981.270788]  [<ffffffff8023d484>] try_to_wake_up+0x1b0/0x1c2
[329981.270843]  [<ffffffff80255e0b>] autoremove_wake_function+0x9/0x2e
[329981.270900]  [<ffffffff80236328>] __wake_up_common+0x44/0x73
[329981.270955]  [<ffffffff80236f90>] __wake_up+0x30/0x44
[329981.271035]  [<ffffffffa0326ef9>] kvm_vcpu_kick+0x3b/0x69 [kvm]
[329981.271118]  [<ffffffffa0325dbd>] ioapic_service+0xaf/0x1a9 [kvm]
[329981.271202]  [<ffffffffa0335c1e>] pic_irq_request+0x1e/0x4f [kvm]
[329981.271284]  [<ffffffffa0335cf8>] pic_unlock+0x28/0x6b [kvm]
[329981.271339]  [<ffffffff803fcf5b>] memcpy_toiovec+0x34/0x63
[329981.271394]  [<ffffffff803fd5fa>] skb_copy_datagram_iovec+0x49/0x1ca
[329981.271454]  [<ffffffff803fb05f>] skb_release_head_state+0xd/0xbf
[329981.271511]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.271568]  [<ffffffffa036d33a>] tun_chr_aio_read+0x298/0x2c9 [tun]
[329981.271626]  [<ffffffff8023d496>] default_wake_function+0x0/0x9
[329981.271683]  [<ffffffff802c9559>] set_fd_set+0x25/0x29
[329981.271737]  [<ffffffff802ca33d>] core_sys_select+0x1ee/0x21e
[329981.271794]  [<ffffffff802bd343>] do_sync_read+0xce/0x113
[329981.271848]  [<ffffffff80255e02>] autoremove_wake_function+0x0/0x2e
[329981.271907]  [<ffffffff8025ca61>] getnstimeofday+0x56/0xb0
[329981.271962]  [<ffffffff802c869e>] vfs_ioctl+0x21/0x6c
[329981.272023]  [<ffffffff802c8b22>] do_vfs_ioctl+0x439/0x472
[329981.272078]  [<ffffffff802bdc6f>] vfs_read+0xa6/0xff
[329981.272131]  [<ffffffff802bdd84>] sys_read+0x45/0x6e
[329981.272185]  [<ffffffff802110aa>] system_call_fastpath+0x16/0x1b
[329981.272239] ---[ end trace 56068948bb1e5378 ]---
[329981.272317] ------------[ cut here ]------------
[329981.272367] WARNING: at /tmp/buildd/linux-2.6-2.6.29/debian/build/source_amd64_none/net/core/dst.c:270 br_nf_local_in+0x2c/0x3b [bridge]()
[329981.272471] Hardware name: ProLiant DL185 G5
[329981.272517] Modules linked in: tun bridge stp kvm_amd kvm ipv6 cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conservative ipmi_devintf ipmi_si ipmi_msghandler powernow_k8 loop snd_pcm snd_timer snd soundcore pcspkr snd_page_alloc psmouse serio_raw i2c_piix4 evdev i2c_core shpchp pci_hotplug container button ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod cdrom ata_generic st osst usbhid hid cciss serverworks mptsas mptscsih mptbase scsi_transport_sas sata_svw ohci_hcd ehci_hcd ide_pci_generic tg3 libphy ide_core libata scsi_mod thermal processor fan thermal_sys
[329981.273102] Pid: 4200, comm: kvm Tainted: G        W  2.6.29-bpo.2-amd64 #1
[329981.273160] Call Trace:
[329981.273200]  <IRQ>  [<ffffffff80243a29>] warn_slowpath+0xd8/0x112
[329981.273273]  [<ffffffffa035bc78>] br_dev_queue_push_xmit+0x75/0x79 [bridge]
[329981.273346]  [<ffffffffa035feb4>] br_nf_post_routing+0x1b1/0x1c6 [bridge]
[329981.273405]  [<ffffffff8041d1a2>] nf_iterate+0x41/0x7d
[329981.273470]  [<ffffffffa035bc03>] br_dev_queue_push_xmit+0x0/0x79 [bridge]
[329981.273530]  [<ffffffff8041d240>] nf_hook_slow+0x62/0xc3
[329981.273594]  [<ffffffffa035bc03>] br_dev_queue_push_xmit+0x0/0x79 [bridge]
[329981.273655]  [<ffffffff80401b4f>] netif_receive_skb+0x0/0x42e
[329981.273723]  [<ffffffffa035bcba>] br_forward_finish+0x3e/0x54 [bridge]
[329981.273794]  [<ffffffffa03600de>] br_nf_forward_finish+0xaa/0xb1 [bridge]
[329981.273866]  [<ffffffffa036028b>] br_nf_forward_ip+0x1a6/0x1c1 [bridge]
[329981.273937]  [<ffffffffa03603ce>] br_nf_local_in+0x2c/0x3b [bridge]
[329981.273994]  [<ffffffff8041d1a2>] nf_iterate+0x41/0x7d
[329981.274059]  [<ffffffffa035bc7c>] br_forward_finish+0x0/0x54 [bridge]
[329981.274118]  [<ffffffff80401b4f>] netif_receive_skb+0x0/0x42e
[329981.274173]  [<ffffffff8041d240>] nf_hook_slow+0x62/0xc3
[329981.274227]  [<ffffffff80401b4f>] netif_receive_skb+0x0/0x42e
[329981.274296]  [<ffffffffa035c7d0>] br_handle_frame_finish+0x104/0x148 [bridge]
[329981.274396]  [<ffffffffa036086d>] br_nf_pre_routing_finish+0x278/0x285 [bridge]
[329981.274495]  [<ffffffffa03605f5>] br_nf_pre_routing_finish+0x0/0x285 [bridge]
[329981.274581]  [<ffffffff8041d240>] nf_hook_slow+0x62/0xc3
[329981.274647]  [<ffffffffa03605f5>] br_nf_pre_routing_finish+0x0/0x285 [bridge]
[329981.274746]  [<ffffffffa0360e04>] br_nf_pre_routing+0x58a/0x5a5 [bridge]
[329981.274805]  [<ffffffff8041d1a2>] nf_iterate+0x41/0x7d
[329981.274869]  [<ffffffffa035c6cc>] br_handle_frame_finish+0x0/0x148 [bridge]
[329981.274929]  [<ffffffff8041d240>] nf_hook_slow+0x62/0xc3
[329981.274994]  [<ffffffffa035c6cc>] br_handle_frame_finish+0x0/0x148 [bridge]
[329981.275066]  [<ffffffffa035c9b0>] br_handle_frame+0x19c/0x1c0 [bridge]
[329981.275126]  [<ffffffff80401e5b>] netif_receive_skb+0x30c/0x42e
[329981.275194]  [<ffffffffa00c176a>] tg3_poll+0x68e/0x8a9 [tg3]
[329981.275251]  [<ffffffff8040036b>] net_rx_action+0xa9/0x19c
[329981.275305]  [<ffffffff80258aa3>] ktime_get_ts+0x21/0x4a
[329981.275360]  [<ffffffff8024892a>] __do_softirq+0x83/0x129
[329981.275414]  [<ffffffff8021241c>] call_softirq+0x1c/0x30
[329981.275468]  [<ffffffff80213b84>] do_softirq+0x3c/0x85
[329981.275521]  [<ffffffff802486c5>] irq_exit+0x3f/0x7f
[329981.275573]  [<ffffffff80213df3>] do_IRQ+0xb6/0xd7
[329981.275624]  [<ffffffff80211b93>] ret_from_intr+0x0/0x29
[329981.275675]  <EOI>  [<ffffffff80479d3c>] _spin_lock_irqsave+0x24/0x2c
[329981.275735]  [<ffffffff80244601>] vprintk+0x2a2/0x2d4
[329981.275788]  [<ffffffff80479d00>] _write_trylock+0x13/0x1f
[329981.275843]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.275897]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.275951]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.276013]  [<ffffffff80477eac>] printk+0x4e/0x5a
[329981.276065]  [<ffffffff80479d3c>] _spin_lock_irqsave+0x24/0x2c
[329981.276121]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.276175]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.276230]  [<ffffffff80477eac>] printk+0x4e/0x5a
[329981.276282]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.276337]  [<ffffffff80214fde>] print_trace_address+0x1d/0x4b
[329981.276393]  [<ffffffff802150ba>] print_context_stack+0x7c/0xc6
[329981.276450]  [<ffffffff802143a3>] dump_trace+0x247/0x258
[329981.276506]  [<ffffffff8026853f>] kallsyms_lookup+0x3b/0x101
[329981.276562]  [<ffffffff80477d1b>] dump_stack+0x69/0x6f
[329981.276616]  [<ffffffff80243a29>] warn_slowpath+0xd8/0x112
[329981.276671]  [<ffffffff8023d484>] try_to_wake_up+0x1b0/0x1c2
[329981.276726]  [<ffffffff80255e0b>] autoremove_wake_function+0x9/0x2e
[329981.276783]  [<ffffffff80236328>] __wake_up_common+0x44/0x73
[329981.276838]  [<ffffffff80236f90>] __wake_up+0x30/0x44
[329981.276919]  [<ffffffffa0326ef9>] kvm_vcpu_kick+0x3b/0x69 [kvm]
[329981.277001]  [<ffffffffa0325dbd>] ioapic_service+0xaf/0x1a9 [kvm]
[329981.277085]  [<ffffffffa0335c1e>] pic_irq_request+0x1e/0x4f [kvm]
[329981.277168]  [<ffffffffa0335cf8>] pic_unlock+0x28/0x6b [kvm]
[329981.277223]  [<ffffffff803fcf5b>] memcpy_toiovec+0x34/0x63
[329981.277278]  [<ffffffff803fd5fa>] skb_copy_datagram_iovec+0x49/0x1ca
[329981.277337]  [<ffffffff803fb05f>] skb_release_head_state+0xd/0xbf
[329981.277395]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.277452]  [<ffffffffa036d33a>] tun_chr_aio_read+0x298/0x2c9 [tun]
[329981.277511]  [<ffffffff8023d496>] default_wake_function+0x0/0x9
[329981.277567]  [<ffffffff802c9559>] set_fd_set+0x25/0x29
[329981.277621]  [<ffffffff802ca33d>] core_sys_select+0x1ee/0x21e
[329981.277678]  [<ffffffff802bd343>] do_sync_read+0xce/0x113
[329981.277732]  [<ffffffff80255e02>] autoremove_wake_function+0x0/0x2e
[329981.277791]  [<ffffffff8025ca61>] getnstimeofday+0x56/0xb0
[329981.277846]  [<ffffffff802c869e>] vfs_ioctl+0x21/0x6c
[329981.277899]  [<ffffffff802c8b22>] do_vfs_ioctl+0x439/0x472
[329981.277954]  [<ffffffff802bdc6f>] vfs_read+0xa6/0xff
[329981.278007]  [<ffffffff802bdd84>] sys_read+0x45/0x6e
[329981.278061]  [<ffffffff802110aa>] system_call_fastpath+0x16/0x1b
[329981.285276] ---[ end trace 56068948bb1e5379 ]---
[329981.285347]  [<ffffffffa036d33a>] tun_chr_aio_read+0x298/0x2c9 [tun]
[329981.285406]  [<ffffffff8023d496>] default_wake_function+0x0/0x9
[329981.285463]  [<ffffffff802c9559>] set_fd_set+0x25/0x29
[329981.285517]  [<ffffffff802ca33d>] core_sys_select+0x1ee/0x21e
[329981.285573]  [<ffffffff802bd343>] do_sync_read+0xce/0x113
[329981.285627]  [<ffffffff80255e02>] autoremove_wake_function+0x0/0x2e
[329981.285686]  [<ffffffff8025ca61>] getnstimeofday+0x56/0xb0
[329981.285741]  [<ffffffff802c869e>] vfs_ioctl+0x21/0x6c
[329981.285795]  [<ffffffff802c8b22>] do_vfs_ioctl+0x439/0x472
[329981.285850]  [<ffffffff802bdc6f>] vfs_read+0xa6/0xff
[329981.285903]  [<ffffffff802bdd84>] sys_read+0x45/0x6e
[329981.285957]  [<ffffffff802110aa>] system_call_fastpath+0x16/0x1b
[329981.286012] ---[ end trace 56068948bb1e537a ]---
[329981.286147] ------------[ cut here ]------------
[329981.286199] WARNING: at /tmp/buildd/linux-2.6-2.6.29/debian/build/source_amd64_none/net/core/dst.c:270 skb_release_head_state+0xd/0xbf()
[329981.286302] Hardware name: ProLiant DL185 G5
[329981.286349] Modules linked in: tun bridge stp kvm_amd kvm ipv6 cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conservative ipmi_devintf ipmi_si ipmi_msghandler powernow_k8 loop snd_pcm snd_timer snd soundcore pcspkr snd_page_alloc psmouse serio_raw i2c_piix4 evdev i2c_core shpchp pci_hotplug container button ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod cdrom ata_generic st osst usbhid hid cciss serverworks mptsas mptscsih mptbase scsi_transport_sas sata_svw ohci_hcd ehci_hcd ide_pci_generic tg3 libphy ide_core libata scsi_mod thermal processor fan thermal_sys
[329981.286933] Pid: 4200, comm: kvm Tainted: G        W  2.6.29-bpo.2-amd64 #1
[329981.286991] Call Trace:
[329981.287036]  [<ffffffff80243a29>] warn_slowpath+0xd8/0x112
[329981.287091]  [<ffffffff8023d484>] try_to_wake_up+0x1b0/0x1c2
[329981.287146]  [<ffffffff80255e0b>] autoremove_wake_function+0x9/0x2e
[329981.287203]  [<ffffffff80236328>] __wake_up_common+0x44/0x73
[329981.287258]  [<ffffffff80236f90>] __wake_up+0x30/0x44
[329981.287339]  [<ffffffffa0326ef9>] kvm_vcpu_kick+0x3b/0x69 [kvm]
[329981.287421]  [<ffffffffa0325dbd>] ioapic_service+0xaf/0x1a9 [kvm]
[329981.287505]  [<ffffffffa0335c1e>] pic_irq_request+0x1e/0x4f [kvm]
[329981.287588]  [<ffffffffa0335cf8>] pic_unlock+0x28/0x6b [kvm]
[329981.287643]  [<ffffffff803fcf5b>] memcpy_toiovec+0x34/0x63
[329981.287698]  [<ffffffff803fd5fa>] skb_copy_datagram_iovec+0x49/0x1ca
[329981.287757]  [<ffffffff803fb05f>] skb_release_head_state+0xd/0xbf
[329981.287815]  [<ffffffff803fafb6>] __kfree_skb+0x9/0x7d
[329981.287872]  [<ffffffffa036d33a>] tun_chr_aio_read+0x298/0x2c9 [tun]
[329981.287930]  [<ffffffff8023d496>] default_wake_function+0x0/0x9
[329981.287987]  [<ffffffff802c9559>] set_fd_set+0x25/0x29
[329981.288050]  [<ffffffff802ca33d>] core_sys_select+0x1ee/0x21e
[329981.288107]  [<ffffffff802bd343>] do_sync_read+0xce/0x113
[329981.288162]  [<ffffffff8020f7d6>] __switch_to+0x1d3/0x3cd
[329981.288217]  [<ffffffff80255e02>] autoremove_wake_function+0x0/0x2e
[329981.288276]  [<ffffffff8025ca61>] getnstimeofday+0x56/0xb0
[329981.288331]  [<ffffffff802bdc6f>] vfs_read+0xa6/0xff
[329981.288385]  [<ffffffff802bdd84>] sys_read+0x45/0x6e
[329981.288439]  [<ffffffff802110aa>] system_call_fastpath+0x16/0x1b
[329981.288493] ---[ end trace 56068948bb1e537b ]---
[329981.289133] ------------[ cut here ]------------
[329981.289184] WARNING: at /tmp/buildd/linux-2.6-2.6.29/debian/build/source_amd64_none/net/core/dst.c:270 br_nf_local_in+0x2c/0x3b [bridge]()
[329981.289287] Hardware name: ProLiant DL185 G5
[329981.289334] Modules linked in: tun bridge stp kvm_amd kvm ipv6 cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conservative ipmi_devintf ipmi_si ipmi_msghandler powernow_k8 loop snd_pcm snd_timer snd soundcore pcspkr snd_page_alloc psmouse serio_raw i2c_piix4 evdev i2c_core shpchp pci_hotplug container button ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod cdrom ata_generic st osst usbhid hid cciss serverworks mptsas mptscsih mptbase scsi_transport_sas sata_svw ohci_hcd ehci_hcd ide_pci_generic tg3 libphy ide_core libata scsi_mod thermal processor fan thermal_sys
[329981.289918] Pid: 0, comm: swapper Tainted: G        W  2.6.29-bpo.2-amd64 #1
[329981.289975] Call Trace:
[329981.290015]  <IRQ>  [<ffffffff80243a29>] warn_slowpath+0xd8/0x112
[329981.290076]  [<ffffffff80236f44>] __wake_up_sync+0x39/0x55
[329981.290132]  [<ffffffff803f7829>] sock_def_readable+0x32/0x5d
[329981.290188]  [<ffffffff80435fb8>] tcp_rcv_established+0x59c/0x6f1
[329981.290246]  [<ffffffff80401b4f>] netif_receive_skb+0x0/0x42e
[329981.290304]  [<ffffffff8043d5d2>] tcp_v4_rcv+0x479/0x69d
[329981.290371]  [<ffffffffa03603ce>] br_nf_local_in+0x2c/0x3b [bridge]
[329981.290428]  [<ffffffff8041d1a2>] nf_iterate+0x41/0x7d
[329981.290482]  [<ffffffff80401b4f>] netif_receive_skb+0x0/0x42e
[329981.290537]  [<ffffffff8041d240>] nf_hook_slow+0x62/0xc3
[329981.290591]  [<ffffffff80401b4f>] netif_receive_skb+0x0/0x42e
[329981.290660]  [<ffffffffa035c7d0>] br_handle_frame_finish+0x104/0x148 [bridge]
[329981.290760]  [<ffffffffa036086d>] br_nf_pre_routing_finish+0x278/0x285 [bridge]
[329981.290859]  [<ffffffffa03605f5>] br_nf_pre_routing_finish+0x0/0x285 [bridge]
[329981.290945]  [<ffffffff8041d240>] nf_hook_slow+0x62/0xc3
[329981.291011]  [<ffffffffa03605f5>] br_nf_pre_routing_finish+0x0/0x285 [bridge]
[329981.291109]  [<ffffffffa0360e04>] br_nf_pre_routing+0x58a/0x5a5 [bridge]
[329981.291168]  [<ffffffff8041d1a2>] nf_iterate+0x41/0x7d
[329981.291232]  [<ffffffffa035c6cc>] br_handle_frame_finish+0x0/0x148 [bridge]
[329981.291292]  [<ffffffff8041d240>] nf_hook_slow+0x62/0xc3
[329981.291357]  [<ffffffffa035c6cc>] br_handle_frame_finish+0x0/0x148 [bridge]
[329981.291429]  [<ffffffffa035c9b0>] br_handle_frame+0x19c/0x1c0 [bridge]
[329981.291488]  [<ffffffff80401e5b>] netif_receive_skb+0x30c/0x42e
[329981.291557]  [<ffffffffa00c176a>] tg3_poll+0x68e/0x8a9 [tg3]
[329981.291613]  [<ffffffff8040036b>] net_rx_action+0xa9/0x19c
[329981.291669]  [<ffffffff8025ca61>] getnstimeofday+0x56/0xb0
[329981.291724]  [<ffffffff8024892a>] __do_softirq+0x83/0x129
[329981.291778]  [<ffffffff8021241c>] call_softirq+0x1c/0x30
[329981.291832]  [<ffffffff80213b84>] do_softirq+0x3c/0x85
[329981.291884]  [<ffffffff802486c5>] irq_exit+0x3f/0x7f
[329981.291937]  [<ffffffff80213df3>] do_IRQ+0xb6/0xd7
[329981.291988]  [<ffffffff80211b93>] ret_from_intr+0x0/0x29
[329981.292038]  <EOI>  [<ffffffff80220e7d>] lapic_next_event+0x0/0x19
[329981.292101]  [<ffffffff802274c1>] native_safe_halt+0x2/0x3
[329981.292156]  [<ffffffff8025940d>] notifier_call_chain+0x29/0x4c
[329981.292213]  [<ffffffff80217d3a>] default_idle+0x2a/0x46
[329981.292267]  [<ffffffff80217f6a>] c1e_idle+0x10a/0x10e
[329981.292321]  [<ffffffff80210192>] cpu_idle+0x51/0x92
[329981.292372] ---[ end trace 56068948bb1e537c ]---
[329981.302890] ------------[ cut here ]------------
[329981.302942] WARNING: at /tmp/buildd/linux-2.6-2.6.29/debian/build/source_amd64_none/net/core/dst.c:270 br_nf_local_in+0x2c/0x3b [bridge]()
[329981.303045] Hardware name: ProLiant DL185 G5
[329981.303091] Modules linked in: tun bridge stp kvm_amd kvm ipv6 cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conservative ipmi_devintf ipmi_si ipmi_msghandler powernow_k8 loop snd_pcm snd_timer snd soundcore pcspkr snd_page_alloc psmouse serio_raw i2c_piix4 evdev i2c_core shpchp pci_hotplug container button ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod cdrom ata_generic st osst usbhid hid cciss serverworks mptsas mptscsih mptbase scsi_transport_sas sata_svw ohci_hcd ehci_hcd ide_pci_generic tg3 libphy ide_core libata scsi_mod thermal processor fan thermal_sys
[329981.303670] Pid: 0, comm: swapper Tainted: G        W  2.6.29-bpo.2-amd64 #1
[329981.303727] Call Trace:
[329981.303767]  <IRQ>  [<ffffffff80243a29>] warn_slowpath+0xd8/0x112
[329981.303830]  [<ffffffff80435401>] tcp_data_snd_check+0x33/0xf7
[329981.303885]  [<ffffffff80435ae5>] tcp_rcv_established+0xc9/0x6f1
[329981.303942]  [<ffffffff80401b4f>] netif_receive_skb+0x0/0x42e
[329981.304000]  [<ffffffff8043d5d2>] tcp_v4_rcv+0x479/0x69d
[329981.304066]  [<ffffffffa03603ce>] br_nf_local_in+0x2c/0x3b [bridge]
[329981.304122]  [<ffffffff8041d1a2>] nf_iterate+0x41/0x7d
[329981.304176]  [<ffffffff80401b4f>] netif_receive_skb+0x0/0x42e
[329981.304230]  [<ffffffff8041d240>] nf_hook_slow+0x62/0xc3
[329981.304284]  [<ffffffff80401b4f>] netif_receive_skb+0x0/0x42e
[329981.304352]  [<ffffffffa035c7d0>] br_handle_frame_finish+0x104/0x148 [bridge]
[329981.304451]  [<ffffffffa036086d>] br_nf_pre_routing_finish+0x278/0x285 [bridge]
[329981.304549]  [<ffffffffa03605f5>] br_nf_pre_routing_finish+0x0/0x285 [bridge]
[329981.304633]  [<ffffffff8041d240>] nf_hook_slow+0x62/0xc3
[329981.304698]  [<ffffffffa03605f5>] br_nf_pre_routing_finish+0x0/0x285 [bridge]
[329981.304796]  [<ffffffffa0360e04>] br_nf_pre_routing+0x58a/0x5a5 [bridge]
[329981.304854]  [<ffffffff8041d1a2>] nf_iterate+0x41/0x7d
[329981.304917]  [<ffffffffa035c6cc>] br_handle_frame_finish+0x0/0x148 [bridge]
[329981.304976]  [<ffffffff8041d240>] nf_hook_slow+0x62/0xc3
[329981.305040]  [<ffffffffa035c6cc>] br_handle_frame_finish+0x0/0x148 [bridge]
[329981.305111]  [<ffffffffa035c9b0>] br_handle_frame+0x19c/0x1c0 [bridge]
[329981.305170]  [<ffffffff80401e5b>] netif_receive_skb+0x30c/0x42e
[329981.305238]  [<ffffffffa00c176a>] tg3_poll+0x68e/0x8a9 [tg3]
[329981.305293]  [<ffffffff8040036b>] net_rx_action+0xa9/0x19c
[329981.305348]  [<ffffffff8025ca61>] getnstimeofday+0x56/0xb0
[329981.305402]  [<ffffffff8024892a>] __do_softirq+0x83/0x129
[329981.305456]  [<ffffffff8021241c>] call_softirq+0x1c/0x30
[329981.305509]  [<ffffffff80213b84>] do_softirq+0x3c/0x85
[329981.305561]  [<ffffffff802486c5>] irq_exit+0x3f/0x7f
[329981.305612]  [<ffffffff80213df3>] do_IRQ+0xb6/0xd7
[329981.305663]  [<ffffffff80211b93>] ret_from_intr+0x0/0x29
[329981.305713]  <EOI>  [<ffffffff80220e7d>] lapic_next_event+0x0/0x19
[329981.305775]  [<ffffffff802274c1>] native_safe_halt+0x2/0x3
[329981.305829]  [<ffffffff8025940d>] notifier_call_chain+0x29/0x4c
[329981.305885]  [<ffffffff80217d3a>] default_idle+0x2a/0x46
[329981.305939]  [<ffffffff80217f6a>] c1e_idle+0x10a/0x10e
[329981.305992]  [<ffffffff80210192>] cpu_idle+0x51/0x92
[329981.306042] ---[ end trace 56068948bb1e537d ]---
[329981.306139] ------------[ cut here ]------------

# cat /proc/interrupts 
           CPU0       CPU1       CPU2       CPU3       
  0:         43          0          2       1099   IO-APIC-edge      timer
  1:          0          0          0          2   IO-APIC-edge      i8042
  5:          0          0          0          0   IO-APIC-fasteoi   sata_svw
  8:          0          0          0          1   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 10:          0          0       1226        151   IO-APIC-fasteoi   ehci_hcd:usb1, ohci_hcd:usb2, ohci_hcd:usb3
 12:          0          0          0          4   IO-APIC-edge      i8042
 14:          0          0         10         98   IO-APIC-edge      ide0
 36:          0          0          0         59   IO-APIC-fasteoi   ioc0
 40:    3673771          0          0        120   IO-APIC-fasteoi   eth0
 55:         95    4123839          2       1448   PCI-MSI-edge      cciss0
NMI:          0          0          0          0   Non-maskable interrupts
LOC:   36489602   73783679    9810373   84868019   Local timer interrupts
RES:     684198    1166448    1077487     426396   Rescheduling interrupts
CAL:         64      37920      44234       1217   Function call interrupts
TLB:       3264      11105      11945       9316   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
SPU:          0          0          0          0   Spurious interrupts
ERR:          0
MIS:          0

# cat /var/log/dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.29-bpo.2-amd64 (Debian 2.6.29-5~bpo50+1) (nobse@debian.org) (gcc version 4.3.3 (Debian 4.3.3-10) ) #1 SMP Mon May 18 09:38:23 UTC 2009
[    0.000000] Command line: root=/dev/mapper/linux-root ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009a800 (usable)
[    0.000000]  BIOS-e820: 000000000009a800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000d7f90000 (usable)
[    0.000000]  BIOS-e820: 00000000d7f9e000 - 00000000d7fa0000 type 9
[    0.000000]  BIOS-e820: 00000000d7fa0000 - 00000000d7fae000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000d7fae000 - 00000000d7fe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000d7fe0000 - 00000000d7fee000 (reserved)
[    0.000000]  BIOS-e820: 00000000d7ff0000 - 00000000d8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec03000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001a8000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x1a8000 max_arch_pfn = 0x100000000
[    0.000000] last_pfn = 0xd7f90 max_arch_pfn = 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000d7f90000
[    0.000000] Using GB pages for direct mapping
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00d7e00000 page 2M
[    0.000000]  00d7e00000 - 00d7f90000 page 4k
[    0.000000] kernel direct mapping tables up to d7f90000 @ 8000-b000
[    0.000000] last_map_addr: d7f90000 end: d7f90000
[    0.000000] init_memory_mapping: 0000000100000000-00000001a8000000
[    0.000000] Using GB pages for direct mapping
[    0.000000]  0100000000 - 0180000000 page 1G
[    0.000000]  0180000000 - 01a8000000 page 2M
[    0.000000] kernel direct mapping tables up to 1a8000000 @ a000-c000
[    0.000000] last_map_addr: 1a8000000 end: 1a8000000
[    0.000000] RAMDISK: 3789f000 - 37fef758
[    0.000000] ACPI: RSDP 000FA320, 0024 (r2 HP    )
[    0.000000] ACPI: XSDT D7FA0100, 0094 (r1 HP     ProLiant 20081212 FOXC       97)
[    0.000000] ACPI: FACP D7FA0290, 00F4 (r4 HP     ProLiant 20081212 FOXC       97)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] FADT: X_PM1b_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT D7FA06F0, 4392 (r2 HP     ProLiant      600 INTL 20051117)
[    0.000000] ACPI: FACS D7FAE000, 0040
[    0.000000] ACPI: APIC D7FA0390, 00AA (r2 HP     ProLiant 20081212 FOXC       97)
[    0.000000] ACPI: SPCR D7FA0440, 0050 (r1 HP     ProLiant 20081212 FOXC       97)
[    0.000000] ACPI: MCFG D7FA0490, 003C (r1 HP     ProLiant 20081212 FOXC       97)
[    0.000000] ACPI: SPMI D7FA04D0, 0041 (r5 HP     ProLiant 20081212 FOXC       97)
[    0.000000] ACPI: WDRT D7FA06A0, 0047 (r1 HP     ProLiant 20081212 FOXC       97)
[    0.000000] ACPI: OEMB D7FAE040, 008E (r1 HP     ProLiant 20081212 FOXC       97)
[    0.000000] ACPI: SRAT D7FA4A90, 00E8 (r1 HP     ProLiant        2 FOXC        1)
[    0.000000] ACPI: HPET D7FA4B80, 0038 (r1 HP     ProLiant 20081212 FOXC       97)
[    0.000000] ACPI: EINJ D7FA4BC0, 0130 (r1 HP     ProLiant 20081212 FOXC       97)
[    0.000000] ACPI: BERT D7FA4D50, 0030 (r1 HP     ProLiant 20081212 FOXC       97)
[    0.000000] ACPI: ERST D7FA4D80, 01B0 (r1 HP     ProLiant 20081212 FOXC       97)
[    0.000000] ACPI: HEST D7FA4F30, 00A8 (r1 HP     ProLiant 20081212 FOXC       97)
[    0.000000] ACPI: SSDT D7FA4FE0, 088C (r1 HP     ProLiant        1 FOXC        1)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 2 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 3 -> Node 0
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-d8000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-1a8000000
[    0.000000] NUMA: Allocated memnodemap from b000 - e580
[    0.000000] NUMA: Using 20 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-00000001a8000000
[    0.000000]   NODE_DATA [000000000000e580 - 000000000001657f]
[    0.000000]   bootmap [0000000000017000 -  000000000004bfff] pages 35
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 01a8000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00007ef74c]    TEXT DATA BSS ==> [0000200000 - 00007ef74c]
[    0.000000]   #3 [003789f000 - 0037fef758]          RAMDISK ==> [003789f000 - 0037fef758]
[    0.000000]   #4 [000009a800 - 0000100000]    BIOS reserved ==> [000009a800 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]   #6 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
[    0.000000]   #7 [000000b000 - 000000e580]       MEMNODEMAP ==> [000000b000 - 000000e580]
[    0.000000] found SMP MP-table at [ffff8800000ff780] 000ff780
[    0.000000]  [ffffe20000000000-ffffe20005dfffff] PMD -> [ffff880028200000-ffff88002d7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001a8000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009a
[    0.000000]     0: 0x00000100 -> 0x000d7f90
[    0.000000]     0: 0x00100000 -> 0x001a8000
[    0.000000] On node 0 totalpages: 1572650
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1631 pages reserved
[    0.000000]   DMA zone: 2307 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 866248 pages, LIFO batch:31
[    0.000000]   Normal zone: 9408 pages used for memmap
[    0.000000]   Normal zone: 678720 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x508
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x86] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x87] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-15
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec01000] gsi_base[16])
[    0.000000] IOAPIC[1]: apic_id 5, version 0, address 0xfec01000, GSI 16-31
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec02000] gsi_base[32])
[    0.000000] IOAPIC[2]: apic_id 6, version 0, address 0xfec02000, GSI 32-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x1166a201 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 48
[    0.000000] PM: Registered nosave memory: 000000000009a000 - 000000000009b000
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000d7f90000 - 00000000d7f9e000
[    0.000000] PM: Registered nosave memory: 00000000d7f9e000 - 00000000d7fa0000
[    0.000000] PM: Registered nosave memory: 00000000d7fa0000 - 00000000d7fae000
[    0.000000] PM: Registered nosave memory: 00000000d7fae000 - 00000000d7fe0000
[    0.000000] PM: Registered nosave memory: 00000000d7fe0000 - 00000000d7fee000
[    0.000000] PM: Registered nosave memory: 00000000d7fee000 - 00000000d7ff0000
[    0.000000] PM: Registered nosave memory: 00000000d7ff0000 - 00000000d8000000
[    0.000000] PM: Registered nosave memory: 00000000d8000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec03000
[    0.000000] PM: Registered nosave memory: 00000000fec03000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff700000
[    0.000000] PM: Registered nosave memory: 00000000ff700000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at f1000000 (gap: f0000000:ec00000)
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Allocating 53248 bytes of per cpu data
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1547275
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/mapper/linux-root ro
[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2293.979 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Node 0: aperture @ 20000000 size 32 MB
[    0.004000] Aperture pointing to e820 RAM. Ignoring.
[    0.004000] Your BIOS doesn't leave a aperture memory hole
[    0.004000] Please enable the IOMMU option in the BIOS setup
[    0.004000] This costs you 64 MB of RAM
[    0.004000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.004000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.004000] Memory: 6122648k/6946816k available (2547k kernel code, 656216k absent, 167952k reserved, 1323k data, 552k init)
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4587.95 BogoMIPS (lpj=9175904)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.004335] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.006028] Mount-cache hash table entries: 256
[    0.006261] Initializing cgroup subsys ns
[    0.006355] Initializing cgroup subsys cpuacct
[    0.006451] Initializing cgroup subsys devices
[    0.006546] Initializing cgroup subsys freezer
[    0.008004] Initializing cgroup subsys net_cls
[    0.008121] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.008225] CPU: L2 Cache: 512K (64 bytes/line)
[    0.008320] CPU 0/0x0 -> Node 0
[    0.008411] tseg: 0000000000
[    0.008422] CPU: Physical Processor ID: 0
[    0.008514] CPU: Processor Core ID: 0
[    0.008612] using C1E aware idle routine
[    0.010277] ACPI: Core revision 20081204
[    0.024049] Setting APIC routing to flat
[    0.024848] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.067426] CPU0: Quad-Core AMD Opteron(tm) Processor 2376 stepping 02
[    0.068001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4588.51 BogoMIPS (lpj=9177024)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 1/0x1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.156639] CPU1: Quad-Core AMD Opteron(tm) Processor 2376 stepping 02
[    0.157537] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.160100] Booting processor 2 APIC 0x2 ip 0x6000
[    0.004000] Initializing CPU#2
[    0.004000] Calibrating delay using timer specific routine.. 4588.51 BogoMIPS (lpj=9177030)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 2/0x2 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 2
[    0.252689] CPU2: Quad-Core AMD Opteron(tm) Processor 2376 stepping 02
[    0.253586] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.256097] Booting processor 3 APIC 0x3 ip 0x6000
[    0.004000] Initializing CPU#3
[    0.004000] Calibrating delay using timer specific routine.. 4588.50 BogoMIPS (lpj=9177011)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 3/0x3 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 3
[    0.348688] CPU3: Quad-Core AMD Opteron(tm) Processor 2376 stepping 02
[    0.349585] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.352030] Brought up 4 CPUs
[    0.352121] Total of 4 processors activated (18353.48 BogoMIPS).
[    0.352319] CPU0 attaching sched-domain:
[    0.352321]  domain 0: span 0-3 level CPU
[    0.352323]   groups: 0 1 2 3
[    0.352329] CPU1 attaching sched-domain:
[    0.352331]  domain 0: span 0-3 level CPU
[    0.352332]   groups: 1 2 3 0
[    0.352337] CPU2 attaching sched-domain:
[    0.352339]  domain 0: span 0-3 level CPU
[    0.352340]   groups: 2 3 0 1
[    0.352344] CPU3 attaching sched-domain:
[    0.352346]  domain 0: span 0-3 level CPU
[    0.352348]   groups: 3 0 1 2
[    0.352414] net_namespace: 1888 bytes
[    0.352414] Booting paravirtualized kernel on bare hardware
[    0.352414] regulator: core version 0.5
[    0.352414] NET: Registered protocol family 16
[    0.352414] node 0 link 2: io port [a000, efff]
[    0.352414] TOM: 00000000d8000000 aka 3456M
[    0.352414] Fam 10h mmconf [e0000000, efffffff]
[    0.352414] node 0 link 2: mmio [dd000000, dfffffff]
[    0.352414] node 0 link 2: mmio [e0000000, efffffff] ==> none
[    0.352414] node 0 link 2: mmio [a0000, bffff]
[    0.352414] TOM2: 00000001a8000000 aka 6784M
[    0.352414] bus: [00,1e] on node 0 link 2
[    0.352414] bus: 00 index 0 io port: [0, ffff]
[    0.352414] bus: 00 index 1 mmio: [d8000000, dfffffff]
[    0.352414] bus: 00 index 2 mmio: [a0000, bffff]
[    0.352414] bus: 00 index 3 mmio: [f0000000, ffffffff]
[    0.352414] bus: 00 index 4 mmio: [1a8000000, fcffffffff]
[    0.352414] ACPI: bus type pci registered
[    0.352414] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.356005] PCI: MCFG area at e0000000 reserved in E820
[    0.367705] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.367803] PCI: Using configuration type 1 for base access
[    0.368080] bio: create slab <bio-0> at 0
[    0.368595] ACPI: EC: Look up EC in DSDT
[    0.381164] ACPI: Interpreter enabled
[    0.381257] ACPI: (supports S0 S4 S5)
[    0.381521] ACPI: Using IOAPIC for interrupt routing
[    0.392116] ACPI: No dock devices found.
[    0.392277] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.392403] pci 0000:00:01.0: Enabling HT MSI Mapping
[    0.392403] pci 0000:00:02.1: reg 10 io port: [0x1f0-0x1f7]
[    0.392403] pci 0000:00:02.1: reg 14 io port: [0x3f4-0x3f7]
[    0.392403] pci 0000:00:02.1: reg 18 io port: [0x170-0x177]
[    0.392403] pci 0000:00:02.1: reg 1c io port: [0x374-0x377]
[    0.392403] pci 0000:00:02.1: reg 20 io port: [0xffa0-0xffaf]
[    0.392403] pci 0000:00:02.3: reg 10 32bit mmio: [0xfe0d8000-0xfe0d8fff]
[    0.392432] pci 0000:00:03.0: reg 10 32bit mmio: [0xde5ff000-0xde5fffff]
[    0.392439] pci 0000:00:03.0: reg 14 io port: [0xa800-0xa8ff]
[    0.392516] pci 0000:00:03.1: reg 10 32bit mmio: [0xde5fe000-0xde5fefff]
[    0.392523] pci 0000:00:03.1: reg 14 io port: [0xa400-0xa4ff]
[    0.392600] pci 0000:00:03.2: reg 10 32bit mmio: [0xde5fd000-0xde5fdfff]
[    0.392607] pci 0000:00:03.2: reg 14 io port: [0xa000-0xa0ff]
[    0.392661] pci 0000:00:03.2: supports D1 D2
[    0.392663] pci 0000:00:03.2: PME# supported from D0 D1 D2 D3hot
[    0.392765] pci 0000:00:03.2: PME# disabled
[    0.392905] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.393006] pci 0000:00:06.0: PME# disabled
[    0.393136] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.393237] pci 0000:00:07.0: PME# disabled
[    0.393366] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[    0.393467] pci 0000:00:08.0: PME# disabled
[    0.393597] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.393698] pci 0000:00:09.0: PME# disabled
[    0.393830] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.393931] pci 0000:00:0a.0: PME# disabled
[    0.394215] pci 0000:01:0e.0: reg 10 io port: [0xcc00-0xcc07]
[    0.394220] pci 0000:01:0e.0: reg 14 io port: [0xc880-0xc883]
[    0.394225] pci 0000:01:0e.0: reg 18 io port: [0xc800-0xc807]
[    0.394230] pci 0000:01:0e.0: reg 1c io port: [0xc480-0xc483]
[    0.394235] pci 0000:01:0e.0: reg 20 io port: [0xc400-0xc41f]
[    0.394240] pci 0000:01:0e.0: reg 24 32bit mmio: [0xde6fe000-0xde6fffff]
[    0.394246] pci 0000:01:0e.0: reg 30 32bit mmio: [0xde6c0000-0xde6dffff]
[    0.394295] pci 0000:00:01.0: bridge io port: [0xb000-0xcfff]
[    0.394299] pci 0000:00:01.0: bridge 32bit mmio: [0xde600000-0xde7fffff]
[    0.394335] pci 0000:02:02.0: reg 10 64bit mmio: [0xde7f0000-0xde7fffff]
[    0.394395] pci 0000:02:02.0: PME# supported from D3hot D3cold
[    0.394496] pci 0000:02:02.0: PME# disabled
[    0.394622] pci 0000:02:02.1: reg 10 64bit mmio: [0xde7d0000-0xde7dffff]
[    0.394683] pci 0000:02:02.1: PME# supported from D3hot D3cold
[    0.394784] pci 0000:02:02.1: PME# disabled
[    0.394926] pci 0000:01:0d.0: bridge 32bit mmio: [0xde700000-0xde7fffff]
[    0.394954] pci 0000:03:00.0: reg 10 io port: [0xd000-0xd0ff]
[    0.394964] pci 0000:03:00.0: reg 14 64bit mmio: [0xdeafc000-0xdeafffff]
[    0.394974] pci 0000:03:00.0: reg 1c 64bit mmio: [0xdeae0000-0xdeaeffff]
[    0.394984] pci 0000:03:00.0: reg 30 32bit mmio: [0xde800000-0xde9fffff]
[    0.395012] pci 0000:03:00.0: supports D1 D2
[    0.395043] pci 0000:00:06.0: bridge io port: [0xd000-0xdfff]
[    0.395046] pci 0000:00:06.0: bridge 32bit mmio: [0xde800000-0xdeafffff]
[    0.395132] pci 0000:06:00.0: reg 10 64bit mmio: [0xdec00000-0xdeffffff]
[    0.395143] pci 0000:06:00.0: reg 18 64bit mmio: [0xdebff000-0xdebfffff]
[    0.395150] pci 0000:06:00.0: reg 20 io port: [0xe800-0xe8ff]
[    0.395161] pci 0000:06:00.0: reg 30 32bit mmio: [0xdeb00000-0xdeb7ffff]
[    0.395199] pci 0000:06:00.0: supports D1
[    0.395200] pci 0000:06:00.0: PME# supported from D0
[    0.396005] pci 0000:06:00.0: PME# disabled
[    0.396130] pci 0000:00:09.0: bridge io port: [0xe000-0xefff]
[    0.396133] pci 0000:00:09.0: bridge 32bit mmio: [0xdeb00000-0xdeffffff]
[    0.396166] pci 0000:1e:00.0: reg 10 32bit mmio: [0xdd000000-0xddffffff]
[    0.396175] pci 0000:1e:00.0: reg 14 32bit mmio: [0xdfffc000-0xdfffffff]
[    0.396183] pci 0000:1e:00.0: reg 18 32bit mmio: [0xdf000000-0xdf7fffff]
[    0.396209] pci 0000:1e:00.0: reg 30 32bit mmio: [0xdffe0000-0xdffeffff]
[    0.396283] pci 0000:00:0a.0: bridge 32bit mmio: [0xdf000000-0xdfffffff]
[    0.396287] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xdd000000-0xddffffff]
[    0.396308] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.396448] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB0._PRT]
[    0.396510] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB1._PRT]
[    0.396571] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB3._PRT]
[    0.396631] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB4._PRT]
[    0.396679] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.396738] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1.P1P2._PRT]
[    0.404447] ACPI: PCI Interrupt Link [LN00] (IRQs 7 9 11 12 14 15) *0, disabled.
[    0.404948] ACPI: PCI Interrupt Link [LN01] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.408233] ACPI: PCI Interrupt Link [LN02] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.409103] ACPI: PCI Interrupt Link [LN03] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.409970] ACPI: PCI Interrupt Link [LN04] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.410838] ACPI: PCI Interrupt Link [LN05] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.411705] ACPI: PCI Interrupt Link [LN06] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.412585] ACPI: PCI Interrupt Link [LN07] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.413454] ACPI: PCI Interrupt Link [LN08] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.414323] ACPI: PCI Interrupt Link [LN09] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.415191] ACPI: PCI Interrupt Link [LN10] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.416090] ACPI: PCI Interrupt Link [LN11] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.416957] ACPI: PCI Interrupt Link [LN12] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.417824] ACPI: PCI Interrupt Link [LN13] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.418692] ACPI: PCI Interrupt Link [LN14] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.419561] ACPI: PCI Interrupt Link [LN15] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.420424] ACPI: PCI Interrupt Link [LN16] (IRQs 6 7 9 *11 12 14 15)
[    0.421155] ACPI: PCI Interrupt Link [LN17] (IRQs *6 7 9 11 12 14 15)
[    0.421888] ACPI: PCI Interrupt Link [LN18] (IRQs 6 *7 9 11 12 14 15)
[    0.422619] ACPI: PCI Interrupt Link [LN19] (IRQs 6 7 *9 11 12 14 15)
[    0.423351] ACPI: PCI Interrupt Link [LN20] (IRQs 6 7 9 *11 12 14 15)
[    0.424397] ACPI: PCI Interrupt Link [LN21] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.425265] ACPI: PCI Interrupt Link [LN22] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.426132] ACPI: PCI Interrupt Link [LN23] (IRQs 6 7 9 *11 12 14 15)
[    0.428341] ACPI: PCI Interrupt Link [LN24] (IRQs 6 7 *9 11 12 14 15)
[    0.429073] ACPI: PCI Interrupt Link [LN25] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.429942] ACPI: PCI Interrupt Link [LN26] (IRQs 6 7 *9 11 12 14 15)
[    0.430675] ACPI: PCI Interrupt Link [LN27] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.431542] ACPI: PCI Interrupt Link [LN28] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.432422] ACPI: PCI Interrupt Link [LN29] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.433291] ACPI: PCI Interrupt Link [LN30] (IRQs 6 7 9 11 12 14 15) *0, disabled.
[    0.434155] ACPI: PCI Interrupt Link [LNUS] (IRQs *10)
[    0.434555] ACPI: PCI Interrupt Link [LNSA] (IRQs *5)
[    0.434863] usbcore: registered new interface driver usbfs
[    0.434863] usbcore: registered new interface driver hub
[    0.434863] usbcore: registered new device driver usb
[    0.434863] PCI: Using ACPI for IRQ routing
[    0.452150] PCI-DMA: Disabling AGP.
[    0.452318] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.452318] PCI-DMA: using GART IOMMU.
[    0.452318] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.454585] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.454900] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.480022] pnp: PnP ACPI init
[    0.480128] ACPI: bus type pnp registered
[    0.485514] pnp: PnP ACPI: found 14 devices
[    0.485608] ACPI: ACPI bus type pnp unregistered
[    0.485712] system 00:05: ioport range 0xb00-0xb7f has been reserved
[    0.485813] system 00:05: ioport range 0xb80-0xb83 has been reserved
[    0.485915] system 00:05: ioport range 0xb84-0xb85 has been reserved
[    0.486016] system 00:05: ioport range 0xb86-0xb8d has been reserved
[    0.486118] system 00:05: ioport range 0xb90-0xb9f has been reserved
[    0.486219] system 00:05: ioport range 0x200-0x2fe has been reserved
[    0.486324] system 00:06: ioport range 0x200-0x20f has been reserved
[    0.486425] system 00:06: ioport range 0x4d0-0x4d1 has been reserved
[    0.486527] system 00:06: ioport range 0xc00-0xc01 has been reserved
[    0.486628] system 00:06: ioport range 0xcd6-0xcd7 has been reserved
[    0.486730] system 00:06: ioport range 0xcd4-0xcd5 has been reserved
[    0.486832] system 00:06: ioport range 0xcd8-0xcdf has been reserved
[    0.486933] system 00:06: ioport range 0x40b-0x40b has been reserved
[    0.487035] system 00:06: ioport range 0x4d6-0x4d6 has been reserved
[    0.487136] system 00:06: ioport range 0xc06-0xc07 has been reserved
[    0.487237] system 00:06: ioport range 0xc14-0xc14 has been reserved
[    0.487340] system 00:06: ioport range 0xc49-0xc49 has been reserved
[    0.487441] system 00:06: ioport range 0xc4a-0xc4a has been reserved
[    0.487543] system 00:06: ioport range 0xc50-0xc51 has been reserved
[    0.487644] system 00:06: ioport range 0xc52-0xc52 has been reserved
[    0.489553] system 00:06: ioport range 0xc6c-0xc6c has been reserved
[    0.489655] system 00:06: ioport range 0xc6f-0xc6f has been reserved
[    0.489756] system 00:06: ioport range 0x500-0x57f has been reserved
[    0.489862] system 00:08: iomem range 0xfec00000-0xfec02fff has been reserved
[    0.489965] system 00:08: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.490072] system 00:0a: ioport range 0x162e-0x162f has been reserved
[    0.490174] system 00:0a: ioport range 0x600-0x67f has been reserved
[    0.490276] system 00:0a: ioport range 0xa80-0xa8f has been reserved
[    0.497442] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.497549] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.497651] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[    0.497753] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.497857] system 00:0c: iomem range 0x100000-0xdcffffff could not be reserved
[    0.497987] system 00:0c: iomem range 0xff780000-0xffffffff has been reserved
[    0.503092] pci 0000:01:0d.0: PCI bridge, secondary bus 0000:02
[    0.503191] pci 0000:01:0d.0:   IO window: disabled
[    0.503290] pci 0000:01:0d.0:   MEM window: 0xde700000-0xde7fffff
[    0.503392] pci 0000:01:0d.0:   PREFETCH window: disabled
[    0.503492] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.503593] pci 0000:00:01.0:   IO window: 0xb000-0xcfff
[    0.503692] pci 0000:00:01.0:   MEM window: 0xde600000-0xde7fffff
[    0.503793] pci 0000:00:01.0:   PREFETCH window: disabled
[    0.503894] pci 0000:00:06.0: PCI bridge, secondary bus 0000:03
[    0.504003] pci 0000:00:06.0:   IO window: 0xd000-0xdfff
[    0.504102] pci 0000:00:06.0:   MEM window: 0xde800000-0xdeafffff
[    0.504202] pci 0000:00:06.0:   PREFETCH window: disabled
[    0.504302] pci 0000:00:07.0: PCI bridge, secondary bus 0000:04
[    0.504401] pci 0000:00:07.0:   IO window: disabled
[    0.504498] pci 0000:00:07.0:   MEM window: disabled
[    0.504595] pci 0000:00:07.0:   PREFETCH window: disabled
[    0.504695] pci 0000:00:08.0: PCI bridge, secondary bus 0000:05
[    0.504794] pci 0000:00:08.0:   IO window: disabled
[    0.504891] pci 0000:00:08.0:   MEM window: disabled
[    0.504988] pci 0000:00:08.0:   PREFETCH window: disabled
[    0.505088] pci 0000:00:09.0: PCI bridge, secondary bus 0000:06
[    0.505188] pci 0000:00:09.0:   IO window: 0xe000-0xefff
[    0.505287] pci 0000:00:09.0:   MEM window: 0xdeb00000-0xdeffffff
[    0.505388] pci 0000:00:09.0:   PREFETCH window: disabled
[    0.505488] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:1e
[    0.505587] pci 0000:00:0a.0:   IO window: disabled
[    0.505684] pci 0000:00:0a.0:   MEM window: 0xdf000000-0xdfffffff
[    0.505748] Switched to high resolution mode on CPU 1
[    0.505781] Switched to high resolution mode on CPU 3
[    0.505785] Switched to high resolution mode on CPU 2
[    0.505788] pci 0000:00:0a.0:   PREFETCH window: 0x000000dd000000-0x000000ddffffff
[    0.505932]   alloc irq_desc for 36 on cpu 0 node 0
[    0.505934]   alloc kstat_irqs on cpu 0 node 0
[    0.505940] pci 0000:00:06.0: PCI INT A -> GSI 36 (level, low) -> IRQ 36
[    0.506044] pci 0000:00:06.0: setting latency timer to 64
[    0.506048]   alloc irq_desc for 35 on cpu 0 node 0
[    0.506050]   alloc kstat_irqs on cpu 0 node 0
[    0.506055] pci 0000:00:07.0: PCI INT A -> GSI 35 (level, low) -> IRQ 35
[    0.506158] pci 0000:00:07.0: setting latency timer to 64
[    0.506163]   alloc irq_desc for 34 on cpu 0 node 0
[    0.506164]   alloc kstat_irqs on cpu 0 node 0
[    0.506169] pci 0000:00:08.0: PCI INT A -> GSI 34 (level, low) -> IRQ 34
[    0.506272] pci 0000:00:08.0: setting latency timer to 64
[    0.506277]   alloc irq_desc for 33 on cpu 0 node 0
[    0.506279]   alloc kstat_irqs on cpu 0 node 0
[    0.506284] pci 0000:00:09.0: PCI INT A -> GSI 33 (level, low) -> IRQ 33
[    0.506387] pci 0000:00:09.0: setting latency timer to 64
[    0.506392]   alloc irq_desc for 32 on cpu 0 node 0
[    0.506393]   alloc kstat_irqs on cpu 0 node 0
[    0.506399] pci 0000:00:0a.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
[    0.506502] pci 0000:00:0a.0: setting latency timer to 64
[    0.506505] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.506507] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.506510] pci_bus 0000:01: resource 0 io:  [0xb000-0xcfff]
[    0.506512] pci_bus 0000:01: resource 1 mem: [0xde600000-0xde7fffff]
[    0.506514] pci_bus 0000:01: resource 2 mem: [0x0-0x0]
[    0.506515] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.506517] pci_bus 0000:02: resource 0 mem: [0x0-0x0]
[    0.506519] pci_bus 0000:02: resource 1 mem: [0xde700000-0xde7fffff]
[    0.506521] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    0.506522] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.506524] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
[    0.506526] pci_bus 0000:03: resource 1 mem: [0xde800000-0xdeafffff]
[    0.506528] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.506530] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.506531] pci_bus 0000:04: resource 0 mem: [0x0-0x0]
[    0.506533] pci_bus 0000:04: resource 1 mem: [0x0-0x0]
[    0.506535] pci_bus 0000:04: resource 2 mem: [0x0-0x0]
[    0.506536] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    0.506538] pci_bus 0000:05: resource 0 mem: [0x0-0x0]
[    0.506540] pci_bus 0000:05: resource 1 mem: [0x0-0x0]
[    0.506541] pci_bus 0000:05: resource 2 mem: [0x0-0x0]
[    0.506543] pci_bus 0000:05: resource 3 mem: [0x0-0x0]
[    0.506545] pci_bus 0000:06: resource 0 io:  [0xe000-0xefff]
[    0.506547] pci_bus 0000:06: resource 1 mem: [0xdeb00000-0xdeffffff]
[    0.506549] pci_bus 0000:06: resource 2 mem: [0x0-0x0]
[    0.506550] pci_bus 0000:06: resource 3 mem: [0x0-0x0]
[    0.506552] pci_bus 0000:1e: resource 0 mem: [0x0-0x0]
[    0.506554] pci_bus 0000:1e: resource 1 mem: [0xdf000000-0xdfffffff]
[    0.506556] pci_bus 0000:1e: resource 2 mem: [0xdd000000-0xddffffff]
[    0.506557] pci_bus 0000:1e: resource 3 mem: [0x0-0x0]
[    0.506644] NET: Registered protocol family 2
[    0.508011] Switched to high resolution mode on CPU 0
[    0.553731] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.555113] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.558033] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.558530] TCP: Hash tables configured (established 524288 bind 65536)
[    0.558633] TCP reno registered
[    0.572169] NET: Registered protocol family 1
[    0.572354] checking if image is initramfs... it is
[    1.022146] Freeing initrd memory: 7489k freed
[    1.025778] audit: initializing netlink socket (disabled)
[    1.025885] type=2000 audit(1243605988.024:1): initialized
[    1.026441] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.026687] VFS: Disk quotas dquot_6.5.2
[    1.026810] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.026965] msgmni has been set to 11972
[    1.027167] alg: No test for stdrng (krng)
[    1.027337] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.027468] io scheduler noop registered
[    1.027560] io scheduler anticipatory registered
[    1.027655] io scheduler deadline registered
[    1.027776] io scheduler cfq registered (default)
[    1.027940] disabled boot interrupts on PCI device0x1166:0x0205
[    1.084088] pci 0000:1e:00.0: Boot video device
[    1.084231] pcieport-driver 0000:00:06.0: setting latency timer to 64
[    1.084275]   alloc irq_desc for 48 on cpu 0 node 0
[    1.084277]   alloc kstat_irqs on cpu 0 node 0
[    1.084285] pcieport-driver 0000:00:06.0: irq 48 for MSI/MSI-X
[    1.084392] pcieport-driver 0000:00:07.0: setting latency timer to 64
[    1.084432]   alloc irq_desc for 49 on cpu 0 node 0
[    1.084433]   alloc kstat_irqs on cpu 0 node 0
[    1.084438] pcieport-driver 0000:00:07.0: irq 49 for MSI/MSI-X
[    1.084545] pcieport-driver 0000:00:08.0: setting latency timer to 64
[    1.084585]   alloc irq_desc for 50 on cpu 0 node 0
[    1.084587]   alloc kstat_irqs on cpu 0 node 0
[    1.084591] pcieport-driver 0000:00:08.0: irq 50 for MSI/MSI-X
[    1.084712] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    1.084753]   alloc irq_desc for 51 on cpu 0 node 0
[    1.084755]   alloc kstat_irqs on cpu 0 node 0
[    1.084759] pcieport-driver 0000:00:09.0: irq 51 for MSI/MSI-X
[    1.084859] pcieport-driver 0000:00:0a.0: setting latency timer to 64
[    1.084901]   alloc irq_desc for 52 on cpu 0 node 0
[    1.084903]   alloc kstat_irqs on cpu 0 node 0
[    1.084907] pcieport-driver 0000:00:0a.0: irq 52 for MSI/MSI-X
[    1.085051] aer 0000:00:06.0:pcie01: AER service couldn't init device: no _OSC support
[    1.085057] aer 0000:00:07.0:pcie01: AER service couldn't init device: no _OSC support
[    1.085062] aer 0000:00:08.0:pcie01: AER service couldn't init device: no _OSC support
[    1.085066] aer 0000:00:09.0:pcie01: AER service couldn't init device: no _OSC support
[    1.085071] aer 0000:00:0a.0:pcie01: AER service couldn't init device: no _OSC support
[    1.087875] Linux agpgart interface v0.103
[    1.087970] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.088203] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.088683] 00:04: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.090246] brd: module loaded
[    1.090404] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    1.090751] PNP: No PS/2 controller found. Probing ports directly.
[    1.092385] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.092486] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.120885] mice: PS/2 mouse device common for all mice
[    1.121072] rtc_cmos 00:07: RTC can wake from S4
[    1.121216] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    1.121350] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.121483] cpuidle: using governor ladder
[    1.121576] cpuidle: using governor menu
[    1.121671] No iBFT detected.
[    1.122035] TCP cubic registered
[    1.122126] NET: Registered protocol family 17
[    1.122380] registered taskstats version 1
[    1.122642] rtc_cmos 00:07: setting system clock to 2009-05-29 14:06:28 UTC (1243605988)
[    1.122815] Freeing unused kernel memory: 552k freed
[    1.198237] processor ACPI_CPU:00: registered as cooling_device0
[    1.198413] processor ACPI_CPU:01: registered as cooling_device1
[    1.198559] processor ACPI_CPU:02: registered as cooling_device2
[    1.198707] processor ACPI_CPU:03: registered as cooling_device3
[    1.497914] SCSI subsystem initialized
[    1.508045] libata version 3.00 loaded.
[    1.516243] Uniform Multi-Platform E-IDE driver
[    1.529489] tg3.c:v3.97 (December 10, 2008)
[    1.529595]   alloc irq_desc for 40 on cpu 0 node 0
[    1.529597]   alloc kstat_irqs on cpu 0 node 0
[    1.529605] tg3 0000:02:02.0: PCI INT A -> GSI 40 (level, low) -> IRQ 40
[    1.534598] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.537155] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.540091] tg3 0000:02:02.0: wake-up capability disabled by ACPI
[    1.540195] tg3 0000:02:02.0: PME# disabled
[    1.547574] Fusion MPT base driver 3.04.07
[    1.547669] Copyright (c) 1999-2008 LSI Corporation
[    1.555523] eth0: Tigon3 [partno(N/A) rev 2100] (PCIX:133MHz:64-bit) MAC address 00:23:7d:5e:cc:bc
[    1.555660] eth0: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    1.555791] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[0]
[    1.555892] eth0: dma_rwctrl[769f4000] dma_mask[64-bit]
[    1.555999] sata_svw 0000:01:0e.0: version 2.3
[    1.556037] sata_svw 0000:01:0e.0: PCI INT A -> GSI 5 (level, low) -> IRQ 5
[    1.556256] scsi0 : sata_svw
[    1.556429] scsi1 : sata_svw
[    1.556569] scsi2 : sata_svw
[    1.556701] scsi3 : sata_svw
[    1.556815] ata1: SATA max UDMA/133 mmio m8192@0xde6fe000 port 0xde6fe000 irq 5
[    1.556946] ata2: SATA max UDMA/133 mmio m8192@0xde6fe000 port 0xde6fe100 irq 5
[    1.557075] ata3: SATA max UDMA/133 mmio m8192@0xde6fe000 port 0xde6fe200 irq 5
[    1.557205] ata4: SATA max UDMA/133 mmio m8192@0xde6fe000 port 0xde6fe300 irq 5
[    1.560822] Fusion MPT SAS Host driver 3.04.07
[    1.571276] HP CISS Driver (v 3.6.20)
[    1.886985] ata1: SATA link down (SStatus 4 SControl 300)
[    2.214480] ata2: SATA link down (SStatus 4 SControl 300)
[    2.542480] ata3: SATA link down (SStatus 4 SControl 300)
[    2.870491] ata4: SATA link down (SStatus 4 SControl 300)
[    2.870629] ehci_hcd 0000:00:03.2: PCI INT A -> GSI 10 (level, low) -> IRQ 10
[    2.870775] ehci_hcd 0000:00:03.2: EHCI Host Controller
[    2.870946] ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1
[    2.892043] ehci_hcd 0000:00:03.2: irq 10, io mem 0xde5fd000
[    2.904020] ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00
[    2.904137] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.904240] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.904369] usb usb1: Product: EHCI Host Controller
[    2.904465] usb usb1: Manufacturer: Linux 2.6.29-bpo.2-amd64 ehci_hcd
[    2.904566] usb usb1: SerialNumber: 0000:00:03.2
[    2.904712] usb usb1: configuration #1 chosen from 1 choice
[    2.904831] hub 1-0:1.0: USB hub found
[    2.904927] hub 1-0:1.0: 4 ports detected
[    2.905117]   alloc irq_desc for 39 on cpu 0 node 0
[    2.905120]   alloc kstat_irqs on cpu 0 node 0
[    2.905127] tg3 0000:02:02.1: PCI INT B -> GSI 39 (level, low) -> IRQ 39
[    2.912044] tg3 0000:02:02.1: wake-up capability disabled by ACPI
[    2.912148] tg3 0000:02:02.1: PME# disabled
[    2.930149] eth1: Tigon3 [partno(N/A) rev 2100] (PCIX:133MHz:64-bit) MAC address 00:23:7d:5e:cc:bd
[    2.930286] eth1: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    2.930417] eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    2.930518] eth1: dma_rwctrl[769f4000] dma_mask[64-bit]
[    2.930625] mptsas 0000:03:00.0: PCI INT A -> GSI 36 (level, low) -> IRQ 36
[    2.931017] mptbase: ioc0: Initiating bringup
[    3.272032] usb 1-3: new high speed USB device using ehci_hcd and address 3
[    3.404415] usb 1-3: New USB device found, idVendor=04b4, idProduct=6560
[    3.404521] usb 1-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.404680] usb 1-3: configuration #1 chosen from 1 choice
[    3.404931] hub 1-3:1.0: USB hub found
[    3.405162] hub 1-3:1.0: 4 ports detected
[    3.632024] ioc0: LSISAS1068E B3: Capabilities={Initiator}
[    3.632364] mptsas 0000:03:00.0: setting latency timer to 64
[    3.676114] usb 1-3.3: new full speed USB device using ehci_hcd and address 4
[    3.770883] usb 1-3.3: New USB device found, idVendor=0000, idProduct=0000
[    3.770989] usb 1-3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.771121] usb 1-3.3: Product: SE USB Device
[    3.771217] usb 1-3.3: Manufacturer: ServerEngines
[    3.771314] usb 1-3.3: SerialNumber: 40062DA644870A
[    3.771457] usb 1-3.3: configuration #1 chosen from 1 choice
[    3.799804] usbcore: registered new interface driver hiddev
[    3.801203] input: ServerEngines SE USB Device as /devices/pci0000:00/0000:00:03.2/usb1/1-3/1-3.3/1-3.3:1.0/input/input1
[    3.816820] generic-usb 0003:0000:0000.0001: input,hidraw0: USB HID v1.11 Keyboard [ServerEngines SE USB Device] on usb-0000:00:03.2-3.3/input0
[    3.818400] input: ServerEngines SE USB Device as /devices/pci0000:00/0000:00:03.2/usb1/1-3/1-3.3/1-3.3:1.1/input/input2
[    3.828822] generic-usb 0003:0000:0000.0002: input,hidraw1: USB HID v1.11 Mouse [ServerEngines SE USB Device] on usb-0000:00:03.2-3.3/input1
[    3.836001] usbcore: registered new interface driver usbhid
[    3.836100] usbhid: v2.6:USB HID core driver
[   18.270808] scsi4 : ioc0: LSISAS1068E B3, FwRev=01172800h, Ports=1, MaxQ=163, IRQ=36
[   18.294350] scsi 4:0:0:0: Sequential-Access HP       Ultrium 3-SCSI   Q24D PQ: 0 ANSI: 5
[   18.318431] cciss 0000:06:00.0: PCI INT A -> GSI 33 (level, low) -> IRQ 33
[   18.318629]   alloc irq_desc for 53 on cpu 0 node 0
[   18.318631]   alloc kstat_irqs on cpu 0 node 0
[   18.318637] cciss 0000:06:00.0: irq 53 for MSI/MSI-X
[   18.318639]   alloc irq_desc for 54 on cpu 0 node 0
[   18.318641]   alloc kstat_irqs on cpu 0 node 0
[   18.318643] cciss 0000:06:00.0: irq 54 for MSI/MSI-X
[   18.318645]   alloc irq_desc for 55 on cpu 0 node 0
[   18.318647]   alloc kstat_irqs on cpu 0 node 0
[   18.318649] cciss 0000:06:00.0: irq 55 for MSI/MSI-X
[   18.318651]   alloc irq_desc for 56 on cpu 0 node 0
[   18.318652]   alloc kstat_irqs on cpu 0 node 0
[   18.318654] cciss 0000:06:00.0: irq 56 for MSI/MSI-X
[   18.343281] osst :I: Tape driver with OnStream support version 0.99.4
[   18.343282] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   18.343499] Driver 'osst' needs updating - please use bus_type methods
[   18.348430] st: Version 20081215, fixed bufsize 32768, s/g segs 256
[   18.348540] Driver 'st' needs updating - please use bus_type methods
[   18.348776] st 4:0:0:0: Attached scsi tape st0
[   18.348871] st 4:0:0:0: st0: try direct i/o: yes (alignment 4 B)
[   18.360023] IRQ 55/cciss0: IRQF_DISABLED is not guaranteed on shared IRQs
[   18.360141] cciss0: <0x323a> at PCI 0000:06:00.0 IRQ 55 using DAC
[   18.361562]       blocks= 2930122800 block_size= 512
[   18.361702]       heads=255, sectors=32, cylinders=359084
[   18.361703] 
[   18.362015]       blocks= 2930122800 block_size= 512
[   18.362148]       heads=255, sectors=32, cylinders=359084
[   18.362149] 
[   18.362331]  cciss/c0d0: p1 p2 < p5 >
[   18.370794] ohci_hcd 0000:00:03.0: PCI INT A -> GSI 10 (level, low) -> IRQ 10
[   18.370920] ohci_hcd 0000:00:03.0: OHCI Host Controller
[   18.371060] ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
[   18.371202] ohci_hcd 0000:00:03.0: irq 10, io mem 0xde5ff000
[   18.432019] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   18.432123] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.432256] usb usb2: Product: OHCI Host Controller
[   18.432352] usb usb2: Manufacturer: Linux 2.6.29-bpo.2-amd64 ohci_hcd
[   18.432452] usb usb2: SerialNumber: 0000:00:03.0
[   18.432596] usb usb2: configuration #1 chosen from 1 choice
[   18.432715] hub 2-0:1.0: USB hub found
[   18.432814] hub 2-0:1.0: 2 ports detected
[   18.433017] serverworks 0000:00:02.1: IDE controller (0x1166:0x0214 rev 0x00)
[   18.433139] serverworks 0000:00:02.1: not 100% native mode: will probe irqs later
[   18.433272]     ide0: BM-DMA at 0xffa0-0xffa7
[   18.433368] Probing IDE interface ide0...
[   18.808023] usb 2-2: new low speed USB device using ohci_hcd and address 2
[   19.017129] usb 2-2: New USB device found, idVendor=046d, idProduct=c315
[   19.017233] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   19.017337] usb 2-2: Product: Logitech USB Keyboard
[   19.017432] usb 2-2: Manufacturer: Logitech
[   19.017579] usb 2-2: configuration #1 chosen from 1 choice
[   19.025291] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:03.0/usb2/2-2/2-2:1.0/input/input3
[   19.060809] generic-usb 0003:046D:C315.0003: input,hidraw2: USB HID v1.10 Keyboard [Logitech Logitech USB Keyboard] on usb-0000:00:03.0-2/input0
[   19.168317] hda: TEAC DV-W28E-RW, ATAPI CD/DVD-ROM drive
[   19.504053] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[   19.505545] hda: UDMA/33 mode selected
[   19.507809] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   19.508620] ohci_hcd 0000:00:03.1: PCI INT A -> GSI 10 (level, low) -> IRQ 10
[   19.508744] ohci_hcd 0000:00:03.1: OHCI Host Controller
[   19.508887] ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
[   19.509029] ohci_hcd 0000:00:03.1: irq 10, io mem 0xde5fe000
[   19.572017] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   19.572121] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   19.572250] usb usb3: Product: OHCI Host Controller
[   19.572346] usb usb3: Manufacturer: Linux 2.6.29-bpo.2-amd64 ohci_hcd
[   19.572447] usb usb3: SerialNumber: 0000:00:03.1
[   19.572587] usb usb3: configuration #1 chosen from 1 choice
[   19.572704] hub 3-0:1.0: USB hub found
[   19.572803] hub 3-0:1.0: 2 ports detected
[   19.603555] ide-cd driver 5.00
[   19.621602] ide-cd: hda: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache
[   19.622026] Uniform CD-ROM driver Revision: 3.20
[   20.152900] device-mapper: uevent: version 1.0.3
[   20.153085] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[   20.345389] PM: Starting manual resume from disk
[   20.441450] kjournald starting.  Commit interval 5 seconds
[   20.441456] EXT3-fs: mounted filesystem with ordered data mode.
[   21.308397] udevd version 125 started
[   21.619380] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[   21.636763] ACPI: Power Button (FF) [PWRF]
[   21.636935] input: Sleep Button (FF) as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input5
[   21.652764] ACPI: Sleep Button (FF) [SLPF]
[   21.652921] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input6
[   21.668761] ACPI: Power Button (CM) [PWRB]
[   21.890714] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   21.896109] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   21.960097] piix4_smbus 0000:00:02.0: SMBus Host Controller at 0x580, revision 0
[   22.403199] input: PC Speaker as /devices/platform/pcspkr/input/input7
[   22.498331] Error: Driver 'pcspkr' is already registered, aborting...
[   23.545727] EXT3 FS on dm-0, internal journal
[   24.481209] loop: module loaded
[   24.510224] powernow-k8: Found 1 Quad-Core AMD Opteron(tm) Processor 2376 processors (4 cpu cores) (version 2.20.00)
[   24.510409] powernow-k8:    0 : pstate 0 (2300 MHz)
[   24.510507] powernow-k8:    1 : pstate 1 (1600 MHz)
[   24.510603] powernow-k8:    2 : pstate 2 (1100 MHz)
[   24.510699] powernow-k8:    3 : pstate 3 (800 MHz)
[   24.541469] ipmi message handler version 39.2
[   24.546634] IPMI System Interface driver.
[   24.546729] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
[   24.676943] ipmi: Found new BMC (man_id: 0x00000b,  prod_id: 0x2001, dev_id: 0x12)
[   24.677105] IPMI kcs interface initialized
[   24.677222] ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[   24.677371] ipmi_si: duplicate interface
[   24.740154] ipmi device interface
[   25.410564] kjournald starting.  Commit interval 5 seconds
[   25.410786] EXT3 FS on cciss/c0d0p1, internal journal
[   25.410956] EXT3-fs: mounted filesystem with ordered data mode.
[   25.443706] Adding 7811064k swap on /dev/mapper/linux-swap.  Priority:-1 extents:1 across:7811064k

Does anybody know what's wrong?

-- 
Frederik Himpe

