Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbYHZJ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbYHZJ20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 05:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYHZJ2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 05:28:17 -0400
Received: from mxpdbe2.wincor-nixdorf.com ([80.154.98.130]:58433 "EHLO
	mxpdbe2.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410AbYHZJ2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 05:28:16 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Aug 2008 05:28:16 EDT
Message-ID: <48B3CAA2.5040207@wincor-nixdorf.com>
Date: Tue, 26 Aug 2008 11:19:30 +0200
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
Organization: Wincor Nixdorf International
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] POSKeyboard driver for exclusive keyboard access
References: <1b51b6f80808220917t20fdb09el78b117c5ba5b7f7c@mail.gmail.com> <20080822135507.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080822135507.ZZRA012@mailhub.coreip.homeip.net>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5F5CAF4660E6F2FF8572A796"
X-OriginalArrivalTime: 26 Aug 2008 09:20:54.0045 (UTC) FILETIME=[0A26FCD0:01C9075D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5F5CAF4660E6F2FF8572A796
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Dmitry,

Dmitry Torokhov wrote:
> Hi Niels,
>=20
> On Fri, Aug 22, 2008 at 06:17:28PM +0200, Niels de Vos wrote:
>> This new driver makes it possible for middleware like JavaPOS to use
>> a POSKeyboard (connected to PS/2) with exclusive access. This is
>> required by the UnifiedPOS Specification which is available from
>> http://www.nrf-arts.org/UnifiedPOS. Any middleware using this driver
>> should implement the full exception-handling in user-space. Therefor
>> it is possible to use specific POS-extensions of POSKeyboards, without=

>> abusing other keyboard-drivers.
>>
>> Opening /dev/poskeyboard will route all scancodes to this device. The
>> scancodes will not be processes by the input-subsystem anymore. Readin=
g
>> /dev/poskeyboard results in receiving the scancodes as raw data for
>> further processing by the reader. Sending commands to the hardware can=

>> be done by writing to /dev/poskeyboard.
>>
>> If the driver is loaded and /dev/poskeyboard is not opened, all
>> scancodes are given to the input-subsystem. This allows 'normal' use o=
f
>> the keyboard.
>>
>> Making the driver active involves some commands like the following:
>>    echo -n serio1 > /sys/bus/serio/drivers/atkbd/unbind
>>    echo -n serio1 > /sys/bus/serio/drivers/poskbd/bind
>>
>=20
> It seems you have just reimplemented serio_raw driver, therefore NAK.
> Right now serio_raw is limited to untranslated ports but adding
> SERIO_I8042XL signature should be easy.

Okay, thanks for pointing this out, I'll look into using serio_raw
instead. If a patch is needed I'll send you one.


>> Open questions:
>> - How to achieve the same with USB-HID complaint keyboards?
>=20
> Thsi is probably is the candidate for legitimate use of EVIOCGRAB.
> Just grab device for exclusive access and do your processing, probably
> looking at MSC_SCAN (or KEY_*, depends on how hardware-sepcific this
> thing is). This approach shoudl work equally well for HID, PS/2,
> serial or any other kind of keyboard/input device actually. You can
> also re-inject the keystrokes you are not interested in back into
> input core via uinput.

Great. I already saw input_dev->grab but never really understood what
it would do or how it could be used. Tried it with a small test and
should be sufficient for the UnifiedPOS requirements.


>> - Does serio_unregister_port() a kfree() on the port?
>=20
> Eventually, after the last user drops off.

Okay, so the driver allocates it, but never needs to do a kfree() on
it, because the serio-layer takes care of it.

Thanks for the infos,
Niels


--------------enig5F5CAF4660E6F2FF8572A796
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFIs8qi5KAkGQPO/QoRAqrCAKCtdEAH+uSNK16z1cdfE1kYAIHNNACfSq5K
OpqWPtOuOAhVMjll8DqjGx4=
=alLi
-----END PGP SIGNATURE-----

--------------enig5F5CAF4660E6F2FF8572A796--
