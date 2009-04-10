Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbZDJUbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbZDJUbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 16:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936227AbZDJUan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 16:30:43 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55206 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936385AbZDJUak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 16:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ls2rzF7bRdfOnN23UOLLr6pkK14fL39S5JzI5Vxl9yjgwCRfm++w8ZV+glfrYWKWBR
         3jCugm0Snuj3EoOn2OsPLa30UWJlBfy3YTqv/YpKfneuSeEGc/Pgmd4DXQBhTqmwN/l9
         aL9wo0rhhAOEIk81lUpO83UBLLqJv+y+WE5NA=
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239136637.7475.57.camel@johannes.local>
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
	 <1239108689.15015.3.camel@maxim-laptop>
	 (sfid-20090407_145137_740898_8D0C40FD)  <1239109001.22453.40.camel@johannes.local>
	 <1239109497.15015.12.camel@maxim-laptop>
	 (sfid-20090407_150534_375314_4DA28551)  <1239110010.22453.41.camel@johannes.local>
	 <1239110412.15015.23.camel@maxim-laptop>
	 (sfid-20090407_152021_060436_AEF9110F)  <1239110860.4084.0.camel@johannes.local>
	 <1239112310.15015.25.camel@maxim-laptop>
	 <1239135878.17958.11.camel@maxim-laptop>
	 (sfid-20090407_222443_633750_085B264D)  <1239136637.7475.57.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 23:30:34 +0300
Message-Id: <1239395434.13792.3.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 22:37 +0200, Johannes Berg wrote:
> On Tue, 2009-04-07 at 23:24 +0300, Maxim Levitsky wrote:
> 
> > First I get this in kernel logs:
> > 
> > 
> > > [   29.971903] WARNING:
> > at /home/maxim/software/kernel/linux-2.6/net/wireless/core.h:79
> > nl80211_send_wiphy+0x8bd/0xa20 [cfg80211]()
> 
> Eh, I don't think that is present in a recent wireless tree.

It is.

I have just compiled iwlwifi.git tree, and same message is there:



> [ 1666.298390] ------------[ cut here ]------------
> [ 1666.298395] WARNING: at /home/maxim/software/kernel/linux-2.6/net/wireless/core.h:79 nl80211_send_wiphy+0x8bd/0xa20 [cfg80211]()
> [ 1666.298399] Hardware name: Aspire 5720     
> [ 1666.298402] Modules linked in: af_packet nfsd exportfs ipv6 nfs lockd nfs_acl auth_rpcgss sunrpc cpufreq_powersave cpufreq_conservative cpufreq_userspace acpi_cpufreq coretemp sbp2 joydev uvcvideo iwl3945 videodev v4l1_compat v4l2_compat_ioctl32 iwlcore rfkill snd_hda_codec_realtek snd_hda_intel snd_hda_codec mac80211 snd_hwdep ehci_hcd psmouse video iTCO_wdt lib80211 tg3 snd_pcm_oss snd_mixer_oss usbcore output evdev iTCO_vendor_support nvidia(P) cfg80211 libphy serio_raw snd_pcm snd_timer ricoh_mmc sdhci_pci sdhci ohci1394 ata_piix snd_page_alloc ext3 jbd mbcache fuse ahci libata
> [ 1666.298473] Pid: 13164, comm: wpa_supplicant Tainted: P           2.6.29-wl #19
> [ 1666.298477] Call Trace:
> [ 1666.298490]  [<ffffffff80241320>] warn_slowpath+0xd0/0x130
> [ 1666.298504]  [<ffffffffa00f9ac6>] ? nl80211_get_wiphy+0x56/0xd0 [cfg80211]
> [ 1666.298512]  [<ffffffff802a8263>] ? __alloc_pages_internal+0xe3/0x4f0
> [ 1666.298525]  [<ffffffffa00f965d>] nl80211_send_wiphy+0x8bd/0xa20 [cfg80211]
> [ 1666.298537]  [<ffffffffa00f9ac6>] ? nl80211_get_wiphy+0x56/0xd0 [cfg80211]
> [ 1666.298542]  [<ffffffff802a86ee>] ? __get_free_pages+0x1e/0x60
> [ 1666.298550]  [<ffffffff804a59ae>] ? __alloc_skb+0x6e/0x140
> [ 1666.298562]  [<ffffffffa00f9ae4>] nl80211_get_wiphy+0x74/0xd0 [cfg80211]
> [ 1666.298569]  [<ffffffff804c5986>] genl_rcv_msg+0x1b6/0x1f0
> [ 1666.298575]  [<ffffffff804c57d0>] ? genl_rcv_msg+0x0/0x1f0
> [ 1666.298582]  [<ffffffff804c4839>] netlink_rcv_skb+0x89/0xb0
> [ 1666.298586]  [<ffffffff804c57b7>] genl_rcv+0x27/0x40
> [ 1666.298592]  [<ffffffff804c4234>] netlink_unicast+0x2c4/0x2e0
> [ 1666.298597]  [<ffffffff804a59ae>] ? __alloc_skb+0x6e/0x140
> [ 1666.298603]  [<ffffffff804c4464>] netlink_sendmsg+0x214/0x310
> [ 1666.298609]  [<ffffffff8049ceb7>] sock_sendmsg+0x127/0x140
> [ 1666.298616]  [<ffffffff80258c20>] ? autoremove_wake_function+0x0/0x40
> [ 1666.298622]  [<ffffffff8023bc60>] ? wake_up_process+0x10/0x20
> [ 1666.298629]  [<ffffffff80535c74>] ? __mutex_unlock_slowpath+0x44/0x50
> [ 1666.298635]  [<ffffffff80535c0e>] ? mutex_unlock+0xe/0x10
> [ 1666.298641]  [<ffffffff804b8900>] ? __rtnl_unlock+0x10/0x20
> [ 1666.298647]  [<ffffffff8049dd17>] ? move_addr_to_kernel+0x57/0x60
> [ 1666.298652]  [<ffffffff804a6e7c>] ? verify_iovec+0x3c/0xd0
> [ 1666.298657]  [<ffffffff8049d059>] sys_sendmsg+0x189/0x320
> [ 1666.298663]  [<ffffffff804ffd14>] ? inet_ioctl+0x94/0xc0
> [ 1666.298668]  [<ffffffff8049bf56>] ? sock_ioctl+0x66/0x270
> [ 1666.298675]  [<ffffffff802dfd21>] ? vfs_ioctl+0x31/0xa0
> [ 1666.298680]  [<ffffffff802dfe18>] ? do_vfs_ioctl+0x88/0x580
> [ 1666.298686]  [<ffffffff802d20c9>] ? __fput+0x169/0x1e0
> [ 1666.298692]  [<ffffffff8020c5db>] system_call_fastpath+0x16/0x1b
> [ 1666.298696] ---[ end trace 24eb07dee6e9ca52 ]---
> 
> 

On top of that I need to note that NM doesn't show signal strenghts correctly.
Instead it shows 100% for all AP except the current active one.

This is iwl3945 driver from iwlwifi-git of today.
Plus I use latest -git of wpa_supplicant, and NM


Best regards,
	Maxim Levitsky



