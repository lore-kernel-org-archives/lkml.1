Return-Path: <linux-kernel-owner+w=401wt.eu-S934938AbZJNQpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934938AbZJNQpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934539AbZJNQpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:45:10 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:62983 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245AbZJNQpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:45:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=DUS6Qdxm0ude0EIduoYklbY6nlMNy0t5tWF5nWT9+D+Q3shyaDbVENWuczXpGMhrn8
         Zen3jkzAYcAEQ6M5tOyUjAP7eh3Opwug1rfv/VOAP53D7vrfkZphQvtTOBN68O42LHPj
         mkvTOqJ/KLiPz0A+zLBcmcBtI0L/E6hyOsq48=
MIME-Version: 1.0
In-Reply-To: <20091014151529.GA6602@Pilar.aei.mpg.de>
References: <20091007142031.GA7495@Pilar.aei.mpg.de> <1255023883.26521.13298.camel@rc-desk> 
	<20091014151529.GA6602@Pilar.aei.mpg.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 14 Oct 2009 09:44:10 -0700
Message-ID: <43e72e890910140944y23399b71sf20cd37e003c9729@mail.gmail.com>
Subject: Re: [2.6.32-rc3] iwlagn lost connection after s2ram (with warnings)
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       johannes@sipsolutions.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 8:15 AM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
> On Thu  8.Oct'09 at 10:44:43 -0700, reinette chatre wrote:
>> Hi Carlos,
>>
>> On Wed, 2009-10-07 at 07:20 -0700, Carlos R. Mafra wrote:
>> > I just got these warnings after resuming from a suspend to RAM, and
>> > the wireless connection was not resumed (now I am connected via eth0).
>> > This is the first time I had a failed wireless resume since 2.6.32-rc1.
>> >
>> > The full dmesg is here: http://www.aei.mpg.de/~crmafra/dmesg-2.6.32-rc3-wifi.txt
>> >
>> > [ 3427.570113] Restarting tasks ...
>> > [ 3427.585827] wlan0: deauthenticated from 00:0b:86:26:36:f1 (Reason: 6)
>> > [ 3427.589451] done.
>> > [ 3428.503203] input: PS/2 Mouse as /devices/platform/i8042/serio4/input/input15
>> > [ 3428.521064] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio4/input/input16
>> > [ 3434.504175] wlan0: direct probe to AP 00:0b:86:26:36:f1 (try 1)
>> > [ 3434.507058] wlan0: direct probe responded
>> > [ 3434.507062] wlan0: authenticate with AP 00:0b:86:26:36:f1 (try 1)
>> > [ 3434.509000] wlan0: authenticated
>> > [ 3434.509022] wlan0: associate with AP 00:0b:86:26:36:f1 (try 1)
>> > [ 3434.512778] wlan0: RX ReassocResp from 00:0b:86:26:36:f1 (capab=0x431 status=0 aid=2)
>> > [ 3434.512782] wlan0: associated
>> > [ 3434.563942] wlan0: deauthenticating from 00:0b:86:26:36:f1 by local choice (reason=3)
>>
>> You mention you are trying to connect again after a resume. The message
>> above indicates that userspace (maybe wpa_supplicant ?) requested that
>> the connection be closed. Do you maybe know how this could have been
>> triggered?
>>
>> > [ 3434.564023] ------------[ cut here ]------------
>> > [ 3434.564039] WARNING: at net/wireless/mlme.c:96 cfg80211_send_rx_assoc+0x193/0x230()
>>
>> This warning and the one below indicates that there is no information
>> available for this BSS. Maybe Johannes knows why this can be?
>>
>> > [ 3434.564045] Hardware name: VGN-FZ240E
>> > [ 3434.564049] Modules linked in: usbhid nvram dvb_usb_dib0700 dib7000p dib7000m dib0070 dvb_usb dib3000mc dib8000 dibx000_common snd_hda_codec_idt uvcvideo snd_hda_intel snd_hda_codec ehci_hcd sg uhci_hcd snd_hwdep sky2 iwlagn i2c_i801 sr_mod evdev ata_piix ahci libata sd_mod scsi_mod
>> > [ 3434.564104] Pid: 2319, comm: phy0 Not tainted 2.6.32-rc3 #204
>> > [ 3434.564109] Call Trace:
>> > [ 3434.564119]  [<ffffffff81420dd3>] ? cfg80211_send_rx_assoc+0x193/0x230
>> > [ 3434.564131]  [<ffffffff81047cb8>] warn_slowpath_common+0x78/0xd0
>> > [ 3434.564139]  [<ffffffff81047d1f>] warn_slowpath_null+0xf/0x20
>> > [ 3434.564147]  [<ffffffff81420dd3>] cfg80211_send_rx_assoc+0x193/0x230
>> > [ 3434.564156]  [<ffffffff814316cb>] ieee80211_sta_work+0x2fb/0x1100
>> > [ 3434.564166]  [<ffffffff81453b1f>] ? _spin_unlock_bh+0xf/0x20
>> > [ 3434.564175]  [<ffffffff8142802a>] ? ieee80211_configure_filter+0x11a/0x170
>> > [ 3434.564183]  [<ffffffff814313d0>] ? ieee80211_sta_work+0x0/0x1100
>> > [ 3434.564193]  [<ffffffff8105e9e2>] worker_thread+0x182/0x260
>> > [ 3434.564203]  [<ffffffff81063320>] ? autoremove_wake_function+0x0/0x40
>> > [ 3434.564211]  [<ffffffff8105e860>] ? worker_thread+0x0/0x260
>> > [ 3434.564219]  [<ffffffff81062f06>] kthread+0x96/0xb0
>> > [ 3434.564229]  [<ffffffff8100cd1a>] child_rip+0xa/0x20
>> > [ 3434.564237]  [<ffffffff81062e70>] ? kthread+0x0/0xb0
>> > [ 3434.564245]  [<ffffffff8100cd10>] ? child_rip+0x0/0x20
>> > [ 3434.564250] ---[ end trace 99d6122abfa316f7 ]---
>> > [ 3434.564272] ------------[ cut here ]------------
>> > [ 3434.564280] WARNING: at net/wireless/sme.c:417 __cfg80211_connect_result+0x343/0x380()
>> > [ 3434.564285] Hardware name: VGN-FZ240E
>> > [ 3434.564289] Modules linked in: usbhid nvram dvb_usb_dib0700 dib7000p dib7000m dib0070 dvb_usb dib3000mc dib8000 dibx000_common snd_hda_codec_idt uvcvideo snd_hda_intel snd_hda_codec ehci_hcd sg uhci_hcd snd_hwdep sky2 iwlagn i2c_i801 sr_mod evdev ata_piix ahci libata sd_mod scsi_mod
>> > [ 3434.564335] Pid: 2319, comm: phy0 Tainted: G        W  2.6.32-rc3 #204
>> > [ 3434.564340] Call Trace:
>> > [ 3434.564347]  [<ffffffff81453b1f>] ? _spin_unlock_bh+0xf/0x20
>> > [ 3434.564355]  [<ffffffff814236e3>] ? __cfg80211_connect_result+0x343/0x380
>> > [ 3434.564364]  [<ffffffff81047cb8>] warn_slowpath_common+0x78/0xd0
>> > [ 3434.564373]  [<ffffffff81047d1f>] warn_slowpath_null+0xf/0x20
>> > [ 3434.564381]  [<ffffffff814236e3>] __cfg80211_connect_result+0x343/0x380
>> > [ 3434.564389]  [<ffffffff814509a2>] ? dump_stack+0x72/0x7b
>> > [ 3434.564397]  [<ffffffff81420e10>] cfg80211_send_rx_assoc+0x1d0/0x230
>> > [ 3434.564405]  [<ffffffff814316cb>] ieee80211_sta_work+0x2fb/0x1100
>> > [ 3434.564413]  [<ffffffff81453b1f>] ? _spin_unlock_bh+0xf/0x20
>> > [ 3434.564421]  [<ffffffff8142802a>] ? ieee80211_configure_filter+0x11a/0x170
>> > [ 3434.564429]  [<ffffffff814313d0>] ? ieee80211_sta_work+0x0/0x1100
>> > [ 3434.564438]  [<ffffffff8105e9e2>] worker_thread+0x182/0x260
>> > [ 3434.564447]  [<ffffffff81063320>] ? autoremove_wake_function+0x0/0x40
>> > [ 3434.564455]  [<ffffffff8105e860>] ? worker_thread+0x0/0x260
>> > [ 3434.564463]  [<ffffffff81062f06>] kthread+0x96/0xb0
>> > [ 3434.564471]  [<ffffffff8100cd1a>] child_rip+0xa/0x20
>> > [ 3434.564479]  [<ffffffff81062e70>] ? kthread+0x0/0xb0
>> > [ 3434.564487]  [<ffffffff8100cd10>] ? child_rip+0x0/0x20
>> > [ 3434.564492] ---[ end trace 99d6122abfa316f8 ]---
>> > [ 3434.962611] Registered led device: iwl-phy0::radio
>> > [ 3434.962629] Registered led device: iwl-phy0::assoc
>> > [ 3434.962645] Registered led device: iwl-phy0::RX
>> > [ 3434.962661] Registered led device: iwl-phy0::TX
>> > [ 3435.000526] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>
> Now I got a similar warning and the connection went down. But this
> time it was not closely related to a suspend to RAM, as can be noticed
> in the dmesg
>
> [  624.603365] wlan0: direct probe responded
> [  624.603373] wlan0: authenticate with AP 00:0b:86:26:36:f1 (try 1)
> [  624.605285] wlan0: authenticated
> [  624.605316] wlan0: associate with AP 00:0b:86:26:36:f1 (try 1)
> [  624.608055] wlan0: RX ReassocResp from 00:0b:86:26:36:f1 (capab=0x21 status=10 aid=0)
> [  624.608061] wlan0: AP denied association (code=10)
> [  640.704549] wlan0: direct probe to AP 00:0b:86:3e:10:31 (try 1)
> [  640.708848] wlan0: direct probe responded
> [  640.708857] wlan0: authenticate with AP 00:0b:86:3e:10:31 (try 1)
> [  640.710857] wlan0: authenticated
> [  640.710888] wlan0: associate with AP 00:0b:86:3e:10:31 (try 1)
> [  640.719800] wlan0: RX AssocResp from 00:0b:86:3e:10:31 (capab=0x431 status=0 aid=1)
> [  640.719807] wlan0: associated
> [  640.746298] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  650.899995] wlan0: no IPv6 routers present
> [  706.797508] CE: hpet increasing min_delta_ns to 15000 nsec
> [ 9523.640903] process `skype' is using obsolete setsockopt SO_BSDCOMPAT
> [ 9546.622398] hda-intel: azx_get_response timeout, switching to polling mode: last cmd=0x00af0900
> [15443.026527] wlan0: deauthenticated from 00:0b:86:3e:10:31 (Reason: 3)
> [15443.032706] ------------[ cut here ]------------
> [15443.032723] WARNING: at net/wireless/sme.c:620 __cfg80211_disconnected+0x232/0x240()
> [15443.032728] Hardware name: VGN-FZ240E
> [15443.032732] deauth failed: -67

Can you reproduce ? If so then please try my patch titled:

[PATCH] mac80211: fix SME warning by removing stale BSS upon assoc failure

and see if that still happens.

  Luis
