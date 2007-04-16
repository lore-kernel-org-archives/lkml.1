Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbXDPVgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbXDPVgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbXDPVgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:36:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbXDPVgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:36:51 -0400
Date: Mon, 16 Apr 2007 14:37:06 -0700
From: John Johansen <jjohansen@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 38/41] AppArmor: Module and LSM hooks
Message-ID: <20070416213706.GC4030@suse.de>
References: <20070412090809.917795000@suse.de> <20070412090849.112397000@suse.de> <20070412112101.328fd7cd@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vEao7xgI/oilGqZ+"
Content-Disposition: inline
In-Reply-To: <20070412112101.328fd7cd@the-village.bc.nu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--vEao7xgI/oilGqZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 12, 2007 at 11:21:01AM +0100, Alan Cox wrote:
> > +
> > +	/**
> > +	 * parent can ptrace child when
> > +	 * - parent is unconfined
> > +	 * - parent is in complain mode
> > +	 * - parent and child are confined by the same profile
> > +	 */
>=20
> Your profiles are name based. That means the same profile in a different
> namespace does different things. It would be a very odd case where it
> mattered but surely the parent ptrace child rule should also require that
> the parent and child are in the same namespace when using apparmor name
> based security.
>=20
you are right we should be requiring parent and child are in the same
namespace.  This has been fixed.

> > +static int apparmor_capget(struct task_struct *task,
> > +			    kernel_cap_t *effective,
> > +			    kernel_cap_t *inheritable,
> > +			    kernel_cap_t *permitted)
> > +{
> > +	return cap_capget(task, effective, inheritable, permitted);
> > +}
>=20
> Pointless function should go away.
>=20
yes we had a few of those thanks for pointing it out.

> > +static int apparmor_sysctl(struct ctl_table *table, int op)
> > +{
> > +	int error =3D 0;
> > +
> > +	if ((op & 002) && !capable(CAP_SYS_ADMIN))
> > +		error =3D aa_reject_syscall(current, GFP_KERNEL,
> > +					  "sysctl (write)");
> > +
> > +	return error;
>=20
> The usual file permission security override is DAC not ADMIN. What is the
> logic of this choice.
>=20
This was a very course grain check that was done to restrict access to
sysctl's that could be potentially used to elevated priledge.  The check
is inconsistent with AppArmor's model and we should be modelling
sysctl accesses as pathname access, and then we could be using standard
mediation.

thanks for the review
john


--vEao7xgI/oilGqZ+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFGI+yCi/GH5xuqKCcRApPnAKCX7piP6Zg36HriUgKNjpcWQ9kzfgCdFMHt
Y9oQs67hsOH2AFc64SkUSRw=
=rTiQ
-----END PGP SIGNATURE-----

--vEao7xgI/oilGqZ+--
