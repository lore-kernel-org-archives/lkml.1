Return-Path: <linux-kernel-owner+w=401wt.eu-S1762692AbYG3PEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762692AbYG3PEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762393AbYG3PE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:04:26 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39662 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762349AbYG3PEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:04:25 -0400
Date: Wed, 30 Jul 2008 08:04:05 -0700
From: Eric B Munson <ebmunson@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       libhugetlbfs-devel@lists.sourceforge.net
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
Message-ID: <20080730150405.GA20465@us.ibm.com>
References: <cover.1216928613.git.ebmunson@us.ibm.com> <20080730014139.39b3edc5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20080730014139.39b3edc5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Jul 2008, Andrew Morton wrote:

> On Mon, 28 Jul 2008 12:17:10 -0700 Eric Munson <ebmunson@us.ibm.com> wrot=
e:
>=20
> > Certain workloads benefit if their data or text segments are backed by
> > huge pages. The stack is no exception to this rule but there is no
> > mechanism currently that allows the backing of a stack reliably with
> > huge pages.  Doing this from userspace is excessively messy and has some
> > awkward restrictions.  Particularly on POWER where 256MB of address spa=
ce
> > gets wasted if the stack is setup there.
> >=20
> > This patch stack introduces a personality flag that indicates the kernel
> > should setup the stack as a hugetlbfs-backed region. A userspace utility
> > may set this flag then exec a process whose stack is to be backed by
> > hugetlb pages.
> >=20
> > Eric Munson (5):
> >   Align stack boundaries based on personality
> >   Add shared and reservation control to hugetlb_file_setup
> >   Split boundary checking from body of do_munmap
> >   Build hugetlb backed process stacks
> >   [PPC] Setup stack memory segment for hugetlb pages
> >=20
> >  arch/powerpc/mm/hugetlbpage.c |    6 +
> >  arch/powerpc/mm/slice.c       |   11 ++
> >  fs/exec.c                     |  209 +++++++++++++++++++++++++++++++++=
+++++---
> >  fs/hugetlbfs/inode.c          |   52 +++++++----
> >  include/asm-powerpc/hugetlb.h |    3 +
> >  include/linux/hugetlb.h       |   22 ++++-
> >  include/linux/mm.h            |    1 +
> >  include/linux/personality.h   |    3 +
> >  ipc/shm.c                     |    2 +-
> >  mm/mmap.c                     |   11 ++-
> >  10 files changed, 284 insertions(+), 36 deletions(-)
>=20
> That all looks surprisingly straightforward.
>=20
> Might there exist an x86 port which people can play with?
>=20

I have tested these patches on x86, x86_64, and ppc64, but not yet on ia64.
There is a user space utility that I have been using to test which would be
included in libhugetlbfs if this is merged into the kernel.  I will send it
out as a reply to this thread, performance numbers are also on the way.

--=20
Eric B Munson
IBM Linux Technology Center
ebmunson@us.ibm.com


--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIkILlsnv9E83jkzoRAnu+AJ43tJhIvKC/V/l/tvEzpOLo1AfDugCgky73
1/w9s6N+iJutNNsYfJdCkx0=
=nEy7
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
