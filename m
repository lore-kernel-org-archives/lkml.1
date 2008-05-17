Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYEQSMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYEQSMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 14:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYEQSMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 14:12:09 -0400
Received: from home.keithp.com ([63.227.221.253]:3312 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbYEQSMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 14:12:08 -0400
Subject: RE: [Bug 10732] REGRESSION: 2.6.26-rc2-git4: X server failed start
	onX61s laptop
From: Keith Packard <keithp@keithp.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>
Cc: keithp@keithp.com, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       bugme-daemon@bugzilla.kernel.org, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE01119B07@orsmsx423.amr.corp.intel.com>
References: <E1JxGth-0001te-S4@closure.thunk.org>
	 <924EFEDD5F540B4284297C4DC59F3DEE01119AFE@orsmsx423.amr.corp.intel.com>
	 <20080517154131.GA7651@mit.edu>
	 <924EFEDD5F540B4284297C4DC59F3DEE01119B07@orsmsx423.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ubSij2XFuKIfgO11DrGI"
Date: Sat, 17 May 2008 11:11:56 -0700
Message-Id: <1211047916.27447.314.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ubSij2XFuKIfgO11DrGI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-05-17 at 09:02 -0700, Pallipadi, Venkatesh wrote:

> I am thinking that may be X is depending on mprotect changes somehow and
> failing when
> it cannot change PAT attributes with mprotect call. Keith earlier
> mentioned that X
> will not depend on this. May be something to do with earlier X version.
> Keith?

It looks like we can turn off read/write access, but we can't turn it
back on. So,

        mprotect (map->memory, map->size, PROT_NONE);
        mprotect (map->memory, map->size, PROT_READ|PROT_WRITE);
=20
leaves the memory with no access.

Eric saw this last week; I don't know whether he debugged into it
further.

Which repository is commit 1c12c4cf in?

--=20
keith.packard@intel.com

--=-ubSij2XFuKIfgO11DrGI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBILx/sQp8BWwlsTdMRAuOsAJ4u7t2VqEHQLjT6/Nkg0ml/TsjwcgCgyNcO
HC3c4wTImhDinq5OTdQLM80=
=Q7LL
-----END PGP SIGNATURE-----

--=-ubSij2XFuKIfgO11DrGI--

