Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbZD0H70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbZD0H70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 03:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbZD0H7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 03:59:14 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:52758 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbZD0H7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 03:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cS/BUIHlcBtsJ5sshbUSh4S4E2uZACYo9b9EYkwMO0CH4gmSGber4bEL3RaFz+AllE
         g37SPJRACWFJLZmpriAVG2qE/OBv0TnZ8N3OkvN4Dgf/PnVxZlERE436msdSdTrr5uL7
         6OfUdN7AD1Iwqlj1hYgB6rwKVo3fjCkenxQbc=
MIME-Version: 1.0
In-Reply-To: <c4e36d110904241218x209a4b76kf271f7288f1a33da@mail.gmail.com>
References: <c4e36d110904220333u37304c79k6ab528f92b5f3718@mail.gmail.com>
	 <20090422140107.GD3288@tuxdriver.com>
	 <c4e36d110904241218x209a4b76kf271f7288f1a33da@mail.gmail.com>
Date: Mon, 27 Apr 2009 09:59:04 +0200
Message-ID: <c4e36d110904270059m3e43d6ccl18cc2ec6954e5649@mail.gmail.com>
Subject: Re: regression IWl3945 - doesn't work with recent 2.6.30-rcX
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/24 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2009/4/22 John W. Linville <linville@tuxdriver.com>:
>> On Wed, Apr 22, 2009 at 12:33:03PM +0200, Zdenek Kabelac wrote:
>>> Hi
>>>
>>> I'm checking whether -rcX kernel could be usable on my
>>> T61/4GB/C2D/x86_64 - but wireless seems to be still out of
>>> functionality:
>>> I'm getting lots of weird trace-back messages and it looks like
>>> iwl3945 is not working at all.
>>> (attached messages from fresh build of -rc3 - but it never worked even in -rc1)
>>
>> Looks like this one did _not_ make -rc3:
>>
>> commit df833b1d73680f9f9dc72cbc3215edbbc6ab740d
>> Author: Reinette Chatre <reinette.chatre@intel.com>
>> Date:   Tue Apr 21 10:55:48 2009 -0700
>>
>>    iwlwifi: DMA fixes
>>
>>    A few issues wrt DMA were uncovered when using the driver with swiotlb.
>> ...
>>
>> It is in wireless-2.6 and should be in net-2.6 -- please try one of those kernels.
>
>
> I can confirm that current upstream linux commit
> 9f5a691253924fd033a58c6b1fed57bb0a4eccf4 works again with iwlwifi.
> and it already contains the patch you suggested to check.
>


While Wifi seems to be working well - I've noticed once attached long
INFO message during suspend.

Zdenek

-----------

Linux version 2.6.30-rc3-00324-g8087eae (gcc version 4.4.0 20090414
(Red Hat 4.4.0-0.34) (GCC) ) #55 SMP Fri Apr 24 20:22:26 CEST 2009
Command line: ro root=/dev/sda5 selinux=0 no_console_suspend
...
ADDRCONF(NETDEV_UP): wlan0: link is not ready
virbr0: no IPv6 routers present
wlan0: authenticate with AP 00:11:d8:da:65:40
wlan0: authenticated
wlan0: associate with AP 00:11:d8:da:65:40
wlan0: RX AssocResp from 00:11:d8:da:65:40 (capab=0x401 status=0 aid=4)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: disassociating by local choice (reason=3)
audit(1240599276.009:18266): audit_enabled=0 old=1 auid=4294967295
ses=4294967295 res=1
wlan0: no IPv6 routers present
fuse init (API version 7.11)
wlan0: authenticate with AP 00:11:d8:da:65:40
wlan0: authenticated
wlan0: associate with AP 00:11:d8:da:65:40
wlan0: RX AssocResp from 00:11:d8:da:65:40 (capab=0x401 status=0 aid=4)
wlan0: associated
wlan0: no probe response from AP 00:11:d8:da:65:40 - disassociating
wlan0: deauthenticated (Reason: 7)
wlan0: authenticate with AP 00:11:d8:da:65:40
wlan0: authenticate with AP 00:11:d8:da:65:40
wlan0: authenticate with AP 00:11:d8:da:65:40
wlan0: authenticated
wlan0: associate with AP 00:11:d8:da:65:40
wlan0: RX ReassocResp from 00:11:d8:da:65:40 (capab=0x401 status=0 aid=4)
wlan0: associated

..........

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.30-rc3-00324-g8087eae #55
---------------------------------------------------------
swapper/0 just changed the state of lock:
 (&(&priv->scan_check)->timer){+.-...}, at: [<ffffffff80250d90>]
run_timer_softirq+0x120/0x2e0
but this lock was taken by another, HARDIRQ-safe lock in the past:
 (&priv->lock){-.-...}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
1 lock held by swapper/0:
 #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff8055cf50>]
__atomic_notifier_call_chain+0x0/0xa0

the first lock's dependencies:
-> (&(&priv->scan_check)->timer){+.-...} ops: 0 {
   HARDIRQ-ON-W at:
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   IN-SOFTIRQ-W at:
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   INITIAL USE at:
                                      [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                      [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                      [<ffffffff80251771>]
del_timer_sync+0x41/0xa0
                                      [<ffffffffa026f78d>]
iwl3945_mac_add_interface+0x14d/0x420 [iwl3945]
                                      [<ffffffffa0125598>]
ieee80211_open+0x408/0x920 [mac80211]
                                      [<ffffffff804d02fa>] dev_open+0x9a/0x100
                                      [<ffffffff804cfdb6>]
dev_change_flags+0x96/0x1c0
                                      [<ffffffff804dbfe2>]
do_setlink+0x212/0x4a0
                                      [<ffffffff804dc882>]
rtnl_setlink+0x122/0x160
                                      [<ffffffff804dbb1f>]
rtnetlink_rcv_msg+0x1df/0x220
                                      [<ffffffff804e7409>]
netlink_rcv_skb+0xa9/0xd0
                                      [<ffffffff804db925>]
rtnetlink_rcv+0x25/0x40
                                      [<ffffffff804e708a>]
netlink_unicast+0x29a/0x2f0
                                      [<ffffffff804e7e82>]
netlink_sendmsg+0x222/0x320
                                      [<ffffffff804befdb>]
sock_sendmsg+0x10b/0x140
                                      [<ffffffff804bfa90>]
sys_sendmsg+0x1d0/0x330
                                      [<ffffffff8020c15b>]
system_call_fastpath+0x16/0x1b
                                      [<ffffffffffffffff>] 0xffffffffffffffff
 }
 ... key      at: [<ffffffffa0290a64>]
__key.46148+0x0/0xffffffffffff27ff [iwl3945]

the second lock's dependencies:
-> (&priv->lock){-.-...} ops: 0 {
   IN-HARDIRQ-W at:
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   IN-SOFTIRQ-W at:
                                       [<ffffffffffffffff>] 0xffffffffffffffff
   INITIAL USE at:
                                      [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                      [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                      [<ffffffff8055a038>]
_spin_lock_irqsave+0x48/0x90
                                      [<ffffffffa0226204>]
iwl_reset_qos+0x24/0x2c0 [iwlcore]
                                      [<ffffffffa026c5d8>]
iwl3945_pci_probe+0x348/0x1080 [iwl3945]
                                      [<ffffffff803c9067>]
local_pci_probe+0x17/0x20
                                      [<ffffffff803ca248>]
pci_device_probe+0x88/0xb0
                                      [<ffffffff80453e39>]
driver_probe_device+0x89/0x180
                                      [<ffffffff80453fcb>]
__driver_attach+0x9b/0xb0
                                      [<ffffffff804532c3>]
bus_for_each_dev+0x73/0xa0
                                      [<ffffffff80453c8e>]
driver_attach+0x1e/0x20
                                      [<ffffffff80453595>]
bus_add_driver+0xd5/0x290
                                      [<ffffffff804542d6>]
driver_register+0x86/0x140
                                      [<ffffffff803ca4f6>]
__pci_register_driver+0x66/0xe0
                                      [<ffffffffa00b305c>] 0xffffffffa00b305c
                                      [<ffffffff8020904f>]
do_one_initcall+0x3f/0x1c0
                                      [<ffffffff8027e071>]
sys_init_module+0xb1/0x200
                                      [<ffffffff8020c15b>]
system_call_fastpath+0x16/0x1b
                                      [<ffffffffffffffff>] 0xffffffffffffffff
 }
 ... key      at: [<ffffffffa0290a5c>]
__key.46201+0x0/0xffffffffffff2807 [iwl3945]
 -> (pci_lock){-.....} ops: 0 {
    IN-HARDIRQ-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                                        [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                        [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                        [<ffffffff8055a038>]
_spin_lock_irqsave+0x48/0x90
                                        [<ffffffff803c2442>]
pci_bus_read_config_dword+0x42/0x90
                                        [<ffffffff8054765c>]
pci_scan_single_device+0x6c/0x170
                                        [<ffffffff803c43be>]
pci_scan_slot+0x1e/0xc0
                                        [<ffffffff80549939>]
pci_scan_child_bus+0x29/0x9d
                                        [<ffffffff805499d0>]
pci_scan_bus_parented+0x23/0x31
                                        [<ffffffff8054e37e>]
pci_acpi_scan_root+0x10c/0x2c6
                                        [<ffffffff8054b94b>]
acpi_pci_root_add+0x2c2/0x3f7
                                        [<ffffffff803eab35>]
acpi_device_probe+0x50/0x1c4
                                        [<ffffffff80453e39>]
driver_probe_device+0x89/0x180
                                        [<ffffffff80453fcb>]
__driver_attach+0x9b/0xb0
                                        [<ffffffff804532c3>]
bus_for_each_dev+0x73/0xa0
                                        [<ffffffff80453c8e>]
driver_attach+0x1e/0x20
                                        [<ffffffff80453595>]
bus_add_driver+0xd5/0x290
                                        [<ffffffff804542d6>]
driver_register+0x86/0x140
                                        [<ffffffff803ec46f>]
acpi_bus_register_driver+0x43/0x48
                                        [<ffffffff80787150>]
acpi_pci_root_init+0x19/0x28
                                        [<ffffffff8020904f>]
do_one_initcall+0x3f/0x1c0
                                        [<ffffffff807686c0>]
kernel_init+0x13a/0x190
                                        [<ffffffff8020d23a>] child_rip+0xa/0x20
                                        [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff807146d8>] pci_lock+0x18/0x40
  -> (pci_config_lock){-.....} ops: 0 {
     IN-HARDIRQ-W at:
                                           [<ffffffffffffffff>]
0xffffffffffffffff
     INITIAL USE at:
                                          [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                          [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                          [<ffffffff8055a038>]
_spin_lock_irqsave+0x48/0x90
                                          [<ffffffff804bac30>]
pci_conf1_read+0x80/0x120
                                          [<ffffffff8078de2f>]
__pci_mmcfg_init+0x92/0x308
                                          [<ffffffff8078e0c0>]
pci_mmcfg_early_init+0xe/0x10
                                          [<ffffffff8078d663>]
pci_arch_init+0x1e/0x58
                                          [<ffffffff8020904f>]
do_one_initcall+0x3f/0x1c0
                                          [<ffffffff807686c0>]
kernel_init+0x13a/0x190
                                          [<ffffffff8020d23a>]
child_rip+0xa/0x20
                                          [<ffffffffffffffff>]
0xffffffffffffffff
   }
   ... key      at: [<ffffffff8072c938>] pci_config_lock+0x18/0x60
  ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff8055a038>] _spin_lock_irqsave+0x48/0x90
   [<ffffffff804bac30>] pci_conf1_read+0x80/0x120
   [<ffffffff804bc492>] raw_pci_read+0x52/0x60
   [<ffffffff804bc52c>] pci_read+0x2c/0x30
   [<ffffffff803c2460>] pci_bus_read_config_dword+0x60/0x90
   [<ffffffff8054765c>] pci_scan_single_device+0x6c/0x170
   [<ffffffff803c43be>] pci_scan_slot+0x1e/0xc0
   [<ffffffff80549939>] pci_scan_child_bus+0x29/0x9d
   [<ffffffff805499d0>] pci_scan_bus_parented+0x23/0x31
   [<ffffffff8054e37e>] pci_acpi_scan_root+0x10c/0x2c6
   [<ffffffff8054b94b>] acpi_pci_root_add+0x2c2/0x3f7
   [<ffffffff803eab35>] acpi_device_probe+0x50/0x1c4
   [<ffffffff80453e39>] driver_probe_device+0x89/0x180
   [<ffffffff80453fcb>] __driver_attach+0x9b/0xb0
   [<ffffffff804532c3>] bus_for_each_dev+0x73/0xa0
   [<ffffffff80453c8e>] driver_attach+0x1e/0x20
   [<ffffffff80453595>] bus_add_driver+0xd5/0x290
   [<ffffffff804542d6>] driver_register+0x86/0x140
   [<ffffffff803ec46f>] acpi_bus_register_driver+0x43/0x48
   [<ffffffff80787150>] acpi_pci_root_init+0x19/0x28
   [<ffffffff8020904f>] do_one_initcall+0x3f/0x1c0
   [<ffffffff807686c0>] kernel_init+0x13a/0x190
   [<ffffffff8020d23a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff8055a038>] _spin_lock_irqsave+0x48/0x90
   [<ffffffff803c24d2>] pci_bus_read_config_word+0x42/0x90
   [<ffffffff803c4e7e>] __pci_bus_find_cap_start+0x1e/0x50
   [<ffffffff803c4fba>] pci_find_capability+0x2a/0x60
   [<ffffffffa022cf54>] iwl_power_initialize+0xb4/0x210 [iwlcore]
   [<ffffffffa027d5da>] iwl3945_apm_init+0x1a/0x670 [iwl3945]
   [<ffffffffa027f5af>] iwl3945_hw_nic_init+0x3f/0xd60 [iwl3945]
   [<ffffffffa02763d5>] __iwl3945_up+0xb5/0x750 [iwl3945]
   [<ffffffffa0276f08>] iwl3945_mac_start+0x438/0x1440 [iwl3945]
   [<ffffffffa0125419>] ieee80211_open+0x289/0x920 [mac80211]
   [<ffffffff804d02fa>] dev_open+0x9a/0x100
   [<ffffffff804cfdb6>] dev_change_flags+0x96/0x1c0
   [<ffffffff804dbfe2>] do_setlink+0x212/0x4a0
   [<ffffffff804dc882>] rtnl_setlink+0x122/0x160
   [<ffffffff804dbb1f>] rtnetlink_rcv_msg+0x1df/0x220
   [<ffffffff804e7409>] netlink_rcv_skb+0xa9/0xd0
   [<ffffffff804db925>] rtnetlink_rcv+0x25/0x40
   [<ffffffff804e708a>] netlink_unicast+0x29a/0x2f0
   [<ffffffff804e7e82>] netlink_sendmsg+0x222/0x320
   [<ffffffff804befdb>] sock_sendmsg+0x10b/0x140
   [<ffffffff804bfa90>] sys_sendmsg+0x1d0/0x330
   [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&rxq->lock){..-...} ops: 0 {
    IN-SOFTIRQ-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                                        [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                        [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                        [<ffffffff8055a038>]
_spin_lock_irqsave+0x48/0x90
                                        [<ffffffffa026fbec>]
iwl3945_rx_allocate+0x2c/0x1e0 [iwl3945]
                                        [<ffffffffa026fdc1>]
iwl3945_rx_replenish+0x21/0x60 [iwl3945]
                                        [<ffffffffa027f659>]
iwl3945_hw_nic_init+0xe9/0xd60 [iwl3945]
                                        [<ffffffffa02763d5>]
__iwl3945_up+0xb5/0x750 [iwl3945]
                                        [<ffffffffa0276f08>]
iwl3945_mac_start+0x438/0x1440 [iwl3945]
                                        [<ffffffffa0125419>]
ieee80211_open+0x289/0x920 [mac80211]
                                        [<ffffffff804d02fa>] dev_open+0x9a/0x100
                                        [<ffffffff804cfdb6>]
dev_change_flags+0x96/0x1c0
                                        [<ffffffff804dbfe2>]
do_setlink+0x212/0x4a0
                                        [<ffffffff804dc882>]
rtnl_setlink+0x122/0x160
                                        [<ffffffff804dbb1f>]
rtnetlink_rcv_msg+0x1df/0x220
                                        [<ffffffff804e7409>]
netlink_rcv_skb+0xa9/0xd0
                                        [<ffffffff804db925>]
rtnetlink_rcv+0x25/0x40
                                        [<ffffffff804e708a>]
netlink_unicast+0x29a/0x2f0
                                        [<ffffffff804e7e82>]
netlink_sendmsg+0x222/0x320
                                        [<ffffffff804befdb>]
sock_sendmsg+0x10b/0x140
                                        [<ffffffff804bfa90>]
sys_sendmsg+0x1d0/0x330
                                        [<ffffffff8020c15b>]
system_call_fastpath+0x16/0x1b
                                        [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffffa0253254>]
__key.39781+0x0/0xfffffffffffea608 [iwlcore]
  -> (io_tlb_lock){-.-...} ops: 0 {
     IN-HARDIRQ-W at:
                                           [<ffffffffffffffff>]
0xffffffffffffffff
     IN-SOFTIRQ-W at:
                                           [<ffffffffffffffff>]
0xffffffffffffffff
     INITIAL USE at:
                                          [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                          [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                          [<ffffffff8055a038>]
_spin_lock_irqsave+0x48/0x90
                                          [<ffffffff803c0814>]
map_single+0xa4/0x260
                                          [<ffffffff803c0b5d>]
swiotlb_map_sg_attrs+0x7d/0x1a0
                                          [<ffffffff80478a0f>]
ata_qc_issue+0x10f/0x300
                                          [<ffffffff8047e756>]
ata_scsi_translate+0xa6/0x180
                                          [<ffffffff8048138f>]
ata_scsi_queuecmd+0xbf/0x2d0
                                          [<ffffffff8045bdc7>]
scsi_dispatch_cmd+0x197/0x2c0
                                          [<ffffffff80462fb4>]
scsi_request_fn+0x3c4/0x520
                                          [<ffffffff8039dcd5>]
__generic_unplug_device+0x35/0x40
                                          [<ffffffff803a2a30>]
blk_execute_rq_nowait+0x70/0xc0
                                          [<ffffffff803a2afa>]
blk_execute_rq+0x7a/0xe0
                                          [<ffffffff8046457c>]
scsi_execute+0xfc/0x160
                                          [<ffffffff804647ba>]
scsi_execute_req+0xaa/0x180
                                          [<ffffffff80465b6a>]
scsi_probe_and_add_lun+0x24a/0xe90
                                          [<ffffffff80467b4a>]
__scsi_add_device+0x10a/0x110
                                          [<ffffffff8047fccb>]
ata_scsi_scan_host+0x13b/0x1d0
                                          [<ffffffff8047c7dc>]
async_port_probe+0xac/0xe0
                                          [<ffffffff80265888>]
async_thread+0x108/0x260
                                          [<ffffffff8025e61a>] kthread+0x5a/0xa0
                                          [<ffffffff8020d23a>]
child_rip+0xa/0x20
                                          [<ffffffffffffffff>]
0xffffffffffffffff
   }
   ... key      at: [<ffffffff80714698>] io_tlb_lock+0x18/0x40
  ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff8055a038>] _spin_lock_irqsave+0x48/0x90
   [<ffffffff803c0814>] map_single+0xa4/0x260
   [<ffffffff803c0d62>] swiotlb_map_page+0xd2/0x1a0
   [<ffffffffa026fc73>] iwl3945_rx_allocate+0xb3/0x1e0 [iwl3945]
   [<ffffffffa026fdc1>] iwl3945_rx_replenish+0x21/0x60 [iwl3945]
   [<ffffffffa027f659>] iwl3945_hw_nic_init+0xe9/0xd60 [iwl3945]
   [<ffffffffa02763d5>] __iwl3945_up+0xb5/0x750 [iwl3945]
   [<ffffffffa0276f08>] iwl3945_mac_start+0x438/0x1440 [iwl3945]
   [<ffffffffa0125419>] ieee80211_open+0x289/0x920 [mac80211]
   [<ffffffff804d02fa>] dev_open+0x9a/0x100
   [<ffffffff804cfdb6>] dev_change_flags+0x96/0x1c0
   [<ffffffff804dbfe2>] do_setlink+0x212/0x4a0
   [<ffffffff804dc882>] rtnl_setlink+0x122/0x160
   [<ffffffff804dbb1f>] rtnetlink_rcv_msg+0x1df/0x220
   [<ffffffff804e7409>] netlink_rcv_skb+0xa9/0xd0
   [<ffffffff804db925>] rtnetlink_rcv+0x25/0x40
   [<ffffffff804e708a>] netlink_unicast+0x29a/0x2f0
   [<ffffffff804e7e82>] netlink_sendmsg+0x222/0x320
   [<ffffffff804befdb>] sock_sendmsg+0x10b/0x140
   [<ffffffff804bfa90>] sys_sendmsg+0x1d0/0x330
   [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

  -> (&zone->lock){..-...} ops: 0 {
     IN-SOFTIRQ-W at:
                                           [<ffffffffffffffff>]
0xffffffffffffffff
     INITIAL USE at:
                                          [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                          [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                          [<ffffffff80559ec6>]
_spin_lock+0x36/0x70
                                          [<ffffffff802ba6d2>]
free_pages_bulk.clone.1+0x32/0x270
                                          [<ffffffff802bab29>]
free_hot_cold_page+0x219/0x2a0
                                          [<ffffffff802bac30>]
free_hot_page+0x10/0x20
                                          [<ffffffff802bac75>]
__free_pages+0x35/0x40
                                          [<ffffffff80795063>]
__free_pages_bootmem+0x24/0x69
                                          [<ffffffff8077e740>]
free_all_bootmem_core+0xf7/0x1c5
                                          [<ffffffff8077e81e>]
free_all_bootmem+0x10/0x12
                                          [<ffffffff80778d95>]
mem_init+0x1e/0x161
                                          [<ffffffff80768c19>]
start_kernel+0x2cd/0x37b
                                          [<ffffffff80768315>]
x86_64_start_reservations+0x125/0x129
                                          [<ffffffff807683fd>]
x86_64_start_kernel+0xe4/0xeb
                                          [<ffffffffffffffff>]
0xffffffffffffffff
   }
   ... key      at: [<ffffffff81164260>] __key.31011+0x0/0x8
  ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff8055a038>] _spin_lock_irqsave+0x48/0x90
   [<ffffffff802b9371>] get_page_from_freelist+0x561/0x5e0
   [<ffffffff802b94dd>] __alloc_pages_internal+0xed/0x4f0
   [<ffffffff802df548>] __slab_alloc+0x138/0x4a0
   [<ffffffff802dff2d>] __kmalloc_track_caller+0x15d/0x1c0
   [<ffffffff804c6884>] __alloc_skb+0x74/0x170
   [<ffffffffa026fcd8>] iwl3945_rx_allocate+0x118/0x1e0 [iwl3945]
   [<ffffffffa026fdc1>] iwl3945_rx_replenish+0x21/0x60 [iwl3945]
   [<ffffffffa027f659>] iwl3945_hw_nic_init+0xe9/0xd60 [iwl3945]
   [<ffffffffa02763d5>] __iwl3945_up+0xb5/0x750 [iwl3945]
   [<ffffffffa0276f08>] iwl3945_mac_start+0x438/0x1440 [iwl3945]
   [<ffffffffa0125419>] ieee80211_open+0x289/0x920 [mac80211]
   [<ffffffff804d02fa>] dev_open+0x9a/0x100
   [<ffffffff804cfdb6>] dev_change_flags+0x96/0x1c0
   [<ffffffff804dbfe2>] do_setlink+0x212/0x4a0
   [<ffffffff804dc882>] rtnl_setlink+0x122/0x160
   [<ffffffff804dbb1f>] rtnetlink_rcv_msg+0x1df/0x220
   [<ffffffff804e7409>] netlink_rcv_skb+0xa9/0xd0
   [<ffffffff804db925>] rtnetlink_rcv+0x25/0x40
   [<ffffffff804e708a>] netlink_unicast+0x29a/0x2f0
   [<ffffffff804e7e82>] netlink_sendmsg+0x222/0x320
   [<ffffffff804befdb>] sock_sendmsg+0x10b/0x140
   [<ffffffff804bfa90>] sys_sendmsg+0x1d0/0x330
   [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

  -> (&n->list_lock){-.-...} ops: 0 {
     IN-HARDIRQ-W at:
                                           [<ffffffffffffffff>]
0xffffffffffffffff
     IN-SOFTIRQ-W at:
                                           [<ffffffffffffffff>]
0xffffffffffffffff
     INITIAL USE at:
                                          [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                          [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                          [<ffffffff80559ec6>]
_spin_lock+0x36/0x70
                                          [<ffffffff802de987>]
add_partial+0x27/0x90
                                          [<ffffffff802dec0c>]
__slab_free+0x8c/0xf0
                                          [<ffffffff802df377>]
kmem_cache_free+0xf7/0x130
                                          [<ffffffff803e7732>]
acpi_os_release_object+0xe/0x12
                                          [<ffffffff8040c2cb>]
acpi_ps_free_op+0x69/0x70
                                          [<ffffffff8040bf3b>]
acpi_ps_delete_parse_tree+0x43/0x60
                                          [<ffffffff8040b263>]
acpi_ps_complete_this_op+0x183/0x194
                                          [<ffffffff8040b2a2>]
acpi_ps_complete_op+0x2e/0x2b7
                                          [<ffffffff8040bca1>]
acpi_ps_parse_loop+0x776/0x901
                                          [<ffffffff8040ad14>]
acpi_ps_parse_aml+0x10f/0x3e6
                                          [<ffffffff80409ae6>]
acpi_ns_one_complete_parse+0x13a/0x157
                                          [<ffffffff80409b51>]
acpi_ns_parse_table+0x4e/0x91
                                          [<ffffffff804061a1>]
acpi_ns_load_table+0x7d/0x118
                                          [<ffffffff8040e17b>]
acpi_load_tables+0x72/0x15f
                                          [<ffffffff80786c2c>]
acpi_early_init+0x60/0xf5
                                          [<ffffffff80768cb1>]
start_kernel+0x365/0x37b
                                          [<ffffffff80768315>]
x86_64_start_reservations+0x125/0x129
                                          [<ffffffff807683fd>]
x86_64_start_kernel+0xe4/0xeb
                                          [<ffffffffffffffff>]
0xffffffffffffffff
   }
   ... key      at: [<ffffffff811664e0>] __key.25156+0x0/0x8
  ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff80559ec6>] _spin_lock+0x36/0x70
   [<ffffffff802df6f4>] __slab_alloc+0x2e4/0x4a0
   [<ffffffff802dfa17>] kmem_cache_alloc+0x167/0x170
   [<ffffffff804c685a>] __alloc_skb+0x4a/0x170
   [<ffffffffa026fcd8>] iwl3945_rx_allocate+0x118/0x1e0 [iwl3945]
   [<ffffffffa026fdc1>] iwl3945_rx_replenish+0x21/0x60 [iwl3945]
   [<ffffffffa027f659>] iwl3945_hw_nic_init+0xe9/0xd60 [iwl3945]
   [<ffffffffa02763d5>] __iwl3945_up+0xb5/0x750 [iwl3945]
   [<ffffffffa0276f08>] iwl3945_mac_start+0x438/0x1440 [iwl3945]
   [<ffffffffa0125419>] ieee80211_open+0x289/0x920 [mac80211]
   [<ffffffff804d02fa>] dev_open+0x9a/0x100
   [<ffffffff804cfdb6>] dev_change_flags+0x96/0x1c0
   [<ffffffff804dbfe2>] do_setlink+0x212/0x4a0
   [<ffffffff804dc882>] rtnl_setlink+0x122/0x160
   [<ffffffff804dbb1f>] rtnetlink_rcv_msg+0x1df/0x220
   [<ffffffff804e7409>] netlink_rcv_skb+0xa9/0xd0
   [<ffffffff804db925>] rtnetlink_rcv+0x25/0x40
   [<ffffffff804e708a>] netlink_unicast+0x29a/0x2f0
   [<ffffffff804e7e82>] netlink_sendmsg+0x222/0x320
   [<ffffffff804befdb>] sock_sendmsg+0x10b/0x140
   [<ffffffff804bfa90>] sys_sendmsg+0x1d0/0x330
   [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff8055a038>] _spin_lock_irqsave+0x48/0x90
   [<ffffffffa026bd8f>] iwl3945_rx_queue_restock+0x2f/0x170 [iwl3945]
   [<ffffffffa026fddc>] iwl3945_rx_replenish+0x3c/0x60 [iwl3945]
   [<ffffffffa027f659>] iwl3945_hw_nic_init+0xe9/0xd60 [iwl3945]
   [<ffffffffa02763d5>] __iwl3945_up+0xb5/0x750 [iwl3945]
   [<ffffffffa0276f08>] iwl3945_mac_start+0x438/0x1440 [iwl3945]
   [<ffffffffa0125419>] ieee80211_open+0x289/0x920 [mac80211]
   [<ffffffff804d02fa>] dev_open+0x9a/0x100
   [<ffffffff804cfdb6>] dev_change_flags+0x96/0x1c0
   [<ffffffff804dbfe2>] do_setlink+0x212/0x4a0
   [<ffffffff804dc882>] rtnl_setlink+0x122/0x160
   [<ffffffff804dbb1f>] rtnetlink_rcv_msg+0x1df/0x220
   [<ffffffff804e7409>] netlink_rcv_skb+0xa9/0xd0
   [<ffffffff804db925>] rtnetlink_rcv+0x25/0x40
   [<ffffffff804e708a>] netlink_unicast+0x29a/0x2f0
   [<ffffffff804e7e82>] netlink_sendmsg+0x222/0x320
   [<ffffffff804befdb>] sock_sendmsg+0x10b/0x140
   [<ffffffff804bfa90>] sys_sendmsg+0x1d0/0x330
   [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&base->lock){-.-...} ops: 0 {
    IN-HARDIRQ-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    IN-SOFTIRQ-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                                        [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                        [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                        [<ffffffff8055a038>]
_spin_lock_irqsave+0x48/0x90
                                        [<ffffffff8025118c>]
lock_timer_base+0x3c/0x70
                                        [<ffffffff802519b7>]
mod_timer+0x57/0x120
                                        [<ffffffff807891b2>] con_init+0xc3/0x24c
                                        [<ffffffff8078892d>]
console_init+0x19/0x2a
                                        [<ffffffff80768b73>]
start_kernel+0x227/0x37b
                                        [<ffffffff80768315>]
x86_64_start_reservations+0x125/0x129
                                        [<ffffffff807683fd>]
x86_64_start_kernel+0xe4/0xeb
                                        [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff809e7358>] __key.23674+0x0/0x8
 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&q->lock){-.-.-.} ops: 0 {
    IN-HARDIRQ-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    IN-SOFTIRQ-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    IN-RECLAIM_FS-W at:
                                            [<ffffffff80271eba>]
__lock_acquire+0x39a/0x1100
                                            [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                            [<ffffffff8055a038>]
_spin_lock_irqsave+0x48/0x90
                                            [<ffffffff8025ecfa>]
prepare_to_wait+0x2a/0x80
                                            [<ffffffff802c1bd0>]
kswapd+0x100/0x750
                                            [<ffffffff8025e61a>]
kthread+0x5a/0xa0
                                            [<ffffffff8020d23a>]
child_rip+0xa/0x20
                                            [<ffffffffffffffff>]
0xffffffffffffffff
    INITIAL USE at:
                                        [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                        [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                        [<ffffffff80559fac>]
_spin_lock_irq+0x3c/0x80
                                        [<ffffffff8055723d>]
wait_for_common+0x4d/0x190
                                        [<ffffffff8055743d>]
wait_for_completion+0x1d/0x20
                                        [<ffffffff8025e8b5>]
kthread_create+0xb5/0x150
                                        [<ffffffff805539c2>]
migration_call+0x4a/0x4de
                                        [<ffffffff8077a252>]
migration_init+0x27/0x5b
                                        [<ffffffff8020904f>]
do_one_initcall+0x3f/0x1c0
                                        [<ffffffff807685ea>]
kernel_init+0x64/0x190
                                        [<ffffffff8020d23a>] child_rip+0xa/0x20
                                        [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff809e7ac8>] __key.18195+0x0/0x18
  -> (&rq->lock){-.-.-.} ops: 0 {
     IN-HARDIRQ-W at:
                                           [<ffffffffffffffff>]
0xffffffffffffffff
     IN-SOFTIRQ-W at:
                                           [<ffffffffffffffff>]
0xffffffffffffffff
     IN-RECLAIM_FS-W at:
                                              [<ffffffff80271eba>]
__lock_acquire+0x39a/0x1100
                                              [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                              [<ffffffff80559ec6>]
_spin_lock+0x36/0x70
                                              [<ffffffff80236722>]
task_rq_lock+0x52/0x90
                                              [<ffffffff80241b8f>]
set_cpus_allowed_ptr+0x2f/0x150
                                              [<ffffffff802c1b49>]
kswapd+0x79/0x750
                                              [<ffffffff8025e61a>]
kthread+0x5a/0xa0
                                              [<ffffffff8020d23a>]
child_rip+0xa/0x20
                                              [<ffffffffffffffff>]
0xffffffffffffffff
     INITIAL USE at:
                                          [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                          [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                          [<ffffffff8055a038>]
_spin_lock_irqsave+0x48/0x90
                                          [<ffffffff80237e5b>]
rq_attach_root+0x2b/0x110
                                          [<ffffffff8077a519>]
sched_init+0x293/0x3c5
                                          [<ffffffff80768a91>]
start_kernel+0x145/0x37b
                                          [<ffffffff80768315>]
x86_64_start_reservations+0x125/0x129
                                          [<ffffffff807683fd>]
x86_64_start_kernel+0xe4/0xeb
                                          [<ffffffffffffffff>]
0xffffffffffffffff
   }
   ... key      at: [<ffffffff809a2458>] __key.49600+0x0/0x8
   -> (&vec->lock){..-...} ops: 0 {
      IN-SOFTIRQ-W at:
                                             [<ffffffffffffffff>]
0xffffffffffffffff
      INITIAL USE at:
                                            [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                            [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                            [<ffffffff8055a038>]
_spin_lock_irqsave+0x48/0x90
                                            [<ffffffff802b2cac>]
cpupri_set+0xec/0x190
                                            [<ffffffff80237713>]
rq_online_rt+0x73/0x80
                                            [<ffffffff802356be>]
set_rq_online+0x4e/0x70
                                            [<ffffffff80237f18>]
rq_attach_root+0xe8/0x110
                                            [<ffffffff8077a519>]
sched_init+0x293/0x3c5
                                            [<ffffffff80768a91>]
start_kernel+0x145/0x37b
                                            [<ffffffff80768315>]
x86_64_start_reservations+0x125/0x129
                                            [<ffffffff807683fd>]
x86_64_start_kernel+0xe4/0xeb
                                            [<ffffffffffffffff>]
0xffffffffffffffff
    }
    ... key      at: [<ffffffff811641d8>] __key.15002+0x0/0x28
   ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff8055a038>] _spin_lock_irqsave+0x48/0x90
   [<ffffffff802b2cac>] cpupri_set+0xec/0x190
   [<ffffffff80237713>] rq_online_rt+0x73/0x80
   [<ffffffff802356be>] set_rq_online+0x4e/0x70
   [<ffffffff80237f18>] rq_attach_root+0xe8/0x110
   [<ffffffff8077a519>] sched_init+0x293/0x3c5
   [<ffffffff80768a91>] start_kernel+0x145/0x37b
   [<ffffffff80768315>] x86_64_start_reservations+0x125/0x129
   [<ffffffff807683fd>] x86_64_start_kernel+0xe4/0xeb
   [<ffffffffffffffff>] 0xffffffffffffffff

   -> (&rt_b->rt_runtime_lock){..-...} ops: 0 {
      IN-SOFTIRQ-W at:
                                             [<ffffffffffffffff>]
0xffffffffffffffff
      INITIAL USE at:
                                            [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                            [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                            [<ffffffff80559ec6>]
_spin_lock+0x36/0x70
                                            [<ffffffff80241844>]
enqueue_task_rt+0x1f4/0x290
                                            [<ffffffff80234b8c>]
enqueue_task+0x5c/0x70
                                            [<ffffffff80234cbd>]
activate_task+0x2d/0x40
                                            [<ffffffff8023c8c4>]
try_to_wake_up+0x204/0x2f0
                                            [<ffffffff8023ca05>]
wake_up_process+0x15/0x20
                                            [<ffffffff80553a54>]
migration_call+0xdc/0x4de
                                            [<ffffffff8077a273>]
migration_init+0x48/0x5b
                                            [<ffffffff8020904f>]
do_one_initcall+0x3f/0x1c0
                                            [<ffffffff807685ea>]
kernel_init+0x64/0x190
                                            [<ffffffff8020d23a>]
child_rip+0xa/0x20
                                            [<ffffffffffffffff>]
0xffffffffffffffff
    }
    ... key      at: [<ffffffff809a2460>] __key.38840+0x0/0x8
    -> (&cpu_base->lock){-.-...} ops: 0 {
       IN-HARDIRQ-W at:
                                               [<ffffffffffffffff>]
0xffffffffffffffff
       IN-SOFTIRQ-W at:
                                               [<ffffffffffffffff>]
0xffffffffffffffff
       INITIAL USE at:
                                              [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                              [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                              [<ffffffff8055a038>]
_spin_lock_irqsave+0x48/0x90
                                              [<ffffffff80262401>]
lock_hrtimer_base+0x31/0x60
                                              [<ffffffff802625d2>]
__hrtimer_start_range_ns+0x42/0x2b0
                                              [<ffffffff80241892>]
enqueue_task_rt+0x242/0x290
                                              [<ffffffff80234b8c>]
enqueue_task+0x5c/0x70
                                              [<ffffffff80234cbd>]
activate_task+0x2d/0x40
                                              [<ffffffff8023c8c4>]
try_to_wake_up+0x204/0x2f0
                                              [<ffffffff8023ca05>]
wake_up_process+0x15/0x20
                                              [<ffffffff80553a54>]
migration_call+0xdc/0x4de
                                              [<ffffffff8077a273>]
migration_init+0x48/0x5b
                                              [<ffffffff8020904f>]
do_one_initcall+0x3f/0x1c0
                                              [<ffffffff807685ea>]
kernel_init+0x64/0x190
                                              [<ffffffff8020d23a>]
child_rip+0xa/0x20
                                              [<ffffffffffffffff>]
0xffffffffffffffff
     }
     ... key      at: [<ffffffff809e7b10>] __key.20525+0x0/0x8
    ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff8055a038>] _spin_lock_irqsave+0x48/0x90
   [<ffffffff80262401>] lock_hrtimer_base+0x31/0x60
   [<ffffffff802625d2>] __hrtimer_start_range_ns+0x42/0x2b0
   [<ffffffff80241892>] enqueue_task_rt+0x242/0x290
   [<ffffffff80234b8c>] enqueue_task+0x5c/0x70
   [<ffffffff80234cbd>] activate_task+0x2d/0x40
   [<ffffffff8023c8c4>] try_to_wake_up+0x204/0x2f0
   [<ffffffff8023ca05>] wake_up_process+0x15/0x20
   [<ffffffff80553a54>] migration_call+0xdc/0x4de
   [<ffffffff8077a273>] migration_init+0x48/0x5b
   [<ffffffff8020904f>] do_one_initcall+0x3f/0x1c0
   [<ffffffff807685ea>] kernel_init+0x64/0x190
   [<ffffffff8020d23a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

    -> (&rt_rq->rt_runtime_lock){-.-...} ops: 0 {
       IN-HARDIRQ-W at:
                                               [<ffffffffffffffff>]
0xffffffffffffffff
       IN-SOFTIRQ-W at:
                                               [<ffffffffffffffff>]
0xffffffffffffffff
       INITIAL USE at:
                                              [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                              [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                              [<ffffffff80559ec6>]
_spin_lock+0x36/0x70
                                              [<ffffffff80240ad4>]
update_curr_rt+0x104/0x180
                                              [<ffffffff802415f4>]
dequeue_task_rt+0x24/0x80
                                              [<ffffffff80234c55>]
dequeue_task+0xb5/0xf0
                                              [<ffffffff80234cfd>]
deactivate_task+0x2d/0x40
                                              [<ffffffff80556a35>]
thread_return+0xe7/0x722
                                              [<ffffffff8055707e>]
schedule+0xe/0x30
                                              [<ffffffff802421b8>]
migration_thread+0x1d8/0x2d0
                                              [<ffffffff8025e61a>]
kthread+0x5a/0xa0
                                              [<ffffffff8020d23a>]
child_rip+0xa/0x20
                                              [<ffffffffffffffff>]
0xffffffffffffffff
     }
     ... key      at: [<ffffffff809a2468>] __key.49580+0x0/0x8
    ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff80559ec6>] _spin_lock+0x36/0x70
   [<ffffffff8023679d>] __enable_runtime+0x3d/0x80
   [<ffffffff802376f7>] rq_online_rt+0x57/0x80
   [<ffffffff802356be>] set_rq_online+0x4e/0x70
   [<ffffffff80553a8f>] migration_call+0x117/0x4de
   [<ffffffff8055cf18>] notifier_call_chain+0x68/0xa0
   [<ffffffff80263b56>] raw_notifier_call_chain+0x16/0x20
   [<ffffffff80553fec>] _cpu_up+0xe5/0x134
   [<ffffffff8055409a>] cpu_up+0x5f/0x6f
   [<ffffffff80768643>] kernel_init+0xbd/0x190
   [<ffffffff8020d23a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff80559ec6>] _spin_lock+0x36/0x70
   [<ffffffff80241844>] enqueue_task_rt+0x1f4/0x290
   [<ffffffff80234b8c>] enqueue_task+0x5c/0x70
   [<ffffffff80234cbd>] activate_task+0x2d/0x40
   [<ffffffff8023c8c4>] try_to_wake_up+0x204/0x2f0
   [<ffffffff8023ca05>] wake_up_process+0x15/0x20
   [<ffffffff80553a54>] migration_call+0xdc/0x4de
   [<ffffffff8077a273>] migration_init+0x48/0x5b
   [<ffffffff8020904f>] do_one_initcall+0x3f/0x1c0
   [<ffffffff807685ea>] kernel_init+0x64/0x190
   [<ffffffff8020d23a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff80559ec6>] _spin_lock+0x36/0x70
   [<ffffffff80240ad4>] update_curr_rt+0x104/0x180
   [<ffffffff802415f4>] dequeue_task_rt+0x24/0x80
   [<ffffffff80234c55>] dequeue_task+0xb5/0xf0
   [<ffffffff80234cfd>] deactivate_task+0x2d/0x40
   [<ffffffff80556a35>] thread_return+0xe7/0x722
   [<ffffffff8055707e>] schedule+0xe/0x30
   [<ffffffff802421b8>] migration_thread+0x1d8/0x2d0
   [<ffffffff8025e61a>] kthread+0x5a/0xa0
   [<ffffffff8020d23a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   -> (&rq->lock/1){..-...} ops: 0 {
      IN-SOFTIRQ-W at:
                                             [<ffffffffffffffff>]
0xffffffffffffffff
      INITIAL USE at:
                                            [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                            [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                            [<ffffffff80559e54>]
_spin_lock_nested+0x34/0x70
                                            [<ffffffff8023b97a>]
double_rq_lock+0x3a/0xa0
                                            [<ffffffff8023ba44>]
__migrate_task+0x64/0x120
                                            [<ffffffff80242085>]
migration_thread+0xa5/0x2d0
                                            [<ffffffff8025e61a>]
kthread+0x5a/0xa0
                                            [<ffffffff8020d23a>]
child_rip+0xa/0x20
                                            [<ffffffffffffffff>]
0xffffffffffffffff
    }
    ... key      at: [<ffffffff809a2459>] __key.49600+0x1/0x8
    -> (&sig->cputimer.lock){-.-...} ops: 0 {
       IN-HARDIRQ-W at:
                                               [<ffffffffffffffff>]
0xffffffffffffffff
       IN-SOFTIRQ-W at:
                                               [<ffffffffffffffff>]
0xffffffffffffffff
       INITIAL USE at:
                                              [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                              [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                              [<ffffffff8055a038>]
_spin_lock_irqsave+0x48/0x90
                                              [<ffffffff8025fc9d>]
thread_group_cputimer+0x3d/0x100
                                              [<ffffffff8025ffca>]
posix_cpu_timers_exit_group+0x1a/0x40
                                              [<ffffffff80248298>]
release_task+0x368/0x480
                                              [<ffffffff80248965>]
do_exit+0x5b5/0x7c0
                                              [<ffffffff80258f85>]
____call_usermodehelper+0x155/0x160
                                              [<ffffffff8020d23a>]
child_rip+0xa/0x20
                                              [<ffffffffffffffff>]
0xffffffffffffffff
     }
     ... key      at: [<ffffffff809a45ec>] __key.15894+0x0/0x8
    ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff80559ec6>] _spin_lock+0x36/0x70
   [<ffffffff8023b2f3>] update_curr+0x103/0x140
   [<ffffffff80240e9f>] enqueue_task_fair+0x5f/0x2f0
   [<ffffffff80234b8c>] enqueue_task+0x5c/0x70
   [<ffffffff80234cbd>] activate_task+0x2d/0x40
   [<ffffffff8023bad4>] __migrate_task+0xf4/0x120
   [<ffffffff80242085>] migration_thread+0xa5/0x2d0
   [<ffffffff8025e61a>] kthread+0x5a/0xa0
   [<ffffffff8020d23a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff80559e54>] _spin_lock_nested+0x34/0x70
   [<ffffffff8023b97a>] double_rq_lock+0x3a/0xa0
   [<ffffffff8023ba44>] __migrate_task+0x64/0x120
   [<ffffffff80242085>] migration_thread+0xa5/0x2d0
   [<ffffffff8025e61a>] kthread+0x5a/0xa0
   [<ffffffff8020d23a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff80559ec6>] _spin_lock+0x36/0x70
   [<ffffffff8023b2f3>] update_curr+0x103/0x140
   [<ffffffff80240e9f>] enqueue_task_fair+0x5f/0x2f0
   [<ffffffff80234b8c>] enqueue_task+0x5c/0x70
   [<ffffffff80234cbd>] activate_task+0x2d/0x40
   [<ffffffff8023c8c4>] try_to_wake_up+0x204/0x2f0
   [<ffffffff8023c9c2>] default_wake_function+0x12/0x20
   [<ffffffff80235219>] __wake_up_common+0x59/0x90
   [<ffffffff802364b6>] complete+0x46/0x60
   [<ffffffff8025e52a>] kthreadd+0xba/0x150
   [<ffffffff8020d23a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   -> (latency_lock){-.-...} ops: 0 {
      IN-HARDIRQ-W at:
                                             [<ffffffffffffffff>]
0xffffffffffffffff
      IN-SOFTIRQ-W at:
                                             [<ffffffffffffffff>]
0xffffffffffffffff
      INITIAL USE at:
                                            [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                            [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                            [<ffffffff8055a038>]
_spin_lock_irqsave+0x48/0x90
                                            [<ffffffff80559373>]
__account_scheduler_latency+0x93/0x310
                                            [<ffffffff80241125>]
enqueue_task_fair+0x2e5/0x2f0
                                            [<ffffffff80234b8c>]
enqueue_task+0x5c/0x70
                                            [<ffffffff80234cbd>]
activate_task+0x2d/0x40
                                            [<ffffffff8023c8c4>]
try_to_wake_up+0x204/0x2f0
                                            [<ffffffff8023c9c2>]
default_wake_function+0x12/0x20
                                            [<ffffffff80235219>]
__wake_up_common+0x59/0x90
                                            [<ffffffff802365b8>]
__wake_up+0x48/0x70
                                            [<ffffffff80289bc0>]
audit_log_end+0x120/0x170
                                            [<ffffffff8029200d>]
audit_log_exit+0x2ad/0x1110
                                            [<ffffffff802930c4>]
audit_syscall_exit+0x254/0x260
                                            [<ffffffff8020c313>]
sysret_audit+0x14/0x1e
                                            [<ffffffffffffffff>]
0xffffffffffffffff
    }
    ... key      at: [<ffffffff80706258>] latency_lock+0x18/0x40
   ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff8055a038>] _spin_lock_irqsave+0x48/0x90
   [<ffffffff80559373>] __account_scheduler_latency+0x93/0x310
   [<ffffffff80241125>] enqueue_task_fair+0x2e5/0x2f0
   [<ffffffff80234b8c>] enqueue_task+0x5c/0x70
   [<ffffffff80234cbd>] activate_task+0x2d/0x40
   [<ffffffff8023c8c4>] try_to_wake_up+0x204/0x2f0
   [<ffffffff8023c9c2>] default_wake_function+0x12/0x20
   [<ffffffff80235219>] __wake_up_common+0x59/0x90
   [<ffffffff802365b8>] __wake_up+0x48/0x70
   [<ffffffff80289bc0>] audit_log_end+0x120/0x170
   [<ffffffff8029200d>] audit_log_exit+0x2ad/0x1110
   [<ffffffff802930c4>] audit_syscall_exit+0x254/0x260
   [<ffffffff8020c313>] sysret_audit+0x14/0x1e
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff80559ec6>] _spin_lock+0x36/0x70
   [<ffffffff80236722>] task_rq_lock+0x52/0x90
   [<ffffffff8023c709>] try_to_wake_up+0x49/0x2f0
   [<ffffffff8023c9c2>] default_wake_function+0x12/0x20
   [<ffffffff80235219>] __wake_up_common+0x59/0x90
   [<ffffffff802364b6>] complete+0x46/0x60
   [<ffffffff8025e5f9>] kthread+0x39/0xa0
   [<ffffffff8020d23a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  -> (&ep->lock){..-...} ops: 0 {
     IN-SOFTIRQ-W at:
                                           [<ffffffffffffffff>]
0xffffffffffffffff
     INITIAL USE at:
                                          [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                          [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                          [<ffffffff8055a038>]
_spin_lock_irqsave+0x48/0x90
                                          [<ffffffff80319167>]
sys_epoll_ctl+0x3a7/0x550
                                          [<ffffffff8020c15b>]
system_call_fastpath+0x16/0x1b
                                          [<ffffffffffffffff>]
0xffffffffffffffff
   }
   ... key      at: [<ffffffff81167370>] __key.23029+0x0/0x10
   ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff80559ec6>] _spin_lock+0x36/0x70
   [<ffffffff80236722>] task_rq_lock+0x52/0x90
   [<ffffffff8023c709>] try_to_wake_up+0x49/0x2f0
   [<ffffffff8023c9c2>] default_wake_function+0x12/0x20
   [<ffffffff80235219>] __wake_up_common+0x59/0x90
   [<ffffffff80235268>] __wake_up_locked+0x18/0x20
   [<ffffffff80318d20>] ep_poll_callback+0x90/0x130
   [<ffffffff80235219>] __wake_up_common+0x59/0x90
   [<ffffffff80236523>] __wake_up_sync_key+0x53/0x80
   [<ffffffff804c2929>] sock_def_readable+0x49/0x80
   [<ffffffff8053e067>] unix_stream_connect+0x467/0x480
   [<ffffffff804bf5d7>] sys_connect+0xa7/0xc0
   [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff8055a038>] _spin_lock_irqsave+0x48/0x90
   [<ffffffff80318cbd>] ep_poll_callback+0x2d/0x130
   [<ffffffff80235219>] __wake_up_common+0x59/0x90
   [<ffffffff80236523>] __wake_up_sync_key+0x53/0x80
   [<ffffffff804c2929>] sock_def_readable+0x49/0x80
   [<ffffffff8053e067>] unix_stream_connect+0x467/0x480
   [<ffffffff804bf5d7>] sys_connect+0xa7/0xc0
   [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&cwq->lock){-.-...} ops: 0 {
    IN-HARDIRQ-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    IN-SOFTIRQ-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                                        [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                        [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                        [<ffffffff8055a038>]
_spin_lock_irqsave+0x48/0x90
                                        [<ffffffff8025a1b4>]
__queue_work+0x24/0x50
                                        [<ffffffff8025a272>]
queue_work_on+0x42/0x60
                                        [<ffffffff8025a2cf>]
queue_work+0x1f/0x30
                                        [<ffffffff80259192>]
call_usermodehelper_exec+0xd2/0xf0
                                        [<ffffffff803b1cc5>]
kobject_uevent_env+0x3a5/0x430
                                        [<ffffffff803b1d5b>]
kobject_uevent+0xb/0x10
                                        [<ffffffff803b1002>]
kset_register+0x52/0x60
                                        [<ffffffff80453832>]
bus_register+0xe2/0x2f0
                                        [<ffffffff8078a509>]
platform_bus_init+0x29/0x41
                                        [<ffffffff8078a5ba>]
driver_init+0x1d/0x29
                                        [<ffffffff807686ad>]
kernel_init+0x127/0x190
                                        [<ffffffff8020d23a>] child_rip+0xa/0x20
                                        [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff809e73d4>] __key.24067+0x0/0x8
  ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff8055a038>] _spin_lock_irqsave+0x48/0x90
   [<ffffffff802365a2>] __wake_up+0x32/0x70
   [<ffffffff80259c4a>] insert_work+0x7a/0xc0
   [<ffffffff8025a1c6>] __queue_work+0x36/0x50
   [<ffffffff8025a272>] queue_work_on+0x42/0x60
   [<ffffffff8025a2cf>] queue_work+0x1f/0x30
   [<ffffffff80259192>] call_usermodehelper_exec+0xd2/0xf0
   [<ffffffff803b1cc5>] kobject_uevent_env+0x3a5/0x430
   [<ffffffff803b1d5b>] kobject_uevent+0xb/0x10
   [<ffffffff803b1002>] kset_register+0x52/0x60
   [<ffffffff80453832>] bus_register+0xe2/0x2f0
   [<ffffffff8078a509>] platform_bus_init+0x29/0x41
   [<ffffffff8078a5ba>] driver_init+0x1d/0x29
   [<ffffffff807686ad>] kernel_init+0x127/0x190
   [<ffffffff8020d23a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff8055a038>] _spin_lock_irqsave+0x48/0x90
   [<ffffffff8025a1b4>] __queue_work+0x24/0x50
   [<ffffffff8025a272>] queue_work_on+0x42/0x60
   [<ffffffff8025a2cf>] queue_work+0x1f/0x30
   [<ffffffffa023a59d>] iwl_scan_initiate+0xcd/0x2a0 [iwlcore]
   [<ffffffffa023a87b>] iwl_mac_hw_scan+0x10b/0x390 [iwlcore]
   [<ffffffffa011ce2c>] ieee80211_start_scan+0x9c/0x310 [mac80211]
   [<ffffffffa0124412>] ieee80211_sta_work+0x222/0xa70 [mac80211]
   [<ffffffff80259868>] worker_thread+0x1e8/0x3a0
   [<ffffffff8025e61a>] kthread+0x5a/0xa0
   [<ffffffff8020d23a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&priv->hcmd_lock){..-...} ops: 0 {
    IN-SOFTIRQ-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                                        [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                        [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                        [<ffffffff8055a038>]
_spin_lock_irqsave+0x48/0x90
                                        [<ffffffffa0232b59>]
iwl_enqueue_hcmd+0xb9/0x540 [iwlcore]
                                        [<ffffffffa022c911>]
iwl_send_cmd_sync+0x71/0x4d0 [iwlcore]
                                        [<ffffffffa022cda9>]
iwl_send_cmd_pdu+0x39/0x40 [iwlcore]
                                        [<ffffffffa022657b>]
iwl_send_bt_config+0x3b/0x40 [iwlcore]
                                        [<ffffffffa02734d9>]
iwl3945_bg_alive_start+0x2e9/0x830 [iwl3945]
                                        [<ffffffff80259868>]
worker_thread+0x1e8/0x3a0
                                        [<ffffffff8025e61a>] kthread+0x5a/0xa0
                                        [<ffffffff8020d23a>] child_rip+0xa/0x20
                                        [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffffa0290a44>]
__key.46204+0x0/0xffffffffffff281f [iwl3945]
  ... acquired at:
   [<ffffffff80272800>] __lock_acquire+0xce0/0x1100
   [<ffffffff80272cb8>] lock_acquire+0x98/0x140
   [<ffffffff8055a038>] _spin_lock_irqsave+0x48/0x90
   [<ffffffff803c0814>] map_single+0xa4/0x260
   [<ffffffff803c0d62>] swiotlb_map_page+0xd2/0x1a0
   [<ffffffffa0232cc2>] iwl_enqueue_hcmd+0x222/0x540 [iwlcore]
   [<ffffffffa022c911>] iwl_send_cmd_sync+0x71/0x4d0 [iwlcore]
   [<ffffffffa022cda9>] iwl_send_cmd_pdu+0x39/0x40 [iwlcore]
   [<ffffffffa022657b>] iwl_send_bt_config+0x3b/0x40 [iwlcore]
   [<ffffffffa02734d9>] iwl3945_bg_alive_start+0x2e9/0x830 [iwl3945]
   [<ffffffff80259868>] worker_thread+0x1e8/0x3a0
   [<ffffffff8025e61a>] kthread+0x5a/0xa0
   [<ffffffff8020d23a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&list->lock#7){..-...} ops: 0 {
    IN-SOFTIRQ-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                                        [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffffa0141b88>]
__key.19075+0x0/0xffffffffffff25c1 [mac80211]
 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (&(&priv->scan_check)->timer){+.-...} ops: 0 {
    HARDIRQ-ON-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    IN-SOFTIRQ-W at:
                                         [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                                        [<ffffffff80271cbe>]
__lock_acquire+0x19e/0x1100
                                        [<ffffffff80272cb8>]
lock_acquire+0x98/0x140
                                        [<ffffffff80251771>]
del_timer_sync+0x41/0xa0
                                        [<ffffffffa026f78d>]
iwl3945_mac_add_interface+0x14d/0x420 [iwl3945]
                                        [<ffffffffa0125598>]
ieee80211_open+0x408/0x920 [mac80211]
                                        [<ffffffff804d02fa>] dev_open+0x9a/0x100
                                        [<ffffffff804cfdb6>]
dev_change_flags+0x96/0x1c0
                                        [<ffffffff804dbfe2>]
do_setlink+0x212/0x4a0
                                        [<ffffffff804dc882>]
rtnl_setlink+0x122/0x160
                                        [<ffffffff804dbb1f>]
rtnetlink_rcv_msg+0x1df/0x220
                                        [<ffffffff804e7409>]
netlink_rcv_skb+0xa9/0xd0
                                        [<ffffffff804db925>]
rtnetlink_rcv+0x25/0x40
                                        [<ffffffff804e708a>]
netlink_unicast+0x29a/0x2f0
                                        [<ffffffff804e7e82>]
netlink_sendmsg+0x222/0x320
                                        [<ffffffff804befdb>]
sock_sendmsg+0x10b/0x140
                                        [<ffffffff804bfa90>]
sys_sendmsg+0x1d0/0x330
                                        [<ffffffff8020c15b>]
system_call_fastpath+0x16/0x1b
                                        [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffffa0290a64>]
__key.46148+0x0/0xffffffffffff27ff [iwl3945]
 ... acquired at:
   [<ffffffffffffffff>] 0xffffffffffffffff


stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.30-rc3-00324-g8087eae #55
Call Trace:
 <IRQ>  [<ffffffff8026fd8f>] print_irq_inversion_bug+0x13f/0x160
 [<ffffffff8026fe70>] ? check_usage_backwards+0x0/0xc0
 [<ffffffff8026fed5>] check_usage_backwards+0x65/0xc0
 [<ffffffff80270a68>] mark_lock+0x1b8/0x430
 [<ffffffff80271fe1>] __lock_acquire+0x4c1/0x1100
 [<ffffffff80272cb8>] lock_acquire+0x98/0x140
 [<ffffffff80250d90>] ? run_timer_softirq+0x120/0x2e0
 [<ffffffff8025a1e0>] ? delayed_work_timer_fn+0x0/0x50
 [<ffffffff80250e4f>] run_timer_softirq+0x1df/0x2e0
 [<ffffffff80250d90>] ? run_timer_softirq+0x120/0x2e0
 [<ffffffff8024bb11>] ? __do_softirq+0x61/0x1f0
 [<ffffffff8024bb52>] __do_softirq+0xa2/0x1f0
 [<ffffffff8020d33c>] call_softirq+0x1c/0x50
 [<ffffffff8020e9a5>] do_softirq+0x75/0xc0
 [<ffffffff8024b785>] irq_exit+0x95/0xa0
 [<ffffffff8055f041>] smp_apic_timer_interrupt+0x71/0x9c
 [<ffffffff8020cd53>] apic_timer_interrupt+0x13/0x20
 <EOI>  [<ffffffff80272cd2>] ? lock_acquire+0xb2/0x140
 [<ffffffff8055cf50>] ? __atomic_notifier_call_chain+0x0/0xa0
 [<ffffffff8026a302>] ? clockevents_notify+0x42/0xb0
 [<ffffffff8055cfa1>] ? __atomic_notifier_call_chain+0x51/0xa0
 [<ffffffff8055cf50>] ? __atomic_notifier_call_chain+0x0/0xa0
 [<ffffffff8055d001>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8020af38>] ? cpu_idle+0x98/0xc0
 [<ffffffff80552bee>] ? start_secondary+0x189/0x18e

.......

CE: hpet increasing min_delta_ns to 15000 nsec
usb 3-1: USB disconnect, address 2
btusb_intr_complete: hci0 urb ffff880138eb4600 failed to resubmit (19)
btusb_bulk_complete: hci0 urb ffff880138eb4180 failed to resubmit (19)
btusb_bulk_complete: hci0 urb ffff880138eb4000 failed to resubmit (19)
btusb_send_frame: hci0 urb ffff880092d6ea80 submission failed
wlan0: direct probe to AP 00:11:d8:da:65:40 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:11:d8:da:65:40
wlan0: authenticated
wlan0: associate with AP 00:11:d8:da:65:40
wlan0: RX AssocResp from 00:11:d8:da:65:40 (capab=0x401 status=0 aid=1)
wlan0: associated
wlan0: disassociating by local choice (reason=3)
[drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for
disabled pipe 0
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
