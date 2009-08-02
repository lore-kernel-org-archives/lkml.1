Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbZHBFQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbZHBFQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 01:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbZHBFQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 01:16:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:43248 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750784AbZHBFQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 01:16:58 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19t8D0bx49tkBkUEe85s6o4yiL6tN9q3JNF8z2msc
	ZxU2le11aJOG0t
Subject: Re: rt2800usb: memory corruption?
From: Mike Galbraith <efault@gmx.de>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1249172514.3043.7.camel@ct>
References: <1248945770.7910.24.camel@marge.simson.net>
	 <1248946195.8925.9.camel@johannes.local>
	 <1248947099.8396.6.camel@marge.simson.net>
	 <1248947740.8925.12.camel@johannes.local>
	 <1248948326.8823.4.camel@marge.simson.net>
	 <1248955916.7995.47.camel@marge.simson.net>
	 <1249104348.7146.60.camel@marge.simson.net>
	 <1249124154.8236.5.camel@marge.simson.net>  <1249172514.3043.7.camel@ct>
Content-Type: text/plain
Date: Sun, 02 Aug 2009 07:16:49 +0200
Message-Id: <1249190209.7486.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-01 at 20:21 -0400, Pavel Roskin wrote:
> On Sat, 2009-08-01 at 12:55 +0200, Mike Galbraith wrote:
> 
> > Enabled slub/pagealloc debugging.  First down/rmmod said...
> 
> I suggest that you try kmemcheck.  It's very slow, but it finds memory
> problems when they occur, not when it's too late.
> 
> You may want to disable kmemleak and framebuffer support and make sure
> that X doesn't start, at it will be too slow.  Slub debugging might
> conflict with kmemcheck, so it's better to disable it.


I didn't even get as far as down/rmmod.  Kmemcheck fired as soon as the
interface came up.

[  230.954526] rt2800usb 2-5:1.0: firmware: requesting rt2870.bin
[  231.388801] input: rt2800usb as /devices/pci0000:00/0000:00:1a.7/usb2/2-5/2-5:1.0/input/input4
[  232.281796] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  235.428512] wlan0: direct probe to AP 00:1a:4f:9a:d0:12 try 1
[  235.437710] wlan0 direct probe responded
[  235.437740] wlan0: authenticate with AP 00:1a:4f:9a:d0:12
[  235.441546] wlan0: authenticated
[  235.441578] wlan0: associate with AP 00:1a:4f:9a:d0:12
[  235.448697] wlan0: RX AssocResp from 00:1a:4f:9a:d0:12 (capab=0x411 status=0 aid=1)
[  235.448719] wlan0: associated
[  235.495961] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  246.172043] wlan0: no IPv6 routers present
[  282.661880] WARNING: kmemcheck: Caught 64-bit read from uninitialized memory (ffff8800bfb8c9f0)
[  282.670576] 0000000000000000000000000000000000000000000000000000000000000000
[  282.678086]  u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u
[  282.685594]                                  ^
[  282.690079] 
[  282.691571] Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 cpufreq_conservative nf_conntrack nf_defrag_ipv4 cpufreq_ondemand cpufreq_userspace ip_tables cpufreq_powersave acpi_cpufreq ip6table_filter ip6_tables x_tables microcode ipv6 fuse loop dm_mod snd_hda_codec_realtek arc4 ecb i2c_i801 firewire_ohci i2c_core firewire_core snd_hda_intel crc_itu_t rt2800usb snd_hda_codec rt2x00usb sr_mod snd_hwdep ohci1394 rt2x00lib cdrom snd_pcm led_class input_polldev sg snd_timer ieee1394 mac80211 snd usb_storage soundcore snd_page_alloc cfg80211 crc_ccitt usb_libusual e1000e intel_agp rtc_cmos rtc_core rtc_lib button thermal processor usbhid hid sd_mod uhci_hcd ehci_hcd usbcore edd fan ext3 mbcache jbd ahci libata scsi_mod
[  282.775664] Pid: 5857, comm: rpcinfo Not tainted 2.6.31-smp #1005 MS-7502
[  282.782444] RIP: 0010:[<ffffffff8123f6e3>]  [<ffffffff8123f6e3>] sk_clone+0x23/0x290
[  282.790215] RSP: 0018:ffff88000156bb98  EFLAGS: 00010286
[  282.795521] RAX: ffff8800bfb8c800 RBX: ffff8800bfb8c800 RCX: 0000000000000000
[  282.802645] RDX: 0000000000000020 RSI: 0000000000000002 RDI: ffff8800bfb8c800
[  282.809769] RBP: ffff88000156bba8 R08: 0000000000000004 R09: ffff8800be46c838
[  282.816895] R10: 0000000000000000 R11: 000000000100007f R12: ffff8800bfb88000
[  282.824021] R13: ffff8800be8eed00 R14: ffff8800bfb88000 R15: ffff8800bfb88000
[  282.831149] FS:  00007f2e15b5a6f0(0000) GS:ffff880001568000(0000) knlGS:0000000000000000
[  282.839230] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  282.844966] CR2: ffff8800377da024 CR3: 00000000b3c2c000 CR4: 00000000000006f0
[  282.852089] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  282.859213] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[  282.866336]  [<ffffffff8127f321>] inet_csk_clone+0x11/0xc0
[  282.871829]  [<ffffffff81297c8e>] tcp_create_openreq_child+0x1e/0x420
[  282.878282]  [<ffffffff81296b18>] tcp_v4_syn_recv_sock+0x48/0x280
[  282.884383]  [<ffffffff812979ad>] tcp_check_req+0x1dd/0x4a0
[  282.889964]  [<ffffffff81295c74>] tcp_v4_do_rcv+0x324/0x430
[  282.895561]  [<ffffffff81296414>] tcp_v4_rcv+0x694/0x880
[  282.900887]  [<ffffffff812751d1>] ip_local_deliver_finish+0xd1/0x230
[  282.907249]  [<ffffffff812753bd>] ip_local_deliver+0x8d/0xa0
[  282.912917]  [<ffffffff81274b5e>] ip_rcv_finish+0x19e/0x3f0
[  282.918498]  [<ffffffff81275071>] ip_rcv+0x2c1/0x350
[  282.923473]  [<ffffffff8124c164>] netif_receive_skb+0x314/0x5f0
[  282.929405]  [<ffffffff8124c4b5>] process_backlog+0x75/0xc0
[  282.934985]  [<ffffffff8124ccc8>] net_rx_action+0x108/0x210
[  282.940567]  [<ffffffff8104e972>] __do_softirq+0xe2/0x1c0
[  282.945975]  [<ffffffff8100cf5c>] call_softirq+0x1c/0x30
[  282.951294]  [<ffffffff8100ee65>] do_softirq+0x45/0x80
[  282.956441]  [<ffffffff8104e745>] local_bh_enable_ip+0xa5/0xb0
[  282.962284]  [<ffffffff812f542f>] _spin_unlock_bh+0xf/0x20
[  282.967779]  [<ffffffff8123e567>] release_sock+0xb7/0xd0
[  282.973098]  [<ffffffff812a4cb6>] inet_stream_connect+0x186/0x2c0
[  282.979200]  [<ffffffff8123c938>] sys_connect+0xb8/0xd0
[  282.984434]  [<ffffffff8100be2b>] system_call_fastpath+0x16/0x1b
[  282.990447]  [<ffffffffffffffff>] 0xffffffffffffffff
[  328.666950] martian source 192.168.178.31 from 192.168.178.23, on dev wlan0
[  328.670921] ll header: ff:ff:ff:ff:ff:ff:00:0c:76:67:11:5a:08:06


