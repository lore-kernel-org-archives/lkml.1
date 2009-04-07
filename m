Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbZDGUY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbZDGUY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbZDGUYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:24:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:48962 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbZDGUYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:24:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CMSnkf1iE29ihHgOEX0BGPnAl9NXL9iY9sVHaz6L4Yr/0GAOacZ67x4MmmoO4E8ovK
         wLQ2lBfVBJMZOMxwaKyLZpMzWF88YRMgU46X6tldr0JrwkIrRLiHuDqLwCBS41//fkdP
         HRTqPAyiVpoi5DjCMJBgS08j/qBzJMvX1WNHM=
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239112310.15015.25.camel@maxim-laptop>
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
	 <1239108689.15015.3.camel@maxim-laptop>
	 (sfid-20090407_145137_740898_8D0C40FD)  <1239109001.22453.40.camel@johannes.local>
	 <1239109497.15015.12.camel@maxim-laptop>
	 (sfid-20090407_150534_375314_4DA28551)  <1239110010.22453.41.camel@johannes.local>
	 <1239110412.15015.23.camel@maxim-laptop>
	 (sfid-20090407_152021_060436_AEF9110F)  <1239110860.4084.0.camel@johannes.local>
	 <1239112310.15015.25.camel@maxim-laptop>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 23:24:38 +0300
Message-Id: <1239135878.17958.11.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 16:51 +0300, Maxim Levitsky wrote:
> On Tue, 2009-04-07 at 15:27 +0200, Johannes Berg wrote:
> > On Tue, 2009-04-07 at 16:20 +0300, Maxim Levitsky wrote:
> > 
> > > > Of course, we can go back to dropping the scan request, but that
> > > > wouldn't be very nice.
> > > > 
> > > > Is this creating any problems?
> > 
> > > Yep, but dropping the request won't help ether.
> > 
> > Indeed.
> > 
> > > Problem is that wpa_supplicant will attempt to scan before association,
> > > scan fails (it doesn't know it is already running) thus it waits 10
> > > seconds. (I patched it to wait 2 seconds).
> > > 
> > > It happens if user first disconnects, and then reconnects to a network
> > > (typical test I do for time it takes to connect)
> > > 
> > > Now I patched it not to clear essid on disconnect, and this helped
> > > reduce connect times by about 2 seconds.
> > > 
> > > now it takes just 3~4 seconds to connect to open network, and ~6 seconds
> > > to WPA2 network.
> > > 
> > > (This is with patched dhclient, I reduced its timeouts, but this is
> > > another story.... it seems that first DHCPREQUEST never succeeds, and I
> > > tested this with 2 cards, and few wireless networks)
> > 
> > Have you tried with a new tree and wpa_supplicant's (from git) nl80211
> > driver? Might be a lot better.
> I use NM and wpa_supplicant from -git
> Last time, I tried nl80211 wpa_supplicant driver it didn't work well,
> but I try again soon I  hope.

I have just tried the nl80211 driver.


First I get this in kernel logs:


> [   29.971903] WARNING: at /home/maxim/software/kernel/linux-2.6/net/wireless/core.h:79 nl80211_send_wiphy+0x8bd/0xa20 [cfg80211]()
> [   29.971905] Hardware name: Aspire 5720     
> [   29.971906] Modules linked in: nfsd exportfs ipv6 nfs lockd nfs_acl auth_rpcgss sunrpc cpufreq_powersave cpufreq_conservative cpufreq_userspace acpi_cpufreq coretemp sbp2 uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 joydev iwl3945 iwlcore rfkill uhci_hcd mac80211 snd_hda_codec_realtek psmouse lib80211 video snd_hda_intel snd_hda_codec iTCO_wdt tg3 serio_raw ehci_hcd snd_hwdep snd_pcm_oss snd_mixer_oss sdhci_pci iTCO_vendor_support libphy output cfg80211 ata_piix sdhci nvidia(P) evdev ohci1394 snd_pcm snd_timer snd_page_alloc usbcore ext3 jbd mbcache fuse ahci libata
> [   29.971936] Pid: 3688, comm: wpa_supplicant Tainted: P           2.6.29-wl #18
> [   29.971938] Call Trace:
> [   29.971948]  [<ffffffff80241320>] warn_slowpath+0xd0/0x130
> [   29.971956]  [<ffffffffa08e4ac6>] ? nl80211_get_wiphy+0x56/0xd0 [cfg80211]
> [   29.971960]  [<ffffffff802a8263>] ? __alloc_pages_internal+0xe3/0x4f0
> [   29.971965]  [<ffffffff804ade47>] ? netdev_run_todo+0x57/0x260
> [   29.971972]  [<ffffffffa08e465d>] nl80211_send_wiphy+0x8bd/0xa20 [cfg80211]
> [   29.971979]  [<ffffffffa08e4ac6>] ? nl80211_get_wiphy+0x56/0xd0 [cfg80211]
> [   29.971981]  [<ffffffff802a86ee>] ? __get_free_pages+0x1e/0x60
> [   29.971986]  [<ffffffff804a59ae>] ? __alloc_skb+0x6e/0x140
> [   29.971993]  [<ffffffffa08e4ae4>] nl80211_get_wiphy+0x74/0xd0 [cfg80211]
> [   29.972020]  [<ffffffff804c5986>] genl_rcv_msg+0x1b6/0x1f0
> [   29.972023]  [<ffffffff804c57d0>] ? genl_rcv_msg+0x0/0x1f0
> [   29.972027]  [<ffffffff804c4839>] netlink_rcv_skb+0x89/0xb0
> [   29.972030]  [<ffffffff804c57b7>] genl_rcv+0x27/0x40
> [   29.972032]  [<ffffffff804c4234>] netlink_unicast+0x2c4/0x2e0
> [   29.972035]  [<ffffffff804a59ae>] ? __alloc_skb+0x6e/0x140
> [   29.972038]  [<ffffffff804c4464>] netlink_sendmsg+0x214/0x310
> [   29.972041]  [<ffffffff8049ceb7>] sock_sendmsg+0x127/0x140
> [   29.972045]  [<ffffffff80258c20>] ? autoremove_wake_function+0x0/0x40
> [   29.972049]  [<ffffffff802da0c7>] ? do_lookup+0x147/0x260
> [   29.972052]  [<ffffffff802e375c>] ? dput+0xac/0x160
> [   29.972054]  [<ffffffff8049dd17>] ? move_addr_to_kernel+0x57/0x60
> [   29.972057]  [<ffffffff804a6e7c>] ? verify_iovec+0x3c/0xd0
> [   29.972060]  [<ffffffff8049d059>] sys_sendmsg+0x189/0x320
> [   29.972063]  [<ffffffff8049bf71>] ? sock_ioctl+0x81/0x270
> [   29.972065]  [<ffffffff802dfd21>] ? vfs_ioctl+0x31/0xa0
> [   29.972068]  [<ffffffff802dfe18>] ? do_vfs_ioctl+0x88/0x580
> [   29.972071]  [<ffffffff802d20c9>] ? __fput+0x169/0x1e0
> [   29.972074]  [<ffffffff802e03a9>] ? sys_ioctl+0x99/0xa0
> [   29.972077]  [<ffffffff8020c5db>] system_call_fastpath+0x16/0x1b
> [   29.972079] ---[ end trace b4d9e95705d7d0d8 ]---
> 
> 
> 
Then same -EBUSY errors are present, and this driver even says explictly this.
(This is despite the fact I removed the essid clearing from the wpa_supplicant)
In fact (now I speak about the wext driver) I put printfs in many its functions, and it seems that it only resets encryption keys
before scanning now, and still device seems to be busy.
This ensures that scan occurs twice, and adds up 2~3 seconds to association time, which consists about 40% of all time (~7 seconds)


>  
> 
> Best regards,
> 	Maxim Levitsky
> > 
> > johannes
> 

