Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbYFLRE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbYFLRE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYFLREU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:04:20 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:36625 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbYFLREU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:04:20 -0400
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com> (sfid-20080612_174340_901526_B7377B4B)
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
	 <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
	 (sfid-20080612_174340_901526_B7377B4B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Q78vsZtOst7XjhJeiVvL"
Date: Thu, 12 Jun 2008 19:03:25 +0200
Message-Id: <1213290205.3730.2.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Q78vsZtOst7XjhJeiVvL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Try the patch below. It should improve code generation too.
> >
> > I discussed this with Tomas previously and he says the hw is capable of
> > doing 20 fragments per frame (wonder why, Broadcom can do an unlimited
> > number...) but he complained about the networking stack not being able
> > to.
>=20
> This is scatter gather buffers that can be kicked in one DMA transaction.
>=20
> Well, the hardware needs to support IP checksumming for that, hence,
> > afaik, only two fragments can ever be used (one for hw header, one for
> > frame)
> This I still don't understand why but everybody is already tired to
> explaining me why.. :) Just need to find time to dig into it.

And you can safely decrease the allocation to 10% as I do in my patch
because once you understand you'll see that you cannot possibly use
more. Hence, you can ack this patch ;)

> > This cuts the allocation to 10%, or (under) a page in all cases.
>=20
> Probably. it would be safe to use vmalloc for allocating txb anyway.
> I'll give it a try.

Yeah, but why bother if we can just allocate 10% of the size, waste a
lot less memory etc. mac80211 isn't going to pass in a scatter/gather
frame anyway.

> There was already discussion on LKML about memory allocation problems
> on X86_64, which might explain this regression. This didn't happen
> before.

Doesn't really matter, iwlwifi is _wasting_ this allocation, it cannot
possibly use all those buffers anyway.

The more interesting thing is the pci_alloc_consistent allocation right
below that is also _huge_, but that's because of the stupid hardware
design, or can the hardware cope with having the descriptors non-linear
in memory?

johannes

--=-Q78vsZtOst7XjhJeiVvL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUVbZAAoJEKVg1VMiehFYKYcQAISQgagssDGO5w7/PnxbpkCU
+w/YsElVWjj0HiATPAAkP3D+V3y8NT2a4ZARWflhC5NNFIOI2vqEVJZog1rCvozb
PYxIgD86TQ4aeEBAo7XLi0hSG85CD6GbvMPyaRgzl4wqsqUe6GDYl0Z7mH43VB5Z
lH16ITXFEZnGWQ1F6YS1o+AuULTJw8XL3a1OLWGc++xJbmWXwJCq7r/O3eengA0v
UK0cPIaADIJoD9c0sjIZ/eVoy5+hLoSH5wSy5cFheMJhPRpR8dRnJs4JI1cDt8O7
WbQXpBw/kdzSqbFQJW615YQIBP2yx78lcF3T2k71rPn5NKz/he9a32aMtNn3hdul
3hy0cQJetQwrqByLSIhgT/90VMpbKp5Ub8WHsDhP62tCzNJ3WyOt9vWy6DRNekVi
gWSER55XHPc0wwJZ9as8yFIpMLtqkKJjrBl8rGNm0f2Bb1zldI0nEAQ3Gb/0PvEF
M1WYfUZelu9yjqAokrJDcoQrC8KmTlKHvqhi1FGLedTzniKPo4X5WeFxrFV7VX60
n3RzeE1ZRQZJQfHc3XDTKrkYw2EdEc40Z8gdcBoi7NBD8fI7sdLbqAKQEL98NjqG
R0e40AqrUT5ZW98sYAcSVQwtam4SkC+G7DM0Z2oQjAb2U/GtzBZVGWx73qeMw8Qx
Aenmf4J/fHjr4LHqYWgT
=dwse
-----END PGP SIGNATURE-----

--=-Q78vsZtOst7XjhJeiVvL--

