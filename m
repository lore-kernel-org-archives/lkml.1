Return-Path: <linux-kernel-owner+w=401wt.eu-S1763140AbXJOKyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763140AbXJOKyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 06:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758500AbXJOKxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 06:53:55 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60791 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468AbXJOKxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 06:53:54 -0400
Message-ID: <471346B0.8050102@bull.net>
Date: Mon, 15 Oct 2007 12:53:36 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND 2][PATCH 4/4] Modify KVM to update guest time	accounting.
References: <46E550EF.5080209@bull.net> <20071015093800.GA22818@elte.hu> <47133732.2090809@qumranet.com> <20071015095125.GB28367@elte.hu> <47133ABD.8050608@qumranet.com>
In-Reply-To: <47133ABD.8050608@qumranet.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/10/2007 13:00:17,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/10/2007 13:00:18,
	Serialize complete at 15/10/2007 13:00:18
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB4432969F832F98C794CBDE1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB4432969F832F98C794CBDE1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Ingo Molnar wrote:
>> * Avi Kivity <avi@qumranet.com> wrote:
>>
>> =20
>>> This bit can go; for the external module I can add it back in
>>> external-module-compat.h.  No need to pollute mainline with backward
>>> compatibility stuff.
>>>    =20
>>
>> hm:
>>
>> static inline void kvm_guest_enter(void)
>> {
>>         current->flags |=3D PF_VCPU;
>> }
>>
>> static inline void kvm_guest_exit(void)
>> {
>> }
>>
>> shouldnt PF_VCPU be cleared in kvm_guest_exit()?
>>  =20
>=20
> IIRC the accounting code clears it, but yes, it may not have been calle=
d
> at all, so clearing it here is needed.
>=20

No, It must not be cleared here because we can't enter in the accounting =
code
between kvm_guest_enter(void) and kvm_guest_exit(void).

This is why the accounting code clears it.

I put a kvm_guest_exit() only for symmetry.

Laurent
--=20
---------------- Laurent.Vivier@bull.net  -----------------
"Given enough eyeballs, all bugs are shallow" E. S. Raymond


--------------enigB4432969F832F98C794CBDE1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFHE0a09Kffa9pFVzwRAqrxAKCd4uq+OXRfnFA0B5i5ivwhqvc4hACgzugv
+qJVKsFvUyy5zR9M96mPgPw=
=lQEl
-----END PGP SIGNATURE-----

--------------enigB4432969F832F98C794CBDE1--
