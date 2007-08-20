Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbXHTNuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbXHTNuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 09:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbXHTNt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 09:49:57 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55067 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705AbXHTNt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 09:49:56 -0400
Message-ID: <46C99C05.90701@bull.net>
Date: Mon, 20 Aug 2007 15:49:57 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [kvm-devel] [PATCH 4/4] Modify KVM to update guest time accounting.
References: <46C993A6.3060001@bull.net> <46C999C8.4080307@qumranet.com>
In-Reply-To: <46C999C8.4080307@qumranet.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 15:55:08,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 15:55:09,
	Serialize complete at 20/08/2007 15:55:09
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig48ADE0736957CFF903179F09"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig48ADE0736957CFF903179F09
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Laurent Vivier wrote:
>> [PATCH 4/4] Modify KVM to update guest time accounting.
>>
>>  =20
>=20
>> Index: kvm/drivers/kvm/kvm.h
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- kvm.orig/drivers/kvm/kvm.h    2007-08-20 13:23:53.000000000 +0200
>> +++ kvm/drivers/kvm/kvm.h    2007-08-20 13:23:58.000000000 +0200
>> @@ -589,6 +589,17 @@ void kvm_mmu_unload(struct kvm_vcpu *vcp
>> =20
>>  int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> =20
>> +static inline void kvm_guest_enter(void)
>> +{
>> +#ifdef CONFIG_GUEST_ACCOUNTING
>> +    current->flags |=3D PF_VCPU;
>> +#endif
>>  =20
>=20
> Since you select GUEST_ACCOUNTING, the #ifdef is always true?

It is just to avoid error if we compile kvm module outside of the kernel,=
 with
kernel without support of guest accounting. Can be removed if you want.

>> +}
>> +
>> +static inline void kvm_guest_exit(void)
>> +{
>>  =20
>=20
> Missing content?

No, empty function.

It is just to introduce "symmetry" in code, the VCPU code begins with
"kvm_guest_start()" and ends with "kvm_guest_exit()". And we have no oper=
ation
to do in kvm_guest_exit() (the PF_VCPU is cleared by account_system_time(=
)), so
"empty function", removed by the optimizer (I hope).

Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enig48ADE0736957CFF903179F09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGyZwJ9Kffa9pFVzwRAmaUAJ9vgVP8WlZHk6vrSM3A+b+kA9/8JQCgq2a9
KmWrAEpAeNpiBwP+ItVrY9I=
=/vf8
-----END PGP SIGNATURE-----

--------------enig48ADE0736957CFF903179F09--
