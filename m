Return-Path: <linux-kernel-owner+w=401wt.eu-S1751242AbZHRVbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242AbZHRVbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbZHRVbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:31:39 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:39401 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbZHRVbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:31:36 -0400
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Mario Limonciello <mario_limonciello@dell.com>,
       Marcel Holtmann <marcel@holtmann.org>, cezary.jackiewicz@gmail.com,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <9b2b86520908181408v5f7875b6sea31d8d95cc08c0b@mail.gmail.com>
References: <4A89E768.7010207@dell.com>
	 <1250558643.30166.109.camel@localhost.localdomain>
	 <9b2b86520908180044l72cb8642j6256e246662f7971@mail.gmail.com>
	 <9b2b86520908180752k66feda09rf9034a96ac6ef470@mail.gmail.com>
	 <4A8AE459.8060102@dell.com>
	 <9b2b86520908181408v5f7875b6sea31d8d95cc08c0b@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0VC1sEJhQN+4gmH6espD"
Date: Tue, 18 Aug 2009 23:31:03 +0200
Message-Id: <1250631063.16393.14.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.90 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0VC1sEJhQN+4gmH6espD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi everyone,

> > I'm attaching the updated patch (sorry, git send-email seems to still
> > not be very graceful with line breaks when the SMTP implementation is
> > exchange from what i've seen)
>=20
> > +static void compal_rfkill_poll(struct rfkill *rfkill, void *data)
> > +{
> > +	unsigned long radio =3D (unsigned long) data;
> > +	u8 result;
> > +	bool hw_blocked;
> > +	bool sw_blocked;
> > +
> > +	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
> > +
> > +	hw_blocked =3D !(result & KILLSWITCH_MASK);
> > +	sw_blocked =3D (!hw_blocked && !(result & radio));
> > +
> > +	rfkill_set_states(rfkill, sw_blocked, hw_blocked);
> > +}
>=20
> I assume you have good reason for having sw_block depend on hw_block.
> I.e. you can't read sw_blocked while hw_blocked is set, right?
>=20
> If KILLSWITCH is toggled on and off, will the hardware "forget" any
> prior soft-blocks?

That's a bit strange indeed, but I haven't seen the rest of the code.

Does the 'soft block' bit change based on user input, like pressing a
button?

If not, you shouldn't poll that bit at all, but just set it based on
what rfkill gives you as the return value of set_hw_state().

hth,
johannes

--=-0VC1sEJhQN+4gmH6espD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKix2TAAoJEODzc/N7+Qma1iAP/jsIAhJyN+f43o1KZwYQLkNw
+U1A/tgPlE3PWKyRqVsdzcm34cbQ2FYQd4ojTgaXEMOs8hz4SS+Tj+6tVS6485QA
jWfUB+DkBYjeW95o/qD0duH+raKtH3mCBTdJMuYRkSM/YOXs9rIIKxrR8xqowjVJ
lYAmsJNEMJrHlQFhXttWH6FnEkz7+W9adS2BmJp3/253ARZ4MylmtG0g1p9Ly2gg
nNCqjZeUqRA+VR0/1Nxjt3VmdyBv8VN8BSOAPK52tODrJpv8tsnlHltEWhIGi/Qc
NCaGD5lBURkomslQqLhzAEPtEhCYI3VZU5A03drpsp3bCqsd8PIjXhO9V0/B5Yi5
PpqvQpc1nN3E5FIE1zroZcI7baW5ZpwpKhPfhcGHhwQ2b+jSMI+r1HC0b+viG5/8
JFiELJ5eIvct0wOCkpgHNGpi/JJjauaUASHBC7pNGHwOTeuBi4uF98cgYRopF91p
gfV4Gv59lfw5KpjSklO/OudmnjXd+AwZQF8zHjjs2s5QyRXQey41AQ/RIhfZacNj
BT7KOJwEGt83BNAKoqEuwX0w5QnYnnsSyqBgxAlEep+SHw/coKIL9yhKAfOm6w+F
FUPVyYTjaYGUcNZEo1BGaYUYNt9EojYNEIV75A2agvu3gRI3MlFBtEtzdSmu5nM7
3CcFzlkfTSWf1b7ZemRV
=Duc8
-----END PGP SIGNATURE-----

--=-0VC1sEJhQN+4gmH6espD--

