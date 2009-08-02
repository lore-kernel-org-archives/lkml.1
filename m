Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbZHBHOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbZHBHOh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 03:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZHBHOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 03:14:37 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:54007 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZHBHOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 03:14:36 -0400
X-Greylist: delayed 1618 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Aug 2009 03:14:35 EDT
Message-ID: <4A753687.2040209@xs4all.nl>
Date: Sun, 02 Aug 2009 08:47:35 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Oops on 2.6.30.1 w/ ipaq
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Just put the HP Ipaq H2210 in the craddle. It powered on and booted into
Angstrom. I didn't do anything else. This oops occurred soon thereafter:

md: md1: data-check done.
usb 4-1: new full speed USB device using ohci_hcd and address 3
usb 4-1: New USB device found, idVendor=049f, idProduct=505a
usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-1: Product: Ethernet Gadget
usb 4-1: Manufacturer: Linux 2.6.15-hh1/pxa2xx_udc
usb 4-1: configuration #1 chosen from 1 choice
usb0: register 'cdc_subset' at usb-0000:00:12.1-1, Linux Device,
5e:d6:d0:11:60:60
usb 4-1: USB disconnect, address 3
usb0: unregister 'cdc_subset' usb-0000:00:12.1-1, Linux Device
usb 4-1: new full speed USB device using ohci_hcd and address 4
usb 4-1: New USB device found, idVendor=0525, idProduct=a4a2
usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-1: Product: RNDIS/Ethernet Gadget
usb 4-1: Manufacturer: Linux 2.6.21-hh20/pxa2xx_udc
usb 4-1: configuration #1 chosen from 2 choices
usb0: register 'cdc_subset' at usb-0000:00:12.1-1, Linux Device,
5e:d6:d0:11:60:60
usb0: no IPv6 routers present
------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:226 dev_watchdog+0x20c/0x220()
Hardware name:
NETDEV WATCHDOG: usb0 (cdc_subset): transmit timed out
Modules linked in: vfat fat usb_storage nfs amd5536udc radeon drm nfsd
nfs_acl rfcomm auth_rpcgss exportfs sco bridge stp llc bnep l2cap it87
hwmon_vid lockd sunrpc ipt_REJECT iptable_filter ipt_MASQUERADE
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
nf_conntrack_netbios_ns ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state
nf_conntrack ip6table_filter ip6_tables x_tables ipv6 powernow_k8
binfmt_misc snd_hda_codec_atihdmi snd_hda_codec_realtek snd_hda_intel
snd_hda_codec ide_cd_mod cdrom snd_pcm ohci1394 pata_atiixp
ide_pci_generic btusb bluetooth usblp ppdev pwc snd_timer ieee1394 snd
snd_page_alloc parport_pc k10temp i2c_piix4 sata_sil24 atiixp floppy
button sg parport dm_mirror dm_region_hash dm_log ohci_hcd ehci_hcd
[last unloaded: scsi_wait_scan]
Pid: 13, comm: ksoftirqd/3 Not tainted 2.6.30.1 #10
Call Trace:
 <IRQ>  [<ffffffff8023e943>] ? warn_slowpath_common+0x73/0xb0
 [<ffffffff8023e9e0>] ? warn_slowpath_fmt+0x40/0x50
 [<ffffffff80390ee1>] ? strlcpy+0x41/0x50
 [<ffffffff804ea9fc>] ? dev_watchdog+0x20c/0x220
 [<ffffffff80553c02>] ? _spin_unlock_irqrestore+0x12/0x30
 [<ffffffff80237b37>] ? try_to_wake_up+0x117/0x250
 [<ffffffff804ea7f0>] ? dev_watchdog+0x0/0x220
 [<ffffffff80248890>] ? run_timer_softirq+0x170/0x250
 [<ffffffff8024406b>] ? __do_softirq+0x6b/0xf0
 [<ffffffff8020c3ec>] ? call_softirq+0x1c/0x30
 <EOI>  [<ffffffff8020e095>] ? do_softirq+0x35/0x70
 [<ffffffff80243a63>] ? ksoftirqd+0x83/0x1a0
 [<ffffffff802439e0>] ? ksoftirqd+0x0/0x1a0
 [<ffffffff80254884>] ? kthread+0x54/0xa0
 [<ffffffff8023ba7a>] ? schedule_tail+0x2a/0x70
 [<ffffffff8020c2ea>] ? child_rip+0xa/0x20
 [<ffffffff80254830>] ? kthread+0x0/0xa0
 [<ffffffff8020c2e0>] ? child_rip+0x0/0x20
---[ end trace 342550263adf85bc ]---
