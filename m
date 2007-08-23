Return-Path: <linux-kernel-owner+w=401wt.eu-S1762439AbXHWJex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762439AbXHWJex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 05:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759404AbXHWJeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 05:34:44 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:52929 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795AbXHWJen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 05:34:43 -0400
Message-ID: <46CD54B5.6050200@bull.net>
Date: Thu, 23 Aug 2007 11:34:45 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
Cc: discuss@x86-64.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] Implement missing x86_64 function smp_call_function_mask()
References: <46CD38E5.4000704@bull.net> <200708231125.38816.ak@suse.de>
In-Reply-To: <200708231125.38816.ak@suse.de>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 23/08/2007 11:39:57,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 23/08/2007 11:39:59,
	Serialize complete at 23/08/2007 11:39:59
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig419FE8037CB55511F358E8BC"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig419FE8037CB55511F358E8BC
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Andi Kleen wrote:
> On Thursday 23 August 2007 09:36:05 Laurent Vivier wrote:
>> This patch defines the missing function smp_call_function_mask() for x=
86_64,
>> this is more or less a cut&paste of i386 function.
>=20
> What do you need it for?

Hi Andi,

it is for KVM:

drivers/kvm/kvm_main.c:

 203 void kvm_flush_remote_tlbs(struct kvm *kvm)
 204 {
=2E..
 227         /*
 228          * We really want smp_call_function_mask() here.  But that's=
 not
 229          * available, so ipi all cpus in parallel and wait for them
 230          * to complete.
 231          */
 232         for (cpu =3D first_cpu(cpus); cpu !=3D NR_CPUS; cpu =3D next=
_cpu(cpu, cpus))
 233                 smp_call_function_single(cpu, ack_flush, &completed,=
 1, 0);
 234         while (atomic_read(&completed) !=3D needed) {
 235                 cpu_relax();
 236                 barrier();
 237         }
 238 }

Regards,
Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enig419FE8037CB55511F358E8BC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGzVS49Kffa9pFVzwRAoFlAKCtICqK3f6yw1BrNzFLYO5WbOp+6gCeM97y
0wb2CEqqwuYr64YZ1m44sYg=
=Cna1
-----END PGP SIGNATURE-----

--------------enig419FE8037CB55511F358E8BC--
