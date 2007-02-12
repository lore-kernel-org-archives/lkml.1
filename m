Return-Path: <linux-kernel-owner+w=401wt.eu-S1750941AbXBLAJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750941AbXBLAJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbXBLAJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:09:23 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:46739 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbXBLAJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:09:23 -0500
X-Sasl-enc: JYmNvv1jGk4yVrp0OHhUr9nRVBaO9oiTINyt6O5W0JlY 1171238960
Message-ID: <45CFB06B.5080102@imap.cc>
Date: Mon, 12 Feb 2007 01:10:19 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: nigel@nigel.suspend2.net
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
References: <1171058269.1484.64.camel@nigel.suspend2.net>	 <1171059433.8675.195.camel@laptopd505.fenrus.org>	 <20070210193851.GA3956@ucw.cz>  <200702102320.39531.rjw@sisk.pl>	 <1171147026.19894.16.camel@nigel.suspend2.net>  <45CE5934.3020801@imap.cc> <1171233454.4493.74.camel@nigel.suspend2.net>
In-Reply-To: <1171233454.4493.74.camel@nigel.suspend2.net>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB00DA7791053E0E9AEEDF832"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB00DA7791053E0E9AEEDF832
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Am 11.02.2007 23:37 schrieb Nigel Cunningham:
> On Sun, 2007-02-11 at 00:45 +0100, Tilman Schmidt wrote:
>> Am 10.02.2007 23:37 schrieb Nigel Cunningham:
>>> If your device requires power management, and you know it requires po=
wer
>>> management, why not just implement power management? [...]
>> Like it or not, power management is far from trivial, and people
>> writing device drivers have limited resources. [...]
> It's not that complex. All we're really talking about is a bit of extra=

> code to cleanup and configure hardware state; things that the driver
> author already knows how to do. S3 might require a bit more
> initialisation if firmware needs to be reloaded or more extensive
> configuration needs to be done, but if there's firmware to be loaded,
> there is a reasonably good probability that we loaded it from Linux to
> start with anyway.

You are assuming a perfect world where driver authors have complete
knowledge of their devices. In reality, many drivers (including
those I have the mixed pleasure of maintaining) are based at least
in part on reverse engineering, and managing power states may well
fall into the domain of things not yet sufficiently reverse
engineered.

>> Also, in your argument you neglected a few cases:
>> - What if my device does not require power management?
>=20
> Then you as a generic routine that does nothing but return success
> (potentially shared with other drivers that are in the same situation).=


But if I just write an empty routine like that I open myself up to
criticism along the lines of "writing dummy routines just in order
to shut up kernel warnings". BTDT.

>> - What if I don't know whether my device requires power management?
>=20
> The questions are straight forward: Is there hardware state that needs
> to be configured if you've just booted the computer and nothing else ha=
s
> touched it? If so, that needs to be done in a resume method. Do you nee=
d
> to clean up state prior to doing the things in the resume method, or
> otherwise do things to quiesce the driver? If so, they will need to be
> done in the suspend method. The result will be roughly similar to what
> you do for module load/unload, except maybe less complete in some cases=
=2E

I don't doubt your basic assessment. However it doesn't translate that
easily into a real implementation. In my case, I maintain a USB driver,
so I have to deal with USB specifics of suspend/resume which happen not
to be that well documented. My driver provides an isdn4linux device but
isdn4linux knows nothing about suspend/resume so I am on my own on how
to reconcile the two. The device itself, though in turn far from trivial,=

is actually the least of my worries.

>> - What if I know my device would require power management, but don't
>>   know how to implement it?
>=20
> I've just told you above :) Now you know!

No I don't. See above.

>>> -ENOSYS is just not acceptable.
>> Your argument falls down the moment you consider the alternative:
>> not merging the driver means that the device won't work at all.
>> (Given that out-of-tree drivers are actively discouraged, to put
>> it mildly.) That's arguably farther from "desktop readiness" than
>> a device not supporting power management.
>=20
> I disagree (but I would, of course!). If we apply your logic
> consistently, we should merge the driver as soon as any code is written=

> for it (anything is better than nothing). I'm simply arguing that a
> driver that handling suspend and resume should be as much of a
> requirement as not causing memory corruption or such like are.

Well, that's a common fallacy about applying any logic consistently.
There's a continuum of usefulness from "hardly works at all" through
"causes random memory corruption", "doesn't support power management",
and "does not support some esoteric protocol variety no one ever heard
of anyways" up to "supports any and all uses to which anyone could
possibly want to put the device". I would argue that "doesn't support
power management" is *much* farther up that ladder than, for example,
"causes random memory corruption".

Regards,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigB00DA7791053E0E9AEEDF832
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFz7BrMdB4Whm86/kRAlJwAJ0VNjEeZlaqjpZTe9mjsrDPTKb92gCfWREv
FiBNEQ2ptR6MSRfgcRQmb4A=
=v/Q9
-----END PGP SIGNATURE-----

--------------enigB00DA7791053E0E9AEEDF832--
