Return-Path: <linux-kernel-owner+w=401wt.eu-S1764396AbXJOLjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764396AbXJOLjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbXJOLjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:39:12 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50751 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539AbXJOLjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:39:10 -0400
Message-ID: <47135150.8040901@bull.net>
Date: Mon, 15 Oct 2007 13:38:56 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND 2][PATCH 4/4] Modify KVM to update guest time accounting.
References: <46E550EF.5080209@bull.net> <471346B0.8050102@bull.net> <47134BCE.1080306@qumranet.com> <200710151333.21078.borntraeger@de.ibm.com>
In-Reply-To: <200710151333.21078.borntraeger@de.ibm.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/10/2007 13:45:34,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/10/2007 13:45:36,
	Serialize complete at 15/10/2007 13:45:36
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig49F5BEEB615E63CA953CABAF"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig49F5BEEB615E63CA953CABAF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Christian Borntraeger wrote:
> Am Montag, 15. Oktober 2007 schrieb Avi Kivity:
>> We can clear it a bit later, after local_irq_enable() in __vcpu_run().=
 =20
>> However we need a nop instruction first because "sti" keeps interrupts=
=20
>> disabled for one more instruction.
>=20
> Ah, I see. The host interrupt  behaves different and instead of running=
 the
> interrupt handler, it exits the vmrun on x86? The interrupt handler wil=
l be
> called some cycles after the sti?
> That is different to s390. We can run the guest code for a long time an=
d the
> host instruction pointer stays on the sie instruction. That means, we c=
an=20
> interrupt sie and continue by simply setting the instrution pointer (PS=
W)=20
> back to the sie instruction.
>=20
> Any idea how to make this proper on all architectures? I will have a lo=
ok.

I think the solution is to have an arch dependent kvm_guest_exit(): empty=
 for
x86, clearing the bit for s390.

Regards,
Laurent
--=20
---------------- Laurent.Vivier@bull.net  -----------------
"Given enough eyeballs, all bugs are shallow" E. S. Raymond


--------------enig49F5BEEB615E63CA953CABAF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFHE1FQ9Kffa9pFVzwRAvdLAJ9KjKWLnyEpvc4R2V2uE2X6dSt/RQCeMs+d
ul7RLxTE6SJg3s1oJfqcBn0=
=jZC9
-----END PGP SIGNATURE-----

--------------enig49F5BEEB615E63CA953CABAF--
