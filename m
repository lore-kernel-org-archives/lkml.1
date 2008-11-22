Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYKVGnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYKVGnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 01:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYKVGnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 01:43:14 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:40933 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYKVGnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 01:43:13 -0500
From: Yuval Hager <yuval@avramzon.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: BCM4312 Fails when xdm is started
Date: Sat, 22 Nov 2008 08:39:24 +0200
User-Agent: KMail/1.9.9
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, Peter Stuge <peter@stuge.se>
References: <200811151801.02369.yuval@avramzon.net> <200811211842.13099.mb@bu3sch.de> <4926FDB3.2030701@lwfinger.net>
In-Reply-To: <4926FDB3.2030701@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1446152.EUCJFn6g4S";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811220839.32674.yuval@avramzon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1446152.EUCJFn6g4S
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 21 November 2008, Larry Finger wrote:
> Yuval,
>
> Michael Buesch wrote:
> > Can you dump PCI config space and SSB registers (TMSLOW, maybe others,
> > too). It looks like a random bus write disabled the device.
>
> Please incorporate the following patch and run your system. In addition,
> run the following command when the wireless is working and after it fails:
>
> sudo lspci -d 14e4:4312 -x
>

When the wireless is working:
$ lspci -d 14e4:4312 -x
02:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g (rev 0=
2)
00: e4 14 12 43 06 01 10 00 02 00 80 02 08 00 00 00
10: 04 c0 ff fd 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 71 13
30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 01 00 00

After it fails:
$ lspci -d 14e4:4312 -x
02:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g (rev 0=
2)
00: e4 14 12 43 00 00 10 00 02 00 80 02 00 00 00 00
10: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 71 13
30: 00 00 00 00 40 00 00 00 00 00 00 00 00 01 00 00


> Post the results of the above commands and any entries in /var/log/messag=
es
> that dump registers. They should all be prefaced with ****
>

Sorry for the long time to reply, it took a while to recreate the problem.=
=20
According to the logs, it happened exactly when I checked the machine in th=
e=20
morning.
At the beginning, the register dumps look like this:

[   57.279984] ****** b43: B43_MMIO_MACCTL 0x840A0503
[   57.279992] ****** b43: SSB_TMSLOW 0x20150000
(these line repeat exactly the same. Skipping)

[31723.961262] ****** b43: B43_MMIO_MACCTL 0x840A0503
[31723.961275] ****** b43: SSB_TMSLOW 0x20150000
[31732.959490] b43-phy0: Radio hardware status changed to DISABLED
[31732.959505] b43-phy0: ******** B43_B43_MMIO_RADIO_HWENABLED_HI 0xFFFFFFFF
[31738.130551] wlan0: No ProbeResp from current AP 00:22:3f:18:89:5e - assu=
me=20
out of range
[31783.855931] ------------[ cut here ]------------
[31783.855944] WARNING: at drivers/net/wireless/b43/phy_common.c:135=20
b43_radio_lock+0x29/0x7e [b43]()
[31783.855955] Modules linked in: via drm rfkill_input hci_usb b43 led_clas=
s=20
input_polldev rtc snd_hda_intel snd_pcm snd_tim
er snd_page_alloc snd_hwdep snd soundcore ehci_hcd uhci_hcd usbcore sg ssb=
=20
video output via_agp agpgart
[31783.856023] Pid: 1220, comm: b43 Not tainted 2.6.28-rc5 #13
[31783.856032] Call Trace:
[31783.856055]  [<c011f4e9>] warn_on_slowpath+0x40/0x59
[31783.856102]  [<f7d93da3>] b43_gphy_op_write+0x25/0x29 [b43]
[31783.856143]  [<f7d90735>] b43_calc_nrssi_slope+0x103e/0x105a [b43]
[31783.856180]  [<f7cba429>] ssb_pci_write32+0x15/0x3f [ssb]
[31783.856209]  [<f7cba545>] ssb_pci_read16+0x31/0x3f [ssb]
[31783.856244]  [<f7d8854c>] __b43_shm_read16+0x79/0x81 [b43]
[31783.856272]  [<f7cba545>] ssb_pci_read16+0x31/0x3f [ssb]
[31783.856306]  [<f7d8854c>] __b43_shm_read16+0x79/0x81 [b43]
[31783.856334]  [<f7cba4eb>] ssb_pci_read32+0x12/0x3b [ssb]
[31783.856370]  [<f7d8dc77>] b43_radio_lock+0x29/0x7e [b43]
[31783.856408]  [<f7d91e92>] b43_gphy_op_adjust_txpower+0x111/0x138 [b43]
[31783.856446]  [<f7d8da06>] b43_phy_txpower_adjust_work+0x0/0x39 [b43]
[31783.856483]  [<f7d8da36>] b43_phy_txpower_adjust_work+0x30/0x39 [b43]
[31783.856500]  [<c012b2a4>] run_workqueue+0x6a/0xdf
[31783.856515]  [<c012b9ba>] worker_thread+0x0/0xbd
[31783.856527]  [<c012ba6d>] worker_thread+0xb3/0xbd
[31783.856545]  [<c012dc8c>] autoremove_wake_function+0x0/0x2d
[31783.856560]  [<c012dbc9>] kthread+0x38/0x5f
[31783.856573]  [<c012db91>] kthread+0x0/0x5f
[31783.856588]  [<c01040a7>] kernel_thread_helper+0x7/0x10
[31783.856598] ---[ end trace 7548c7ede66fa0d3 ]---
[31783.856607] ****** b43: B43_MMIO_MACCTL 0xFFFFFFFF
[31783.856616] ****** b43: SSB_TMSLOW 0xFFFFFFFF

And from now on, all reads are ones. I have the full logs if you need.

Cheers,

=2D-yuval

--nextPart1446152.EUCJFn6g4S
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkknqSQACgkQl7qmwPqEj98XHgCdHTuB1NotQMa1OZe/eaIwvG5o
tR0AoMJnmGJnmwF8oM9ZVtZbnKioECmj
=3Xyl
-----END PGP SIGNATURE-----

--nextPart1446152.EUCJFn6g4S--
