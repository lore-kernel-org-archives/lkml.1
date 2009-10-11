Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZJKRCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZJKRCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 13:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZJKRCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 13:02:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57548 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466AbZJKRCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 13:02:11 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Eric Sesterhenn <snakebyte@gmx.de>,
       Roman Zippel <zippel@linux-m68k.org>, 550010@bugs.debian.org
In-Reply-To: <20091011005153.cc723dca.akpm@linux-foundation.org>
References: <1254883878.4246.191.camel@localhost>
	 <1255227087.25061.76.camel@localhost>
	 <20091011005153.cc723dca.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Pe0GxBTT0Xu6zyb4WbZK"
Date: Sun, 11 Oct 2009 18:01:30 +0100
Message-Id: <1255280490.25061.280.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] hfsplus: Refuse to mount volumes larger than 2TB
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Pe0GxBTT0Xu6zyb4WbZK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-10-11 at 00:51 -0700, Andrew Morton wrote:
[...]
> > --- a/fs/hfsplus/wrapper.c
> > +++ b/fs/hfsplus/wrapper.c
> > @@ -99,6 +99,10 @@
> > =20
> >  	if (hfsplus_get_last_session(sb, &part_start, &part_size))
> >  		return -EINVAL;
> > +	if (part_start + part_size > 0x100000000) {
> > +		pr_err("hfs: volumes larger than 2TB are not supported yet\n");
> > +		return -EINVAL;
> > +	}
>=20
> part_start and part_size are sector_t.  This code will do weird overflow
> things when sector_t is 32-bit.

Sorry, I forgot CONFIG_LBD is still optional.

> Also 32-bit compilers will get upset at the excessively large hex constan=
t.
[...]

Good point.

Ben.

--=20
Ben Hutchings
DNRC Motto:  I can please only one person per day.
Today is not your day.  Tomorrow isn't looking good either.

--=-Pe0GxBTT0Xu6zyb4WbZK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAStIPZee/yOyVhhEJAQI/YBAAiiu08cnDylboPUysRyLi6hYHwhPbvI7a
J2LjaLcf7kZJcGLPc/j+HfOerePO19mejBIrjULiCzO8lKkf2NzPT+HsuzDeKC3R
jT/NMSj5uQ+NPBpUmy4U/fnuDhl0NQ3vdMowc8t5nGXGk0S4tcxOgZxFMUZ/2fST
2j+yXxWJFWnT0BGHoTolgU3qdTvOLloOH9kTXzUzSFQvQznqgwZOHU9/1yP6fyqh
qshffpjkjnDRx7gbR+qjf/nvnB6wcY4DN1ZJFGqQ0c5VxrkfXkF0WhDUuPadGfzB
xHa7PBX5vsAUQ7lCGklHcxxe7SuQ663tez9bFd7T52R8Q9/dT/XuGsEnyYYbMbFm
IbimMd+7n2/bXiDR7KkFO341/bh35mHlddJ2ckHTHFKrSQ6R4WywH5aNEalE+CWf
incnH7B6vvVa8PziNA5Jbh3rcZLlH1vgYdumOJijAX66d0CVDqzCHZzFOKW59KLI
H5Uc0TUcq47IH7yd5psRpyYFyQxUt0nXrbnR/CxNq4TKjx1bEJIMzFAapHtG4Ba2
Cz4P8cMZ4kgCQ4TwnDrzEkAQU7H3VnnGqCVfxqJYWVng2bSPrVzvNXIUt3PjeSwO
Ha4lOhfNnc7dWcNs4NEbqP4FPiu3v8U8s122jIAJrBbxHPs/0VSkrDBGNL0bIUm+
vDoYNoVg1rE=
=TKlS
-----END PGP SIGNATURE-----

--=-Pe0GxBTT0Xu6zyb4WbZK--
