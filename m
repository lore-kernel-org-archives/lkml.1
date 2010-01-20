Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423Ab0ATNhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab0ATNhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146Ab0ATNhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:37:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab0ATNhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:37:46 -0500
Date: Wed, 20 Jan 2010 07:37:34 -0600
From: Clark Williams <williams@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Carsten Emde <ce@ceag.ch>, John Kacur <jkacur@redhat.com>
Subject: Re: RFC: NUMA modifications to cyclictest
Message-ID: <20100120073734.4be7a52b@torg>
In-Reply-To: <alpine.LFD.2.00.1001200741000.2906@localhost.localdomain>
References: <20100119171439.24726f2e@torg>
	<alpine.LFD.2.00.1001200741000.2906@localhost.localdomain>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dSWNDpu1MzBAg+Lj9jzN+/2"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dSWNDpu1MzBAg+Lj9jzN+/2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Jan 2010 07:51:41 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 19 Jan 2010, Clark Williams wrote:
> > RT-ers,
> >=20
> > Lately we've been struggling with some performance issues on high-core
> > count (>16 cores) NUMA machines with the RT kernel. During the course
> > of troubleshooting this issue, we tried using the 'numactl' program to
> > constrain our measurement testing tool (rteval) to a particular memory
> > node, rather than letting everything float. Doing so showed marked
> > improvement in both max latency and jitter.  While this doesn't solve
> > our performance problems I thought it might make sense to have a --numa
> > mode for cylictest that compliments the --smp mode just added.=20
> >=20
> > The big difference here is that when using --numa, each measurement
> > thread (one per cpu) has it's stack allocated from the memory node
> > associated with it's cpu. Also, the major data structures for each
> > thread (parameter block, statistics block and histogram) are allocated
> > from the appropriate node. This is done with calls into libnuma,
> > which means this will add a dependency on libnuma.=20
>=20
> That might cause some trouble for embedded folks. :(

Yeah, that's why I send the RFC, wanted to see who would hate me for
it :).

Carsten already told me off-list that one of his build machines didn't
have numa.h, so I'm going to have to rearrange the build a bit.

As much as I hate to say it, I think the best option is to use autoconf
to detect if libnuma is available on the build platform and to take
appropriate steps if it's not.=20

The other idea I toyed with was dynamic loading of libnuma so there's
not an install dependency for the libnuma package with the rt-tests
package. I only use five functions from libnuma, so that's not too bad
a set of function pointers to manage. Hmmm, that probably won't work
very well, since I'll still have to include numa.h. Sigh...

Clark

--Sig_/dSWNDpu1MzBAg+Lj9jzN+/2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAktXByIACgkQHyuj/+TTEp0OtwCfZa2g3qej2MA8RCO/R16NJulx
/p4Anied3kZJF+nXaLVqgbXQZd+CRA7Y
=M8XX
-----END PGP SIGNATURE-----

--Sig_/dSWNDpu1MzBAg+Lj9jzN+/2--
