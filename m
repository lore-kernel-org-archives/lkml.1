Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbXHBMli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbXHBMli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbXHBMl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:41:29 -0400
Received: from styx.suse.cz ([82.119.242.94]:58443 "EHLO elijah.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755068AbXHBMl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:41:28 -0400
Subject: mmap behavior on out-of-space conditions
From: Petr Tesarik <ptesarik@suse.cz>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xsleWFtAuKBfGVb390Mj"
Organization: SuSE CR
Date: Thu, 02 Aug 2007 14:41:26 +0200
Message-Id: <1186058486.2289.17.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xsleWFtAuKBfGVb390Mj
Content-Type: multipart/mixed; boundary="=-zSm295JPNFY80If2LFQN"


--=-zSm295JPNFY80If2LFQN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello,

while solving a different issue, my colleague Libor Pechacek found a
problem with handling mmapped sparse files. If you mmap the hole insidea
sparse file and write to it, the data gets silently lost if there is not
enough space left on the underlying device.

I found a thread which touched this topic in December 2001 (sic!). I'd
like to quote an email by Andrea Arcangeli:

> On Sun, Dec 30, 2001 at 01:33:24AM -0500, Alexander Viro wrote:
> >=20
> >=20
> > On Sat, 29 Dec 2001, Andrew Morton wrote:
> >=20
> > > Would it be necessary to preallocate the holes at mmap() time?  Mad
> > > hand-waving: Could we not perform the instantiation at pagefault time=
,
> > > and give the caller SIGBUS if we cannot allocate the blocks?  Or if
> > > there's an IO error, or quota exceeded.
> >=20
> > Allocation at mmap() Is Not Going To Happen.  Consider it vetoed.
> > There are applications that use mmap() on large and very sparse
> > files.
>=20
> it's exactly this kind of apps that will be screwed up by silent data
> corruption. the point of the holes is to optimize performance and save
> space, but they shouldn't introduce the possibilty of data corruption.
>=20
> Note: I'm fine to introduce another way to notify the app about -ENOSPC,
> -ENOSPC on mmap is the most obvious one, but we could still allow the
> current "overcommit" behaviour with a kind of sigbus mentioned by
> Andrew (possibly not sigbus though, since it has just well defined
> semantics for MAP_SHARED, maybe they could be extended, anyways as said
> this is only a matter of API). My point is only that some API should be
> added because your mmap on sparse files are unreliable at the moment.

(see http://marc.info/?l=3Dlinux-kernel&m=3D100975730421590&w=3D2)

However, this is still not fixed - I am attaching a simple test case,
run it like:

$ make
$ # become root
# make check

IMO we should go with the SIGBUS solution, but I want to discuss it here
before making a patch.

Kind regards,
Petr Tesarik
SUSE LINUX, L3 Prague


--=-zSm295JPNFY80If2LFQN
Content-Disposition: attachment; filename=mmap-nospc.tar.gz
Content-Type: application/x-compressed-tar; name=mmap-nospc.tar.gz
Content-Transfer-Encoding: base64

H4sIAIbNsUYAA+1Y60/jRhDnq/evGAItSeoktuOEFpK7IggClccpBCG1PUXuek2s+CU/0ru29793
dp3HmgtHWgFVdf59ILvjee3M7O4svm9FjSBMItraeiloiP1OB3+Ntmnui7lumuJ3ji1d63bMttnt
4ljTjX3N3ILOi3kkIUtSKwbYilKWWLE7fZyPxclrOPS68Ff5Xw2b9Flt8AR3Rb7X5r/daRvL/HeM
Nua/o7f1LdCe1YtH8JXnf8cNqJfZDHpJarthc/KGSKSPSSv9GLHkczJGLS1SHRqkXpGUBS5q/VwY
Ky1YQw2zQOgkOzZz3IDB8dnt1U/jm/OfB4qp/dBd0s+uLwY5WTe+r6+4COFuuRTcICU0ZlbKxklk
xQkbO67HqjQMkhToBBNedwLLZzXyJ1GQGRz7kCjiA4U+7B3vHSpKqw7H4LlT9EOognqLILcDVag6
NrKFEQuqQo8K1+Phyd0Q/sLBaHh7dSxGx8PB0UgFrdvt1mrQA60GaE+JWByHcbXC5Ss1NKzELM3i
ABo6Tj7NjfweuylDQyp8S1XQa7Dd539lBYJFz1Xch2kISB+HWSpp8RLGpkLLMmgq3AwGGLDBSOhc
0ou6heAXVW/qoPGolvmyefDJ/MtBrpt6YcJ112qSNkEUyqR4fSokHdPsjSehx5JqnlaR4dBxxilE
YbJIct2y7RiNKk4YQxU/YDa1Q84BPSkiOeW7vlSI+fq4OIrwE7N6dXtxoUocKrwbXo/GmPoTLAIx
vhuejwYqyimAuDx6N745OxoOTlTg0UMbIkB83bnivuA5PTq/GJzkBpcx4CbzeBaKRoRTqc/92jvF
+sXyPc3L9xSDwos3N+FnAXebs8pu1x4aEmzrTcnJ0x5PwTivkC8lgi68XePuv85Ose6R6UHF84AX
FysV+5qwPlHsxWoHvvRNw8ZD41tuIGJkxfeoOq/POk5mhdMp3xecBw+Sdm7ZiWL87FTxkEUXVKjc
JtY9O4BvMFB4naX80HsDvZg5YvRrUFG5ldkv2nv52JFPnfnRtubwFIL6+/lBtpI2Fr5Je2++cR9y
rHZ14ZQQZFg4XDgRjc1dMzZybbxI5D93EMPIYhZQBo+6KSf3v77ZN4PU/11aU8ZX9uw2nuj/NF3q
/8wu7/9xZJb932vA8rwDWBUBoRNGpweAZKIkExDTZjIhZMUj8zcpUe4phcYdSkDj2oBGCLs/wm7v
f1L/Xzuk/b/I9bPbeGL/6/q+udr/+7rY/0a33P+vgZ1taP3mBi2+xS+vRifnwz6/iH1s5EjCUmgw
fI4tHkDpJL/78LWWMp/YNrhOv2WzWesPFocQOv2ZG2MvMgPK33J9fJ0RfnWmWQSCzQvDSIM5E/Gn
TtL03cD9IH3l5i659ENr/tR2Y2hEsJv7ScR7ERrYQT1QseQoep53DEIlRF6WgCV6DkEgTenfHwv5
Vi7REBLL219Mueoh89f4CfjKcYOZ5bk2NxxhQwbUwr1FspxdWupmK+DbcmWEYJ+yDdSPNvDykIsF
hD86GJ2EUDmztuFughxgu7bQiU5acB++rQgu3sZnSV8nDDtimaJhWy+c8ZgVQBatWcwi0Q1bpsY+
z9pyOeyDm8JurrS8IUqUKFGiRIkSJUqUKFGiRIkSJUqUeGH8DcnBEaIAKAAA


--=-zSm295JPNFY80If2LFQN--

--=-xsleWFtAuKBfGVb390Mj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBGsdD2jpY2ODFi2ogRAkJKAKCMCUq/lI96oYuzBtjkeYZj7y9cXACfXiDg
C+vXpDmsMsgA2aw0DCPMXb4=
=DQvg
-----END PGP SIGNATURE-----

--=-xsleWFtAuKBfGVb390Mj--
