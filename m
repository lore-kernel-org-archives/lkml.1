Return-Path: <linux-kernel-owner+w=401wt.eu-S971193AbXHMQcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971193AbXHMQcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764676AbXHMPgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:36:11 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49117 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939525AbXHMPgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:36:09 -0400
Message-ID: <46C07A67.8060107@bull.net>
Date: Mon, 13 Aug 2007 17:36:07 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: kvm-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [PATCH 0/2][KVM] guest time accounting
References: <46BC8B39.6050202@bull.net> <46C06AFE.2050702@qumranet.com>	<46C06D99.2030106@bull.net> <200708131722.43936.borntraeger@de.ibm.com>
In-Reply-To: <200708131722.43936.borntraeger@de.ibm.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/08/2007 17:41:09,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/08/2007 17:41:10,
	Serialize complete at 13/08/2007 17:41:10
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig39EE4D22E353FCD5405284F8"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig39EE4D22E353FCD5405284F8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Christian Borntraeger wrote:
> Am Montag, 13. August 2007 schrieb Laurent Vivier:
>>>> As guest accounting is hw dependent, I think we should add a hook in=
 the
>>>> accounting functions.
>>>>  =20
>>> Isn't PF_VM exactly such a hook?  All the hypervisor needs to do is t=
o
>>> set/unset it correctly?
>> In fact, no.
>>
>> PF_VM is used to know we have entered a virtual CPU (the hypervisor se=
t it,
>> the scheduler unset it on accounting)
>=20
> Why not do something like the following. (This patch does not work as i=
t=20
> relies on the no-existing var cputime_since_last_update, but it shows t=
he=20
> idea)

Yes, I think it is a really good idea, much more cleaner.

But doing like that you can have cpustat->system decreasing and thus nega=
tive
values in "top".

It is why I modify account_system_time() (see my last patch) to decrease =
the
value to add to system time accordingly the value we add in cpustat->gues=
t, and
thus system time never decreases. We cannot do that when we call
account_system_time() from KVM part.

Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enig39EE4D22E353FCD5405284F8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGwHpq9Kffa9pFVzwRAuC2AKC8viT2Y1Hk/RyvihaKtR67ldatMwCgoP7c
4cz9sABTHXZOD7Vdui+QuWI=
=4M6j
-----END PGP SIGNATURE-----

--------------enig39EE4D22E353FCD5405284F8--
