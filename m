Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbZA2ODW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbZA2ODW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZA2ODH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:03:07 -0500
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:47906 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbZA2ODG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:03:06 -0500
Date: Thu, 29 Jan 2009 15:02:47 +0100
From: Frank Mehnert <Frank.Mehnert@Sun.COM>
Subject: Re: PFs on pages pinned with get_user_pages()
In-reply-to: <1233236630.4495.80.camel@laptop>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Message-id: <200901291502.48312.frank.mehnert@sun.com>
Organization: Sun Microsystems
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart1341903.Qsp4XQ16TP
Content-transfer-encoding: 7BIT
References: <200901290905.10966.frank.mehnert@sun.com>
 <200901291408.02454.frank.mehnert@sun.com> <1233236630.4495.80.camel@laptop>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1341903.Qsp4XQ16TP
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 29 January 2009, Peter Zijlstra wrote:
> On Thu, 2009-01-29 at 14:08 +0100, Frank Mehnert wrote:
> > Peter,
>
> (please retain CC's)
>
> > On Thursday 29 January 2009, Peter Zijlstra wrote:
> > > On Thu, 2009-01-29 at 09:05 +0100, Frank Mehnert wrote:
> > > > please could someone explain me under which circumstances a
> > > > pagefault, either generated from kernel code or from userland code,
> > > > can occur on pages which are pinned with get_user_pages()?
> > > >
> > > > So far my understanding was that this can _never_ happen but I seems
> > > > to be wrong. Under high memory pressure I get PFs on such pages
> > > > raised from kernel code and the PFs are handled by do_swap_page().
> > > > When this happens, page_count is 3 but page_mapped() returns false.
> > >
> > > Under memory pressure the page reclaim will first unmap the physical
> > > page from the virtual address range, and then try to free it.
> >
> > Which means the page table entry is removed but the physical page
> > is not swapped out, right?
>
> Correct.
>
> > > Obviously the freeing bit fails if you hold a reference to it, but the
> > > unmap will work.
> >
> > Right.
> >
> > > After that, userspace will have to (minor) fault the stuff back in.

[...]

> > Question: Is it possible to prevent these minor page faults at all?
>
> Not without some serious tinkering to the VM -- and in the case of the
> dirty fault, not at all.
>
> Why are you asking?

I'm one of the VirtualBox developers. We are trying to fix the annoying
kerneloops warning 'BUG: sleeping function called from invalid context'
reported by the Fedora folks. This warning occurs when do_swap_page()
calls lock_page() and in_atomic() returns true.

This warning appears when we touch into memory which is pinned with
get_user_pages(). In VT-x/AMD-V mode we are executing some code in the
context of the Linux kernel. To prevent scheduling of the current CPU
core we disable the interripts. preempt_disable() would be probably the
better choice but this would oops as well if CONFIG_PREEMPT is enabled.

Kind regards,

=46rank
=2D-=20
Dr.-Ing. Frank Mehnert    Sun Microsystems    http://www.sun.com/

--nextPart1341903.Qsp4XQ16TP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmBtwgACgkQ6z8pigLf3EehKQCcDNVS/FxWb6wRN2MuVTTZ4G6Q
tzIAn2+kx63Ikha5t0SC3ItC9uzg+ytC
=5U+d
-----END PGP SIGNATURE-----

--nextPart1341903.Qsp4XQ16TP--
