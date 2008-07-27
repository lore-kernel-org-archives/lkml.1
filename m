Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbYG0NMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbYG0NMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 09:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYG0NMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 09:12:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56236 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYG0NMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:12:42 -0400
Date: Sun, 27 Jul 2008 23:11:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trent Piepho <tpiepho@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Richard Purdie <rpurdie@rpsys.net>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] leds: make the default trigger name const
Message-Id: <20080727231149.1b2508da.sfr@canb.auug.org.au>
In-Reply-To: <20080727020857.GM12191@secretlab.ca>
References: <Pine.LNX.4.64.0807181339500.10116@t2.domain.actdsltmp>
	<1217019705-24244-1-git-send-email-tpiepho@freescale.com>
	<20080727020857.GM12191@secretlab.ca>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__27_Jul_2008_23_11_49_+1000_nza_GRb/r6/K0b.d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__27_Jul_2008_23_11_49_+1000_nza_GRb/r6/K0b.d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trent,

On Sat, 26 Jul 2008 20:08:57 -0600 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> On Fri, Jul 25, 2008 at 02:01:44PM -0700, Trent Piepho wrote:
> > The default_trigger fields of struct gpio_led and thus struct led_class=
dev
> > are pretty much always assigned from a string literal, which means the
> > string can't be modified.  Which is fine, since there is no reason to
> > modify the string and in fact it never is.
> >=20
> > But they should be marked const to prevent such code from being added, =
to
> > prevent warnings if -Wwrite-strings is used and when assigned from a
> > constant string other than a string literal (which produces a warning u=
nder
> > current kernel compiler flags), and for general good coding practices.
> >=20
> > Signed-off-by: Trent Piepho <tpiepho@freescale.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

I would ack this as well, except I am not sure what tree this patch is
against.  In the current powerpc next tree,


> > +++ b/include/linux/leds.h
> > @@ -48,7 +48,7 @@ struct led_classdev {
> > =20
> >  	struct device		*dev;
> >  	struct list_head	 node;			/* LED Device list */
> > -	char			*default_trigger;	/* Trigger to use */
> > +	const char		*default_trigger;	/* Trigger to use */

this is already const, but there is another structure slightly further
down (struct led_info) that has a non-const default_tigger.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__27_Jul_2008_23_11_49_+1000_nza_GRb/r6/K0b.d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiMdBUACgkQjjKRsyhoI8wkPQCfXx7UyEDbUIM6bv8qFmwDl44m
HAoAn1WKfzXFkpfL8+/5MYHOCBtd8AIT
=25GB
-----END PGP SIGNATURE-----

--Signature=_Sun__27_Jul_2008_23_11_49_+1000_nza_GRb/r6/K0b.d--
