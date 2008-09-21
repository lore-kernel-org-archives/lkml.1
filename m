Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbYIUPqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbYIUPqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 11:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYIUPq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 11:46:28 -0400
Received: from fmailhost05.isp.att.net ([207.115.11.55]:34112 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYIUPq1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 11:46:27 -0400
X-Originating-IP: [74.251.44.253]
Date: Sun, 21 Sep 2008 10:46:25 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: linux-kernel@vger.kernel.org
Subject: Console not capturing call trace
Message-ID: <20080921104625.655f55df@osprey.hogchain.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAIVBMVEV2dXOAgYNxSD+aemaal42A
 gIBqYV2UU07Ik5GXfoFMRTdbKiVwAAACbUlEQVQ4jXXTzWvbMBQAcG3EZsmt0Owc3pgNPo1oxNFt
 pQnEN3Wrs3UnkdXq5tOwIdq9Pci3gUqJexo55KC/cs9O/dHBRIiMfpb03rNE4v800jxIQRzsXPEP
 jDwndhNelo9/ngE/SFdKmZQnfOT0YSSlQBKLiJBDH6w9SPwlp5evpduDr9biQqkV8Rh7p4NRNSO1
 4BHhpjLpIK2gWksIgl0LPLCHoBIcX6dp2kGKMYnfGJnjIFungZeuHA6dhSvqLXrA1zJmVKayCu1w
 DKuGAU+WZRRCsLdBFXgLl2Sw3N2ZEJDAn3VwEV9FK12YUGW+yqlIWiD30U5rbSi2efGuhRfxEXRB
 8e+uJE/AL5z78xrqVg6aBHlMTj9V7x/RJOMGHHI11ItVUW+B0JakkGPcUsJNHuY7/ZA04X4xwQ/D
 3I0FGgaT8iFponoJ26F+sNbu51O7l7QHHtNTbxMc5o/W+kw0S31Ub5i+pQBq/hjYPVPbJ/ic/aoC
 pbTQtxlAvvnZgNod89Y4D2sFXpMHZWU1yHb6Ft+g2aTJY84iY2iY4ySGmWdvmxlDprHkCgd1yDRV
 bXVfFQiZjyuyaU5p1pZkTbXBbxRagAyU2rZfcH2tTQ7+FpNQ4Ofb7lxdFzTHDGqAvHdEv0cIezi2
 be+0vzdUqawaDSATHfB7itGiIfrQu2p8UQOOooHTh5lUPn6lva/qQrWwQpCUTv08hGe3dkU9KWmJ
 Z2EGpAeDFc3kN8oMNbNJ/AzMFERUhjmehB7ws6XBTTnfeOXT9T/C9dn4HEshpPWIjDvgi5Px2U0G
 Hl7dzaQHg8U4Xn6oa4g3vVnqLz3ribDLdyFmAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm thinking this may be a userspace issue, but most users don't hack
network drivers and don't encounter kernel warnings and oopses, and
therefore aren't likely to encounter this, so I'm bringing it to the
kernel list (especially those who run Fedora) for assistance/opinions.

The problem:  I no longer get full module lists and call traces on the
console for a WARN_ON (for example).  I run Fedora 9 and its current
version of rsyslog-3.18.1-2.fc9.x86_64.  Reverting to
rsyslog-3.14.1-2.fc9.x86_64 or advancing to
rsyslog-3.21.3-3.fc10.x86_64 didn't seem to help.  

For test purposes I inserted a WARN_ON(1) statement in the atl1 driver,
and dmesg shows the output just fine, but /var/log/messages and my
serial console both fail to show the module list and call trace.
(Evidence below.)

One thing I can't figure out is where the "<8>" comes from in
the serial console output down at the bottom of this message.
Backstepping from warn_on_slowpath() to print_modules() in the kernel
code doesn't seem to show an <8> printed anywhere.  I've got 
/proc/sys/kernel/printk set to 8 8 8 8, so maybe that's related?

Has anyone else encountered this or know which rsyslogd knob to tweak
to enable the full modules list and call trace?  I've verified the
condition occurs with current git, 2.6.26.3, and 2.6.25.16 kernels, so I
think it's not a kernel problem.  It *used* to work fine, but I can't 
remember when it stopped doing so.

>From dmesg, which is what the output *should* look like.

[ 3487.555651] ------------[ cut here ]------------
[ 3487.569484] WARNING: at drivers/net/atlx/atl1.c:2735 atl1_open+0x40/0x51 [atl1]()
[ 3487.569485] Modules linked in: sit tunnel4 fuse nf_conntrack_ipv4 ipt_REJECT iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 cpufreq_ondemand dm_mirror dm_log dm_multipath dm_mod snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event atl2 snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_hwdep i2c_i801 snd soundcore i2c_core atl1 ppdev parport_pc iTCO_wdt mii iTCO_vendor_support sg pcspkr parport sr_mod floppy cdrom ata_generic ata_piix libata dock sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
[ 3487.569526] Pid: 3730, comm: ip Tainted: G        W 2.6.27-rc6 #17
[ 3487.569528] 
[ 3487.569528] Call Trace:
[ 3487.569535]  [<ffffffff8103c719>] warn_on_slowpath+0x5d/0x84
[ 3487.569539]  [<ffffffff8104625f>] ? mod_timer+0x42/0x47
[ 3487.569543]  [<ffffffff8123196c>] ? __netdev_watchdog_up+0x53/0x62
[ 3487.569546]  [<ffffffff812320c5>] ? netif_carrier_on+0x33/0x38
[ 3487.569551]  [<ffffffffa010c4e8>] ? atl1_check_link+0x250/0x313 [atl1]
[ 3487.569556]  [<ffffffffa010ecc5>] ? atl1_up+0x7ab/0x7df [atl1]
[ 3487.569560]  [<ffffffffa010f3f8>] atl1_open+0x40/0x51 [atl1]
[ 3487.569563]  [<ffffffff812238bb>] dev_open+0x7a/0xb7
[ 3487.569566]  [<ffffffff812231fc>] dev_change_flags+0xb0/0x173
[ 3487.569569]  [<ffffffff8122aec7>] do_setlink+0x27f/0x341
[ 3487.569572]  [<ffffffff81026bc3>] ? kernel_map_pages+0x122/0x12d
[ 3487.569575]  [<ffffffff8122c35e>] rtnl_newlink+0x2db/0x479
[ 3487.569577]  [<ffffffff8122c135>] ? rtnl_newlink+0xb2/0x479
[ 3487.569580]  [<ffffffff8122be83>] ? rtnetlink_rcv+0x1f/0x38
[ 3487.569583]  [<ffffffff8122c065>] rtnetlink_rcv_msg+0x1c9/0x1e7
[ 3487.569585]  [<ffffffff8122be9c>] ? rtnetlink_rcv_msg+0x0/0x1e7
[ 3487.569588]  [<ffffffff8123af45>] netlink_rcv_skb+0x43/0x92
[ 3487.569590]  [<ffffffff8122be92>] rtnetlink_rcv+0x2e/0x38
[ 3487.569593]  [<ffffffff8123a91a>] ? netlink_unicast+0x101/0x278
[ 3487.569595]  [<ffffffff8123aa12>] netlink_unicast+0x1f9/0x278
[ 3487.569599]  [<ffffffff8121cc79>] ? __alloc_skb+0x6b/0x131
[ 3487.569601]  [<ffffffff8123ad14>] netlink_sendmsg+0x283/0x296
[ 3487.569604]  [<ffffffff812a7ab1>] ? do_page_fault+0x6de/0xaf8
[ 3487.569607]  [<ffffffff8121cc79>] ? __alloc_skb+0x6b/0x131
[ 3487.569609]  [<ffffffff81215d67>] sock_sendmsg+0x102/0x125
[ 3487.569613]  [<ffffffff81050ce5>] ? autoremove_wake_function+0x0/0x3d
[ 3487.569616]  [<ffffffff81050ce5>] ? autoremove_wake_function+0x0/0x3d
[ 3487.569618]  [<ffffffff812167cf>] ? move_addr_to_kernel+0x45/0x4e
[ 3487.569621]  [<ffffffff8121d9d3>] ? verify_iovec+0x54/0x95
[ 3487.569623]  [<ffffffff81215f0e>] sys_sendmsg+0x184/0x1e8
[ 3487.569625]  [<ffffffff81216bf1>] ? sys_recvmsg+0x132/0x1ac
[ 3487.569630]  [<ffffffff81145a41>] ? __up_write+0x24/0xff
[ 3487.569632]  [<ffffffff81145b0d>] ? __up_write+0xf0/0xff
[ 3487.569636]  [<ffffffff810745e7>] ? audit_syscall_entry+0x12b/0x15f
[ 3487.569639]  [<ffffffff8100c18a>] system_call_fastpath+0x16/0x1b
[ 3487.569640] 
[ 3487.569642] ---[ end trace 144a207f2e9d6a37 ]---


>From /var/log/messages.  Note the module list and call trace don't 
show up at all.

Sep 21 08:57:46 osprey kernel: [ 3487.555651] ------------[ cut here ]------------
Sep 21 08:57:46 osprey kernel: [ 3487.569484] WARNING: at drivers/net/atlx/atl1.c:2735 atl1_open+0x40/0x51 [atl1]()
Sep 21 08:57:46 osprey kernel: [ 3487.569642] ---[ end trace 144a207f2e9d6a37 ]---


>From minicom on my serial console.  Note the <8> at the beginning of
the third line.  Relevant?  Maybe rsyslogd sees this as some sort of
"don't display me" symbol?

[ 3487.555651] ------------[ cut here ]------------
[ 3487.569484] WARNING: at drivers/net/atlx/atl1.c:2735 atl1_open+0x40/0x51 [atl1]() 
<8>[ 3487.569485] Modules linked in: sit tunnel4 fuse nf_conntrack_ipv4 ipt_REJECT iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_-

Thanks,
Jay
