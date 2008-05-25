Return-Path: <linux-kernel-owner+w=401wt.eu-S1760846AbYEYJbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846AbYEYJbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 05:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYEYJbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 05:31:04 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:57413 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbYEYJbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 05:31:03 -0400
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>,
       Michael Buesch <mb@bu3sch.de>
In-Reply-To: <D56F641E-9FDB-48E5-AF0B-B8E84B08504A@holtmann.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <1211550374.28967.10.camel@pmac.infradead.org>
	 <20080523164108.GA31545@uranus.ravnborg.org>
	 <1211640377.540.14.camel@pmac.infradead.org>
	 <20080524152214.GA12582@uranus.ravnborg.org>
	 <1211642706.31212.85.camel@shinybook.infradead.org>
	 <1211643245.31212.88.camel@shinybook.infradead.org>
	 <D56F641E-9FDB-48E5-AF0B-B8E84B08504A@holtmann.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mVDsLheZBz+krYuxyBBL"
Date: Sun, 25 May 2008 11:30:37 +0200
Message-Id: <1211707837.17151.14.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mVDsLheZBz+krYuxyBBL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> so using "/" within the name parameter for request_firmware() is =20
> actually forbidden. I know that some driver authers think it is a good =20
> idea, but it is not.

Can you explain why it is allowed now? And maybe why the API was
designed in a way that easily allows it?

> I explained this a couple of times. The request_firmware() is an =20
> abstract mechanism that can request a firmware file. The location of =20
> the firmware file is up to the userspace. The kernel requests a =20
> particular file and that is it. All namespacing has to be done by the =20
> firmware helper script (nowadays udev). That the current =20
> implementation of the firmware helper maps the filename 1:1 to a file =20
> under /lib/firmware/ just works, but doesn't have to work all the =20
> time. It is not the agreed contract between kernel and userspace.

I don't buy this argument. I could agree if you said that the "agreed
contract" between the kernel and userspace is for the kernel to request
a firmware file /keyed by an arbitrary, null-terminated string/.

The fact that it is usually stored on a filesystem where / means a
directory (and thus grouping) can be seen as a nice convenience of the
filesystem storage, but if firmware was stored elsewhere then you could
degrade to the simple key-based lookup that happens to allow "/" as a
character in the keys.

And because the kernel is nice, it allows userspace to use a filesystem
storage by not using paths like "../../lib/firmware/asdf". But
fundamentally, I don't even see anything wrong with that.

Put another way, you can have pretty arbitrary firmware firmware names
(though since humans need to handle them you want printable characters),
and I don't see why now all the sudden you would treat "/" specially by
*explicitly* disallowing it.

b43 comes with 22 firmware files for a single driver, and groups them
using "b43/<name>". What you're proposing will make firmware fail
*again* for all users, and we got a *LOT* of flak from all kinds of
stakeholders (not just the users) when firmware upgrades were required,
doing it again for such a petty reason is ridiculous.

johannes

--=-mVDsLheZBz+krYuxyBBL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDkxvKVg1VMiehFYAQLOQQ/9EA5YX8QIzzuZoZ3+X5J3pqAD+UuTyS3z
kdWlMOTuzVOyGkHOnUGDf4b6eF0fvnl5bPa/GeBjnOvhzqYp72KtseqO50Hj1cHr
kAq5uMsovOKqCcMRm2oijrRVz2bKGOUAytV5Ld24PPi/P244Oh2OpaNxA6/9BDzW
2fIOlq++0+1DiARuxa28f/ogfEcw4trhRvpr09Jn78RMe1TjJZ56jMrkR7mXxdJo
fDZB+kvAY2P+rcGoXf3Vudl8KJAcwggIflm8usSPg0OW4yRsX4krutHTyhd398RS
rYeMzX+/g4VxA9lPmiTvoLGvFgrx8hHMdB2zdrDZY2XfSHKkwO8A3lmWId2LNGOO
Go9LyGQ97aQK76kR9cacUt21fsfV548SuAYPs7ZUeIborblUMszR8TBs+nyq6M22
TXd1qc/sP6ET7mpIyaC86TuHvBaYpRfterBDORNQkUb6NhPTdLehCcyOv+FvGpS3
aBpPaU1kFCPwXzHwuo7QRSHGGlkusKc1h40Dg02eHV1/1pLkljG2YEqItoCLfguc
26gCeNNadwcVzgUy8DqBRoDOOw3uax2/xhStB/C+BMLuIV7sa2BMZfjwETIS2BIn
mYAF8WX7SI6aZVjnjCQ6mLmYfOkQrllZggJkW+jh6lPYHmBqc/NcHsildlaTOoC6
zqnnvqeVCXQ=
=A4sS
-----END PGP SIGNATURE-----

--=-mVDsLheZBz+krYuxyBBL--

