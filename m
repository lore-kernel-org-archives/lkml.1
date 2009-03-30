Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbZC3SBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbZC3SBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZC3SA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:00:56 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:35223 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbZC3SAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:00:54 -0400
Date: Mon, 30 Mar 2009 23:29:51 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Dhaval Giani <dhaval.lists@thegianis.in>,
       linville@tuxdriver.com, davem@davemloft.net,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
Message-ID: <20090330175951.GB4199@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1231336282-22283-1-git-send-email-jirislaby@gmail.com> <1231338965-796-1-git-send-email-jirislaby@gmail.com> <20090107152208.GB4207@linux.vnet.ibm.com> <4964CAAA.3040801@gmail.com> <25891f3e0902012357n21e7bc2fmc59fb2a842631651@mail.gmail.com> <20090215134702.GA10180@hash.localnet> <49A9C3D7.8060706@gmail.com> <20090330085952.GB3837@linux.vnet.ibm.com> <b6c5339f0903300958m587cde69o44ae24d0609228ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6c5339f0903300958m587cde69o44ae24d0609228ba@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 12:58:28PM -0400, Bob Copeland wrote:
> On Mon, Mar 30, 2009 at 4:59 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > Where is the fix? Is it merged in? I still see this happen on 2.6.29
> >
> > thanks,
> 
> It's in b726604706ad88d8b28bc487e45e710f58cc19ee in Linus' tree, after
> 2.6.29.  You still might get a warning, but this time from the driver
> side instead of higher up the stack -- if you do please post it.
> 

ok, so my kernel does hve this patch applied, and this is what I get,

 ------------[ cut here ]------------
 WARNING: at include/net/mac80211.h:1956 minstrel_get_rate+0xa1/0x4b9 [mac80211]()
 Hardware name: 2007CS3
 Modules linked in: fuse radeon drm ipt_MASQUERADE iptable_nat nf_nat bridge stp bnep sco l2cap bluetooth ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq dm_multipath kvm_intel kvm uinput snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy arc4 snd_seq_oss snd_seq_midi_event snd_seq ecb ath5k nsc_ircc snd_seq_device snd_pcm_oss video snd_mixer_oss snd_pcm mac80211 snd_timer snd yenta_socket i2c_i801 thinkpad_acpi rfkill irda output iTCO_wdt rsrc_nonstatic pcspkr hwmon cfg80211 joydev i2c_core iTCO_vendor_support soundcore crc_ccitt snd_page_alloc [last unloaded: scsi_wait_scan]
 Pid: 2389, comm: wpa_supplicant Tainted: G        W  2.6.29-tip #28
 Call Trace:
 [<c0431b0e>] warn_slowpath+0x76/0xad
 [<c04523e1>] ? print_lock_contention_bug+0x14/0xd7
 [<c042e874>] ? default_wake_function+0x10/0x12
 [<c04523e1>] ? print_lock_contention_bug+0x14/0xd7
 [<f7d31879>] minstrel_get_rate+0xa1/0x4b9 [mac80211]
 [<c0450fa4>] ? trace_hardirqs_on+0xb/0xd
 [<c0424909>] ? __wake_up+0x36/0x40
 [<f7d272fe>] ? invoke_tx_handlers+0x3b1/0xa50 [mac80211]
 [<f7d21b1e>] rate_control_get_rate+0x7e/0xbe [mac80211]
 [<f7d27330>] invoke_tx_handlers+0x3e3/0xa50 [mac80211]
 [<c0450e61>] ? trace_hardirqs_on_caller+0x18/0x150
 [<f7d26c03>] ? __ieee80211_tx_prepare+0x24b/0x288 [mac80211]
 [<f7d286ad>] ieee80211_master_start_xmit+0x38b/0x4b2 [mac80211]
 [<c069d1f4>] dev_hard_start_xmit+0x219/0x280
 [<c06ac17e>] __qdisc_run+0xca/0x1b0
 [<c069d6de>] dev_queue_xmit+0x398/0x4bf
 [<f7d2a116>] ieee80211_tx_skb+0x53/0x56 [mac80211]
 [<f7d1dac4>] ieee80211_send_deauth_disassoc+0xd7/0xdf [mac80211]
 [<f7d1dbc1>] ieee80211_set_disassoc+0xf5/0x209 [mac80211]
 [<f7d1ddc6>] ieee80211_sta_req_auth+0x47/0x69 [mac80211]
 [<f7d17c5a>] ieee80211_ioctl_siwgenie+0x50/0x5d [mac80211]
 [<c06f9720>] ioctl_standard_call+0x1b4/0x268
 [<c069b3ce>] ? dev_name_hash+0x1b/0x47
 [<c06f92e7>] wext_handle_ioctl+0xe7/0x17d
 [<f7d17c0a>] ? ieee80211_ioctl_siwgenie+0x0/0x5d [mac80211]
 [<c04937ba>] ? might_fault+0x83/0x85
 [<c069f06f>] dev_ioctl+0x5c6/0x5e6
 [<c0690bf3>] ? sockfd_lookup_light+0x1b/0x4e
 [<c0691b65>] ? sys_sendto+0xa9/0xc8
 [<c04cf997>] ? dnotify_parent+0x22/0x63
 [<c0690746>] ? sock_ioctl+0x0/0x1f0
 [<c069092a>] sock_ioctl+0x1e4/0x1f0
 [<c0690746>] ? sock_ioctl+0x0/0x1f0
 [<c04b6d55>] vfs_ioctl+0x27/0x6e
 [<c04b72d4>] do_vfs_ioctl+0x46f/0x4a8
 [<c0691ba1>] ? sys_send+0x1d/0x1f
 [<c04b7352>] sys_ioctl+0x45/0x5f
 [<c04032a4>] sysenter_do_call+0x12/0x38
 ---[ end trace 0e3d1a2e9037b74b ]---


> -- 
> Bob Copeland %% www.bobcopeland.com

-- 
regards,
Dhaval
