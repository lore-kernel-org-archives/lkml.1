Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbYL3Lue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbYL3Lue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 06:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYL3LuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 06:50:18 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:49538 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbYL3LuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 06:50:17 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: warn about headers using __[us]{8,16,32,64} types w/out linux/types.h
Date: Tue, 30 Dec 2008 06:50:14 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1230553127-953-1-git-send-email-vapier@gentoo.org> <200812291527.53317.vapier@gentoo.org> <20081230104303.GA486@uranus.ravnborg.org>
In-Reply-To: <20081230104303.GA486@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5981463.2A98Ec162t";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812300650.15201.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5981463.2A98Ec162t
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 30 December 2008 05:43:03 Sam Ravnborg wrote:
> On Mon, Dec 29, 2008 at 03:27:51PM -0500, Mike Frysinger wrote:
> > > We do not need to warn for each line in a file. Only once is enough.
> >
> > i wasnt sure about that ... got pretty noisy the way i posted it :)
> >
> > > Also I assume that include <asm/types.h> is also ok.
> >
> > i dont think so ... does it really make sense for headers to be hitting
> > asm/types.h anyways ?  shouldnt they all be going through linux/types.h=
 ?
> > checkpatch would certainly warn about it ...
>
> I added following patch which I have pushed out.
>
> 	Sam
>
> From 1f71c478dadbe1425eeaa704e50c7030ab011c5b Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Tue, 30 Dec 2008 11:34:58 +0100
> Subject: [PATCH] kbuild: add checks for include of linux/types in userspa=
ce
> headers
>
> If we see __[us](8|16|32|64) then we must include <linux/types.h>
> If wee see include of <asm/types.h> then we recommend <linux/types.h>
>
> Original script from Mike but modified by me.
>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  scripts/headers_check.pl |   47
> +++++++++++++++++++++++++++++++++++++++++++-- 1 files changed, 44
> insertions(+), 3 deletions(-)
>
> diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
> index 72924a7..b62c319 100644
> --- a/scripts/headers_check.pl
> +++ b/scripts/headers_check.pl
> @@ -34,9 +34,11 @@ foreach my $file (@files) {
>  	$lineno =3D 0;
>  	while ($line =3D <FH>) {
>  		$lineno++;
> -		check_include();
> -		check_prototypes();
> -		check_config();
> +		&check_include();
> +		&check_asm_types();
> +		&check_sizetypes();
> +		&check_prototypes();
> +		&check_config();
>  	}
>  	close FH;
>  }
> @@ -73,3 +75,42 @@ sub check_config
>  	}
>  }
>
> +my $linux_asm_types;
> +sub check_asm_types()
> +{
> +	if ($lineno =3D=3D 1) {
> +		$linux_asm_types =3D 0;
> +	} elsif ($linux_asm_types >=3D 1) {
> +		return;
> +	}
> +	if ($line =3D~ m/^\s*#\s*include\s+<asm\/types.h>/) {
> +		$linux_asm_types =3D 1;
> +		printf STDERR "$filename:$lineno: " .
> +		"include of <linux/types.h> is preferred over <asm/types.h>\n"
> +		# Warn until headers are all fixed
> +		#$ret =3D 1;
> +	}
> +}

you'll want to special case linux/types.h as it should be pulling in=20
asm/types.h ... off the top of my head, that's the only one ...
=2Dmike

--nextPart5981463.2A98Ec162t
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJWgr3AAoJEEFjO5/oN/WBNj8QALc8+xURGtUpZF/YCCH1KW+k
YvSv5sHbZfceRKPcJCT+nW8DZWO0uWS1FA6Xcxi/hVNiQm4ewWTO3yKjs9UZ0o4w
/iGeZnTpaEaj4UPO6BtM38G9ARi15ITJwtnTVycitBXF/ZUVnhmEwIvAePc5bEl1
+I5LknMT0SHOOKMfga/PMc7IFuitCoz8TVDlws3wfkOdovhnciUxqUo4Bw4qsruh
W72n33gKuXUlNCesC0W0MT187vO4VAY708O3arkUCl71BLDxWUPmPRObfuRkkk4G
T21EcYhrK3th50/QiO8pMo0WZad1DUmcO6GvtztFD33shEM9DulHsik/fQaRVBjm
1guTwKFlZwTi0iSuyEVcdWJtB0uJsLSQ/3uAOf/D3I+iqk4AtmDT4LyTIMXHbIM6
0zha8shl7gxt2mMt5HdyRewWk21tqcKwFzmFlqZPnhNO+PV4pxYmjilhUyXNBOTf
p+wUJ4w9nECxXzflfPQeWqUJ/aCHdO0vNwWtukv9c4MYIQd19dX2zpCxeicx8cMy
rMWQ/54GkWlX1gxs5O0KDG5iLxN949DEqCpZOi2ND1PyG2xmLMIW5k07RnccpCtX
9sg4YdFa3sSR8Hk+FLFtXdTx7zofv7lw/k9mHVWo6YyH6NnYe8dbp9weT8VVk9XP
2qQajCQliR6uamOqgtj8
=SnJw
-----END PGP SIGNATURE-----

--nextPart5981463.2A98Ec162t--
