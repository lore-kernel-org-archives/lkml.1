Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbZERVgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbZERVgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 17:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZERVgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 17:36:36 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:19287 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbZERVgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 17:36:36 -0400
X-Loopcount0: from 10.9.160.254
Message-ID: <4A11D4E8.1020807@dell.com>
Date: Mon, 18 May 2009 16:36:40 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on
 suspend
References: <4A11C126.1000704@dell.com> <20090518210241.GA17755@srcf.ucam.org>
In-Reply-To: <20090518210241.GA17755@srcf.ucam.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig376252EF10F8BD2D68EBEB4D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig376252EF10F8BD2D68EBEB4D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Matthew:

Matthew Garrett wrote:
> On Mon, May 18, 2009 at 03:12:22PM -0500, Mario Limonciello wrote:
>  =20
>>  Dell BT devices need to be removed from the bus and reinserted
>>  so that userspace udev rules can transition the devices into the
>>  proper mode after S3 or S4.
>>    =20
>
> This sounds wrong. What kind of reinitialisation are you talking about?=

>  =20
Dell BT adapters will startup in a HID mode.  In HID mode two logical
USB devices are exposed, a mouse and a keyboard.  If properly set, the
BT radio will work with pre-paired keyboards or mice in this mode.  This
is useful for things like BIOS control via a BT keyboard.  A command is
sent to one of the descriptors of the mouse to cause the device to
transition to HCI mode.  When transitioned to HCI mode, a radio device
is exposed allowing it to pair and operate with any BT device.

Here's what the utility looks like that ships with bluez:
http://git.kernel.org/?p=3Dbluetooth/bluez.git;a=3Dblob;f=3Dtools/hid2hci=
=2Ec;h=3D11d707fd76e940b884c9078907ab1504cd7350d4;hb=3DHEAD
Look at the switch_dell method to see how it works.

Currently, this is implemented via a set of udev rules shipped with
bluez that match the Dell device and transition it to HCI mode.
Here's the udev rule that matches:
ACTION=3D=3D"add", ENV{ID_VENDOR}=3D=3D"413c", ENV{ID_CLASS}=3D=3D"mouse"=
, ATTRS{bmAttributes}=3D=3D"e0", KERNEL=3D=3D"mouse*", RUN+=3D"/usr/sbin/=
hid2hci --method dell -v $env{ID_VENDOR} -p $env{ID_MODEL} --mode hci"

When coming out of S3 if the killswitch isn't activated, the logical USB
mouse isn't coldplugged again preventing the udev rule from being
matched upon.  You can manually run hid2hci and the device will switch
modes.

--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enig376252EF10F8BD2D68EBEB4D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoR1OgACgkQ2CrZjkA73Yt0dgCgl8wxzdS7QiJSheFxNHCalPaj
xQgAoIhOUpcA9K6V6PvR7bDp1REFEsiq
=lId8
-----END PGP SIGNATURE-----

--------------enig376252EF10F8BD2D68EBEB4D--
