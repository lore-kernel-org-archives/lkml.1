Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbYLKVMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbYLKVMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 16:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbYLKVMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 16:12:38 -0500
Received: from mail.gmx.net ([213.165.64.20]:48506 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756201AbYLKVMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:12:38 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1+18HEWPnW1qKwP6p/KnCMSH6BgmOaQe6TMY2y4Qg
	boCJImoO27o/ZD
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [patch 03/83] cxgb3: Fix kernel crash caused by uninitialized l2t_entry.arpq
Date: Thu, 11 Dec 2008 22:12:34 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Roland Dreier <rolandd@cisco.com>, Jeff Garzik <jgarzik@redhat.com>
References: <20081211190201.612240183@mini.kroah.org> <20081211191334.GC5894@kroah.com>
In-Reply-To: <20081211191334.GC5894@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6511956.XDOFFPBlSr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812112212.35832.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6511956.XDOFFPBlSr
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

On Donnerstag, 11. Dezember 2008, Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
>=20
> From: Roland Dreier <rdreier@cisco.com>
>=20
> [ Upstream commit 6d329af9967e7ab3f4a3d7f1e8ef87539c3a069f ]
>=20
> Commit 147e70e6 ("cxgb3: Use SKB list interfaces instead of home-grown
> implementation.") causes a crash in t3_l2t_send_slow() when an iWARP
> connection request is received.  This is because the new l2t_entry.arpq
> skb queue is never initialized, and therefore trying to add an skb to
> it causes a NULL dereference.  With the old code there was no need to
> initialize the queues because the l2t_entry structures were zeroed,
> and the code used NULL to mean empty.
>=20
> Fix this by adding __skb_queue_head_init() when all the l2t_entry
> structures get allocated.

This patch doesn't compile.

> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> ---
>  drivers/net/cxgb3/l2t.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> --- a/drivers/net/cxgb3/l2t.c
> +++ b/drivers/net/cxgb3/l2t.c
> @@ -436,6 +436,7 @@ struct l2t_data *t3_init_l2t(unsigned in
>  	for (i =3D 0; i < l2t_capacity; ++i) {
>  		d->l2tab[i].idx =3D i;
>  		d->l2tab[i].state =3D L2T_STATE_UNUSED;
> +		__skb_queue_head_init(&d->l2tab[i].arpq);
>  		spin_lock_init(&d->l2tab[i].lock);
>  		atomic_set(&d->l2tab[i].refcnt, 0);
>  	}

  CC [M]  drivers/net/cxgb3/cxgb3_main.o
  CC [M]  drivers/net/cxgb3/ael1002.o
  CC [M]  drivers/net/cxgb3/vsc8211.o
  CC [M]  drivers/net/cxgb3/t3_hw.o
  CC [M]  drivers/net/cxgb3/mc5.o
  CC [M]  drivers/net/cxgb3/xgmac.o
  CC [M]  drivers/net/cxgb3/sge.o
  CC [M]  drivers/net/cxgb3/l2t.o
drivers/net/cxgb3/l2t.c: In function =E2=80=98t3_init_l2t=E2=80=99:
drivers/net/cxgb3/l2t.c:439: error: implicit declaration of function =E2=80=
=98__skb_queue_head_init=E2=80=99
drivers/net/cxgb3/l2t.c:439: error: =E2=80=98struct l2t_entry=E2=80=99 has =
no member named =E2=80=98arpq=E2=80=99
make[3]: *** [drivers/net/cxgb3/l2t.o] Error 1
make[2]: *** [drivers/net/cxgb3] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

It seems to depend on

commit 147e70e62fdd5af6263106ad634b03c5154c1e56
Author: David S. Miller <davem@davemloft.net>
Date:   Mon Sep 22 01:29:52 2008 -0700

    cxgb3: Use SKB list interfaces instead of home-grown implementation.

    Signed-off-by: David S. Miller <davem@davemloft.net>

Regards
	Stefan Lippers-Hollmann

--nextPart6511956.XDOFFPBlSr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklBgkMACgkQORbEMfgJlPY5PwCbBfY0Lf/RZ0KRIDiaFuxmlEiJ
tOAAnjkUE++aLn07ot8cp7Lel9o0i4vc
=YuiO
-----END PGP SIGNATURE-----

--nextPart6511956.XDOFFPBlSr--
