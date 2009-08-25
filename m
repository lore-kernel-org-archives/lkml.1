Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbZHYVtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbZHYVtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 17:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZHYVtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 17:49:42 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37094 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbZHYVtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 17:49:41 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Helge Deller" <deller@gmx.de>
Subject: Re: kernel segv with 2.6.31-rc6 ?
Date: Tue, 25 Aug 2009 17:49:40 -0400
User-Agent: KMail/1.12.0 (Linux/2.6.30.4; KDE/4.3.0; x86_64; ; )
Cc: roland@redhat.com, James.Bottomley@hansenpartnership.com,
       rusty@rustcorp.com.au, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, John David Anglin <dave.anglin@nrc.ca>
References: <4A89CC4D.5040801@gmx.de> <20090820115122.123520@gmx.net> <20090820122537.29410@gmx.net>
In-Reply-To: <20090820122537.29410@gmx.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1908013.TYp3mq9syD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200908251749.42647.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1908013.TYp3mq9syD
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thursday 20 August 2009 08:25:37 Helge Deller wrote:
> The reason seems to be, that something in the newer gcc compilers changed
> to generate multiple sections all named ".text" for the PCREL17
> relocations. Older compilers named those sections ".text.1", ".text.2",
> ".text.3" and so forth.

we saw this on Blackfin some time ago and it was tracked back to attribute =
mismatches in
assembly files:
http://blackfin.uclinux.org/gf/tracker/3638
http://blackfin.uclinux.org/gf/project/linux-kernel/scmsvn/?action=3Dbrowse=
&path=3D/trunk/arch/blackfin/mach-
common/entry.S&r1=3D3898&r2=3D3897&pathrev=3D3898

when `ld -r` ran, the sections named .text couldnt be combined due to diffe=
rent attributes so ld just added the .#=20
suffix for us

if you have scanelf installed (from pax-utils), that might help track back =
the source object ... `scanelf -qrk .text.1 ./`
=2Dmike

--nextPart1908013.TYp3mq9syD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJKlFx2AAoJEEFjO5/oN/WBMjkP/RTTDa+8jdxV2KveG3fCmwBa
DGFpg8aN4ADgeATlkiNFZgh/c9WMs4aQAvt4o0kQ4vIcMMeBjwxn/CVFteRDpCBk
4ToIzwohjcDJAurTSD/WXwNA2C0ekYAh2eIq5+N+lihZMAG6wic8OlkNdcBDYqO4
vtD4UEV0TyyTxQJqn5BdJ/+T2Xt85NoJd4yzp6pD9lI3QQLsDCpn20wWsc1icBoe
BxX4l98Xo/EN6ac5Tz8dMbt52OTpXwm2SqLHQnbkCTFv65rXwoh0h58TF8Oe5jz+
J3ga/skXfYV4Pf+GK4PwuLjwM27JItmYeEzlDE4sMmxaHPpcUwAhoytoAn5LG+HD
1lLVGnhMHdJE+s7JV4/fFGRvNjaD3v6Z5uUPsN0w1qaSU63eNKa1T4gCYAAhP5j2
QXHstMHfUeHzeJ2bRPvvrND34rgOnlsV97899SZq0UdsbGkZB0RBtwpTBeCJ4g2K
nifuK0MTNCwyufmpajfgmB3k9O3yqKNtLNuUvdLoYV7zhjLE9geAnP+Wvl7fMpMe
MtqIyhYYMbemHfJwWncbZAsiyNbK9swlVm7s9Z1fp4dySMrJYkzc9HugYv1JVXB1
A4/lK3pmj7OjvxJCzz0LMBQJte5I8NgP6pmnsEpxNntxEmBvi6wrO+GJ4gIEHmw+
xNN6RfQ4Bdu4H/AfU1Mo
=afY3
-----END PGP SIGNATURE-----

--nextPart1908013.TYp3mq9syD--
