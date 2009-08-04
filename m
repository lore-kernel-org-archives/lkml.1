Return-Path: <linux-kernel-owner+w=401wt.eu-S933039AbZHDVoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbZHDVoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 17:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932728AbZHDVoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 17:44:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:16868 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700AbZHDVoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 17:44:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,323,1246863600"; 
   d="scan'208";a="538597525"
Subject: Re: regression IWl3945 - doesn't work with recent 2.6.30-rcX
From: reinette chatre <reinette.chatre@intel.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       johannes@sipsolutions.net
In-Reply-To: <c4e36d110908040807s1778f392o941748fd2c373d4a@mail.gmail.com>
References: <c4e36d110904220333u37304c79k6ab528f92b5f3718@mail.gmail.com>
	 <20090422140107.GD3288@tuxdriver.com>
	 <c4e36d110904241218x209a4b76kf271f7288f1a33da@mail.gmail.com>
	 <c4e36d110904270059m3e43d6ccl18cc2ec6954e5649@mail.gmail.com>
	 <1240959723.1207.104.camel@rc-desk>
	 <c4e36d110908040807s1778f392o941748fd2c373d4a@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 14:44:20 -0700
Message-Id: <1249422260.30019.4553.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zdenek,

>From what I can tell you have now recycled this thread for a third
distinct issue. Please start a new thread when you encounter a new
issue. 

On Tue, 2009-08-04 at 08:07 -0700, Zdenek Kabelac wrote:
> I'm not sure how it's related together - but this message I've got
> today with 2.6.31-rc5.
> Should I create a new report - or is it still the same not yet fixed issue ?

If you are referring to the locking issue then please see
http://bugzilla.kernel.org/show_bug.cgi?id=13224 Patch is in 2.6.31.


> 
> iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms.
> iwl3945 0000:03:00.0: Error setting new configuration (-110).
> iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
> iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms.
> iwl3945 0000:03:00.0: Error setting new configuration (-110).
> iwl3945 0000:03:00.0: Error sending REPLY_RXON: time out after 500ms.
> iwl3945 0000:03:00.0: Error setting new configuration (-110).
> iwl3945 0000:03:00.0: Error sending REPLY_TX_PWR_TABLE_CMD: time out
> after 500ms.

Your device stops responding here. How do you trigger this?

> ------------[ cut here ]------------
> WARNING: at net/mac80211/scan.c:281
> ieee80211_scan_completed+0xf1/0x4d0 [mac80211]()
> Hardware name: 6464CTO
> Modules linked in: oprofile fuse ipt_MASQUERADE iptable_nat nf_nat
> nf_conntrack_ipv4 nf_defrag_ipv4 xt_state ipt_REJECT xt_tcpudp
> iptable_filter ip_tables x_tables bridge stp llc sunrpc autofs4 ipv6
> nf_conntrack_ftp nf_conntrack binfmt_misc dm_mirror dm_region_hash
> dm_log dm_mod kvm_intel kvm i915 drm i2c_algo_bit uinput
> snd_hda_codec_analog arc4 ecb dvb_core cryptomgr videodev aead
> v4l1_compat v4l2_compat_ioctl32 snd_hda_intel snd_hda_codec
> snd_seq_oss pcompress crypto_blkcipher crypto_hash crypto_algapi btusb
> snd_seq_midi_event snd_seq iwl3945 sdhci_pci iwlcore snd_seq_device
> sdhci bluetooth mac80211 snd_pcm_oss mmc_core cfg80211 snd_mixer_oss
> snd_pcm snd_timer i2c_i801 snd sr_mod i2c_core psmouse iTCO_wdt video
> cdrom soundcore usbhid hid evdev thinkpad_acpi led_class serio_raw
> iTCO_vendor_support intel_agp snd_page_alloc rtc_cmos rtc_core rtc_lib
> rfkill e1000e backlight output nvram battery button ac uhci_hcd
> ohci_hcd ehci_hcd usbcore [last unloaded: microcode]
> Pid: 1007, comm: iwl3945 Tainted: G        W  2.6.31-rc5-00002-g43e068f #79
> Call Trace:
>  [<ffffffff8104c4eb>] warn_slowpath_common+0x7b/0xc0
>  [<ffffffffa0232040>] ? iwl_bg_scan_completed+0x0/0x100 [iwlcore]
>  [<ffffffff8104c544>] warn_slowpath_null+0x14/0x20
>  [<ffffffffa01c88f1>] ieee80211_scan_completed+0xf1/0x4d0 [mac80211]
>  [<ffffffff8105904a>] ? del_timer_sync+0x7a/0xa0
>  [<ffffffff81058fd0>] ? del_timer_sync+0x0/0xa0
>  [<ffffffffa0232040>] ? iwl_bg_scan_completed+0x0/0x100 [iwlcore]
>  [<ffffffffa023208f>] iwl_bg_scan_completed+0x4f/0x100 [iwlcore]
>  [<ffffffff810613d8>] worker_thread+0x1e8/0x3a0
>  [<ffffffff81061386>] ? worker_thread+0x196/0x3a0
>  [<ffffffff8137c11b>] ? thread_return+0x3e/0x703
>  [<ffffffff81066d60>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffff810611f0>] ? worker_thread+0x0/0x3a0
>  [<ffffffff8106697e>] kthread+0x9e/0xb0
>  [<ffffffff8100d1da>] child_rip+0xa/0x20
>  [<ffffffff8100cb7c>] ? restore_args+0x0/0x30
>  [<ffffffff810668e0>] ? kthread+0x0/0xb0
>  [<ffffffff8100d1d0>] ? child_rip+0x0/0x20
> ---[ end trace 6ac8f069d92dd485 ]---

I think I can see how this could happen. From what I can tell there is
no checking if a scan is in progress when userspace triggers a new scan.
ieee80211_scan -> ieee80211_request_scan -> __ieee80211_start_scan
without local->hw_scanning or local->sw_scanning being checked.

Considering this the above warning could happen in the following
scenario:
* userspace triggers scan, this sets local->hw_scanning and goes off
scanning
* userspace triggers another scan, even though local->hw_scanning is set
it continues anyway and calls the drivers scanning function, this
function returns error (which will cause ieee80211_scan_completed to be
called) or calls ieee80211_scan_completed immediately because it is
still busy with previous scan
* now original scan completes and it tries to call
ieee80211_scan_completed, but this triggers the warning because previous
call of ieee80211_scan_completed cleared local->hw_scanning

Johannes, does this seem possible?

Reinette



