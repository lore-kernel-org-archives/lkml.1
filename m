Return-Path: <linux-kernel-owner+w=401wt.eu-S1760846AbZD2SUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846AbZD2SUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760411AbZD2SUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:20:04 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:16181 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760171AbZD2SUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:20:03 -0400
X-Loopcount0: from 10.9.160.254
Message-ID: <49F89A5C.2090508@dell.com>
Date: Wed, 29 Apr 2009 13:20:12 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add support for more dell-wmi hotkeys
References: <49ECBAE2.2080308@dell.com> <49EE09D9.2060209@dell.com> <20090429171508.GA717@srcf.ucam.org>
In-Reply-To: <20090429171508.GA717@srcf.ucam.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1F575A9B1DE483891ECF9610"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1F575A9B1DE483891ECF9610
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Matthew:

Matthew Garrett wrote:
> This is the version I'm planning on applying - look ok? I've skipped th=
e=20
> OSD stuff, since right now we're not going to do anything terribly=20
> useful with them. I'd prefer some consensus on where we're going with=20
> these notifications.
>
> commit d0cc3d9de1b8e97a7176ddc7efe48239896100c1
> Author: Matthew Garrett <mjg@redhat.com>
> Date:   Wed Apr 29 18:07:30 2009 +0100
>
>     From: Mario Limonciello <mario_limonciello@dell.com>
>    =20
>     dell-wmi: Add additional keyboard events
>    =20
>     Upcoming Dell hardware will send more keyboard events via WMI. Add =
support
>     for them.
>    =20
>     Signed-off-by: Mario Limonciello <mario_limonciello@dell.com>
>
> diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/del=
l-wmi.c
> index 81d7179..847f486 100644
> --- a/drivers/platform/x86/dell-wmi.c
> +++ b/drivers/platform/x86/dell-wmi.c
> @@ -48,8 +48,49 @@ struct key_entry {
> =20
>  enum { KE_KEY, KE_SW, KE_END };
> =20
> +/*
> + * There are some additional events sent as scancodes, but these are
> + * not currently terribly relevant to Linux. They are:
> + *=20
> + * 0xe020: Mute
> + * 0xe02e: Volume down
> + * 0xe030: Volume up
> + * 0xe00c: Keyboard illumination toggle
> + * 0xe033: Keyboard illumination up
> + * 0xe034: Keyboard illumination down
> + * 0xe00d: BIOS error detected
> + * 0xe013: Ambient light sensor toggle
> + * 0xe03a: Caps lock
> + * 0xe045: Num lock
> + * 0xe046: Scroll lock
> + *
> + * All of these are either notifications (rather than requests for cha=
nge) or
> + * are also sent via the keyboard controller
> + */
> +
>  static struct key_entry dell_wmi_keymap[] =3D {
>  	{KE_KEY, 0xe045, KEY_PROG1},
> +        {KE_KEY, 0xe009, KEY_EJECTCD},
> +
> +	/* These also contain the brightness level at offset 6 */
> +	{KE_KEY, 0xe006, KEY_BRIGHTNESSUP},
> +	{KE_KEY, 0xe005, KEY_BRIGHTNESSDOWN},
> +
> +	/* The next device is at offset 6, the active devices are at
> +	   offset 8 and the attached devices at offset 10 */
> +	{KE_KEY, 0xe00b, KEY_DISPLAYTOGGLE},
> +
> +	/* This is actually for all radios. Although physically a
> +	 * switch, the notification does not provide an indication of
> +	 * state and so it should be reported as a key */
> +	{KE_KEY, 0xe008, KEY_WLAN},
> +
> +	/* Wifi Catcher */
> +	{KE_KEY, 0xe011, KEY_PROG2},
> +
> +	/* Battery health status button */
> +	{KE_KEY, 0xe007, KEY_BATTERY},
> +
>  	{KE_END, 0}
>  };
>  =20
Yeah, that patch looks good.  I personally still think it would  be=20
better to "catch" the WMI events for those OSD type keys and do nothing
rather than litter them in dmesg, but this is sane for now otherwise.

--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com


--------------enig1F575A9B1DE483891ECF9610
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn4mlwACgkQ2CrZjkA73YuOlwCeOaMxVLd1Spqa4kDbqn4j2gHG
GaYAn1w8o0cfWPuM3cA1Ff6uAK0l2V/I
=zrHj
-----END PGP SIGNATURE-----

--------------enig1F575A9B1DE483891ECF9610--
