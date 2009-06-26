Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbZFZX6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbZFZX6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 19:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZFZX5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 19:57:53 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:42937 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZFZX5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 19:57:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=G+G8jUUyO6/Upv1SNsHwh19VYCF8ei9XGR01nx51jFm6vTZQhsQf7Y7x3wpqq0HYmM
         2a5eTkJGnhinOHmSegFukjmLemEyQUzNdfRpwc46V9sp6RlxGLiBTSti7C9jUcrCNAj3
         fbR43SrVmnQQbpgWbGxnliW8q/KxpgWN73Emk=
Subject: Re: [PATCH] PCAP RTC driver (for 2.6.32).
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, openezx-devel@lists.openezx.org,
       sameo@linux.intel.com
In-Reply-To: <20090626132310.60665a98.akpm@linux-foundation.org>
References: <1245962749.10360.42.camel@brutus>
	 <20090626132310.60665a98.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ccFsr2bc8E0DzpNROLp1"
Date: Fri, 26 Jun 2009 20:57:38 -0300
Message-Id: <1246060658.10360.336.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ccFsr2bc8E0DzpNROLp1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Em Sex, 2009-06-26 =C3=A0s 13:23 -0700, Andrew Morton escreveu:
> This could be coded more simply:
>=20
> 	unsigned long rtc_events;
>=20
> 	if (irq =3D=3D pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ))
> 		rtc_events =3D RTC_IRQF | RTC_UF;
> 	else if (irq =3D=3D pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA))
> 		rtc_events =3D RTC_IRQF | RTC_AF;

This would make gcc complain about rtc_events being used uninitialized.

> SEC_PER_DAY is defined in include/linux/mfd/ezx-pcap.h.  It should not
> be, because it is not specific to that driver and can be used elsewhere
> in the kernel.
>=20
> I'd suggest that we
>=20
> - define SECS_PER_DAY in include/linux/time.h
>=20
> - remove the private definitions of SECS_PER_DAY from
>   arch/m68k/mac/misc, arch/parisc/include/asm/rtc.h,
>   arch/ia64/hp/sim/boot/fw-emu.c, fs/udf/udftime.c, fs/fat/misc.c and
>   wherever else it appears, make those files use the common definition
>=20
> - migrate rtc-pcap.c from SEC_PER_DAY over to the common SECS_PER_DAY.
>=20
> - Then do it all again for SECS_PER_MIN and SECS_PER_HOUR.
>=20
>=20
> What a mess.

I can't work on this right now, but i will be happy to reserve some
hours for this next month if nobody else does it before.

> "tmp" is a poor identifier.  We had an opportunity here to use an
> identifier which would communicate useful information to the reader.=20
> But we blew it and used the information-free "tmp" instead.
>=20
> Something like
>=20
> 	u32 time_of_day;	/* In seconds since midnight */
>=20
> would be nice.  If that is indeed what the variable contains.  How
> would I know?  It's called 'tmp" and is undescribed!

Hum.. I used tmp because the variable is reused and it may be "days
since 1/1/1970" or "seconds since today's 00:00:00". I will add some
comments to make this clear.

> > +static inline int pcap_rtc_irq_enable(struct device *dev, int pirq,
> > +							unsigned int en)
> > +{
> Inlining this function probably made the code larger and slower.

Right, i will amend this.


I see that you have already added it to the -mm tree. Do you prefer an
incremental patch to address your comments or should I send a patch to
replace the current version?

Thanks for the review! :)

--=20
Daniel Ribeiro

--=-ccFsr2bc8E0DzpNROLp1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpFYHIACgkQw3OYl0G0liSVnACfWQdqPsIsJU3Fosffs8m+sD17
GhcAn3PmDcTs7ecYoobX1YPGddapyfEq
=TGwX
-----END PGP SIGNATURE-----

--=-ccFsr2bc8E0DzpNROLp1--

