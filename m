Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZKMN3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZKMN3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 08:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZKMN31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 08:29:27 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:57872 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbZKMN31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 08:29:27 -0500
Subject: Re: [PATCH 2.6.32] ftrace: fix event format export
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Schwab <schwab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <m3y6mazhij.fsf@hase.home>
References: <1258115870.6167.4.camel@johannes.local>
	 <m3y6mazhij.fsf@hase.home>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AbVU4QqEclcPQW+qCHPa"
Date: Fri, 13 Nov 2009 14:29:26 +0100
Message-ID: <1258118966.6167.21.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AbVU4QqEclcPQW+qCHPa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-11-13 at 14:22 +0100, Andreas Schwab wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > --- wireless-testing.orig/include/trace/ftrace.h	2009-11-13 13:15:21.00=
0000000 +0100
> > +++ wireless-testing/include/trace/ftrace.h	2009-11-13 13:34:03.0000000=
00 +0100
> > @@ -159,7 +159,7 @@
> >  #undef __get_str
> > =20
> >  #undef TP_printk
> > -#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
> > +#define TP_printk(fmt, args...) "\"%s\", %s\n", fmt, __stringify(args)
>=20
> Would using __stringify(fmt) work?  If there are double quote characters
> in fmt your solution would produce output that is ambiguous.

No, for say

#define FOO_FMT		"foo:%d"

and using
	FOO_FMT ", %d"
that would give
	""%s", %d"
instead of
	"%s, %d"

However, isn't it already ambiguous that way? I fail to see why %s, #fmt
would preserve inside " properly.

johannes

--=-AbVU4QqEclcPQW+qCHPa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK/V8zAAoJEODzc/N7+Qmade0P/jE1IkMojPwQi8iHPgifpt0+
OiKrOv+frmcydWm2L3gfCmrNqNsd8+GzXNPvF9SoJnIlV+yTchrawIAZozM9ebew
IGrTFz2OhfUyvlIv6e9ONWPOYIRPjJyiHCmFa74u0EHgdow/6V2DX1YiMvrm8D3y
PeFc7Z6KQxXUF1dv1mPVqFUNyG6HX+LXWh26wP+QoWjgXJuvmDCIqJOSZmtAD2SN
nWZabY0w5ZnH3uM2AIKOCdidS7H6boAqY+NyAXZ1HJiAi5yH2bOOyzGyBSRPlVY/
9u2yioTdS60cf0UBsR9cV1RluaE68CRvOL+ksl86TYIC2cdMu9r1byW8+7WP3BHr
DtPpbdkW6iuEpRJP8NM/2OG2Gqj2xmOR0Q2lhCMLySYhlNKQLqESaU3ILbOvm65t
yGVp0Wi+CUf/Q2N4Gz/CMPRWAiOR0Br42YOZKT5Q1c6lJspTU1/1SIi/8erIoSaV
LNJDRE/61oHbjUvo0zCm9aEjOfquW7v9nU23/c1EvxFMtoLEB9g8dUmOQQYxANnN
bESbUeazvCkwwWYbZPn6TH2jH6/4WhkfC/7cMvPgXZ3Lq/G0cTADVe8q4twI6jMM
xmqz/6mZ8OIExfxtilCTUiE2jTElh3iaZsxmYvClDOZVdGz1YAn2fw8HGTHLvM+l
8VJG2EdpNC6sWVAmzSMz
=TjrH
-----END PGP SIGNATURE-----

--=-AbVU4QqEclcPQW+qCHPa--

