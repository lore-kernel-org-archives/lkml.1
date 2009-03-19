Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbZCSK4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbZCSK4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 06:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZCSK4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 06:56:10 -0400
Received: from mail.agmk.net ([91.192.224.71]:12956 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbZCSK4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 06:56:08 -0400
To: linux-kernel@vger.kernel.org
Subject: [2.6.9] NMI watchdog detected lockup.
Date: Thu, 19 Mar 2009 12:56:01 +0200
X-Mailer: IlohaMail/0.8.13 (On: agmk.net)
Message-ID: <Ok0OsSvf.1237460161.3536740.pluto@agmk.net>
From: "=?ISO-8859-2?Q?Pawe=B3?= Sikora" <pluto@agmk.net>
Bounce-To: "=?ISO-8859-2?Q?Pawe=B3?= Sikora" <pluto@agmk.net>
MIME-Version: 1.0 
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

we're currently testing trial version of Jungo pci driver for
linux/windows
(http://www.jungo.com/st/windriver_usb_pci_driver_development_software.html)
and get 'NMI Watchdog detected LOCKUP' on athlon64/opteron smp systems
with rhel 2.6.9 kernel. from the other side, the lockup doesn't occur
on intel x86_64 smp systems. bad news is that Jungo developers can't
reproduce
the lockup while we can trig it during simple pci bus scanning/opening
device.

only diagnostic we have is console log grabbed over rs232 link.

NMI Watchdog detected LOCKUP, CPU=0, registers:
CPU 0
Modules linked in: windrvr6(U) nfs nfsd exportfs lockd nfs_acl md5 ipv6
autofs4
i2c_dev i2c_core sunrpc powernow_k8 cpufreq_powersave dm_mirror dm_mod
button
battery ac ohci_hcd snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm
snd_timer
snd soundcore snd_page_alloc forcedeth sr_mod ext3 jbd sata_nv ahci libata
sd_mod scsi_mod
Pid: 11027, comm: tb Tainted: PF     2.6.9-78.ELsmp
RIP: 0010:[<ffffffff802b26d2>] <ffffffff802b26d2>{pci_conf1_read+182}
RSP: 0018:ffffffff80472918  EFLAGS: 00000046
RAX: 00000000ffffffff RBX: 0000000080f1c39c RCX: 0000000000000016
RDX: 0000000000000cfc RSI: 0000000000000016 RDI: ffffffff8042a8e0
RBP: 000000000000c300 R08: 0000000000000004 R09: ffffffff80472954
R10: 00000000000000c3 R11: ffffffff802b3c70 R12: 000000000000009c
R13: 0000000000000004 R14: ffffffff80472954 R15: 0000000000000001
FS:  0000002a959e3180(0000) GS:ffffffff80506b00(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000002a9567f330 CR3: 0000000000101000 CR4: 00000000000006e0
Process tb (pid: 11027, threadinfo 000001011d30a000, task
000001011bb947f0)
Stack: 000000000000009c 000001013b9e6c00 0000000000000046 00000000000000c3
       ffffffff80472994 ffffffff801f4c13 0000000000000000 0000000000000000
       0000000000000000 0000000000000000
Call Trace:
<IRQ> <ffffffff801f4c13>{pci_bus_read_config_dword+80}
<ffffffff8012102e>{flush_gart+155}
<ffffffff80121a31>{dma_map_sg+642}
<ffffffffa0034763>{:libata:ata_scsi_qc_complete+505}
<ffffffffa00343f5>{:libata:ata_scsi_rw_xlat+0}
<ffffffffa003028f>{:libata:ata_qc_issue+793}
<ffffffffa000288c>{:scsi_mod:scsi_done+0}
<ffffffffa00343f5>{:libata:ata_scsi_rw_xlat+0}
<ffffffffa0034846>{:libata:ata_scsi_translate+205}
<ffffffffa000288c>{:scsi_mod:scsi_done+0}
<ffffffffa0035bbd>{:libata:ata_scsi_queuecmd+335}
<ffffffffa0002af7>{:scsi_mod:scsi_dispatch_cmd+595}
<ffffffffa0007e2f>{:scsi_mod:scsi_request_fn+990}
<ffffffff80256aea>{blk_run_queue+65}
<ffffffffa000718a>{:scsi_mod:scsi_end_request+182}
<ffffffffa0007411>{:scsi_mod:scsi_io_completion+497}
<ffffffffa0002d45>{:scsi_mod:scsi_softirq+213}
<ffffffff8013d4f0>{__do_softirq+88}
<ffffffff8013d599>{do_softirq+49}
<ffffffff801132ef>{do_IRQ+328}
<ffffffff801108bf>{ret_from_intr+0}  <EOI>
<ffffffff802b3c70>{pci_mmcfg_read+0}
<ffffffff80319315>{_spin_unlock_irqrestore+47}
<ffffffff801f4b3d>{pci_bus_read_config_byte+97}
<ffffffffa014c87a>{:windrvr6:LINUX_pcibios_read_config_byte+138}
<ffffffffa01550eb>{:windrvr6:pci_cfg_rw+91}
<ffffffff802b3c70>{pci_mmcfg_read+0}
<ffffffffa01551e1>{:windrvr6:HalGetBusDataSingle+33}
<ffffffffa015522f>{:windrvr6:pci_find_cap+63}
<ffffffffa0155362>{:windrvr6:pci_bus_get_ops+98}
<ffffffffa01554c5>{:windrvr6:pci_bus_get_config+149}
<ffffffffa01551c0>{:windrvr6:HalGetBusDataSingle+0}
<ffffffffa01553b0>{:windrvr6:HalSetBusDataSingle+0}
<ffffffffa0155992>{:windrvr6:Do_pci_scan+322}
<ffffffffa0150670>{:windrvr6:Do_file_ioctl+2048}
<ffffffff802b6ecd>{release_sock+16}
<ffffffff802b43ba>{kernel_sendmsg+53}
<ffffffffa01cbbe1>{:sunrpc:xdr_sendpages+227}
<ffffffff80318304>{thread_return+0}
<ffffffff803183c5>{thread_return+193}
<ffffffff80134800>{__wake_up+54}
<ffffffffa01c4f63>{:sunrpc:__rpc_execute+867}
<ffffffff8013611c>{autoremove_wake_function+0}
<ffffffff8016bf57>{do_no_page+1023}
<ffffffffa00989da>{:forcedeth:nv_start_xmit_optimized+1014}
<ffffffff802cc898>{qdisc_restart+30}
<ffffffff802bd396>{dev_queue_xmit+541}
<ffffffff802d9e0e>{ip_finish_output+366}
<ffffffff802da252>{ip_queue_xmit+951}
<ffffffff802cc898>{qdisc_restart+30}
<ffffffff802bd396>{dev_queue_xmit+541}
<ffffffff802d9e0e>{ip_finish_output+366}
<ffffffff802b9ba9>{memcpy_toiovec+52}
<ffffffff802ba0f7>{skb_copy_datagram_iovec+85}
<ffffffff802dfb62>{cleanup_rbuf+231}
<ffffffff802b6ecd>{release_sock+16}
<ffffffff802e04e5>{tcp_recvmsg+1798}
<ffffffff801930ae>{__d_lookup+287}
<ffffffff80188987>{do_lookup+44}
<ffffffff80191f9d>{dput+56}
<ffffffff8017258a>{map_vm_area+634}
<ffffffff80172a5a>{__vmalloc+245}
<ffffffffa015100c>{:windrvr6:WDunixIoctl+380}
<ffffffff8017b0fd>{__dentry_open+248}
<ffffffffa0151198>{:windrvr6:WDlinuxIoctl+56}
<ffffffff80191f9d>{dput+56}
<ffffffff801f1be5>{strncpy_from_user+74}
<ffffffff8017cac9>{fget+74}
<ffffffff8018dce9>{sys_ioctl+853}
<ffffffff801102f6>{system_call+126}

Code: 41 89 06 48 c7 c7 e0 a8 42 80 e8 05 6c 06 00 31 c0 5b 5d 41
Kernel panic - not syncing: nmi watchdog


could anyone help me with this kernel panic?
is it a kernel issue already fixed in recent releases
or maybe it looks like a bug in Jungo blob?

i'm not subscribed to LKML, so pleasce CC on reply.

thanks in advance!

BR,
Pawel.
