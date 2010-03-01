Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab0CAVoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:44:32 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:52612 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451Ab0CAVob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:44:31 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <m1d3zn7uwl.fsf@fess.ebiederm.org>
References: <20100207210250.GB8256@jenkins.home.ifup.org>
	 <tip-f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4@git.kernel.org>
	 <4B881097.1050505@kernel.org>
	 <1267442545.11737.20718.camel@zakaz.uk.xensource.com>
	 <m1d3zn7uwl.fsf@fess.ebiederm.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GWWVMHzuexKVzoEzTcLV"
Date: Mon, 01 Mar 2010 21:44:20 +0000
Message-ID: <1267479860.2785.843.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [tip:x86/irq] x86: apic: Fix mismerge, add
 arch_probe_nr_irqs() again
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=ZtHxNT4mZm3rCuM0SmWmgWxeBwJsziC8EqOrwwVkrhA= c=1 sm=0 a=xE1qpWtd3IAA:10 a=8S3BYs4MTRXEnB8gFTYA:9 a=_i4-JYKzFWNUIQerRatqKQY8nOIA:4 a=HKG8AZp9ye3Cn1R5T94A:9 a=kYAV7KtqaWtpsVHcNecvxFwvprgA:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GWWVMHzuexKVzoEzTcLV
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-03-01 at 10:34 -0800, Eric W. Biederman wrote:
>=20
> As of 2.6.33 the limitations in DomU support are:
> - xen_evtchn_do_upcall starts with the irq number instead of
>   the irq_desc, and happens to unnecessarily call into arch
>   specific code. =20

I saw a patch to fix this one recently, "xen: Remove unnecessary arch
specific xen irq functions.", right?

> - Xen has an array irq_info[NR_IRQS] one of the last static arrays
>   sized at NR_IRQs in the entire kernel.

Hopefully the same info as is in that array could (and indeed should) be
instead stored in irq_desc->chip_data. Would you object to
arch_init_copy_chip_data and arch_free_chip_data becoming function
pointers within the struct irq_chip?

> If you can fix the Xen code so it isn't dragging the rest of the
> kernel down when it comes to large numbers of irqs more power to you.

If you know of other aspects of the Xen code where this is the case (or
find them in the future) please let me know, I'll do my best to fix
them.

Ian.

--=20
Ian Campbell

To the systems programmer, users and applications serve only to provide a
test load.

--=-GWWVMHzuexKVzoEzTcLV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkuMNTQACgkQM0+0qS9rzVk95wCfdhuvlVPLNXYVQBadHsPRwl8m
Lm8AnRubqKoq1YO8sPMj6hGf5T8VfiZi
=HQbC
-----END PGP SIGNATURE-----

--=-GWWVMHzuexKVzoEzTcLV--

