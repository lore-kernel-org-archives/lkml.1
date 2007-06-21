Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbXFUX0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbXFUX0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbXFUX0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:26:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbXFUX0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:26:34 -0400
Date: Thu, 21 Jun 2007 16:25:47 -0700
From: John Johansen <jjohansen@suse.de>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070621232547.GA32406@suse.de>
References: <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de> <20070621200740.GG18990@elf.ucw.cz> <20070621202107.GM20105@marowsky-bree.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20070621202107.GM20105@marowsky-bree.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 21, 2007 at 10:21:07PM +0200, Lars Marowsky-Bree wrote:
> On 2007-06-21T22:07:40, Pavel Machek <pavel@ucw.cz> wrote:
>=20
> >=20
> > Plus IIRC we have something like "AA has to allocate path-sized
> > buffers along every syscall".
>=20
> That is an implementation bug though. I'm sure we have other bugs in the
> kernel too - this isn't a design flaw.=20
>=20
> (If people are allowed to thinair solutions for implementing AA on top
> of SELinux, I can thinair that this can be solved by reverse-matching
> the dentry tree against the policy as the path is traversed and
> constructed, requiring a constant sized buffer.)
>=20
Indeed there are a few solutions to "fix" this implementation "bug",
of which reverse matching is one.  For reverse matching the policy
tables would become larger.   Reverse matching wouldn't need any
additional buffer for enforcement but would still fall back to d_path
for logging.

But we would still require the changes to the vfs and also a way to
safely walk the tree backwards.  So we would need to either export the
namespace semaphore or add a generic walking function which we could
pass a hook function to.

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGewj7i/GH5xuqKCcRAng7AKCAS+JUI8Iex9pZD0Xp1aHWDMWUxACdEsqX
Ne6cx5KLJ36ohFUh04cIyAQ=
=zmre
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
