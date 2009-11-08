Return-Path: <linux-kernel-owner+w=401wt.eu-S1751428AbZKHHzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbZKHHzl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 02:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZKHHzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 02:55:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39777 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZKHHzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 02:55:40 -0500
Date: Sun, 8 Nov 2009 18:55:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, linuxppc-dev@ozlabs.org,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 09/16] powerpc: Replace old style lock initializer
Message-Id: <20091108185539.8d09017e.sfr@canb.auug.org.au>
In-Reply-To: <1257548144.13611.267.camel@pasglop>
References: <20091106223547.784916750@linutronix.de>
	<20091106223806.762624109@linutronix.de>
	<1257548144.13611.267.camel@pasglop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__8_Nov_2009_18_55_39_+1100_PvVKoR9/uoxSce0J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__8_Nov_2009_18_55_39_+1100_PvVKoR9/uoxSce0J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Sat, 07 Nov 2009 09:55:44 +1100 Benjamin Herrenschmidt <benh@kernel.cras=
hing.org> wrote:
>
> Looks reasonable. But iseries can be a bitch, so we do need to test it
> on monday.

It should be safe as the spinlocks cannot be access until after the
following ppc_md pointer initialisations are done (and all this happens
before the secondary CPUs are started).

But, you are right that there is nothing like actually testing with
iSeries. :-)

> >  void __init hpte_init_iSeries(void)
> >  {
> > +	int i;
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(iSeries_hlocks); i++)
> > +		spin_lock_init(&iSeries_hlocks[i]);
> > +
> >  	ppc_md.hpte_invalidate	=3D iSeries_hpte_invalidate;
> >  	ppc_md.hpte_updatepp	=3D iSeries_hpte_updatepp;
> >  	ppc_md.hpte_updateboltedpp =3D iSeries_hpte_updateboltedpp;

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__8_Nov_2009_18_55_39_+1100_PvVKoR9/uoxSce0J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr2eXsACgkQjjKRsyhoI8yplQCePqhkhwE9kOsv222YOeuSMTT+
v6QAn0aivxcGS4awyXn6SI2G1PYtfuZt
=kxrY
-----END PGP SIGNATURE-----

--Signature=_Sun__8_Nov_2009_18_55_39_+1100_PvVKoR9/uoxSce0J--
