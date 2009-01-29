Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbZA2NIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbZA2NIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZA2NI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:08:26 -0500
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:36760 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbZA2NIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:08:25 -0500
Date: Thu, 29 Jan 2009 14:08:02 +0100
From: Frank Mehnert <Frank.Mehnert@Sun.COM>
Subject: Re: PFs on pages pinned with get_user_pages()
In-reply-to: <1233232094.4495.45.camel@laptop>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200901291408.02454.frank.mehnert@sun.com>
Organization: Sun Microsystems
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart2744856.2BUzvHmh9c
Content-transfer-encoding: 7BIT
References: <200901290905.10966.frank.mehnert@sun.com>
 <1233232094.4495.45.camel@laptop>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2744856.2BUzvHmh9c
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Peter,

On Thursday 29 January 2009, Peter Zijlstra wrote:
> On Thu, 2009-01-29 at 09:05 +0100, Frank Mehnert wrote:
> > please could someone explain me under which circumstances a pagefault,
> > either generated from kernel code or from userland code, can occur on
> > pages which are pinned with get_user_pages()?
> >
> > So far my understanding was that this can _never_ happen but I seems to
> > be wrong. Under high memory pressure I get PFs on such pages raised from
> > kernel code and the PFs are handled by do_swap_page(). When this happen=
s,
> > page_count is 3 but page_mapped() returns false.
>
> Under memory pressure the page reclaim will first unmap the physical
> page from the virtual address range, and then try to free it.

Which means the page table entry is removed but the physical page
is not swapped out, right?

> Obviously the freeing bit fails if you hold a reference to it, but the
> unmap will work.

Right.

> After that, userspace will have to (minor) fault the stuff back in.

So do_swap_page does only 'restore' the page table entry, no further
reading from the swapfile is necessary?

> Also, that same page-reclaim, or pdflush might decide to write out dirty
> data, which will also result in (minor) faults when userspace will
> re-dirty the pages.
>
> Having a page reference will only avoid the physical page from getting
> removed from its current mapping (and thereby also pins the mapping).

Question: Is it possible to prevent these minor page faults at all?

Thank you very much for your answer!

=46rank
=2D-=20
Dr.-Ing. Frank Mehnert    Sun Microsystems    http://www.sun.com/

--nextPart2744856.2BUzvHmh9c
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmBqjIACgkQ6z8pigLf3EcFtgCdGJxEDAYIpqO0nqB1VbI9iryw
jmEAoJgkakpaoRkpo1Uh5Wydpix2yE10
=1kag
-----END PGP SIGNATURE-----

--nextPart2744856.2BUzvHmh9c--
