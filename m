Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbZFNXqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbZFNXqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 19:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZFNXqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 19:46:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49508 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbZFNXqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 19:46:44 -0400
Date: Mon, 15 Jun 2009 01:46:43 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Wolfgang Grandegger <wg@grandegger.com>, devicetree-discuss@ozlabs.org,
       Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/2] uio: add an of_genirq driver
Message-ID: <20090614234643.GA17791@pengutronix.de>
References: <1244765062-14144-3-git-send-email-w.sang@pengutronix.de> <20090614122136.GD3639@local> <20090614171406.GA1010@pengutronix.de> <20090614183357.GE3639@local> <20090614190533.GA7387@pengutronix.de> <20090614192359.GG3639@local> <4A355155.4020500@grandegger.com> <20090614203444.GH3639@local> <20090614220022.GB24323@pengutronix.de> <20090614230135.GI3639@local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20090614230135.GI3639@local>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> driver. A user _has_ to setup irq, if there is none, he still has to set
> irq=3DUIO_IRQ_NONE. For that matter, 'not specified' and 'not found' is b=
oth
> the same bad thing.

Hmm, what should I do?

A typical interrupts-property in a device-tree is specified as:

	interrupts =3D <&irq_controller_node irq_number irq_sense>;

Something like UIO_IRQ_NONE does not fit into this scheme, even more as it =
is
Linux-specific and device trees need to be OS independant.

I'm pretty sure the correct way to state that you don't need an interrupt in
the device-tree is to simply not specify the above interrupt property.

Well, yes, that means you can't distinguish between 'forgotten' and
'intentionally left out'. I wonder if it is really that bad? If something d=
oes
not work (=3D one is missing interrupts), the first place to look at is the
device tree. If one does not see an interrupt-property, voila, problem solv=
ed.

(Note that with my latest suggestion, a _wrong_ interrupt is handled the sa=
me
way as with platform_data. request_irq() should equally fail if the
return-value from irq_of_parse_and_map() is simply forwarded.)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko1i+MACgkQD27XaX1/VRtmwgCfU35vNsB6pRMg8ZPEwH5uZbGv
yf0AoK9cs8c+cyQpX3TlCqepX2CY7fID
=ZRIy
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
