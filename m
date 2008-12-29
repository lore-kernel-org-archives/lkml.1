Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbYL2U2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbYL2U2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYL2U1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:27:55 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:48527 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbYL2U1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:27:54 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: warn about headers using __[us]{8,16,32,64} types w/out linux/types.h
Date: Mon, 29 Dec 2008 15:27:51 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1230553127-953-1-git-send-email-vapier@gentoo.org> <20081229132456.GA6938@uranus.ravnborg.org>
In-Reply-To: <20081229132456.GA6938@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6160406.cFuKtZrNQK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812291527.53317.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6160406.cFuKtZrNQK
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 29 December 2008 08:24:56 Sam Ravnborg wrote:
> On Mon, Dec 29, 2008 at 07:18:47AM -0500, Mike Frysinger wrote:
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > ---
> >  scripts/headers_check.pl |   20 ++++++++++++++++++++
> >  1 files changed, 20 insertions(+), 0 deletions(-)
> >
> > diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
> > index bdd9fb6..5036319 100644
> > --- a/scripts/headers_check.pl
> > +++ b/scripts/headers_check.pl
> > @@ -37,6 +37,7 @@ foreach my $file (@files) {
> >  		check_include();
> >  		check_prototypes();
> >  		check_config();
> > +		check_sizetypes();
> >  	}
> >  	close FH;
> >  }
> > @@ -72,3 +73,22 @@ sub check_config
> >  		printf STDERR "$filename:$lineno: leaks CONFIG_$1 to userspace where
> > it is not valid\n"; }
> >  }
> > +
> > +my $linux_types;
> > +sub check_sizetypes
> > +{
> > +	if ($lineno =3D=3D 1) {
> > +		$linux_types =3D 0;
> > +	} elsif ($linux_types) {
> > +		return;
> > +	}
> > +	if ($line =3D~ m/^\s*#\s*include\s+<linux\/types.h>/) {
> > +		$linux_types =3D 1;
> > +		return;
> > +	}
> > +	if ($line =3D~ m/__[us](8|16|32|64)\b/) {
> > +		printf STDERR "$filename:$lineno: found __[us]{8,16,32,64} type w/out
> > #include <linux/types.h>\n"; +		# Warn until headers are all fixed
> > +		#$ret =3D 1;
> > +	}
> > +}
>
> We do not need to warn for each line in a file. Only once is enough.

i wasnt sure about that ... got pretty noisy the way i posted it :)

> Also I assume that include <asm/types.h> is also ok.

i dont think so ... does it really make sense for headers to be hitting=20
asm/types.h anyways ?  shouldnt they all be going through linux/types.h ? =
=20
checkpatch would certainly warn about it ...
=2Dmike

--nextPart6160406.cFuKtZrNQK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJWTLJAAoJEEFjO5/oN/WBZtcP/iYTDVNQyDZRmVfPj7eN27UV
gxAeExBnyiTJCKQgFjRS2puFiSfoV8BgkNzvajqrBQPXJFcCm+Ra/ZhmL+TynW/w
NIQFa8Ur/Fe/zVM6Njx2fnxCJCRBZEpCatkJSSn3ExK9oEg3ZdsGfzWX8IJBrRaV
bts/tjsSCLbgOcizoOCRmpNcZYSr0tNJYSqd12Dq6RFAu2eFB2guIq8Lhmgumvs2
r5qcDww6VRvfxGq/X3UeuWOH1Nb+KHVucQkF11KOo4u6lERVayy7qSFzBkrmxMNm
MOtLz4EcUPyk1pIDKrGTJu9v/bDItle5sOo46Xh90GFFcllXe07ZtFrzEhsoWG7T
D8/yXB1RAXDNsw3VeQU4r3UKKZltLK20Zmj2zPxF6Phh43xMZWuaIjkyaiS08MuN
rvrmLAVBZBQJS8ShQu1IY/+md9xjBcHNiAKer4t6EThA+gxRa5zV2tPWCGz7EdBX
PHdhwcK6frvhwwA4qXR9iuXUVYHDoMqRw3iwLQezikYLBs2eljn5uG6oeyDeRHj9
j+FJCJsHe1IKQqrd4AzPRY4KWwWL9f3RQyj3w4QCYG6+r7eA63BLbqI3LXBupRKV
cKYz5WgyZhIG+gi04pQC9mPBBZlx5FP4CxymT7M941AzZF+VLYbXAG2hxLedA2L0
Lt+1mGwJS5ISHcZ6VXQ+
=DoHX
-----END PGP SIGNATURE-----

--nextPart6160406.cFuKtZrNQK--
