Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYGKXLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYGKXLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 19:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYGKXLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 19:11:07 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60468 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbYGKXLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 19:11:06 -0400
Subject: Re: [patch 13/17] Use WARN() in drivers/base/
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <20080711151110.ab2b5401.akpm@linux-foundation.org>
References: <20080708093800.274504ba@infradead.org>
	 <20080708095307.6423cb6f@infradead.org>
	 <20080711122011.7ddf42ef.akpm@linux-foundation.org>
	 <20080711135409.6638498d@infradead.org>
	 <20080711151110.ab2b5401.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AYB69X4lMV991P1KZX1Q"
Date: Sat, 12 Jul 2008 01:10:36 +0200
Message-Id: <1215817836.10052.2.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AYB69X4lMV991P1KZX1Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I don't suppose there's any way of tricking the preprocessor into
> supporting
>=20
> 	WARN_ON(foo =3D=3D 42);
>=20
> as well as
>=20
> 	WARN_ON(foo =3D=3D 42, "bite me!");

Here's one that abuses variadic macros and limits the number of
arguments to 19.

#include <stdarg.h>
#include <stdio.h>

#define cnt(y...)   _cnt( , ## y)
#define _cnt(y...) __cnt(y,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,=
0)
#define __cnt(x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17=
,x18,x19,n,ys...) n

static void warn_on_slowpath(int argcount, ...)
{
        va_list args;
        char *fmt;

	// print beginning of warning

        if (argcount) {
	        va_start(args, count);
        	fmt =3D va_arg(args, char *);
	        vprintf(fmt, args);
	        va_end(args);
	}

	// print rest of warning
}

#define WARN_ON(test, fmt...)           	\
  do {                                  	\
      if (test) {                       	\
          warn_on_slowpath(cnt(fmt) , ## fmt);	\
          printf("WARN\n");             	\
      }                                 	\
  } while (0)

int main(void)
{
        WARN_ON(1);
        WARN_ON(1, "asdf %d\n", 7);

        return 0;
}


johannes

--=-AYB69X4lMV991P1KZX1Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJId+hhAAoJEKVg1VMiehFYvl8QAKiW6Ay6nyk6IzSfHTSYAi+g
JiB2cxW9O8qYNWKyZ2hMuHP5woyoFis13ZPaYc45QiugHslo2OPfEFueOdqTG2Kp
TRAMoDPbGe+a2NLShBuR/DFFbzyHOLnunoKbOYBVLTi3025gfxmc5F27QZMM9YNJ
6HUiTHQJANDZQ5utBscALrSuabF6tsfoby9STQlzYiLkzCDj976I+Iz3GyfT2iPG
2UHLWqcdsalo2QaLsmqTk17ao9fCoR1Xwj8ZMrmttngJH28rYr+838N6ab7zEnY2
n0RmB1Gfs29C5tjXPrc788wc1lKowXm2lvAvM/0aST5azY1aBv5mu9rvvJk0uMAB
18LVXt2/4yih+C8xo0VbloDuVS6FalPmjdpSLeKtUNu4mRv4DJ/xgk+NSBy4iL9w
K4SiayfY4YL0GpUL6miqRNgVi8Eignqphon1KLYRauJHjixuwiW+HpNPQnIh0aGT
xnifxe9HK6v/us83cTDQJcTBOZcbiwkkTP6ATfYbLnfBJ4+4NA6jTLRSKXVZv999
tlEZNDQ+oDciMDv1cRg6aoQ3ig/b6S+6SMY/R3DURSSclMnRX/zX3vvhqXufJECV
iD/gn6LAosTmiozT9fhVm9uEVhLvjvuYIg51J+8L+zE+imuHkrjpG/h5k79GpYF4
a3UNdZ54JYGDNDj9TMHv
=lv5Y
-----END PGP SIGNATURE-----

--=-AYB69X4lMV991P1KZX1Q--

