Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbXLSCzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbXLSCzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 21:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXLSCy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 21:54:57 -0500
Received: from home.keithp.com ([63.227.221.253]:1356 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbXLSCy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 21:54:56 -0500
X-Greylist: delayed 663 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2007 21:54:55 EST
Subject: Re: PCI resource problems caused by improper address rounding
From: Keith Packard <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: keithp@keithp.com, Richard Henderson <rth@twiddle.net>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
In-Reply-To: <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org>
References: <47671377.6000405@redhat.com>
	 <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org>
	 <47680489.6040809@redhat.com>
	 <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org>
	 <20071218202234.GA24525@twiddle.net>
	 <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-P6/l4qZ6gSF82xYffHV/"
Date: Tue, 18 Dec 2007 14:16:27 -0800
Message-Id: <1198016187.5570.21.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-P6/l4qZ6gSF82xYffHV/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-12-18 at 13:09 -0800, Linus Torvalds wrote:

> It's not like 256MB is even as large as they come, half-gig graphics card=
s=20
> are getting to be fairly common at the high end, and X absolutely _has_ t=
o=20
> be able to handle a 64-bit address for those.=20

We're now using a system-dependent wrapper library 'libpciaccess' for
all of this stuff, it uses 64-bits for all PCI addresses and should make
this transparent to the X driver.

In addition, our kernel drivers are moving to support graphics cards
that have memory beyond that addressable through their aperture, so we
should be able to manage cards with even more memory, some of which is
not reachable from the CPU.

> Also, I'm surprised it doesn't work with X already: the ChangeLog for X=20
> says that there are "Minor fixes to the handling of 64-bit PCI BARs [..]"=
=20
> in 4.6.99.18, so I'd have assumed that XFree86-4.7.0 should be able to=20
> handle this perfectly well.

And that code has been replaced with an even more general library that
abstracts away all of the PCI routing issues.

> I'll add Keithp to the cc too, to see if the X issues can be clarified.=20
> Maybe he can set us right. But maybe you just have an old X server? If so=
,=20
> considering the situation, I really think the kernel has done a good job=20
> already, and I'd be *very* nervous about making the kernel allocate new=20
> PCI resources right after the end-of-memory thing.

Trying a libpciaccess-based X server is certainly something worth doing,
that should be 1.4 or later (thanks, git-describe).

> I bet it would work in this case, but as mentioned, we definitely know of=
=20
> cases where the BIOS did *not* document the magic memory region that was=20
> stolen for UMA graphics, and trying to put PCI devices just after the top=
=20
> of reserved memory in the e820 list causes machines to not work at all=20
> because the address decoding will clash.

There is an additional single-page BAR on 9xx chips which may end up
mapped and not documented. Our kernel driver should correctly deal with
that now though.

--=20
keith.packard@intel.com

--=-P6/l4qZ6gSF82xYffHV/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHaEa7Qp8BWwlsTdMRAq7+AJ0aDY+PhDh5US6YotS8w52wflliFwCffyWA
rnmz8HdYNqxW1klcPEUOp1w=
=dnsO
-----END PGP SIGNATURE-----

--=-P6/l4qZ6gSF82xYffHV/--

