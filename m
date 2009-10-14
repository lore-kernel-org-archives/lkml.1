Return-Path: <linux-kernel-owner+w=401wt.eu-S934489AbZJNPRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934489AbZJNPRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934419AbZJNPR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:17:29 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:33853 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932849AbZJNPR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:17:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qaE/1G8xrQVPY4LSBXtXXiSKnwJsDrp1DGDc8CDJ+ENiBzDcVv7yeOFrIajqaoaCAR
         eGlSN3UbrlhSYMaIZcFTPQ495Zzqj8f0oardTjlQAZS4YZ3WbngRkOT36L9FPjoKqy/U
         fMtMnXIe5tylXPO8rvqCamZoE6AWWD/Y/mk7g=
Date: Wed, 14 Oct 2009 17:15:29 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       johannes@sipsolutions.net
Subject: Re: [2.6.32-rc3] iwlagn lost connection after s2ram (with warnings)
Message-ID: <20091014151529.GA6602@Pilar.aei.mpg.de>
References: <20091007142031.GA7495@Pilar.aei.mpg.de> <1255023883.26521.13298.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255023883.26521.13298.camel@rc-desk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu  8.Oct'09 at 10:44:43 -0700, reinette chatre wrote:
> Hi Carlos,
> 
> On Wed, 2009-10-07 at 07:20 -0700, Carlos R. Mafra wrote:
> > I just got these warnings after resuming from a suspend to RAM, and
> > the wireless connection was not resumed (now I am connected via eth0).
> > This is the first time I had a failed wireless resume since 2.6.32-rc1.
> > 
> > The full dmesg is here: http://www.aei.mpg.de/~crmafra/dmesg-2.6.32-rc3-wifi.txt
> > 
> > [ 3427.570113] Restarting tasks ... 
> > [ 3427.585827] wlan0: deauthenticated from 00:0b:86:26:36:f1 (Reason: 6)
> > [ 3427.589451] done.
> > [ 3428.503203] input: PS/2 Mouse as /devices/platform/i8042/serio4/input/input15
> > [ 3428.521064] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio4/input/input16
> > [ 3434.504175] wlan0: direct probe to AP 00:0b:86:26:36:f1 (try 1)
> > [ 3434.507058] wlan0: direct probe responded
> > [ 3434.507062] wlan0: authenticate with AP 00:0b:86:26:36:f1 (try 1)
> > [ 3434.509000] wlan0: authenticated
> > [ 3434.509022] wlan0: associate with AP 00:0b:86:26:36:f1 (try 1)
> > [ 3434.512778] wlan0: RX ReassocResp from 00:0b:86:26:36:f1 (capab=0x431 status=0 aid=2)
> > [ 3434.512782] wlan0: associated
> > [ 3434.563942] wlan0: deauthenticating from 00:0b:86:26:36:f1 by local choice (reason=3)
> 
> You mention you are trying to connect again after a resume. The message
> above indicates that userspace (maybe wpa_supplicant ?) requested that
> the connection be closed. Do you maybe know how this could have been
> triggered?
> 
> > [ 3434.564023] ------------[ cut here ]------------
> > [ 3434.564039] WARNING: at net/wireless/mlme.c:96 cfg80211_send_rx_assoc+0x193/0x230()
> 
> This warning and the one below indicates that there is no information
> available for this BSS. Maybe Johannes knows why this can be?
> 
> > [ 3434.564045] Hardware name: VGN-FZ240E
> > [ 3434.564049] Modules linked in: usbhid nvram dvb_usb_dib0700 dib7000p dib7000m dib0070 dvb_usb dib3000mc dib8000 dibx000_common snd_hda_codec_idt uvcvideo snd_hda_intel snd_hda_codec ehci_hcd sg uhci_hcd snd_hwdep sky2 iwlagn i2c_i801 sr_mod evdev ata_piix ahci libata sd_mod scsi_mod
> > [ 3434.564104] Pid: 2319, comm: phy0 Not tainted 2.6.32-rc3 #204
> > [ 3434.564109] Call Trace:
> > [ 3434.564119]  [<ffffffff81420dd3>] ? cfg80211_send_rx_assoc+0x193/0x230
> > [ 3434.564131]  [<ffffffff81047cb8>] warn_slowpath_common+0x78/0xd0
> > [ 3434.564139]  [<ffffffff81047d1f>] warn_slowpath_null+0xf/0x20
> > [ 3434.564147]  [<ffffffff81420dd3>] cfg80211_send_rx_assoc+0x193/0x230
> > [ 3434.564156]  [<ffffffff814316cb>] ieee80211_sta_work+0x2fb/0x1100
> > [ 3434.564166]  [<ffffffff81453b1f>] ? _spin_unlock_bh+0xf/0x20
> > [ 3434.564175]  [<ffffffff8142802a>] ? ieee80211_configure_filter+0x11a/0x170
> > [ 3434.564183]  [<ffffffff814313d0>] ? ieee80211_sta_work+0x0/0x1100
> > [ 3434.564193]  [<ffffffff8105e9e2>] worker_thread+0x182/0x260
> > [ 3434.564203]  [<ffffffff81063320>] ? autoremove_wake_function+0x0/0x40
> > [ 3434.564211]  [<ffffffff8105e860>] ? worker_thread+0x0/0x260
> > [ 3434.564219]  [<ffffffff81062f06>] kthread+0x96/0xb0
> > [ 3434.564229]  [<ffffffff8100cd1a>] child_rip+0xa/0x20
> > [ 3434.564237]  [<ffffffff81062e70>] ? kthread+0x0/0xb0
> > [ 3434.564245]  [<ffffffff8100cd10>] ? child_rip+0x0/0x20
> > [ 3434.564250] ---[ end trace 99d6122abfa316f7 ]---
> > [ 3434.564272] ------------[ cut here ]------------
> > [ 3434.564280] WARNING: at net/wireless/sme.c:417 __cfg80211_connect_result+0x343/0x380()
> > [ 3434.564285] Hardware name: VGN-FZ240E
> > [ 3434.564289] Modules linked in: usbhid nvram dvb_usb_dib0700 dib7000p dib7000m dib0070 dvb_usb dib3000mc dib8000 dibx000_common snd_hda_codec_idt uvcvideo snd_hda_intel snd_hda_codec ehci_hcd sg uhci_hcd snd_hwdep sky2 iwlagn i2c_i801 sr_mod evdev ata_piix ahci libata sd_mod scsi_mod
> > [ 3434.564335] Pid: 2319, comm: phy0 Tainted: G        W  2.6.32-rc3 #204
> > [ 3434.564340] Call Trace:
> > [ 3434.564347]  [<ffffffff81453b1f>] ? _spin_unlock_bh+0xf/0x20
> > [ 3434.564355]  [<ffffffff814236e3>] ? __cfg80211_connect_result+0x343/0x380
> > [ 3434.564364]  [<ffffffff81047cb8>] warn_slowpath_common+0x78/0xd0
> > [ 3434.564373]  [<ffffffff81047d1f>] warn_slowpath_null+0xf/0x20
> > [ 3434.564381]  [<ffffffff814236e3>] __cfg80211_connect_result+0x343/0x380
> > [ 3434.564389]  [<ffffffff814509a2>] ? dump_stack+0x72/0x7b
> > [ 3434.564397]  [<ffffffff81420e10>] cfg80211_send_rx_assoc+0x1d0/0x230
> > [ 3434.564405]  [<ffffffff814316cb>] ieee80211_sta_work+0x2fb/0x1100
> > [ 3434.564413]  [<ffffffff81453b1f>] ? _spin_unlock_bh+0xf/0x20
> > [ 3434.564421]  [<ffffffff8142802a>] ? ieee80211_configure_filter+0x11a/0x170
> > [ 3434.564429]  [<ffffffff814313d0>] ? ieee80211_sta_work+0x0/0x1100
> > [ 3434.564438]  [<ffffffff8105e9e2>] worker_thread+0x182/0x260
> > [ 3434.564447]  [<ffffffff81063320>] ? autoremove_wake_function+0x0/0x40
> > [ 3434.564455]  [<ffffffff8105e860>] ? worker_thread+0x0/0x260
> > [ 3434.564463]  [<ffffffff81062f06>] kthread+0x96/0xb0
> > [ 3434.564471]  [<ffffffff8100cd1a>] child_rip+0xa/0x20
> > [ 3434.564479]  [<ffffffff81062e70>] ? kthread+0x0/0xb0
> > [ 3434.564487]  [<ffffffff8100cd10>] ? child_rip+0x0/0x20
> > [ 3434.564492] ---[ end trace 99d6122abfa316f8 ]---
> > [ 3434.962611] Registered led device: iwl-phy0::radio
> > [ 3434.962629] Registered led device: iwl-phy0::assoc
> > [ 3434.962645] Registered led device: iwl-phy0::RX
> > [ 3434.962661] Registered led device: iwl-phy0::TX
> > [ 3435.000526] ADDRCONF(NETDEV_UP): wlan0: link is not ready

Now I got a similar warning and the connection went down. But this
time it was not closely related to a suspend to RAM, as can be noticed
in the dmesg

[  624.603365] wlan0: direct probe responded
[  624.603373] wlan0: authenticate with AP 00:0b:86:26:36:f1 (try 1)
[  624.605285] wlan0: authenticated
[  624.605316] wlan0: associate with AP 00:0b:86:26:36:f1 (try 1)
[  624.608055] wlan0: RX ReassocResp from 00:0b:86:26:36:f1 (capab=0x21 status=10 aid=0)
[  624.608061] wlan0: AP denied association (code=10)
[  640.704549] wlan0: direct probe to AP 00:0b:86:3e:10:31 (try 1)
[  640.708848] wlan0: direct probe responded
[  640.708857] wlan0: authenticate with AP 00:0b:86:3e:10:31 (try 1)
[  640.710857] wlan0: authenticated
[  640.710888] wlan0: associate with AP 00:0b:86:3e:10:31 (try 1)
[  640.719800] wlan0: RX AssocResp from 00:0b:86:3e:10:31 (capab=0x431 status=0 aid=1)
[  640.719807] wlan0: associated
[  640.746298] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  650.899995] wlan0: no IPv6 routers present
[  706.797508] CE: hpet increasing min_delta_ns to 15000 nsec
[ 9523.640903] process `skype' is using obsolete setsockopt SO_BSDCOMPAT
[ 9546.622398] hda-intel: azx_get_response timeout, switching to polling mode: last cmd=0x00af0900
[15443.026527] wlan0: deauthenticated from 00:0b:86:3e:10:31 (Reason: 3)
[15443.032706] ------------[ cut here ]------------
[15443.032723] WARNING: at net/wireless/sme.c:620 __cfg80211_disconnected+0x232/0x240()
[15443.032728] Hardware name: VGN-FZ240E
[15443.032732] deauth failed: -67
[15443.032736] Modules linked in: usbhid nvram snd_hda_codec_idt uvcvideo snd_hda_intel snd_hda_codec evdev i2c_i801 sn                                                            d_hwdep uhci_hcd ehci_hcd sr_mod sky2 iwlagn sg ata_piix ahci libata sd_mod scsi_mod
[15443.032779] Pid: 2260, comm: phy0 Not tainted 2.6.32-rc4-dmitry2-00002-g5ce9513 #229
[15443.032784] Call Trace:
[15443.032794]  [<ffffffff81421902>] ? __cfg80211_disconnected+0x232/0x240
[15443.032805]  [<ffffffff81047cd8>] warn_slowpath_common+0x78/0xd0
[15443.032814]  [<ffffffff81047db4>] warn_slowpath_fmt+0x64/0x70
[15443.032823]  [<ffffffff81433e99>] ? ieee80211_deauth+0x19/0x20
[15443.032833]  [<ffffffff8141e3ad>] ? __cfg80211_mlme_deauth+0xed/0x140
[15443.032842]  [<ffffffff81421902>] __cfg80211_disconnected+0x232/0x240
[15443.032851]  [<ffffffff8141f35a>] __cfg80211_send_deauth+0x23a/0x270
[15443.032861]  [<ffffffff8142d064>] ? ieee80211_set_disassoc+0x1b4/0x230
[15443.032870]  [<ffffffff8141f3fa>] cfg80211_send_deauth+0x6a/0x80
[15443.032879]  [<ffffffff8142fe82>] ieee80211_sta_work+0x2e2/0x1100
[15443.032888]  [<ffffffff8142e175>] ? ieee80211_mgd_probe_ap_send+0x65/0x70
[15443.032897]  [<ffffffff8142fba0>] ? ieee80211_sta_work+0x0/0x1100
[15443.032907]  [<ffffffff8105e9e2>] worker_thread+0x182/0x260
[15443.032916]  [<ffffffff810630d0>] ? autoremove_wake_function+0x0/0x40
[15443.032925]  [<ffffffff8105e860>] ? worker_thread+0x0/0x260
[15443.032933]  [<ffffffff81062cb6>] kthread+0x96/0xb0
[15443.032944]  [<ffffffff8100cd1a>] child_rip+0xa/0x20
[15443.032952]  [<ffffffff81062c20>] ? kthread+0x0/0xb0
[15443.032960]  [<ffffffff8100cd10>] ? child_rip+0x0/0x20
[15443.032965] ---[ end trace 0c4814007354915e ]---
[15444.898782] wlan0: direct probe to AP 00:0b:86:3e:10:31 (try 1)
[15445.098540] wlan0: direct probe to AP 00:0b:86:3e:10:31 (try 2)
[15445.299332] wlan0: direct probe to AP 00:0b:86:3e:10:31 (try 3)
[15445.498601] wlan0: direct probe to AP 00:0b:86:3e:10:31 timed out
[15449.715917] Registered led device: iwl-phy0::radio
[15449.716554] Registered led device: iwl-phy0::assoc
[15449.717107] Registered led device: iwl-phy0::RX
[15449.717603] Registered led device: iwl-phy0::TX
[15449.749228] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[15449.794402] wlan0: direct probe to AP 00:0b:86:28:21:11 (try 1)
[15449.992691] wlan0: direct probe to AP 00:0b:86:28:21:11 (try 2)
[15450.191950] wlan0: direct probe to AP 00:0b:86:28:21:11 (try 3)
[15450.392681] wlan0: direct probe to AP 00:0b:86:28:21:11 timed out


But after ~7 minutes the connection was recovered (but in the mean time
I had already started eth0), see here the continuation:


[15824.443480] sky2 eth0: enabling interface
[15824.443735] ADDRCONF(NETDEV_UP): eth0: link is not ready
[15826.108242] sky2 eth0: Link is up at 100 Mbps, full duplex, flow control rx
[15826.108864] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[15836.731786] eth0: no IPv6 routers present
[15924.423010] wlan0: direct probe to AP 00:0b:86:26:36:f1 (try 1)
[15924.426094] wlan0: direct probe responded
[15924.426113] wlan0: authenticate with AP 00:0b:86:26:36:f1 (try 1)
[15924.427981] wlan0: authenticated
[15924.428017] wlan0: associate with AP 00:0b:86:26:36:f1 (try 1)
[15924.434504] wlan0: RX ReassocResp from 00:0b:86:26:36:f1 (capab=0x431 status=0 aid=1)
[15924.434511] wlan0: associated
[15924.458575] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[15934.491760] wlan0: no IPv6 routers present
