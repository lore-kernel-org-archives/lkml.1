Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZKVRhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZKVRhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 12:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbZKVRhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 12:37:23 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:48007 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbZKVRhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 12:37:21 -0500
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Nov 2009 12:37:21 EST
Date: Sun, 22 Nov 2009 12:07:04 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: PROBLEM: 2.6.32-rc8 panic - sky2 (I think)
To: linux-kernel@vger.kernel.org
Message-id: <4B096FB8.20708@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[my first report to this list... please be kind]
Kernel built from current git master branch - also with current nouveau 
driver (from xfree.org git).

Problem: during a period of relative inactivity (middle of the night), 
the system crashed. I've got kernel trace output in the logs that point 
towards the sky2 driver (see below). The errors were for eth0, eth1 
(dual-nic motherboard) was unaffected.

There were no relevant log messages indicating anything abnormal prior 
to the time of the initial kernel trace. A Subsequent to the trace, eth0 
was bouncing up and down (Fedora network manager kept trying to bring 
the network back up). Each time the adapter came back up, I see DHCP 
Discover, offer and ack messages for each connected device. It appears 
that the link would go back down before the completion of DCHP activity. 
The only trace is for the first event; subsequently, I just see sky2 
eth0: tx timeout; disabling interface and enabling interface messages.

Oddly, this cycle continued for one hour (down to the second), at which 
time the system rebooted. There were no messages indicating anything 
about final reason for the reboot.

Log extract:

Nov 22 06:14:01 mail kernel: DRHD: handling fault status reg 302
Nov 22 06:14:01 mail kernel: DMAR:[DMA Read] Request device [06:00.0] 
fault addr fff742bfe000
Nov 22 06:14:01 mail kernel: DMAR:[fault reason 06] PTE Read access is 
not set
Nov 22 06:14:01 mail kernel: sky2 0000:06:00.0: error interrupt 
status=0xc0000000
Nov 22 06:14:01 mail kernel: sky2 0000:06:00.0: PCI hardware error (0x2010)
Nov 22 06:14:01 mail smbd[6750]: [2009/11/22 06:14:01,  0] 
lib/util_sock.c:539(read_fd_with_timeout)
Nov 22 06:14:01 mail smbd[6750]: [2009/11/22 06:14:01,  0] 
lib/util_sock.c:1491(get_peer_addr_internal)
Nov 22 06:14:01 mail smbd[6750]:   getpeername failed. Error was 
Transport endpoint is not connected
Nov 22 06:14:01 mail smbd[6750]:   read_fd_with_timeout: client 0.0.0.0 
read error = Connection timed out.
Nov 22 06:14:32 mail kernel: ------------[ cut here ]------------
Nov 22 06:14:32 mail kernel: WARNING: at net/sched/sch_generic.c:261 
dev_watchdog+0xf3/0x164()
Nov 22 06:14:32 mail kernel: Hardware name: System Product Name
Nov 22 06:14:32 mail kernel: NETDEV WATCHDOG: eth0 (sky2): transmit 
queue 0 timed out
Nov 22 06:14:32 mail kernel: Modules linked in: tun iptable_raw 
iptable_mangle ipt_MASQUERADE iptable_nat nf_nat bridge stp appletalk 
psnap llc nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc hwmon_vid 
coretemp acpi_cpufreq sit tunnel4 ipt_LOG nf_conntrack_netbios_ns 
nf_conntrack_ftp nf_conntrack_ipv6 xt_multiport ip6table_filter xt_DSCP 
xt_dscp xt_MARK ip6table_mangle ip6_tables ipv6 dm_multipath raid1 
kvm_intel kvm snd_hda_codec_analog snd_hda_intel snd_ens1371 gameport 
snd_hda_codec snd_rawmidi snd_ac97_codec ac97_bus snd_hwdep snd_seq 
snd_seq_device snd_pcm gspca_spca505 gspca_main snd_timer videodev 
iTCO_wdt snd ata_generic pata_acpi firewire_ohci asus_atk0110 
v4l1_compat i2c_i801 sky2 soundcore v4l2_compat_ioctl32 firewire_core 
pcspkr snd_page_alloc wmi iTCO_vendor_support hwmon crc_itu_t 
pata_marvell raid456 async_raid6_recov async_pq raid6_pq async_xor xor 
async_memcpy async_tx nouveau ttm drm_kms_helper drm agpgart nvidiafb fb 
fb_ddc i2c_algo_bit cfbcopyarea vgastate i2c_core cfbimgblt cfbfillrect [las
Nov 22 06:14:32 mail kernel: t unloaded: nbd]
Nov 22 06:14:32 mail kernel: Pid: 14, comm: ksoftirqd/5 Tainted: 
G        W  2.6.32-rc8 #1
Nov 22 06:14:32 mail kernel: Call Trace:
Nov 22 06:14:32 mail kernel: <IRQ>  [<ffffffff81055319>] 
warn_slowpath_common+0x7c/0x94
Nov 22 06:14:32 mail kernel: [<ffffffff81055388>] 
warn_slowpath_fmt+0x41/0x43
Nov 22 06:14:32 mail kernel: [<ffffffff813f2932>] dev_watchdog+0xf3/0x164
Nov 22 06:14:32 mail kernel: [<ffffffff814803d1>] ? 
sub_preempt_count+0xe/0x4e
Nov 22 06:14:32 mail kernel: [<ffffffff8147d990>] ? 
_spin_unlock_irqrestore+0x67/0x69
Nov 22 06:14:32 mail kernel: [<ffffffff814803d1>] ? 
sub_preempt_count+0xe/0x4e
Nov 22 06:14:32 mail kernel: [<ffffffff81065578>] 
run_timer_softirq+0x1c6/0x284
Nov 22 06:14:32 mail kernel: [<ffffffff813f283f>] ? dev_watchdog+0x0/0x164
Nov 22 06:14:32 mail kernel: [<ffffffff8105cbcd>] __do_softirq+0x115/0x1f6
Nov 22 06:14:32 mail kernel: [<ffffffff81012f0c>] call_softirq+0x1c/0x30
Nov 22 06:14:32 mail kernel: <EOI>  [<ffffffff81014493>] 
do_softirq+0x4b/0xa6
Nov 22 06:14:32 mail kernel: [<ffffffff8105c7ea>] ksoftirqd+0x96/0x167
Nov 22 06:14:32 mail kernel: [<ffffffff8105c754>] ? ksoftirqd+0x0/0x167
Nov 22 06:14:32 mail kernel: [<ffffffff81074f00>] kthread+0x7f/0x87
Nov 22 06:14:32 mail kernel: [<ffffffff81012e0a>] child_rip+0xa/0x20
Nov 22 06:14:32 mail kernel: [<ffffffff8104b073>] ? 
finish_task_switch+0x50/0xa8
Nov 22 06:14:32 mail kernel: [<ffffffff81012741>] ? restore_args+0x0/0x30
Nov 22 06:14:32 mail kernel: [<ffffffff81074e81>] ? kthread+0x0/0x87
Nov 22 06:14:32 mail kernel: [<ffffffff81012e00>] ? child_rip+0x0/0x20
Nov 22 06:14:32 mail kernel: ---[ end trace 57f7151f6a5def07 ]---
Nov 22 06:14:32 mail kernel: sky2 eth0: tx timeout
Nov 22 06:14:32 mail kernel: sky2 eth0: disabling interface
Nov 22 06:14:32 mail kernel: sky2 eth0: enabling interface
Nov 22 06:14:32 mail NetworkManager: <info>  (eth0): carrier now OFF 
(device state 8, deferring action for 4 seconds)
Nov 22 06:14:35 mail kernel: sky2 eth0: Link is up at 1000 Mbps, full 
duplex, flow control both
Nov 22 06:14:35 mail NetworkManager: <info>  (eth0): carrier now ON 
(device state 8)
Nov 22 06:15:16 mail dhcpd: DHCPINFORM from 10.0.0.11 via eth0
Nov 22 06:15:16 mail dhcpd: DHCPACK to 10.0.0.11 (<mac>) via eth0
Nov 22 06:15:19 mail dhcpd: DHCPINFORM from 10.0.0.11 via eth0
Nov 22 06:15:19 mail dhcpd: DHCPACK to 10.0.0.11 (<mac>) via eth0
Nov 22 06:15:20 mail kernel: sky2 eth0: tx timeout
Nov 22 06:15:20 mail kernel: sky2 eth0: disabling interface
Nov 22 06:15:20 mail kernel: sky2 eth0: enabling interface
Nov 22 06:15:20 mail NetworkManager: <info>  (eth0): carrier now OFF 
(device state 8, deferring action for 4 seconds)
<this sequence repeats with increasing numbers of DCHP messages until 
the last recorded message:
Nov 22 07:14:50 mail dhcpd: DHCPOFFER on 10.0.0.55 to <mac> 
(BLACKBERRY-9A83) via eth0
Subsequent messages are boot messages.swdfqx


