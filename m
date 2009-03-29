Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbZC2SlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbZC2SlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 14:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbZC2Skc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 14:40:32 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:54208 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbZC2Ska (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 14:40:30 -0400
X-Greylist: delayed 1777 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Mar 2009 14:40:30 EDT
Date: Sun, 29 Mar 2009 13:48:33 +0200
From: Harald Welte <laforge@netfilter.org>
To: David Miller <davem@davemloft.net>
Cc: gorcunov@gmail.com, randy.dunlap@oracle.com, pablo@netfilter.org,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kaber@trash.net,
       netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for March 27 (netfilter build error)
Message-ID: <20090329114833.GM15306@prithivi.gnumonks.org>
References: <20090328102852.GA7697@localhost> <49CEF882.5000005@oracle.com> <20090329064704.GA7255@localhost> <20090328.234739.26481917.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCFQJunhLz1tFGpX"
Content-Disposition: inline
In-Reply-To: <20090328.234739.26481917.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lCFQJunhLz1tFGpX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Sat, Mar 28, 2009 at 11:47:39PM -0700, David Miller wrote:
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> Date: Sun, 29 Mar 2009 10:47:04 +0400
>=20
> > [Randy Dunlap - Sat, Mar 28, 2009 at 09:26:42PM -0700]
> > ...=20
> > | works_for_me.  Thanks.
> > | but missing S-O-B.
> > |=20
> > | Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> > ...
> >=20
> > Thanks for testing Randy. So if nobody will complain
> > here is a solid version of the patch. Though I would like
> > if Pablo or Patrick confirm its correctness. Thanks!
>=20
> I'll apply this once Patrick or Pablo have a look at it.

I'm neither of them but I strongly believe the patch is correct.  =20

The only question that Patrick raised during the discussion of this patch s=
ome
days ago is whether the __ipv6_addr_type() call would cause a runtime
dependency to thei ipv6 module.  This would be bad since loading the
xt_cluster.ko module should not pull in the IPv6 protocol module.

I have just verified that __ipv6_addr_type is provided by
net/ipv6/addrconf_core.c, which specifically states it contains functions
"needed by static components when full IPv6 support is not configured or
static".   This is confirmed by the makefile, which addes addrconf_core.o to
obj-y.

So from my point of view, I cannot see any problems.

Regards.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--lCFQJunhLz1tFGpX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJz2ARXaXGVTD0i/8RAoCBAJ4jTchisJoRx+19Oj8Iy54PNOA6xQCdGq8D
L3m5X4n28okQ74uvT2EP3N8=
=OYRA
-----END PGP SIGNATURE-----

--lCFQJunhLz1tFGpX--
