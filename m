Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbZJAWYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbZJAWYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZJAWYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:24:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50035 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbZJAWYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:24:21 -0400
Date: Fri, 2 Oct 2009 00:24:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
Subject: Re: 2.6.32-rc0-git: oops in wireless, iwl3945 related?
Message-ID: <20091001222413.GB10893@elf.ucw.cz>
References: <20090929171249.GB14405@elf.ucw.cz> <1254431783.3959.45.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254431783.3959.45.camel@johannes.local>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-10-01 23:16:23, Johannes Berg wrote:
> On Tue, 2009-09-29 at 19:12 +0200, Pavel Machek wrote:
> > 
> > Happened while playing with wireless.
> > 
> > Kernel is:
> > 
> > Linux version 2.6.31 (pavel@amd) (gcc version 4.3.3 (Debian 4.3.3-10)
> > ) #72 SMP Thu Sep 10 21:56:19 CEST 2009
> > KERNEL supported cpus:
> > 
> > (Could we get kernels between release and -rc1 mark themselves
> > somehow?)
> 
> CONFIG_LOCALVERSION_AUTO?

Well, I'd really like Linus to change extraversion as to -rc0 as first
commit after release...

> > Registered led device: iwl-phy0::radio
> > Registered led device: iwl-phy0::assoc
> > Registered led device: iwl-phy0::RX
> > Registered led device: iwl-phy0::TX
> > wlan0: Selected IBSS BSSID 02:18:41:de:3f:02 based on configured SSID
> > wlan0: Trigger new scan to find an IBSS to join
> > wlan0: Trigger new scan to find an IBSS to join
> > wlan0: Creating new IBSS network, BSSID f2:d3:80:82:ed:6a
> > wlan0: Creating new IBSS network, BSSID 52:17:bf:45:d6:9d
> > skb_over_panic: text:c07b4113 len:130 put:36 head:e4c3edf0
> 
> This entire log is very odd ... can you reproduce this easily? printk
> timestamps would be useful.

Not sure. I was trying to setup adhoc network, randomly running
scripts and pushing interfaces up and down. But I do have timestamps:

Drat. What is going on? I guess this is from another instance; looks
like I did not even notice it. text: address is same so that should be
same version...?

								Pavel

Sep 28 22:08:34 amd wpa_supplicant[1984]: Failed to initiate AP scan.
Sep 28 22:08:34 amd wpa_supplicant[1984]: No network configuration
found for the current AP
Sep 28 22:08:44 amd wpa_supplicant[1984]: No network configuration
found for the current AP
Sep 28 22:08:44 amd wpa_supplicant[1984]: CTRL-EVENT-SCAN-RESULTS 
Sep 28 22:08:44 amd wpa_supplicant[1984]: WPS-AP-AVAILABLE 
Sep 28 22:08:49 amd wpa_supplicant[1984]: Failed to initiate AP scan.
Sep 28 22:08:51 amd dhclient: DHCPREQUEST on wlan0 to 192.168.1.1 port
67
Sep 28 22:08:51 amd dhclient: send_packet: Network is unreachable
Sep 28 22:08:51 amd dhclient: send_packet: please consult README file
regarding broadcast address.
Sep 28 22:08:52 amd dhclient: receive_packet failed on wlan0: Network
is down
Sep 28 22:08:52 amd modprobe: FATAL: Could not load
/lib/modules/2.6.31/modules.dep: No such file or directory 
Sep 28 22:08:58 amd dhclient: DHCPREQUEST on wlan0 to 192.168.1.1 port
67
Sep 28 22:08:58 amd dhclient: send_packet: Network is unreachable
Sep 28 22:08:58 amd dhclient: send_packet: please consult README file
regarding broadcast address.
Sep 28 22:08:59 amd wpa_supplicant[1984]: Failed to initiate AP scan.
Sep 28 22:09:02 amd kernel: Registered led device: iwl-phy0::radio
Sep 28 22:09:02 amd kernel: Registered led device: iwl-phy0::assoc
Sep 28 22:09:02 amd kernel: Registered led device: iwl-phy0::RX
Sep 28 22:09:02 amd kernel: Registered led device: iwl-phy0::TX
Sep 28 22:09:02 amd wpa_supplicant[1984]: No network configuration
found for the current AP
Sep 28 22:09:11 amd wpa_supplicant[1984]: CTRL-EVENT-SCAN-RESULTS 
Sep 28 22:09:11 amd wpa_supplicant[1984]: No network configuration
found for the current AP
Sep 28 22:09:11 amd kernel: skb_over_panic: text:c07b4113 len:130
put:36 head:e4c3edf0 data:e4c3edf0 tail:0xe4c3ee72 end:0xe4c3ee70
dev:<NULL>
Sep 28 22:09:11 amd kernel: ------------[ cut here ]------------
Sep 28 22:09:11 amd kernel: kernel BUG at net/core/skbuff.c:127!
Sep 28 22:09:11 amd kernel: invalid opcode: 0000 [#1] SMP
DEBUG_PAGEALLOC
Sep 28 22:09:11 amd kernel: last sysfs file:
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/status
Sep 28 22:09:11 amd kernel: Modules linked in:
Sep 28 22:09:11 amd kernel: 
Sep 28 22:09:11 amd kernel: Pid: 1353, comm: iwl3945 Not tainted
(2.6.31 #72) 17097HU
Sep 28 22:09:11 amd kernel: EIP: 0060:[<c06d7189>] EFLAGS: 00010286
CPU: 0
Sep 28 22:09:11 amd kernel: EIP is at skb_put+0x89/0x90
Sep 28 22:09:11 amd kernel: EAX: 00000079 EBX: e4c3ee72 ECX: c0230881
EDX: 01eef000
Sep 28 22:09:11 amd kernel: ESI: 00000024 EDI: f5e20fc0 EBP: f5dcde04
ESP: f5dcddd8
Sep 28 22:09:11 amd kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS:
0068
Sep 28 22:09:11 amd kernel: Process iwl3945 (pid: 1353, ti=f5dcc000
task=f72e4698 task.ti=f5dcc000)
Sep 28 22:09:11 amd kernel: Stack:
Sep 28 22:09:11 amd kernel:  c0a28c24 c07b4113 00000082 00000024
e4c3edf0 e4c3edf0 e4c3ee72 e4c3ee70
Sep 28 22:09:11 amd kernel: <0> c09ac8b9 0000009c 66666667 f5dcde74
c07b4113 00000037 00000007 00000282
Sep 28 22:09:11 amd kernel: <0> 00000002 00000000 00000040 00000006
00000064 f5e1bbc0 f5e1be23 c03e82b1
Sep 28 22:09:11 amd kernel: Call Trace:
Sep 28 22:09:11 amd kernel:  [<c07b4113>] ?
__ieee80211_sta_join_ibss+0x143/0x3d0
Sep 28 22:09:11 amd kernel:  [<c07b4113>] ?
__ieee80211_sta_join_ibss+0x143/0x3d0
Sep 28 22:09:11 amd kernel:  [<c03e82b1>] ? extract_entropy+0x51/0xa0
Sep 28 22:09:11 amd kernel:  [<c07b4677>] ?
ieee80211_sta_find_ibss+0x227/0x450
Sep 28 22:09:11 amd kernel:  [<c07fcdc2>] ?
mutex_lock_nested+0x1c2/0x230
Sep 28 22:09:11 amd kernel:  [<c07b48b7>] ?
ieee80211_ibss_notify_scan_completed+0x17//var/log/syslog
Sep 28 22:09:11 amd kernel:  [<c07b4909>] ?
ieee80211_ibss_notify_scan_completed+0x69/0x80
Sep 28 22:09:11 amd kernel:  [<c07b1b85>] ?
ieee80211_scan_completed+0xc5/0x450
Sep 28 22:09:11 amd kernel:  [<c0239e29>] ? del_timer_sync+0x59/0x70
Sep 28 22:09:11 amd kernel:  [<c0239dd0>] ? del_timer_sync+0x0/0x70
Sep 28 22:09:11 amd kernel:  [<c052a4df>] ?
iwl_bg_scan_completed+0x3f/0x80
Sep 28 22:09:11 amd kernel:  [<c024089d>] ? worker_thread+0x16d/0x280
Sep 28 22:09:11 amd kernel:  [<c024083a>] ? worker_thread+0x10a/0x280
Sep 28 22:09:11 amd kernel:  [<c052a4a0>] ?
iwl_bg_scan_completed+0x0/0x80
Sep 28 22:09:11 amd kernel:  [<c02449d0>] ?
autoremove_wake_function+0x0/0x50
Sep 28 22:09:11 amd kernel:  [<c0240730>] ? worker_thread+0x0/0x280
Sep 28 22:09:11 amd kernel:  [<c02446dc>] ? kthread+0x7c/0x90
Sep 28 22:09:11 amd kernel:  [<c0244660>] ? kthread+0x0/0x90
Sep 28 22:09:11 amd kernel:  [<c020385f>] ?
kernel_thread_helper+0x7/0x18
Sep 28 22:09:11 amd kernel: Code: 44 24 14 8b 81 a0 00 00 00 89 74 24
0c 89 44 24 10 8b 41 50 c7 04 24 24 8c a2 c0 89 44 24 08 8b 45 04 89
44 24 04 e8 a7 40 12 00 <0f> 0b eb fe 8d 76 00 55 89 e5 57 56 53 83 ec
18 89 45 e4 89 55 
Sep 28 22:09:11 amd kernel: EIP: [<c06d7189>] skb_put+0x89/0x90 SS:ESP
0068:f5dcddd8
Sep 28 22:09:11 amd kernel: ---[ end trace 5d5762000564cd5a ]---
Sep 28 22:09:12 amd dhclient: DHCPREQUEST on wlan0 to 192.168.1.1 port
67
Sep 28 22:09:12 amd dhclient: send_packet: Network is unreachable
Sep 28 22:09:12 amd dhclient: send_packet: please consult README file
regarding broadcast address.
Sep 28 22:09:29 amd dhclient: DHCPREQUEST on wlan0 to 192.168.1.1 port
67
Sep 28 22:09:29 amd dhclient: send_packet: Network is unreachable
Sep 28 22:09:29 amd dhclient: send_packet: please consult README file
regarding broadcast address.
Sep 28 22:09:44 amd dhclient: DHCPREQUEST on wlan0 to 192.168.1.1 port
67
Sep 28 22:09:44 amd dhclient: send_packet: Network is unreachable
Sep 28 22:09:44 amd dhclient: send_packet: please consult README file
regarding broadc/var/log/syslog lines 147505-147530/155914 94%






-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
