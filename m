Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZDWLzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZDWLzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 07:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbZDWLzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 07:55:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54123 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbZDWLzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 07:55:43 -0400
Date: Thu, 23 Apr 2009 21:55:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, alex.williamson@hp.com, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: upstream tree build warnings
Message-Id: <20090423215533.157df0e0.sfr@canb.auug.org.au>
In-Reply-To: <20090423.002403.74400050.davem@davemloft.net>
References: <20090423163847.200f227e.sfr@canb.auug.org.au>
	<20090423.002403.74400050.davem@davemloft.net>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Apr_2009_21_55_33_+1000_fOWTxQK7z=vDnSjf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Apr_2009_21_55_33_+1000_fOWTxQK7z=vDnSjf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Thu, 23 Apr 2009 00:24:03 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 23 Apr 2009 16:38:47 +1000
>=20
> > Today's linux-next build (powerpc allyesconfig gcc4.4.0) produced these
> > warnings:
> >=20
> > drivers/net/virtio_net.c: In function 'virnet_vlan_rx_add_vid':
> > include/linux/scatterlist.h:57: warning: 'sg' is used uninitialized in =
this function
> > drivers/net/virtio_net.c:746: note: 'sg' was declared here
> > drivers/net/virtio_net.c: In function 'virnet_vlan_rx_kill_vid':
> > include/linux/scatterlist.h:57: warning: 'sg' is used uninitialized in =
this function
> > drivers/net/virtio_net.c:758: note: 'sg' was declared here
> >=20
> > in each case, sg is uninitialised when its address is passed to
> > sg_set_buf() which passes it to gs_set_page() which passes it to
> > sg_assign_page() which dereferences it (to use ->page_link).
>=20
> I wonder if this is a side effect of changes that went in via Rusty's
> tree?  I don't remember touching this driver in a while.

The callers came in throught commit
0bde95690d65653e420d04856c5d5783155c747c ("virtio_net: Add support for
VLAN filtering in the hypervisor") which I assume came in throught the
net tree (it has you SOB on it). Committed Feb 5, 2009, went into Linus'
tree before 2.6.30-rc1.

scatterlist.h hasn't changed since July, 2008.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Apr_2009_21_55_33_+1000_fOWTxQK7z=vDnSjf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknwVzUACgkQjjKRsyhoI8yLbACfYcVhwNwyGGk3oi8Ul8uu8Wg+
RH8AnRPTKP5Jb3zM/L0rQ/S+neOXZwWn
=Rauq
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Apr_2009_21_55_33_+1000_fOWTxQK7z=vDnSjf--
