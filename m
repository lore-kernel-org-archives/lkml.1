Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZA3Ke0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZA3Ke0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbZA3KeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:34:18 -0500
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:51471 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZA3KeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:34:17 -0500
Date: Fri, 30 Jan 2009 11:34:03 +0100
From: Frank Mehnert <Frank.Mehnert@Sun.COM>
Subject: Re: PFs on pages pinned with get_user_pages()
In-reply-to: <1233245483.4495.106.camel@laptop>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Message-id: <200901301134.07242.frank.mehnert@sun.com>
Organization: Sun Microsystems
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart3064661.QbFKPvRJ5z
Content-transfer-encoding: 7BIT
References: <200901290905.10966.frank.mehnert@sun.com>
 <200901291703.35463.frank.mehnert@sun.com> <1233245483.4495.106.camel@laptop>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3064661.QbFKPvRJ5z
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 29 January 2009, Peter Zijlstra wrote:
> On Thu, 2009-01-29 at 17:03 +0100, Frank Mehnert wrote:
> > On Thursday 29 January 2009, Peter Zijlstra wrote:
> > > > > That aside, is there any reason you have to avoid scheduling?
> > > > > Otherwise I would just allow so and be done with it.
> > > >
> > > > The reason is that our code expects that to ensure syncing of the C=
PU
> > > > state with the saved state. I fear it is quite difficult to change
> > > > that...
> > >
> > > Ah, is that what KVM uses the preempt notifiers for? Could you too?
> >
> > Right, that could be an option.
> >
> > We will try to change our code which is a big effort as we try
> > to keep the code as unique as possible between the different
> > hosts we support (Linux, Solaris, Windows, Mac OS X).
> >
> > Just to be sure: There is no other option than disabling interrupts
> > or calling disable_preemption() to prevent scheduling?
>
> Thing is, lock_page() and down_read() require to be able to schedule(),
> so there's no way around that.
>
> So even if there was another way to disable scheduling, you'd still have
> the same problem.

Yes, makes sense.

Back to my initial question: The problem arises for us because we depend
on permanent mappings of memory which were

 - allocated with alloc_pages() or alloc_page()
 - mapped into ring 3 with remap_pfn_range() and
 - pinned with get_user_pages()

There are potential pagefaults when touching into these ring-3-mappings
from ring 0. So I assume we could prevent such pagefaults if we access
that memory from ring-0-mappings, right? Unfortunately, the space for
ring-0-mappings (< 1GB) is smaller than userland (~ 3GB), at least on
32-bit systems.

Kind regards,

=46rank
=2D-=20
Dr.-Ing. Frank Mehnert    Sun Microsystems    http://www.sun.com/

--nextPart3064661.QbFKPvRJ5z
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmC15sACgkQ6z8pigLf3EfyJQCfX4Ym7QK8kB6IU/iPI/c/kYc0
rxsAnR73z0CRZGmiEu/KhbvutUTt8Tzg
=N3SB
-----END PGP SIGNATURE-----

--nextPart3064661.QbFKPvRJ5z--
