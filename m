Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbXHTHaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbXHTHaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 03:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbXHTHaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 03:30:13 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34188 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbXHTHaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 03:30:11 -0400
Message-ID: <46C94306.8080300@bull.net>
Date: Mon, 20 Aug 2007 09:30:14 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [kvm-devel] [PATCH/RFC 3/4]Introduce "account modifiers" mechanism
References: <46C4719A.2060308@bull.net> <46C4720F.7030304@bull.net>		<46C4725A.4070607@bull.net> <46C4740F.2050701@bull.net>		<1187303955.6449.7.camel@localhost.localdomain>	<46C54FB8.7050504@bull.net>	<1187339450.6449.115.camel@localhost.localdomain> <46C56774.2030009@bull.net> <46C59AB1.6070505@qumranet.com> <46C5ACE8.2050004@bull.net> <46C7F362.80106@qumranet.com>
In-Reply-To: <46C7F362.80106@qumranet.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 09:35:23,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 09:35:24,
	Serialize complete at 20/08/2007 09:35:24
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7C737AE7EF4E858B3CFE62D6"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7C737AE7EF4E858B3CFE62D6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Laurent Vivier wrote:
>> Avi Kivity wrote:
>> [...]
>> =20
>>> The normal user/system accounting has the same issue, no?  Whereever =
we
>>> happen to land (kernel or user) gets the whole tick.
>>>
>>> So I think it is okay to have the same limitation for guest time.
>>>
>>>    =20
>>
>> So this is how it looks like.
>> PATCH 1 and 2 are always a prerequisite.
>>
>>  =20
>=20
>> +    tmp =3D cputime_to_cputime64(cputime);
>> +    if (p->flags & PF_VCPU) {
>> +        p->utime =3D cputime_add(p->utime, cputime);
>> +        p->gtime =3D cputime_add(p->gtime, cputime);
>> +
>> +        cpustat->guest =3D cputime64_add(cpustat->guest, tmp);
>> +        cpustat->user =3D cputime64_add(cpustat->user, tmp);
>> +
>> +        p->flags &=3D ~PF_VCPU;
>> +
>> +        return;
>> +    }
>> +
>=20
> Where did CONFIG_GUEST_ACCOUNTING go?
>=20

Lost in the sea ...

Actually, I thought this modification is not enough expensive (in time an=
d
space) to justify a CONFIG_*. But if you think so I can add this in init/=
Kconfig.

Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enig7C737AE7EF4E858B3CFE62D6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGyUMJ9Kffa9pFVzwRAkNfAJ9N5NHDYRg6q0uL28SuPT9ifCq8GQCfZOAM
QuslB/f41g7GPG+L1cPgSqQ=
=sAZD
-----END PGP SIGNATURE-----

--------------enig7C737AE7EF4E858B3CFE62D6--
