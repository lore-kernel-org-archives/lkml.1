Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbYJKPz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbYJKPz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 11:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbYJKPzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 11:55:20 -0400
Received: from mx40.mail.ru ([194.67.23.36]:61861 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbYJKPzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 11:55:20 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: when spin_lock_irq (as opposed to spin_lock_irqsave) is appropriate?
Date: Sat, 11 Oct 2008 19:55:13 +0400
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200810111929.01927.arvidjaar@mail.ru> <200810111741.53404.oliver@neukum.org>
In-Reply-To: <200810111741.53404.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2100474.0vlevzlEYP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810111955.14667.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2100474.0vlevzlEYP
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 11 October 2008, Oliver Neukum wrote:
> Am Samstag, 11. Oktober 2008 17:29:01 schrieb Andrey Borzenkov:
> > Logically, one piece of kernel code has no way to know whether another
> > piece of kernel code (or may be hard-/firmware) has disabled some
> > interrupt line. So it looks like spin_lock_irq should not even exist,
> > except may be for very specific cases (where we are sure no other piece
> > of kernel code may run concurrently)?
> >=20
> > Sorry for stupid question, I an not actually a HW type of person ...
> >=20
>=20
> This has no connection with individual irq lines. It's about being able
> to sleep. Kernel code usually knows whether it can sleep.
> If it knows to be able to sleep it can use spin_lock_irq() which is
> more efficient than spin_lock_irqsave()
>=20

Sorry? I can't sleep under spinlock ... *any* spinlock? Or has this changed?

May I be I was not clear with question. spin_lock_irq implies spin_unlock_i=
rq,
which unconditionally enables interrupts. But I have no idea which interrup=
ts
were disabled before spin_lock_irq; so I may accidentally enable too much?

Or what exactly "irq" in spin_(un-)lock_irq means?

TIA

=2Dandrey

--nextPart2100474.0vlevzlEYP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjwzGIACgkQR6LMutpd94xSCACfX2uBdFb7BsowUI1Ih57dtvdd
kO4AmwRKwl5sCILNA3Ei6sSjyGoxNsVd
=7XCh
-----END PGP SIGNATURE-----

--nextPart2100474.0vlevzlEYP--
