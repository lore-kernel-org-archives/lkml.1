Return-Path: <linux-kernel-owner+w=401wt.eu-S1763016AbZJOW0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763016AbZJOW0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 18:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758713AbZJOW0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 18:26:18 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:33262 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786AbZJOW0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 18:26:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=RwMnbrgjKTKfrH2rQGDOjG3Sca2vKYGkRCgaoW+wfRumHzWDoVX1ej6z5e1Dgc7rG2
         8iywlsEc7yKg7S0Qe5OUHLycSvYsUJyj92bnc7505YghHqcEfVcNR0yoFJEKp1DWG3uM
         J8ZvzLMRbNUXZabH4PNSeNYpgmSb9SoWv6RLw=
Message-ID: <4AD7A141.3060102@gmail.com>
Date: Thu, 15 Oct 2009 18:25:05 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Gregory Haskins <ghaskins@novell.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, sfr@canb.auug.org.au,
       greg@kroah.com, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: [BUILD-FAILURE] next-20091015 - vbus_enet driver breaks with
 allmodconfig
References: <20091015152538.74a1cb15.sfr@canb.auug.org.au>	<20091015104852.GA6740@linux.vnet.ibm.com>	<4AD6CD940200005A00056857@sinclair.provo.novell.com>	<4AD75E60.4020306@gmail.com> <20091015114210.65e1be72.randy.dunlap@oracle.com>
In-Reply-To: <20091015114210.65e1be72.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF135C229963BF58A4FFDD8B8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF135C229963BF58A4FFDD8B8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Randy Dunlap wrote:
> On Thu, 15 Oct 2009 13:39:44 -0400 Gregory Haskins wrote:
>=20
>>
>> I am having difficulty reproducing the problem.  When I look at the
>> Kconfig, I see that VBUS_ENET has a "select VBUS_PROXY" as I would
>> expect.  Additionally, if I run allmodconfig I can confirm that I get
>> VBUS_ENET=3Dm, VBUS_PROXY=3Dy:
>=20
> Greg,
>=20
> Did you try to reproduce it with the ppc64 config file?
> allmodconfig on what arch?
>=20
> I think the problem is that arch/x86/Kconfig says:
>=20
> source "drivers/vbus/Kconfig"
>=20
> and that should actually be in drivers/Kconfig, so that it applies
> to ppc64 et al, not just x86.

Ah, indeed.  I only have/tried x86, and that is the issue.  I will have
to fix this (and the create_irq() dependency you mention in the next mail=
).

Thanks Randy.

-Greg


--------------enigF135C229963BF58A4FFDD8B8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrXoUEACgkQP5K2CMvXmqHjPwCdGjUZb1/Cutbea5ZkZYkYI832
+x0Ani3clRM6y9kcGDoZouUZb4weaht/
=OVu/
-----END PGP SIGNATURE-----

--------------enigF135C229963BF58A4FFDD8B8--
