Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbZKQQlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbZKQQlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbZKQQlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:41:17 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:44864 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbZKQQlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:41:16 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Cc: Roel Kluin <roel.kluin@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
       linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, David Wagner <daw@cs.berkeley.edu>
Subject: Re: [PATCH] Documentation: Fix NUL termination of strncpy
In-Reply-To: Your message of "Tue, 17 Nov 2009 12:25:03 GMT."
             <4B02961F.8020108@draigBrady.com>
From: Valdis.Kletnieks@vt.edu
References: <4B018405.2030408@gmail.com> <4B019F52.50509@gmail.com>
            <4B02961F.8020108@draigBrady.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1258476065_3145P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Nov 2009 11:41:05 -0500
Message-ID: <6806.1258476065@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4B02D222.035D,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1258476065_3145P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Nov 2009 12:25:03 GMT, P=E1draig Brady said:

> You need to explicitly NUL terminate strncpy():
> http://www.pixelbeat.org/programming/gcc/string_buffers.html

Umm. Actually, no.  It's *nice* if you explicitly do it.  However, it's
not strictly *required*. Consider this code:

struct a =7B
	int b, c;
	char d=5B20=5D;
=7D

bzero(a,sizeof(a)); /* voila=21 a->d=5B19=5D is now a =5C0 */

Perfectly valid and we do it all the time. Your referenced web page comme=
nts
that using memset() or bzero() is inefficient - I wonder if they actually=

*tested* the difference between using one memset() or bzero() on a large
structure compared to lots and lots of explicit initialization statements=

(i-cache issues probably most important there). The downside is that ther=
e's a
greater chance of some programmer refactoring code and bollixing it up. (=
The
astute reader will remember a short thread about this not too long ago.. =
:)

And if you're truly careful and always use the strn- variants of the stri=
ng
functions, it's actually possible to *not* null-terminate the strings.  B=
ut
it results in very brittle code and makes Baby Andrew cry, mostly because=
 when
somebody adds a printf() to debug the brittle code, it suddenly becomes e=
ven
more brittle... :)=20

--==_Exmh_1258476065_3145P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLAtIhcC3lWbTT17ARArdkAKD48+QmcTMOfkVTbzlucGKjjGTongCgwR9k
Kh3MCVIsFLau3Ne03Tdq5D0=
=80jq
-----END PGP SIGNATURE-----

--==_Exmh_1258476065_3145P--

