Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbZFYD7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbZFYD7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 23:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbZFYD7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 23:59:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41129 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbZFYD7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 23:59:10 -0400
Date: Thu, 25 Jun 2009 13:59:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Paul Menage <menage@google.com>, akpm@linux-foundation.org,
       jdike@addtoit.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [uml-devel] [PATCH] UML: Fix some apparent bitrot
Message-Id: <20090625135901.a028512d.sfr@canb.auug.org.au>
In-Reply-To: <4A3F4448.30502@panasas.com>
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com>
	<4A3F4448.30502@panasas.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__25_Jun_2009_13_59_01_+1000_2hiOkjakO_iCy08C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Jun_2009_13_59_01_+1000_2hiOkjakO_iCy08C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I applied the following patch to yesterday's linux-next and the i386 uml
defconfig build succeeded.

The last hunk of this patch (arch/um/include/asm/mmu_context.h) needs to
be notified to Rusty Russell (cc'd) since that only applied after merging
his tree.

The rest appears to apply ok to Linus' tree.

Please split this and send it to the appropriate people and cc me.

On Mon, 22 Jun 2009 11:43:52 +0300 Boaz Harrosh <bharrosh@panasas.com> wrot=
e:
>
> On 06/20/2009 03:55 AM, Paul Menage wrote:
> > UML: Fix some apparent bitrot
> >=20
> > - migration of net_device methods into net_device_ops
> > - dma_sync_single() changes
> > - cpumask_clear() -> cpumask_clear_cpu()
> >=20
> > Signed-off-by: Paul Menage <menage@google.com>
> >=20
> > --
> >=20
> > Fixes the following compile errors:
> >=20
> > include/linux/dma-mapping.h:113: error: redefinition of 'dma_sync_singl=
e'
> > arch/um/include/asm/dma-mapping.h:84: error: previous definition of 'dm=
a_sync_single' was here
> > include/linux/dma-mapping.h: In function 'dma_sync_single':
> > include/linux/dma-mapping.h:117: error: implicit declaration of functio=
n 'dma_sync_single_for_cpu'
> > include/linux/dma-mapping.h: At top level:
> > include/linux/dma-mapping.h:120: error: redefinition of 'dma_sync_sg'
> > arch/um/include/asm/dma-mapping.h:91: error: previous definition of 'dm=
a_sync_sg' was here
> > include/linux/dma-mapping.h: In function 'dma_sync_sg':
> > include/linux/dma-mapping.h:124: error: implicit declaration of functio=
n 'dma_sync_sg_for_cpu'
> >=20
> >=20
> > arch/um/drivers/slirp_kern.c: In function 'slirp_init':
> > arch/um/drivers/slirp_kern.c:35: error: 'struct net_device' has no memb=
er named 'init'
> >=20
> >=20
> > arch/um/include/asm/mmu_context.h: In function 'switch_mm':
> > arch/um/include/asm/mmu_context.h:38: warning: passing argument 1 of 'c=
pumask_clear' makes pointer from integer without
> > a cast
> > arch/um/include/asm/mmu_context.h:38: error: too many arguments to func=
tion 'cpumask_clear'
> >=20
> > ---
>=20
> Stephan hi.
>=20
> The above breakage is the usual stuff we get every merge window. With peo=
ple doing
> cross arch work and neglecting UML.
>=20
> Who is the person or people responsible for the large linux-next compilat=
ion rig?
> Is it possible to also add a UML traget, at least for the x86_64/x86_32 s=
ub-arch?
>=20
> Thanks
> Boaz
>=20
> >=20
> >  arch/um/drivers/slip_kern.c       |    1 -
> >  arch/um/drivers/slirp_kern.c      |    1 -
> >  arch/um/include/asm/dma-mapping.h |    4 ++--
> >  arch/um/include/asm/mmu_context.h |    2 +-
> >  4 files changed, 3 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/arch/um/drivers/slip_kern.c b/arch/um/drivers/slip_kern.c
> > index 5ec1756..dd2aadc 100644
> > --- a/arch/um/drivers/slip_kern.c
> > +++ b/arch/um/drivers/slip_kern.c
> > @@ -30,7 +30,6 @@ static void slip_init(struct net_device *dev, void *d=
ata)
> > =20
> >  	slip_proto_init(&spri->slip);
> > =20
> > -	dev->init =3D NULL;
> >  	dev->hard_header_len =3D 0;
> >  	dev->header_ops =3D NULL;
> >  	dev->addr_len =3D 0;
> > diff --git a/arch/um/drivers/slirp_kern.c b/arch/um/drivers/slirp_kern.c
> > index f15a6e7..e376284 100644
> > --- a/arch/um/drivers/slirp_kern.c
> > +++ b/arch/um/drivers/slirp_kern.c
> > @@ -32,7 +32,6 @@ void slirp_init(struct net_device *dev, void *data)
> > =20
> >  	slip_proto_init(&spri->slip);
> > =20
> > -	dev->init =3D NULL;
> >  	dev->hard_header_len =3D 0;
> >  	dev->header_ops =3D NULL;
> >  	dev->addr_len =3D 0;
> > diff --git a/arch/um/include/asm/dma-mapping.h b/arch/um/include/asm/dm=
a-mapping.h
> > index 90fc708..378de4b 100644
> > --- a/arch/um/include/asm/dma-mapping.h
> > +++ b/arch/um/include/asm/dma-mapping.h
> > @@ -79,14 +79,14 @@ dma_unmap_sg(struct device *dev, struct scatterlist=
 *sg, int nhwentries,
> >  }
> > =20
> >  static inline void
> > -dma_sync_single(struct device *dev, dma_addr_t dma_handle, size_t size,
> > +dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, siz=
e_t size,
> >  		enum dma_data_direction direction)
> >  {
> >  	BUG();
> >  }
> > =20
> >  static inline void
> > -dma_sync_sg(struct device *dev, struct scatterlist *sg, int nelems,
> > +dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int ne=
lems,
> >  	    enum dma_data_direction direction)
> >  {
> >  	BUG();
> > diff --git a/arch/um/include/asm/mmu_context.h b/arch/um/include/asm/mm=
u_context.h
> > index edd719e..34d8130 100644
> > --- a/arch/um/include/asm/mmu_context.h
> > +++ b/arch/um/include/asm/mmu_context.h
> > @@ -35,7 +35,7 @@ static inline void switch_mm(struct mm_struct *prev, =
struct mm_struct *next,
> >  	unsigned cpu =3D smp_processor_id();
> > =20
> >  	if(prev !=3D next){
> > -		cpumask_clear(cpu, mm_cpumask(prev));
> > +		cpumask_clear_cpu(cpu, mm_cpumask(prev));
> >  		cpumask_set_cpu(cpu, mm_cpumask(next));
> >  		if(next !=3D &init_mm)
> >  			__switch_mm(&next->context.id);
> >=20

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__25_Jun_2009_13_59_01_+1000_2hiOkjakO_iCy08C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpC9gUACgkQjjKRsyhoI8w3xACcCUxvcBwtYGvIELG/4OPQsq2x
3qEAn1aD/XraFsA0DK3Vd7sJHOIVLYKs
=e+Mv
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Jun_2009_13_59_01_+1000_2hiOkjakO_iCy08C--
