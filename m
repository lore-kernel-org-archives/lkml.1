Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab0BLLLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:11:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48626 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab0BLLLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:11:08 -0500
Date: Fri, 12 Feb 2010 22:10:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: upcoming percpu changes
Message-Id: <20100212221058.37b7c6e6.sfr@canb.auug.org.au>
In-Reply-To: <4B750F80.2030902@kernel.org>
References: <20100205161648.086375b9.sfr@canb.auug.org.au>
	<4B750F80.2030902@kernel.org>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Feb_2010_22_10_58_+1100_13rVWc8Lk2UQfQlf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Feb_2010_22_10_58_+1100_13rVWc8Lk2UQfQlf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tajun,

On Fri, 12 Feb 2010 17:21:20 +0900 Tejun Heo <tj@kernel.org> wrote:
>
> On 02/05/2010 02:16 PM, Stephen Rothwell wrote:
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Fri, 5 Feb 2010 16:09:11 +1100
> > Subject: [PATCH] percpu: add __percpu for sparse
> >=20
> > This is to make the annotation of percpu variables during the next merge
> > window less painfull.
> >=20
> > Extracted from a patch by Rusty Russell.
>=20
> I started doing this and it's a bit ridiculous.  If I split the
> patches into separate trees with maintainers, I end up with a lot of
> one or several liners and all that those patches do is adding __percpu
> to a variable or field declaration which doesn't affect normal builds
> at all.  The only conflicts I had against the current mainline is the
> ones which got changed in the percpu tree by Christoph's patches.
>=20
> Given the wide number of trees this will end up on and given the
> triviality of each change, I think it would better to keep these in
> the percpu tree.  It'll make things harder track without adding much
> benefit.  If non-trivial confict ever happens, please feel free to
> drop it from linux-next and let me know.

You don't need to split them all out, just the problematic ones.

A good start would be commit d3f5fa4075414c7754126fbdc7c8fbd3906db7c8
("percpu: add __percpu sparse annotations to net").  You would need to
rebase it on top of net-next and note that "struct macvlan_dev" has been
moved to include/linux/if_macvlan.h.  Then just send it to DaveM.

You could also send commit e20b68160144bcacbde008b9cf7df4e1544b2507
("percpu: add __percpu sparse annotations to net drivers") along with it.

Commit 949c49c93a02b62278a63457d0d3192d66e55105 ("percpu: add __percpu
sparse annotations to x86") can just go to the x86 guys and commit
0b6dd45041220083a3692edae5253c35d19bcb2b ("percpu: add __percpu sparse
annotations to hw_breakpoint") to Frederic Weisbecker.

Commit eeb721be6bc03fe37755e69ab5c3ba2fe9897fd9 ("percpu: add __percpu
sparse annotations to trace") needs rebasing onto the tip perf/core
branch and then could be sent to Steve and co.

That takes care of most of it and the rest, as you say, we can sort out
if it becomes a problem.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Feb_2010_22_10_58_+1100_13rVWc8Lk2UQfQlf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt1N0IACgkQjjKRsyhoI8xypACgoa1OnkrNZIFW1kMyAcSYWRQ8
sOMAniKQ4a9I7JpdhWAeBcuYtliLJjYn
=m2Cm
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Feb_2010_22_10_58_+1100_13rVWc8Lk2UQfQlf--
