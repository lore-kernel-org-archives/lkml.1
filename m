Return-Path: <linux-kernel-owner+w=401wt.eu-S1759184AbZEBUeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbZEBUeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbZEBUeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:34:16 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:55363 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbZEBUeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:34:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=EOmDXaXChbCJqpyT1DU562XKatk/EEysdWZDWkgOcx9VQcAXUCp5bvDT/Qxa7QfFRE
         GU90mrpqDq4IunD6gJ8dT12OQYHlGSLu81BTGDUl6B4NzMP5sormNP7FFb8gfyFcjDss
         hmyZJYmATYV5ZPfGWMsYVmTufjqzuxPdRedWA=
MIME-Version: 1.0
In-Reply-To: <a44ae5cd0905021327p6253d47ds3c38a0f6ee31db15@mail.gmail.com>
References: <a44ae5cd0905021327p6253d47ds3c38a0f6ee31db15@mail.gmail.com>
Date: Sat, 2 May 2009 16:34:13 -0400
Message-ID: <a44ae5cd0905021334q1f1c40a1q4d2fcd2a20c36d0f@mail.gmail.com>
Subject: 2.6.30-rc4 -- iwl3945 -- INFO: possible irq lock inversion dependency 
	detected
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13224

[ 4573.319715] [ INFO: possible irq lock inversion dependency detected ]
[ 4573.319723] 2.6.30-rc4 #3
[ 4573.319728] ---------------------------------------------------------
[ 4573.319735] swapper/0 just changed the state of lock:
[ 4573.319741]  (&(&priv->scan_check)->timer){+.-...}, at:
[<ffffffff81044e1b>] run_timer_softirq+0x13c/0x26e
[ 4573.319766] but this lock was taken by another, HARDIRQ-safe lock
in the past:
[ 4573.319772]  (&priv->lock){-.-...}
[ 4573.319779]
[ 4573.319781] and interrupts could create inverse lock ordering between them.
[ 4573.319784]
[ 4573.319790]
[ 4573.319791] other info that might help us debug this:
[ 4573.319798] no locks held by swapper/0.
[ 4573.319802]
[ 4573.319804] the first lock's dependencies:
[ 4573.319810] -> (&(&priv->scan_check)->timer){+.-...} ops: 87 {
[ 4573.319825]    HARDIRQ-ON-W at:
[ 4573.319832]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.319855]    IN-SOFTIRQ-W at:
[ 4573.319861]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.319873]    INITIAL USE at:
[ 4573.319880]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.319895]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.319907]
[<ffffffff8104561b>] del_timer_sync+0x3c/0x83
[ 4573.319920]
[<ffffffffa017dedb>] iwl3945_mac_add_interface+0x137/0x1a7 [iwl3945]
[ 4573.319944]
[<ffffffffa00f2462>] ieee80211_open+0x4ce/0x6dd [mac80211]
[ 4573.319980]
[<ffffffff81313f4e>] dev_open+0x7c/0xbd
[ 4573.319993]
[<ffffffff8131399f>] dev_change_flags+0xba/0x180
[ 4573.320005]
[<ffffffff8131bede>] do_setlink+0x307/0x3cf
[ 4573.320017]
[<ffffffff8131c0d1>] rtnl_setlink+0x12b/0x142
[ 4573.320030]
[<ffffffff8131d085>] rtnetlink_rcv_msg+0x1d8/0x1f9
[ 4573.320042]
[<ffffffff81327251>] netlink_rcv_skb+0x3e/0x8d
[ 4573.320056]
[<ffffffff8131cea3>] rtnetlink_rcv+0x29/0x33
[ 4573.320068]
[<ffffffff81326db3>] netlink_unicast+0x117/0x180
[ 4573.320080]
[<ffffffff81327093>] netlink_sendmsg+0x277/0x28a
[ 4573.320092]
[<ffffffff813032b2>] __sock_sendmsg+0x59/0x62
[ 4573.320106]
[<ffffffff81303bda>] sock_sendmsg+0xc7/0xe0
[ 4573.320118]
[<ffffffff81303e07>] sys_sendmsg+0x214/0x29b
[ 4573.320130]
[<ffffffff8100bc6b>] system_call_fastpath+0x16/0x1b
[ 4573.320145]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.320156]  }
[ 4573.320161]  ... key      at: [<ffffffffa018bf48>]
__key.41436+0x0/0xffffffffffff8640 [iwl3945]
[ 4573.320183]
[ 4573.320185] the second lock's dependencies:
[ 4573.320190] -> (&priv->lock){-.-...} ops: 250343 {
[ 4573.320205]    IN-HARDIRQ-W at:
[ 4573.320211]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.320223]    IN-SOFTIRQ-W at:
[ 4573.320230]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.320241]    INITIAL USE at:
[ 4573.320248]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.320261]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.320273]
[<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.320288]
[<ffffffffa0161b8c>] iwl_reset_qos+0x19/0x19a [iwlcore]
[ 4573.320315]
[<ffffffffa017fedd>] iwl3945_pci_probe+0x357/0xcce [iwl3945]
[ 4573.320339]
[<ffffffff811d54ff>] local_pci_probe+0x12/0x16
[ 4573.320353]
[<ffffffff811d61ee>] pci_device_probe+0x5f/0x89
[ 4573.320366]
[<ffffffff8127a36d>] driver_probe_device+0x9e/0x143
[ 4573.320380]
[<ffffffff8127a46a>] __driver_attach+0x58/0x7b
[ 4573.320392]
[<ffffffff81279c60>] bus_for_each_dev+0x54/0x8a
[ 4573.320404]
[<ffffffff8127a1df>] driver_attach+0x1c/0x1e
[ 4573.320416]
[<ffffffff8127959c>] bus_add_driver+0xb2/0x1e6
[ 4573.320427]
[<ffffffff8127a724>] driver_register+0xb6/0x121
[ 4573.320440]
[<ffffffff811d6616>] __pci_register_driver+0x61/0xcf
[ 4573.320452]
[<ffffffffa018e05c>] 0xffffffffa018e05c
[ 4573.320464]
[<ffffffff8100906b>] do_one_initcall+0x65/0x153
[ 4573.320477]
[<ffffffff81068fd4>] sys_init_module+0xab/0x1d3
[ 4573.320490]
[<ffffffff8100bc6b>] system_call_fastpath+0x16/0x1b
[ 4573.320502]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.320514]  }
[ 4573.320518]  ... key      at: [<ffffffffa018bf40>]
__key.41486+0x0/0xffffffffffff8648 [iwl3945]
[ 4573.320539]  -> (pci_lock){......} ops: 9888 {
[ 4573.320555]     INITIAL USE at:
[ 4573.320562]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.320575]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.320587]
[<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.320600]
[<ffffffff811cfa4d>] pci_bus_read_config_dword+0x3c/0x87
[ 4573.320613]
[<ffffffff813cb7fd>] pci_scan_single_device+0x45/0x13a
[ 4573.320627]
[<ffffffff811d1388>] pci_scan_slot+0x19/0x94
[ 4573.320639]
[<ffffffff813cd084>] pci_scan_child_bus+0x24/0x9e
[ 4573.320651]
[<ffffffff813cd11c>] pci_scan_bus_parented+0x1e/0x2b
[ 4573.320663]
[<ffffffff813d1d94>] pci_acpi_scan_root+0xdb/0x26f
[ 4573.320675]
[<ffffffff813cf09a>] acpi_pci_root_add+0x2a4/0x3cd
[ 4573.320688]
[<ffffffff811f5d6c>] acpi_device_probe+0x53/0x150
[ 4573.320701]
[<ffffffff8127a36d>] driver_probe_device+0x9e/0x143
[ 4573.320714]
[<ffffffff8127a46a>] __driver_attach+0x58/0x7b
[ 4573.320726]
[<ffffffff81279c60>] bus_for_each_dev+0x54/0x8a
[ 4573.320738]
[<ffffffff8127a1df>] driver_attach+0x1c/0x1e
[ 4573.320750]
[<ffffffff8127959c>] bus_add_driver+0xb2/0x1e6
[ 4573.320762]
[<ffffffff8127a724>] driver_register+0xb6/0x121
[ 4573.320774]
[<ffffffff811f7603>] acpi_bus_register_driver+0x3e/0x43
[ 4573.320787]
[<ffffffff81644cf4>] acpi_pci_root_init+0x19/0x28
[ 4573.320800]
[<ffffffff8100906b>] do_one_initcall+0x65/0x153
[ 4573.320813]
[<ffffffff8162263d>] kernel_init+0x12d/0x183
[ 4573.320825]
[<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.320836]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.320848]   }
[ 4573.320852]   ... key      at: [<ffffffff815cedd8>] pci_lock+0x18/0x30
[ 4573.320865]   -> (pci_config_lock){......} ops: 9990 {
[ 4573.320880]      INITIAL USE at:
[ 4573.320888]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.320901]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.320913]
[<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.320926]
[<ffffffff8130043d>] pci_conf1_read+0x5b/0xe2
[ 4573.320938]
[<ffffffff8164c054>] __pci_mmcfg_init+0x8f/0x2f5
[ 4573.320952]
[<ffffffff8164c2d5>] pci_mmcfg_early_init+0xe/0x10
[ 4573.320964]
[<ffffffff8164b45f>] pci_arch_init+0x1e/0x57
[ 4573.320976]
[<ffffffff8100906b>] do_one_initcall+0x65/0x153
[ 4573.320989]
[<ffffffff8162263d>] kernel_init+0x12d/0x183
[ 4573.321000]
[<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.321011]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.321022]    }
[ 4573.321026]    ... key      at: [<ffffffff815f1328>]
pci_config_lock+0x18/0x30
[ 4573.321040]   ... acquired at:
[ 4573.321044]    [<ffffffff810600c6>] __lock_acquire+0xa88/0xc22
[ 4573.321055]    [<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.321067]    [<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.321078]    [<ffffffff8130043d>] pci_conf1_read+0x5b/0xe2
[ 4573.321088]    [<ffffffff813018fe>] raw_pci_read+0x1e/0x36
[ 4573.321100]    [<ffffffff81301975>] pci_read+0x27/0x29
[ 4573.321110]    [<ffffffff811cfa6b>] pci_bus_read_config_dword+0x5a/0x87
[ 4573.321121]    [<ffffffff813cb7fd>] pci_scan_single_device+0x45/0x13a
[ 4573.321132]    [<ffffffff811d1388>] pci_scan_slot+0x19/0x94
[ 4573.321142]    [<ffffffff813cd084>] pci_scan_child_bus+0x24/0x9e
[ 4573.321153]    [<ffffffff813cd11c>] pci_scan_bus_parented+0x1e/0x2b
[ 4573.321164]    [<ffffffff813d1d94>] pci_acpi_scan_root+0xdb/0x26f
[ 4573.321174]    [<ffffffff813cf09a>] acpi_pci_root_add+0x2a4/0x3cd
[ 4573.321186]    [<ffffffff811f5d6c>] acpi_device_probe+0x53/0x150
[ 4573.321197]    [<ffffffff8127a36d>] driver_probe_device+0x9e/0x143
[ 4573.321208]    [<ffffffff8127a46a>] __driver_attach+0x58/0x7b
[ 4573.321219]    [<ffffffff81279c60>] bus_for_each_dev+0x54/0x8a
[ 4573.321230]    [<ffffffff8127a1df>] driver_attach+0x1c/0x1e
[ 4573.321240]    [<ffffffff8127959c>] bus_add_driver+0xb2/0x1e6
[ 4573.321251]    [<ffffffff8127a724>] driver_register+0xb6/0x121
[ 4573.321262]    [<ffffffff811f7603>] acpi_bus_register_driver+0x3e/0x43
[ 4573.321273]    [<ffffffff81644cf4>] acpi_pci_root_init+0x19/0x28
[ 4573.321283]    [<ffffffff8100906b>] do_one_initcall+0x65/0x153
[ 4573.321294]    [<ffffffff8162263d>] kernel_init+0x12d/0x183
[ 4573.321304]    [<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.321313]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.321323]
[ 4573.321328]  ... acquired at:
[ 4573.321332]    [<ffffffff810600c6>] __lock_acquire+0xa88/0xc22
[ 4573.321344]    [<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.321355]    [<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.321366]    [<ffffffff811cfad4>] pci_bus_read_config_word+0x3c/0x88
[ 4573.321377]    [<ffffffff811d1e20>] pci_find_capability+0x2c/0x71
[ 4573.321388]    [<ffffffffa0164cb6>] iwl_power_initialize+0x63/0xd4 [iwlcore]
[ 4573.321415]    [<ffffffffa0181dfb>] iwl3945_apm_init+0xf/0xc3 [iwl3945]
[ 4573.321437]    [<ffffffffa0182b6a>] iwl3945_hw_nic_init+0x3b/0x3bc [iwl3945]
[ 4573.321459]    [<ffffffffa017b019>] __iwl3945_up+0x14d/0x24a [iwl3945]
[ 4573.321479]    [<ffffffffa017b754>] iwl3945_mac_start+0x5f8/0x794 [iwl3945]
[ 4573.321499]    [<ffffffffa00f2235>] ieee80211_open+0x2a1/0x6dd [mac80211]
[ 4573.321532]    [<ffffffff81313f4e>] dev_open+0x7c/0xbd
[ 4573.321542]    [<ffffffff8131399f>] dev_change_flags+0xba/0x180
[ 4573.321553]    [<ffffffff8131bede>] do_setlink+0x307/0x3cf
[ 4573.321564]    [<ffffffff8131c0d1>] rtnl_setlink+0x12b/0x142
[ 4573.321575]    [<ffffffff8131d085>] rtnetlink_rcv_msg+0x1d8/0x1f9
[ 4573.321586]    [<ffffffff81327251>] netlink_rcv_skb+0x3e/0x8d
[ 4573.321597]    [<ffffffff8131cea3>] rtnetlink_rcv+0x29/0x33
[ 4573.321608]    [<ffffffff81326db3>] netlink_unicast+0x117/0x180
[ 4573.321619]    [<ffffffff81327093>] netlink_sendmsg+0x277/0x28a
[ 4573.321630]    [<ffffffff813032b2>] __sock_sendmsg+0x59/0x62
[ 4573.321641]    [<ffffffff81303bda>] sock_sendmsg+0xc7/0xe0
[ 4573.321652]    [<ffffffff81303e07>] sys_sendmsg+0x214/0x29b
[ 4573.321662]    [<ffffffff8100bc6b>] system_call_fastpath+0x16/0x1b
[ 4573.321674]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.321685]
[ 4573.321689]  -> (&rxq->lock){..-...} ops: 286984 {
[ 4573.321704]     IN-SOFTIRQ-W at:
[ 4573.321711]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.321722]     INITIAL USE at:
[ 4573.321729]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.321742]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.321754]
[<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.321767]
[<ffffffffa017e814>] iwl3945_rx_allocate+0x31/0x119 [iwl3945]
[ 4573.321790]
[<ffffffffa017eeea>] iwl3945_rx_replenish+0x1c/0x43 [iwl3945]
[ 4573.321812]
[<ffffffffa0182c3a>] iwl3945_hw_nic_init+0x10b/0x3bc [iwl3945]
[ 4573.321835]
[<ffffffffa017b019>] __iwl3945_up+0x14d/0x24a [iwl3945]
[ 4573.321856]
[<ffffffffa017b754>] iwl3945_mac_start+0x5f8/0x794 [iwl3945]
[ 4573.321877]
[<ffffffffa00f2235>] ieee80211_open+0x2a1/0x6dd [mac80211]
[ 4573.321911]
[<ffffffff81313f4e>] dev_open+0x7c/0xbd
[ 4573.321923]
[<ffffffff8131399f>] dev_change_flags+0xba/0x180
[ 4573.321934]
[<ffffffff8131bede>] do_setlink+0x307/0x3cf
[ 4573.321946]
[<ffffffff8131c0d1>] rtnl_setlink+0x12b/0x142
[ 4573.321958]
[<ffffffff8131d085>] rtnetlink_rcv_msg+0x1d8/0x1f9
[ 4573.321971]
[<ffffffff81327251>] netlink_rcv_skb+0x3e/0x8d
[ 4573.321984]
[<ffffffff8131cea3>] rtnetlink_rcv+0x29/0x33
[ 4573.321996]
[<ffffffff81326db3>] netlink_unicast+0x117/0x180
[ 4573.322008]
[<ffffffff81327093>] netlink_sendmsg+0x277/0x28a
[ 4573.322020]
[<ffffffff813032b2>] __sock_sendmsg+0x59/0x62
[ 4573.322033]
[<ffffffff81303bda>] sock_sendmsg+0xc7/0xe0
[ 4573.322045]
[<ffffffff81303e07>] sys_sendmsg+0x214/0x29b
[ 4573.322057]
[<ffffffff8100bc6b>] system_call_fastpath+0x16/0x1b
[ 4573.322070]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322082]   }
[ 4573.322087]   ... key      at: [<ffffffffa0177b20>]
__key.38359+0x0/0xffffffffffff4dcc [iwlcore]
[ 4573.322112]   -> (&n->list_lock){-.-...} ops: 938988 {
[ 4573.322127]      IN-HARDIRQ-W at:
[ 4573.322134]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322146]      IN-SOFTIRQ-W at:
[ 4573.322153]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322164]      INITIAL USE at:
[ 4573.322171]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.322184]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322197]
[<ffffffff813dc446>] _spin_lock+0x36/0x43
[ 4573.322209]
[<ffffffff810bf155>] unfreeze_slab+0x57/0x124
[ 4573.322223]
[<ffffffff810c0341>] __slab_alloc+0x147/0x557
[ 4573.322236]
[<ffffffff810c1427>] __kmalloc+0xef/0x14d
[ 4573.322248]
[<ffffffff810c1f4f>] kmem_cache_create+0x211/0x2fb
[ 4573.322261]
[<ffffffff8163df6d>] key_init+0x1f/0xb1
[ 4573.322273]
[<ffffffff81622c6a>] start_kernel+0x393/0x3e6
[ 4573.322285]
[<ffffffff8162229a>] x86_64_start_reservations+0xaa/0xae
[ 4573.322299]
[<ffffffff8162237f>] x86_64_start_kernel+0xe1/0xe8
[ 4573.322311]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322322]    }
[ 4573.322327]    ... key      at: [<ffffffff81dd7898>] __key.25306+0x0/0x8
[ 4573.322339]   ... acquired at:
[ 4573.322344]    [<ffffffff810600c6>] __lock_acquire+0xa88/0xc22
[ 4573.322356]    [<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322366]    [<ffffffff813dc446>] _spin_lock+0x36/0x43
[ 4573.322378]    [<ffffffff810bf155>] unfreeze_slab+0x57/0x124
[ 4573.322389]    [<ffffffff810c0341>] __slab_alloc+0x147/0x557
[ 4573.322399]    [<ffffffff810c12da>] __kmalloc_track_caller+0xeb/0x149
[ 4573.322411]    [<ffffffff8130ba15>] __alloc_skb+0x66/0x13a
[ 4573.322423]    [<ffffffffa017e832>] iwl3945_rx_allocate+0x4f/0x119 [iwl3945]
[ 4573.322445]    [<ffffffffa017eeea>] iwl3945_rx_replenish+0x1c/0x43 [iwl3945]
[ 4573.322465]    [<ffffffffa0182c3a>] iwl3945_hw_nic_init+0x10b/0x3bc [iwl3945]
[ 4573.322487]    [<ffffffffa017b019>] __iwl3945_up+0x14d/0x24a [iwl3945]
[ 4573.322506]    [<ffffffffa017b754>] iwl3945_mac_start+0x5f8/0x794 [iwl3945]
[ 4573.322526]    [<ffffffffa00f2235>] ieee80211_open+0x2a1/0x6dd [mac80211]
[ 4573.322558]    [<ffffffff81313f4e>] dev_open+0x7c/0xbd
[ 4573.322568]    [<ffffffff8131399f>] dev_change_flags+0xba/0x180
[ 4573.322579]    [<ffffffff8131bede>] do_setlink+0x307/0x3cf
[ 4573.322590]    [<ffffffff8131c0d1>] rtnl_setlink+0x12b/0x142
[ 4573.322600]    [<ffffffff8131d085>] rtnetlink_rcv_msg+0x1d8/0x1f9
[ 4573.322612]    [<ffffffff81327251>] netlink_rcv_skb+0x3e/0x8d
[ 4573.322623]    [<ffffffff8131cea3>] rtnetlink_rcv+0x29/0x33
[ 4573.322634]    [<ffffffff81326db3>] netlink_unicast+0x117/0x180
[ 4573.322645]    [<ffffffff81327093>] netlink_sendmsg+0x277/0x28a
[ 4573.322656]    [<ffffffff813032b2>] __sock_sendmsg+0x59/0x62
[ 4573.322667]    [<ffffffff81303bda>] sock_sendmsg+0xc7/0xe0
[ 4573.322677]    [<ffffffff81303e07>] sys_sendmsg+0x214/0x29b
[ 4573.322688]    [<ffffffff8100bc6b>] system_call_fastpath+0x16/0x1b
[ 4573.322700]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322710]
[ 4573.322714]   -> (&zone->lock){..-...} ops: 128829 {
[ 4573.322729]      IN-SOFTIRQ-W at:
[ 4573.322736]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322748]      INITIAL USE at:
[ 4573.322755]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.322768]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322780]
[<ffffffff813dc446>] _spin_lock+0x36/0x43
[ 4573.322793]
[<ffffffff8109c553>] free_pages_bulk+0x2b/0x8b
[ 4573.322805]
[<ffffffff8109cff6>] free_hot_cold_page+0x14c/0x1be
[ 4573.322817]
[<ffffffff8109d0c0>] free_hot_page+0xb/0xd
[ 4573.322828]
[<ffffffff8109d0e8>] __free_pages+0x26/0x2f
[ 4573.322840]
[<ffffffff8165450f>] __free_pages_bootmem+0x7e/0x80
[ 4573.322853]
[<ffffffff81638e80>] free_all_bootmem_core+0xf3/0x1c2
[ 4573.322867]
[<ffffffff81638f5f>] free_all_bootmem+0x10/0x12
[ 4573.322879]
[<ffffffff816331c9>] mem_init+0x1e/0x161
[ 4573.322891]
[<ffffffff81622bfc>] start_kernel+0x325/0x3e6
[ 4573.322902]
[<ffffffff8162229a>] x86_64_start_reservations+0xaa/0xae
[ 4573.322916]
[<ffffffff8162237f>] x86_64_start_kernel+0xe1/0xe8
[ 4573.322929]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322940]    }
[ 4573.322944]    ... key      at: [<ffffffff81dd5570>] __key.30048+0x0/0x8
[ 4573.322955]   ... acquired at:
[ 4573.322959]    [<ffffffff810600c6>] __lock_acquire+0xa88/0xc22
[ 4573.322971]    [<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]    [<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.322981]    [<ffffffff8109d487>] get_page_from_freelist+0x313/0x5df
[ 4573.322981]    [<ffffffff8109da71>] __alloc_pages_internal+0x101/0x463
[ 4573.322981]    [<ffffffff810c01f4>] alloc_slab_page+0x20/0x26
[ 4573.322981]    [<ffffffff810c0440>] __slab_alloc+0x246/0x557
[ 4573.322981]    [<ffffffff810c12da>] __kmalloc_track_caller+0xeb/0x149
[ 4573.322981]    [<ffffffff8130ba15>] __alloc_skb+0x66/0x13a
[ 4573.322981]    [<ffffffffa017e832>] iwl3945_rx_allocate+0x4f/0x119 [iwl3945]
[ 4573.322981]    [<ffffffffa017eeea>] iwl3945_rx_replenish+0x1c/0x43 [iwl3945]
[ 4573.322981]    [<ffffffffa0182c3a>] iwl3945_hw_nic_init+0x10b/0x3bc [iwl3945]
[ 4573.322981]    [<ffffffffa017b019>] __iwl3945_up+0x14d/0x24a [iwl3945]
[ 4573.322981]    [<ffffffffa017b754>] iwl3945_mac_start+0x5f8/0x794 [iwl3945]
[ 4573.322981]    [<ffffffffa00f2235>] ieee80211_open+0x2a1/0x6dd [mac80211]
[ 4573.322981]    [<ffffffff81313f4e>] dev_open+0x7c/0xbd
[ 4573.322981]    [<ffffffff8131399f>] dev_change_flags+0xba/0x180
[ 4573.322981]    [<ffffffff8131bede>] do_setlink+0x307/0x3cf
[ 4573.322981]    [<ffffffff8131c0d1>] rtnl_setlink+0x12b/0x142
[ 4573.322981]    [<ffffffff8131d085>] rtnetlink_rcv_msg+0x1d8/0x1f9
[ 4573.322981]    [<ffffffff81327251>] netlink_rcv_skb+0x3e/0x8d
[ 4573.322981]    [<ffffffff8131cea3>] rtnetlink_rcv+0x29/0x33
[ 4573.322981]    [<ffffffff81326db3>] netlink_unicast+0x117/0x180
[ 4573.322981]    [<ffffffff81327093>] netlink_sendmsg+0x277/0x28a
[ 4573.322981]    [<ffffffff813032b2>] __sock_sendmsg+0x59/0x62
[ 4573.322981]    [<ffffffff81303bda>] sock_sendmsg+0xc7/0xe0
[ 4573.322981]    [<ffffffff81303e07>] sys_sendmsg+0x214/0x29b
[ 4573.322981]    [<ffffffff8100bc6b>] system_call_fastpath+0x16/0x1b
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]  ... acquired at:
[ 4573.322981]    [<ffffffff810600c6>] __lock_acquire+0xa88/0xc22
[ 4573.322981]    [<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]    [<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.322981]    [<ffffffffa017e92a>]
iwl3945_rx_queue_restock+0x2e/0x135 [iwl3945]
[ 4573.322981]    [<ffffffffa017eefd>] iwl3945_rx_replenish+0x2f/0x43 [iwl3945]
[ 4573.322981]    [<ffffffffa0182c3a>] iwl3945_hw_nic_init+0x10b/0x3bc [iwl3945]
[ 4573.322981]    [<ffffffffa017b019>] __iwl3945_up+0x14d/0x24a [iwl3945]
[ 4573.322981]    [<ffffffffa017b754>] iwl3945_mac_start+0x5f8/0x794 [iwl3945]
[ 4573.322981]    [<ffffffffa00f2235>] ieee80211_open+0x2a1/0x6dd [mac80211]
[ 4573.322981]    [<ffffffff81313f4e>] dev_open+0x7c/0xbd
[ 4573.322981]    [<ffffffff8131399f>] dev_change_flags+0xba/0x180
[ 4573.322981]    [<ffffffff8131bede>] do_setlink+0x307/0x3cf
[ 4573.322981]    [<ffffffff8131c0d1>] rtnl_setlink+0x12b/0x142
[ 4573.322981]    [<ffffffff8131d085>] rtnetlink_rcv_msg+0x1d8/0x1f9
[ 4573.322981]    [<ffffffff81327251>] netlink_rcv_skb+0x3e/0x8d
[ 4573.322981]    [<ffffffff8131cea3>] rtnetlink_rcv+0x29/0x33
[ 4573.322981]    [<ffffffff81326db3>] netlink_unicast+0x117/0x180
[ 4573.322981]    [<ffffffff81327093>] netlink_sendmsg+0x277/0x28a
[ 4573.322981]    [<ffffffff813032b2>] __sock_sendmsg+0x59/0x62
[ 4573.322981]    [<ffffffff81303bda>] sock_sendmsg+0xc7/0xe0
[ 4573.322981]    [<ffffffff81303e07>] sys_sendmsg+0x214/0x29b
[ 4573.322981]    [<ffffffff8100bc6b>] system_call_fastpath+0x16/0x1b
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]  -> (&base->lock){..-...} ops: 2511018 {
[ 4573.322981]     IN-SOFTIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]     INITIAL USE at:
[ 4573.322981]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.322981]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]
[<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.322981]
[<ffffffff810450fd>] lock_timer_base+0x26/0x4a
[ 4573.322981]
[<ffffffff81045750>] __mod_timer+0x3a/0xe6
[ 4573.322981]
[<ffffffff8104586e>] mod_timer+0x1c/0x1e
[ 4573.322981]
[<ffffffff81646c5c>] con_init+0xc5/0x23b
[ 4573.322981]
[<ffffffff816463e2>] console_init+0x19/0x2b
[ 4573.322981]
[<ffffffff81622b51>] start_kernel+0x27a/0x3e6
[ 4573.322981]
[<ffffffff8162229a>] x86_64_start_reservations+0xaa/0xae
[ 4573.322981]
[<ffffffff8162237f>] x86_64_start_kernel+0xe1/0xe8
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]   }
[ 4573.322981]   ... key      at: [<ffffffff816ddad8>] __key.23361+0x0/0x8
[ 4573.322981]  ... acquired at:
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]  -> (&q->lock){-.-.-.} ops: 26125342 {
[ 4573.322981]     IN-HARDIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]     IN-SOFTIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]     IN-RECLAIM_FS-W at:
[ 4573.322981]
[<ffffffff8105f95c>] __lock_acquire+0x31e/0xc22
[ 4573.322981]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]
[<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.322981]
[<ffffffff81050397>] prepare_to_wait+0x1c/0x5e
[ 4573.322981]
[<ffffffff810a36b5>] kswapd+0xd8/0x65f
[ 4573.322981]
[<ffffffff8104fd51>] kthread+0x56/0x83
[ 4573.322981]
[<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]     INITIAL USE at:
[ 4573.322981]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.322981]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]
[<ffffffff813dc4d7>] _spin_lock_irq+0x3c/0x49
[ 4573.322981]
[<ffffffff813d97c3>] wait_for_common+0x35/0xfb
[ 4573.322981]
[<ffffffff813d9913>] wait_for_completion+0x18/0x1a
[ 4573.322981]
[<ffffffff8104ffe5>] kthread_create+0xa8/0x163
[ 4573.322981]
[<ffffffff813d6e26>] migration_call+0x47/0x496
[ 4573.322981]
[<ffffffff816348e8>] migration_init+0x22/0x58
[ 4573.322981]
[<ffffffff8100906b>] do_one_initcall+0x65/0x153
[ 4573.322981]
[<ffffffff81622574>] kernel_init+0x64/0x183
[ 4573.322981]
[<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]   }
[ 4573.322981]   ... key      at: [<ffffffff816de1e8>] __key.17866+0x0/0x8
[ 4573.322981]   -> (&rq->lock){-.-.-.} ops: 10029772 {
[ 4573.322981]      IN-HARDIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]      IN-SOFTIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]      IN-RECLAIM_FS-W at:
[ 4573.322981]
[<ffffffff8105f95c>] __lock_acquire+0x31e/0xc22
[ 4573.322981]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]
[<ffffffff813dc446>] _spin_lock+0x36/0x43
[ 4573.322981]
[<ffffffff8102fc32>] task_rq_lock+0x3e/0x70
[ 4573.322981]
[<ffffffff81037832>] set_cpus_allowed_ptr+0x1c/0x105
[ 4573.322981]
[<ffffffff810a364c>] kswapd+0x6f/0x65f
[ 4573.322981]
[<ffffffff8104fd51>] kthread+0x56/0x83
[ 4573.322981]
[<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]      INITIAL USE at:
[ 4573.322981]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.322981]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]
[<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.322981]
[<ffffffff81032de6>] rq_attach_root+0x16/0xcb
[ 4573.322981]
[<ffffffff81634737>] sched_init+0x35a/0x4e9
[ 4573.322981]
[<ffffffff81622a65>] start_kernel+0x18e/0x3e6
[ 4573.322981]
[<ffffffff8162229a>] x86_64_start_reservations+0xaa/0xae
[ 4573.322981]
[<ffffffff8162237f>] x86_64_start_kernel+0xe1/0xe8
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]    }
[ 4573.322981]    ... key      at: [<ffffffff81699220>] __key.45720+0x0/0x8
[ 4573.322981]    -> (&vec->lock){-.-...} ops: 24940 {
[ 4573.322981]       IN-HARDIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]       IN-SOFTIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]       INITIAL USE at:
[ 4573.322981]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.322981]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]
[<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.322981]
[<ffffffff810973a5>] cpupri_set+0xd3/0x135
[ 4573.322981]
[<ffffffff81030d82>] rq_online_rt+0x6a/0x6e
[ 4573.322981]
[<ffffffff8102f0bf>] set_rq_online+0x48/0x55
[ 4573.322981]
[<ffffffff81032e71>] rq_attach_root+0xa1/0xcb
[ 4573.322981]
[<ffffffff81634737>] sched_init+0x35a/0x4e9
[ 4573.322981]
[<ffffffff81622a65>] start_kernel+0x18e/0x3e6
[ 4573.322981]
[<ffffffff8162229a>] x86_64_start_reservations+0xaa/0xae
[ 4573.322981]
[<ffffffff8162237f>] x86_64_start_kernel+0xe1/0xe8
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]     }
[ 4573.322981]     ... key      at: [<ffffffff81dd54c8>] __key.14696+0x0/0x38
[ 4573.322981]    ... acquired at:
[ 4573.322981]    [<ffffffff810600c6>] __lock_acquire+0xa88/0xc22
[ 4573.322981]    [<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]    [<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.322981]    [<ffffffff810973a5>] cpupri_set+0xd3/0x135
[ 4573.322981]    [<ffffffff81030d82>] rq_online_rt+0x6a/0x6e
[ 4573.322981]    [<ffffffff8102f0bf>] set_rq_online+0x48/0x55
[ 4573.322981]    [<ffffffff81032e71>] rq_attach_root+0xa1/0xcb
[ 4573.322981]    [<ffffffff81634737>] sched_init+0x35a/0x4e9
[ 4573.322981]    [<ffffffff81622a65>] start_kernel+0x18e/0x3e6
[ 4573.322981]    [<ffffffff8162229a>] x86_64_start_reservations+0xaa/0xae
[ 4573.322981]    [<ffffffff8162237f>] x86_64_start_kernel+0xe1/0xe8
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]    -> (&rt_b->rt_runtime_lock){-.-...} ops: 4564 {
[ 4573.322981]       IN-HARDIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]       IN-SOFTIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]       INITIAL USE at:
[ 4573.322981]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.322981]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]
[<ffffffff813dc446>] _spin_lock+0x36/0x43
[ 4573.322981]
[<ffffffff81031419>] enqueue_task_rt+0x199/0x253
[ 4573.322981]
[<ffffffff8102eb2c>] enqueue_task+0x5b/0x66
[ 4573.322981]
[<ffffffff8102ec3b>] activate_task+0x28/0x31
[ 4573.322981]
[<ffffffff810370bb>] try_to_wake_up+0x1c0/0x2fa
[ 4573.322981]
[<ffffffff81037221>] wake_up_process+0x10/0x12
[ 4573.322981]
[<ffffffff813d6eb6>] migration_call+0xd7/0x496
[ 4573.322981]
[<ffffffff8163490a>] migration_init+0x44/0x58
[ 4573.322981]
[<ffffffff8100906b>] do_one_initcall+0x65/0x153
[ 4573.322981]
[<ffffffff81622574>] kernel_init+0x64/0x183
[ 4573.322981]
[<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]     }
[ 4573.322981]     ... key      at: [<ffffffff81699228>] __key.37731+0x0/0x8
[ 4573.322981]     -> (&cpu_base->lock){-.-...} ops: 9825156 {
[ 4573.322981]        IN-HARDIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]        IN-SOFTIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]        INITIAL USE at:
[ 4573.322981]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.322981]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]
[<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.322981]
[<ffffffff81052e32>] lock_hrtimer_base+0x25/0x4b
[ 4573.322981]
[<ffffffff81052f77>] __hrtimer_start_range_ns+0x33/0x1de
[ 4573.322981]
[<ffffffff81031465>] enqueue_task_rt+0x1e5/0x253
[ 4573.322981]
[<ffffffff8102eb2c>] enqueue_task+0x5b/0x66
[ 4573.322981]
[<ffffffff8102ec3b>] activate_task+0x28/0x31
[ 4573.322981]
[<ffffffff810370bb>] try_to_wake_up+0x1c0/0x2fa
[ 4573.322981]
[<ffffffff81037221>] wake_up_process+0x10/0x12
[ 4573.322981]
[<ffffffff813d6eb6>] migration_call+0xd7/0x496
[ 4573.322981]
[<ffffffff8163490a>] migration_init+0x44/0x58
[ 4573.322981]
[<ffffffff8100906b>] do_one_initcall+0x65/0x153
[ 4573.322981]
[<ffffffff81622574>] kernel_init+0x64/0x183
[ 4573.322981]
[<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]      }
[ 4573.322981]      ... key      at: [<ffffffff816de220>] __key.19924+0x0/0x8
[ 4573.322981]     ... acquired at:
[ 4573.322981]    [<ffffffff810600c6>] __lock_acquire+0xa88/0xc22
[ 4573.322981]    [<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]    [<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.322981]    [<ffffffff81052e32>] lock_hrtimer_base+0x25/0x4b
[ 4573.322981]    [<ffffffff81052f77>] __hrtimer_start_range_ns+0x33/0x1de
[ 4573.322981]    [<ffffffff81031465>] enqueue_task_rt+0x1e5/0x253
[ 4573.322981]    [<ffffffff8102eb2c>] enqueue_task+0x5b/0x66
[ 4573.322981]    [<ffffffff8102ec3b>] activate_task+0x28/0x31
[ 4573.322981]    [<ffffffff810370bb>] try_to_wake_up+0x1c0/0x2fa
[ 4573.322981]    [<ffffffff81037221>] wake_up_process+0x10/0x12
[ 4573.322981]    [<ffffffff813d6eb6>] migration_call+0xd7/0x496
[ 4573.322981]    [<ffffffff8163490a>] migration_init+0x44/0x58
[ 4573.322981]    [<ffffffff8100906b>] do_one_initcall+0x65/0x153
[ 4573.322981]    [<ffffffff81622574>] kernel_init+0x64/0x183
[ 4573.322981]    [<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]     -> (&rt_rq->rt_runtime_lock){-.-...} ops: 17246 {
[ 4573.322981]        IN-HARDIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]        IN-SOFTIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]        INITIAL USE at:
[ 4573.322981]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.322981]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]
[<ffffffff813dc446>] _spin_lock+0x36/0x43
[ 4573.322981]
[<ffffffff81035690>] update_curr_rt+0x98/0x123
[ 4573.322981]
[<ffffffff8103583f>] dequeue_task_rt+0x1f/0x74
[ 4573.322981]
[<ffffffff8102ec08>] dequeue_task+0xd1/0xdc
[ 4573.322981]
[<ffffffff8102ec6c>] deactivate_task+0x28/0x31
[ 4573.322981]
[<ffffffff813d9b06>] __schedule+0x1b0/0x88c
[ 4573.322981]
[<ffffffff813da2a5>] schedule+0x13/0x3d
[ 4573.322981]
[<ffffffff81037d53>] migration_thread+0x19f/0x245
[ 4573.322981]
[<ffffffff8104fd51>] kthread+0x56/0x83
[ 4573.322981]
[<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]      }
[ 4573.322981]      ... key      at: [<ffffffff81699230>] __key.45675+0x0/0x8
[ 4573.322981]     ... acquired at:
[ 4573.322981]    [<ffffffff810600c6>] __lock_acquire+0xa88/0xc22
[ 4573.322981]    [<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]    [<ffffffff813dc446>] _spin_lock+0x36/0x43
[ 4573.322981]    [<ffffffff8102ffe1>] __enable_runtime+0x38/0x78
[ 4573.322981]    [<ffffffff81030d66>] rq_online_rt+0x4e/0x6e
[ 4573.322981]    [<ffffffff8102f0bf>] set_rq_online+0x48/0x55
[ 4573.322981]    [<ffffffff813d6ef3>] migration_call+0x114/0x496
[ 4573.322981]    [<ffffffff813def6d>] notifier_call_chain+0x5e/0x92
[ 4573.322981]    [<ffffffff8105407c>] raw_notifier_call_chain+0xf/0x11
[ 4573.322981]    [<ffffffff813d73fd>] _cpu_up+0xe0/0x12f
[ 4573.322981]    [<ffffffff813d74af>] cpu_up+0x63/0x78
[ 4573.322981]    [<ffffffff816225c5>] kernel_init+0xb5/0x183
[ 4573.322981]    [<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]    ... acquired at:
[ 4573.322981]    [<ffffffff810600c6>] __lock_acquire+0xa88/0xc22
[ 4573.322981]    [<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]    [<ffffffff813dc446>] _spin_lock+0x36/0x43
[ 4573.322981]    [<ffffffff81031419>] enqueue_task_rt+0x199/0x253
[ 4573.322981]    [<ffffffff8102eb2c>] enqueue_task+0x5b/0x66
[ 4573.322981]    [<ffffffff8102ec3b>] activate_task+0x28/0x31
[ 4573.322981]    [<ffffffff810370bb>] try_to_wake_up+0x1c0/0x2fa
[ 4573.322981]    [<ffffffff81037221>] wake_up_process+0x10/0x12
[ 4573.322981]    [<ffffffff813d6eb6>] migration_call+0xd7/0x496
[ 4573.322981]    [<ffffffff8163490a>] migration_init+0x44/0x58
[ 4573.322981]    [<ffffffff8100906b>] do_one_initcall+0x65/0x153
[ 4573.322981]    [<ffffffff81622574>] kernel_init+0x64/0x183
[ 4573.322981]    [<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]    ... acquired at:
[ 4573.322981]    [<ffffffff810600c6>] __lock_acquire+0xa88/0xc22
[ 4573.322981]    [<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]    [<ffffffff813dc446>] _spin_lock+0x36/0x43
[ 4573.322981]    [<ffffffff81035690>] update_curr_rt+0x98/0x123
[ 4573.322981]    [<ffffffff8103583f>] dequeue_task_rt+0x1f/0x74
[ 4573.322981]    [<ffffffff8102ec08>] dequeue_task+0xd1/0xdc
[ 4573.322981]    [<ffffffff8102ec6c>] deactivate_task+0x28/0x31
[ 4573.322981]    [<ffffffff813d9b06>] __schedule+0x1b0/0x88c
[ 4573.322981]    [<ffffffff813da2a5>] schedule+0x13/0x3d
[ 4573.322981]    [<ffffffff81037d53>] migration_thread+0x19f/0x245
[ 4573.322981]    [<ffffffff8104fd51>] kthread+0x56/0x83
[ 4573.322981]    [<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]    -> (&rq->lock/1){..-...} ops: 10367 {
[ 4573.322981]       IN-SOFTIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]       INITIAL USE at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]     }
[ 4573.322981]     ... key      at: [<ffffffff81699221>] __key.45720+0x1/0x8
[ 4573.322981]     -> (&sig->cputimer.lock){-.-...} ops: 463719 {
[ 4573.322981]        IN-HARDIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]        IN-SOFTIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]        INITIAL USE at:
[ 4573.322981]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.322981]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]
[<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.322981]
[<ffffffff810510a7>] thread_group_cputimer+0x2d/0xb6
[ 4573.322981]
[<ffffffff810523b5>] posix_cpu_timers_exit_group+0x15/0x3b
[ 4573.322981]
[<ffffffff8103d92b>] release_task+0xce/0x3fc
[ 4573.322981]
[<ffffffff8103f1ba>] do_exit+0x6c0/0x74e
[ 4573.322981]
[<ffffffff8104b80a>] usermodehelper_disable+0x0/0xbf
[ 4573.322981]
[<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]      }
[ 4573.322981]      ... key      at: [<ffffffff8169ae38>] __key.15573+0x0/0x8
[ 4573.322981]     ... acquired at:
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]    ... acquired at:
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]    ... acquired at:
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]   ... acquired at:
[ 4573.322981]    [<ffffffff810600c6>] __lock_acquire+0xa88/0xc22
[ 4573.322981]    [<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]    [<ffffffff813dc446>] _spin_lock+0x36/0x43
[ 4573.322981]    [<ffffffff8102fc32>] task_rq_lock+0x3e/0x70
[ 4573.322981]    [<ffffffff81036f76>] try_to_wake_up+0x7b/0x2fa
[ 4573.322981]    [<ffffffff81037202>] default_wake_function+0xd/0xf
[ 4573.322981]    [<ffffffff8102eed2>] __wake_up_common+0x46/0x76
[ 4573.322981]    [<ffffffff8102fa8d>] complete+0x38/0x4b
[ 4573.322981]    [<ffffffff8104fcca>] kthreadd+0xfe/0x12f
[ 4573.322981]    [<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]   -> (&ep->lock){..-...} ops: 105 {
[ 4573.322981]      IN-SOFTIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]      INITIAL USE at:
[ 4573.322981]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.322981]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]
[<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.322981]
[<ffffffff810efb85>] sys_epoll_ctl+0x293/0x486
[ 4573.322981]
[<ffffffff8100bc6b>] system_call_fastpath+0x16/0x1b
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]    }
[ 4573.322981]    ... key      at: [<ffffffff81dd86d0>] __key.22593+0x0/0x10
[ 4573.322981]    ... acquired at:
[ 4573.322981]    [<ffffffff810600c6>] __lock_acquire+0xa88/0xc22
[ 4573.322981]    [<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]    [<ffffffff813dc446>] _spin_lock+0x36/0x43
[ 4573.322981]    [<ffffffff8102fc32>] task_rq_lock+0x3e/0x70
[ 4573.322981]    [<ffffffff81036f76>] try_to_wake_up+0x7b/0x2fa
[ 4573.322981]    [<ffffffff81037202>] default_wake_function+0xd/0xf
[ 4573.322981]    [<ffffffff8102eed2>] __wake_up_common+0x46/0x76
[ 4573.322981]    [<ffffffff8102ef15>] __wake_up_locked+0x13/0x15
[ 4573.322981]    [<ffffffff810ef4e1>] ep_poll_callback+0xa6/0xe9
[ 4573.322981]    [<ffffffff8102eed2>] __wake_up_common+0x46/0x76
[ 4573.322981]    [<ffffffff8102fae3>] __wake_up_sync_key+0x43/0x5b
[ 4573.322981]    [<ffffffff8102fb06>] __wake_up_sync+0xb/0xd
[ 4573.322981]    [<ffffffff810cc918>] pipe_write+0x4d4/0x507
[ 4573.322981]    [<ffffffff810c514d>] do_sync_write+0xe7/0x12d
[ 4573.322981]    [<ffffffff810c5b72>] vfs_write+0xab/0x105
[ 4573.322981]    [<ffffffff810c5c90>] sys_write+0x47/0x70
[ 4573.322981]    [<ffffffff8100bc6b>] system_call_fastpath+0x16/0x1b
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]   ... acquired at:
[ 4573.322981]    [<ffffffff810600c6>] __lock_acquire+0xa88/0xc22
[ 4573.322981]    [<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]    [<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.322981]    [<ffffffff810ef459>] ep_poll_callback+0x1e/0xe9
[ 4573.322981]    [<ffffffff8102eed2>] __wake_up_common+0x46/0x76
[ 4573.322981]    [<ffffffff8102fae3>] __wake_up_sync_key+0x43/0x5b
[ 4573.322981]    [<ffffffff8102fb06>] __wake_up_sync+0xb/0xd
[ 4573.322981]    [<ffffffff810cc918>] pipe_write+0x4d4/0x507
[ 4573.322981]    [<ffffffff810c514d>] do_sync_write+0xe7/0x12d
[ 4573.322981]    [<ffffffff810c5b72>] vfs_write+0xab/0x105
[ 4573.322981]    [<ffffffff810c5c90>] sys_write+0x47/0x70
[ 4573.322981]    [<ffffffff8100bc6b>] system_call_fastpath+0x16/0x1b
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]  ... acquired at:
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]  -> (&cwq->lock){-.-...} ops: 532654 {
[ 4573.322981]     IN-HARDIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]     IN-SOFTIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]     INITIAL USE at:
[ 4573.322981]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.322981]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]
[<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.322981]
[<ffffffff8104cd05>] __queue_work+0x18/0x3e
[ 4573.322981]
[<ffffffff8104cdb3>] queue_work_on+0x45/0x4e
[ 4573.322981]
[<ffffffff8104cf0c>] queue_work+0x29/0x5f
[ 4573.322981]
[<ffffffff8104b9a7>] call_usermodehelper_exec+0x91/0xee
[ 4573.322981]
[<ffffffff811c228a>] kobject_uevent_env+0x3e5/0x423
[ 4573.322981]
[<ffffffff811c22d3>] kobject_uevent+0xb/0xd
[ 4573.322981]
[<ffffffff811c17ac>] kset_register+0x37/0x3f
[ 4573.322981]
[<ffffffff81279ea5>] bus_register+0xa5/0x230
[ 4573.322981]
[<ffffffff81648113>] platform_bus_init+0x2c/0x44
[ 4573.322981]
[<ffffffff816481c9>] driver_init+0x1d/0x29
[ 4573.322981]
[<ffffffff8162262a>] kernel_init+0x11a/0x183
[ 4573.322981]
[<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]   }
[ 4573.322981]   ... key      at: [<ffffffff816ddb58>] __key.23556+0x0/0x8
[ 4573.322981]   ... acquired at:
[ 4573.322981]    [<ffffffff810600c6>] __lock_acquire+0xa88/0xc22
[ 4573.322981]    [<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]    [<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.322981]    [<ffffffff8102fb2a>] __wake_up+0x22/0x50
[ 4573.322981]    [<ffffffff8104c2c6>] insert_work+0xcd/0xd9
[ 4573.322981]    [<ffffffff8104cd17>] __queue_work+0x2a/0x3e
[ 4573.322981]    [<ffffffff8104cdb3>] queue_work_on+0x45/0x4e
[ 4573.322981]    [<ffffffff8104cf0c>] queue_work+0x29/0x5f
[ 4573.322981]    [<ffffffff8104b9a7>] call_usermodehelper_exec+0x91/0xee
[ 4573.322981]    [<ffffffff811c228a>] kobject_uevent_env+0x3e5/0x423
[ 4573.322981]    [<ffffffff811c22d3>] kobject_uevent+0xb/0xd
[ 4573.322981]    [<ffffffff811c17ac>] kset_register+0x37/0x3f
[ 4573.322981]    [<ffffffff81279ea5>] bus_register+0xa5/0x230
[ 4573.322981]    [<ffffffff81648113>] platform_bus_init+0x2c/0x44
[ 4573.322981]    [<ffffffff816481c9>] driver_init+0x1d/0x29
[ 4573.322981]    [<ffffffff8162262a>] kernel_init+0x11a/0x183
[ 4573.322981]    [<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]  ... acquired at:
[ 4573.322981]    [<ffffffff810600c6>] __lock_acquire+0xa88/0xc22
[ 4573.322981]    [<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]    [<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.322981]    [<ffffffff8104cd05>] __queue_work+0x18/0x3e
[ 4573.322981]    [<ffffffff8104cdb3>] queue_work_on+0x45/0x4e
[ 4573.322981]    [<ffffffff8104cf0c>] queue_work+0x29/0x5f
[ 4573.322981]    [<ffffffffa016b484>] iwl_scan_initiate+0x86/0xb5 [iwlcore]
[ 4573.322981]    [<ffffffffa016b5c0>] iwl_mac_hw_scan+0x10d/0x159 [iwlcore]
[ 4573.322981]    [<ffffffffa00eacf0>] ieee80211_start_scan+0x90/0x2b4
[mac80211]
[ 4573.322981]    [<ffffffffa00f12e4>] ieee80211_sta_work+0x728/0x8ed [mac80211]
[ 4573.322981]    [<ffffffff8104bffd>] worker_thread+0x24b/0x367
[ 4573.322981]    [<ffffffff8104fd51>] kthread+0x56/0x83
[ 4573.322981]    [<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]  -> (&priv->hcmd_lock){..-...} ops: 1345 {
[ 4573.322981]     IN-SOFTIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]     INITIAL USE at:
[ 4573.322981]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.322981]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]
[<ffffffff813dc525>] _spin_lock_irqsave+0x41/0x54
[ 4573.322981]
[<ffffffffa016741e>] iwl_enqueue_hcmd+0xf0/0x254 [iwlcore]
[ 4573.322981]
[<ffffffffa016493e>] iwl_send_cmd_sync+0xad/0x2cc [iwlcore]
[ 4573.322981]
[<ffffffffa0164b96>] iwl_send_cmd_pdu+0x39/0x3b [iwlcore]
[ 4573.322981]
[<ffffffffa01628f5>] iwl_send_bt_config+0x3c/0x3e [iwlcore]
[ 4573.322981]
[<ffffffffa017f87d>] iwl3945_bg_alive_start+0x17c/0x2de [iwl3945]
[ 4573.322981]
[<ffffffff8104bffd>] worker_thread+0x24b/0x367
[ 4573.322981]
[<ffffffff8104fd51>] kthread+0x56/0x83
[ 4573.322981]
[<ffffffff8100cd7a>] child_rip+0xa/0x20
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]   }
[ 4573.322981]   ... key      at: [<ffffffffa018bf28>]
__key.41489+0x0/0xffffffffffff8660 [iwl3945]
[ 4573.322981]  ... acquired at:
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]  -> (&list->lock#5){..-...} ops: 326314 {
[ 4573.322981]     IN-SOFTIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]     INITIAL USE at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]   }
[ 4573.322981]   ... key      at: [<ffffffffa0108868>]
__key.18500+0x0/0xffffffffffff5060 [mac80211]
[ 4573.322981]  ... acquired at:
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]  -> (&(&priv->scan_check)->timer){+.-...} ops: 87 {
[ 4573.322981]     HARDIRQ-ON-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]     IN-SOFTIRQ-W at:
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]     INITIAL USE at:
[ 4573.322981]
[<ffffffff8105f975>] __lock_acquire+0x337/0xc22
[ 4573.322981]
[<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]
[<ffffffff8104561b>] del_timer_sync+0x3c/0x83
[ 4573.322981]
[<ffffffffa017dedb>] iwl3945_mac_add_interface+0x137/0x1a7 [iwl3945]
[ 4573.322981]
[<ffffffffa00f2462>] ieee80211_open+0x4ce/0x6dd [mac80211]
[ 4573.322981]
[<ffffffff81313f4e>] dev_open+0x7c/0xbd
[ 4573.322981]
[<ffffffff8131399f>] dev_change_flags+0xba/0x180
[ 4573.322981]
[<ffffffff8131bede>] do_setlink+0x307/0x3cf
[ 4573.322981]
[<ffffffff8131c0d1>] rtnl_setlink+0x12b/0x142
[ 4573.322981]
[<ffffffff8131d085>] rtnetlink_rcv_msg+0x1d8/0x1f9
[ 4573.322981]
[<ffffffff81327251>] netlink_rcv_skb+0x3e/0x8d
[ 4573.322981]
[<ffffffff8131cea3>] rtnetlink_rcv+0x29/0x33
[ 4573.322981]
[<ffffffff81326db3>] netlink_unicast+0x117/0x180
[ 4573.322981]
[<ffffffff81327093>] netlink_sendmsg+0x277/0x28a
[ 4573.322981]
[<ffffffff813032b2>] __sock_sendmsg+0x59/0x62
[ 4573.322981]
[<ffffffff81303bda>] sock_sendmsg+0xc7/0xe0
[ 4573.322981]
[<ffffffff81303e07>] sys_sendmsg+0x214/0x29b
[ 4573.322981]
[<ffffffff8100bc6b>] system_call_fastpath+0x16/0x1b
[ 4573.322981]
[<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]   }
[ 4573.322981]   ... key      at: [<ffffffffa018bf48>]
__key.41436+0x0/0xffffffffffff8640 [iwl3945]
[ 4573.322981]  ... acquired at:
[ 4573.322981]    [<ffffffffffffffff>] 0xffffffffffffffff
[ 4573.322981]
[ 4573.322981]
[ 4573.322981] stack backtrace:
[ 4573.322981] Pid: 0, comm: swapper Not tainted 2.6.30-rc4 #3
[ 4573.322981] Call Trace:
[ 4573.322981]  <IRQ>  [<ffffffff8105efa7>] print_irq_inversion_bug+0x123/0x131
[ 4573.322981]  [<ffffffff8105f00a>] ? check_usage_backwards+0x0/0x53
[ 4573.322981]  [<ffffffff8105f054>] check_usage_backwards+0x4a/0x53
[ 4573.322981]  [<ffffffff8105e85b>] mark_lock+0x130/0x22c
[ 4573.322981]  [<ffffffff8105f8f8>] __lock_acquire+0x2ba/0xc22
[ 4573.322981]  [<ffffffff81060356>] lock_acquire+0xf6/0x11a
[ 4573.322981]  [<ffffffff81044e1b>] ? run_timer_softirq+0x13c/0x26e
[ 4573.322981]  [<ffffffff8104cd2b>] ? delayed_work_timer_fn+0x0/0x43
[ 4573.322981]  [<ffffffff81044eb6>] run_timer_softirq+0x1d7/0x26e
[ 4573.322981]  [<ffffffff81044e1b>] ? run_timer_softirq+0x13c/0x26e
[ 4573.322981]  [<ffffffff81040b9e>] ? __do_softirq+0x54/0x1fa
[ 4573.322981]  [<ffffffff81040c30>] __do_softirq+0xe6/0x1fa
[ 4573.322981]  [<ffffffff8100ce7c>] call_softirq+0x1c/0x34
[ 4573.322981]  [<ffffffff8100e109>] do_softirq+0x39/0x8e
[ 4573.322981]  [<ffffffff81040842>] irq_exit+0x45/0x99
[ 4573.322981]  [<ffffffff8100d9e8>] do_IRQ+0xaf/0xc6
[ 4573.322981]  [<ffffffff8100c693>] ret_from_intr+0x0/0xf
[ 4573.322981]  <EOI>  [<ffffffff811f330f>] acpi_os_acquire_lock+0x9/0xb
[ 4573.322981]  [<ffffffff8121a461>] ? acpi_idle_enter_bm+0x250/0x27e
[ 4573.322981]  [<ffffffff8121a457>] ? acpi_idle_enter_bm+0x246/0x27e
[ 4573.322981]  [<ffffffff812eef89>] cpuidle_idle_call+0x92/0xcd
[ 4573.322981]  [<ffffffff8100afc8>] cpu_idle+0x9c/0x100
[ 4573.322981]  [<ffffffff813ca431>] rest_init+0x75/0x77
[ 4573.322981]  [<ffffffff81622cb2>] start_kernel+0x3db/0x3e6
[ 4573.322981]  [<ffffffff8162229a>] x86_64_start_reservations+0xaa/0xae
[ 4573.322981]  [<ffffffff8162237f>] x86_64_start_kernel+0xe1/0xe8
