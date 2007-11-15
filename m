Return-Path: <linux-kernel-owner+w=401wt.eu-S932989AbXKOVVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbXKOVVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763480AbXKOVUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:20:54 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:38638 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763225AbXKOVUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:20:52 -0500
Message-ID: <473CB82F.8060204@web.de>
Date: Thu, 15 Nov 2007 22:20:47 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Young <hidave.darkstar@gmail.com>, Greg KH <greg@kroah.com>
Subject: Re: [patch 04/13] param_sysfs_builtin memchr argument fix
References: <20071115042610.731859958@mini.kroah.org> <20071115060927.GE7602@kroah.com> <473C6FCF.6010501@redhat.com> <20071115175810.GC24531@suse.de> <473CB03D.6000404@redhat.com>
In-Reply-To: <473CB03D.6000404@redhat.com>
X-Enigmail-Version: 0.94.4.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2B91C0A08253F84412DC622B"
X-Provags-ID: V01U2FsdGVkX18PAZO+ngk4u+kqR7+pm/SUofxoARot1DTp3XIh
	o5o1fUAt3nKw9Nmwk/0cbXpS5S7b+pde+FwDdBCXnYyxU5j426
	+mf8jvs8c=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2B91C0A08253F84412DC622B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Chuck Ebbert wrote:
> On 11/15/2007 12:58 PM, Greg KH wrote:
>> On Thu, Nov 15, 2007 at 11:11:59AM -0500, Chuck Ebbert wrote:
>>> On 11/15/2007 01:09 AM, Greg KH wrote:
>>>> -stable review patch.  If anyone has any objections, please let us k=
now.
>>>>
>>>> ------------------
>>>> From: Dave Young <hidave.darkstar@gmail.com>
>>>>
>>>> patch faf8c714f4508207a9c81cc94dafc76ed6680b44 in mainline.
>>>>
>>>> If memchr argument is longer than strlen(kp->name), there will be so=
me
>>>> weird result.
>>>>
>>>> It will casuse duplicate filenames in sysfs for the "nousb".  kernel=

>>>> warning messages are as bellow:
>>>>
>>> Needs an additional fix:
>>>
>>> Commit:     22800a2830ec07e7cc5c837999890ac47cc7f5de
>>> fix param_sysfs_builtin name length check
>> That just went in yesterday, right?  If so, it will have to wait until=

>> the next -stable review cycle, unless it's totally broken without that=

>> change.
>>
>> Is it?
>>
>=20
> Yeah, pretty much AFAICT. Maybe Jan can say exactly what happened, but
> it looks like the patch would cause more problems than it solves.
>=20

If you have a module parameter like
"my_module.uses_long_parameter_names", Dave's patch caused it to be
rejected if that module was built into the kernel, although "my_module"
is far shorter than MAX_KBUILD_MODNAME, thus perfectly legal.

I noticed this with out-of-tree stuff, but I would bet in-tree users are
affected as well. Hmm... e.g. "nf_conntrack.expect_hashsize" should not
longer exist if nf_conntrack is non-modular.

Jan


--------------enig2B91C0A08253F84412DC622B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHPLgzniDOoMHTA+kRAr9SAJ9ydh8yVkpbwN1lFNss4oejsMX7bACeP9bZ
uohN6+bLN7Q+WREFXR/l8pc=
=f41C
-----END PGP SIGNATURE-----

--------------enig2B91C0A08253F84412DC622B--
