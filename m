Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbZICQlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbZICQlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 12:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZICQlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 12:41:50 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:56117 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbZICQlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 12:41:50 -0400
X-Loopcount0: from 10.9.160.253
Message-ID: <4A9FF1FB.5090507@dell.com>
Date: Thu, 03 Sep 2009 11:42:35 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Dell-laptop is not working without wireless
References: <20090818060340.E1C7A526EA5@mailhub.coreip.homeip.net> <20090818121049.GB22284@srcf.ucam.org> <20090903153215.E51F8526EA5@mailhub.coreip.homeip.net>
In-Reply-To: <20090903153215.E51F8526EA5@mailhub.coreip.homeip.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCEA76C00C8D890193077C751"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCEA76C00C8D890193077C751
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Dmitry:

Dmitry Torokhov wrote:
> On Tue, Aug 18, 2009 at 01:10:49PM +0100, Matthew Garrett wrote:
>  =20
>
> Admittedly I have not spend much time on it but it looks like my box
> _really_ wants wifi interface to be fully operational before
> dcsbas_smi_request() starts returning proper data. I wonder if iwl3945'=
s
> rfkill support interferes somehow here...
>
> Maybe Mario (being a Dell guy) has an idea why this might be happening?=

>
>  =20
I'm on 2.6.31-rc8 or so.  I can't actually reproduce this on a d630.  I
get all of the rfkill devices populated.

$ rfkill list
0: dell-wifi: Wireless LAN
    Soft blocked: yes
    Hard blocked: yes
1: dell-bluetooth: Bluetooth
    Soft blocked: yes
    Hard blocked: yes
2: phy0: Wireless LAN
    Soft blocked: no
    Hard blocked: yes
$ sudo rmmod iwl3945 iwlcore dell-laptop
$ rfkill list
$ sudo modprobe dell-laptop
$ rfkill list
3: dell-wifi: Wireless LAN
    Soft blocked: yes
    Hard blocked: yes
4: dell-bluetooth: Bluetooth
    Soft blocked: yes
    Hard blocked: yes

<hit the hardware killswitch>

$ rfkill list
3: dell-wifi: Wireless LAN
    Soft blocked: yes
    Hard blocked: yes
4: dell-bluetooth: Bluetooth
    Soft blocked: yes
    Hard blocked: yes
5: hci0: Bluetooth
    Soft blocked: no
    Hard blocked: no
$ sudo modprobe iwl3945
$ rfkill list
3: dell-wifi: Wireless LAN
    Soft blocked: yes
    Hard blocked: yes
4: dell-bluetooth: Bluetooth
    Soft blocked: yes
    Hard blocked: yes
5: hci0: Bluetooth
    Soft blocked: no
    Hard blocked: no
6: phy1: Wireless LAN
    Soft blocked: no
    Hard blocked: no

There *is* a problem here that the hardware killswitch status doesn't
get updated, but Matthew is aware of that.  Make sure you're not getting
false data because of it.

--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enigCEA76C00C8D890193077C751
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqf8fsACgkQ2CrZjkA73YtgfACeMlrAI2jupxDz4YUX3bgEz10b
6AsAnAxJfdsYVyDTvdJfMT1SoPb4SYU/
=ACwC
-----END PGP SIGNATURE-----

--------------enigCEA76C00C8D890193077C751--
