Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbXF0CY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbXF0CY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 22:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbXF0CYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 22:24:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:53542 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278AbXF0CYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 22:24:46 -0400
Date: Tue, 26 Jun 2007 19:24:03 -0700
From: John Johansen <jjohansen@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
Message-ID: <20070627022403.GB14656@suse.de>
References: <20070626230756.519733902@suse.de> <20070626165202.bfe8e6df.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
In-Reply-To: <20070626165202.bfe8e6df.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 26, 2007 at 04:52:02PM -0700, Andrew Morton wrote:
> On Tue, 26 Jun 2007 16:07:56 -0700
> jjohansen@suse.de wrote:
>=20
> > This post contains patches to include the AppArmor application security
> > framework, with request for inclusion into -mm for wider testing.
>=20
> Patches 24 and 31 didn't come through.
>=20
yes, sorry about that I had a very odd failure authetication failure
with those two mails and missed it.

They have been recent.

>=20
> so...  where do we stand with this?  Fundamental, irreconcilable
> differences over the use of pathname-based security?
>=20
There certainly seems to be some differences of opinion over the use
of pathname-based-security.

> Are there any other sticking points?
>=20
>=20
The conditional passing of the vfsmnt mount in the vfs, as done in this
patch series, has received a NAK.  This problem results from NFS passing
a NULL nameidata into the vfs.  We have a second patch series that we
have posted for discussion that addresses this by splitting the nameidata
struct.
Message-Id: <20070626231510.883881222@suse.de>
Subject: [RFD 0/4] AppArmor - Don't pass NULL nameidata to
vfs_create/lookup/permission IOPs

other issues that have been raised are:
- AppArmor does not currently mediate IPC and network communications.
  Mediation of these is a wip
- the use of d_path to generate the pathname used for mediation when a
  file is opened.
  - Generating the pathname using a reverse walk is considered ugly
  - A buffer is alloced to store the generated path name.
  - The  buffer size has a configurable upper limit which will cause
    opens to fail if the pathname length exceeds this limit.  This
    is a fail closed behavior.
  - there have been some concerns expressed about the performance
    of this approach
  We are evaluating our options on how best to address this issue.

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGgcpDi/GH5xuqKCcRAo6vAJ0UvEDdHs1UZG18VLlFFrG4oZR4UACgmqRp
0M9E/s38yQfQ28P9HdJBtak=
=EFdo
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
