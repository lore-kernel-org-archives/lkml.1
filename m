Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbZGVQuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbZGVQuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZGVQuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:50:21 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:59638 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZGVQuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:50:19 -0400
Date: Wed, 22 Jul 2009 18:50:16 +0200
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: kevin.granade@gmail.com
Cc: linux@arm.linux.org.uk, hpa@zytor.com, alain@knaff.lu,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: [PATCH 3/5] Add support for LZO-compressed kernels
Message-ID: <20090722165016.GC4625@pc-ras4041.res.insa>
References: <1248271279-9920-3-git-send-email-albin.tonnerre@free-electrons.com> <0022152d7fe9b6dbcf046f4d04a6@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
In-Reply-To: <0022152d7fe9b6dbcf046f4d04a6@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2009 at 03:28:09PM +0000, kevin.granade@gmail.com wrote :
> On Jul 22, 2009 9:01am, Albin Tonnerre <albin.tonnerre@free-electrons.com>
> wrote:
> > This is the first part of the lzo patch
> >
> > The lzo compressor is worse than gzip at compression, but faster at
> >
> > extraction. Here are some figures for an ARM board I'm working on:
> >
> >
> >
> > Uncompressed size: 3.24Mo
> >
> > gzip 1.61Mo 0.72s
> >
> > lzo 1.75Mo 0.48s
> >
> >
> >
> > So for a compression ratio that is still relatively close to gzip, it's
> >
> > much faster to extract, at least in that case.
>=20
> Is that "time to run the extraction algorithm", or "time to read in image=
 from
> media and extract"? I think the time to read from the media would tend to
> dominate the decompression time.
> Either way, could you provide the other time for each algorithm in order =
to
> give a sense of how this might scale to other CPU speeds/media read speed=
s?
>=20

That's the time to run the extraction algorithm. As H. Peter Anvin pointed =
out,
you can have a fast media and a somewhat slow CPU, for which lzo makes sens=
e.
As for other data, I don't have all the figures handy, but:

 - LZMA: compressed size 1.19Mo, decompression time: several *seconds* (tha=
t's
   on a 180MHz ARM9 board, using a patch to implement LZMA compression simi=
lar
   to this one)
 - Bzip2 eats a lot of RAM, and head.S only gives 64Ko of malloc() space on
   ARM, so I didn't try.

Regards,
--=20
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJKZ0NIAAoJEBEG8gBbtuSl0x0P/32kBqozhjvMJVjopQhg879k
CqVLP9CXmPcfFGc3ytyAnbP3glR+DiAcpc4sWvvCowZZ+k13znU5DpDMgl4+MdVl
XHr3ebrQJon+LJ6toRmcPuy2U/qTqBV2vrAcy7PNViUMVG2QAKPS9LWYsQjdbHW5
Z6bXMOdLCwVGJgENxapgKDwG+yGlDirROGoGHinIdHZmLnNdc+vMd+Grme58jSwC
/D4l4vTU0kEOMon5t2sZOGguyPr7VGTzjJjHZ7vP2B+ltPobwmT1H4C/uut2KPkh
cYxPevUjTkrvXiOqX8NBzB+FBxw8j/S99PEGH9sSTlMEaoPShz+QvR3AUFOcyAsQ
IGoEmCnmm8tYwdhRPUKNs9APVdkQGilAgkVt6Sv/KgJ6ovs0cGMy0KO33TkK/+nS
CgonnEVizauYxmg4mNCOdtxgOSIZvhw7vWQoGdzeC1REg+Lcpa8cadcRrYkZ5BO+
yYXAHCRIX2C4mTzPq+bow7bMaoGnlAt7YFh8WkLi4Uuv1od3qKowqytSXp+07qsx
AGseHIosb33EhCJb09Fbf7TCQDwnXKzrAMpTH/YvYfSoyX/0kdRNSmwRB1RhHSx1
edLCu6mtnbO4A2rTLLEel7OdU4UqJUq3Tbeu4tYLoZNSNgxLXyWlHocNX5NLeOpK
vT+GmLRBLkOipprBfFDW
=jHrT
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
