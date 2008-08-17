Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYHQB7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYHQB7m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 21:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYHQB7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 21:59:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:58133 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751100AbYHQB7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 21:59:32 -0400
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX1/ZzkEbSV/ZehXfmP5fh+QQPfhGeSoAu/j/pm8sQd
	XBo3vMziEbxmTw
Date: Sun, 17 Aug 2008 03:59:21 +0200
From: Mirco Tischler <mt-ml@gmx.de>
To: Leonid Podolny <leonidp.lists@gmail.com>
Cc: linux-kernel@vger.kernel.org, yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org, IvDoorn@gmail.com
Subject: Re: CPU load after killing iwlagn with RF kill switch
Message-ID: <20080817035921.4d35ae0e@mtlp.12thdimension>
In-Reply-To: <48A5EC02.4070303@gmail.com>
References: <48A5EC02.4070303@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qHOd7Y=YbGYmgOtZO=/4E=X";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qHOd7Y=YbGYmgOtZO=/4E=X
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 15 Aug 2008 23:50:10 +0300, Leonid Podolny wrote:
> Hi,
> With a new iwlagn driver and 2.6.27-rc3, if I turn off the wireless=20
> (intel 4965ag) by RF kill switch, the CPU utilization of ksoftirqd=20
> process raises to 100% and stays there until I rmmod the module.
> Please let me know what further information I can provide.

Hi

Same on my machine with same chip and same kernel.
If I use the switch on the side of my laptop to turn off wlan, ksoftirqd ea=
ts
up one core of my cpu til I switch it on again or rmmod the iwlagn module. =
But
when I switch it on before the device loses connection and then off a second
time, I now get a (the) second ksoftirqd process eating up the other core t=
oo.
This only happens if a connection is established, though.
I'm not sure if this problem existed in 2.6.26 but I doubt it. (Will check =
if I
find the time).

My dmesg shows me this:

[48067.257539] iwlagn: Radio Frequency Kill Switch is On:
[48067.257539] Kill switch must be turned off for wireless networking to wo=
rk.
[48071.295154] wlan0: No ProbeResp from current AP 00:c0:a8:e5:e5:a5 - assu=
me
out of range=20
[48072.099173] iwlagn: Error sending REPLY_ADD_STA: enqueue_hcmd failed: -5=
=20
[48072.099260] mac80211-phy1: failed to remove key (0, 00:c0:a8:e5:e5:a5) f=
rom
hardware (-5)=20
[48072.206028] iwlagn: Error sending REPLY_ADD_STA: enqueue_hcmd failed: -5=
=20
[48072.206028] mac80211-phy1: failed to remove key (1, ff:ff:ff:ff:ff:ff) f=
rom
hardware (-5)

The probably interesting parts of my config look like that:

CONFIG_IWLWIFI=3Dm
CONFIG_IWLCORE=3Dm
CONFIG_IWLWIFI_LEDS=3Dy
CONFIG_IWLWIFI_RFKILL=3Dy
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLAGN=3Dm
CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=3Dy
CONFIG_IWLAGN_LEDS=3Dy
CONFIG_IWL4965=3Dy
# CONFIG_IWL5000 is not set
# CONFIG_IWL3945 is not set

CONFIG_RFKILL=3Dm
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_LEDS=3Dy
CONFIG_IWLWIFI_RFKILL=3Dy

I can recompile with debug options set if this helps. Just haven't found the
time.

Thanks
Mirco

P.S.: added some cc's for iwlwifi and rfkill.

--Sig_/qHOd7Y=YbGYmgOtZO=/4E=X
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkinhgEACgkQz+diZ7c2xfjaQACfb5c/stFKRA1LvjSCFsBUn02N
/YkAn2TOIdhb6M1vjH6k/uTw5edgUIYL
=C0io
-----END PGP SIGNATURE-----

--Sig_/qHOd7Y=YbGYmgOtZO=/4E=X--
