Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbYJFJQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbYJFJQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 05:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbYJFJQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 05:16:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:18632 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbYJFJQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 05:16:09 -0400
Date: Mon, 6 Oct 2008 12:17:14 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: Implement personality ADDR_LIMIT_32BIT
Message-ID: <20081006091709.GB20852@localhost.localdomain>
References: <1223017469-5158-1-git-send-email-kirill@shutemov.name> <20081003080244.GC25408@elte.hu> <20081003092550.GA8669@localhost.localdomain> <87abdintds.fsf@basil.nowhere.org> <20081006081717.GA20072@localhost.localdomain> <20081006084246.GC3180@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline
In-Reply-To: <20081006084246.GC3180@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 06, 2008 at 10:42:46AM +0200, Andi Kleen wrote:
> On Mon, Oct 06, 2008 at 11:17:23AM +0300, Kirill A. Shutemov wrote:
> > On Mon, Oct 06, 2008 at 08:13:19AM +0200, Andi Kleen wrote:
> > > Unfortunately that doesn't work for shmat() because the address argum=
ent
> > > is not a search hint, but a fixed address.=20
> > >=20
> > > I presume you need this for the qemu syscall emulation. For a standard
> > > application I would just recommend to use mmap with tmpfs instead
> > > (sysv shm is kind of obsolete). For shmat() emulation the cleanest way
> > > would be probably to add a new flag to shmat() that says that address
> > > is a search hint, not a fixed address. Then implement it the way reco=
mmended
> > > above.
> >=20
> > I prefer one handle to switch application to 32-bit address mode. Why i=
s it
> > wrong?
>=20
> "32 bit mode" really has to be set at exec time, otherwise it is not
> (e.g. the stack will be beyond).

Stack isn't a problem for qemu. qemu allocate stack for target application
by itself.

> And personality() is not thread local/safe, so it's not a particularly
> good interface to use later.

qemu can call personality() before any threads will be created.

> Per system call switches are preferable
> and more flexible.

Per syscall switches are cool, but I don't see any advantage from it for=20
qemu.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjp15UACgkQbWYnhzC5v6qV2QCeNlyCez2Win898hSL08zNcwn+
FrgAn1iR+luBG1dnbdbceKtawQCz4sAr
=hmIl
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--
