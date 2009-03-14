Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbZCNLpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbZCNLpO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbZCNLo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:44:56 -0400
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:52826 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366AbZCNLoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:44:54 -0400
MIME-version: 1.0
Date: Sat, 14 Mar 2009 12:44:42 +0100
From: Frank Mehnert <Frank.Mehnert@Sun.COM>
Subject: Re: remap_pfn_range() not suitable for physical RAM?
In-reply-to: <1236964416.4529.125.camel@localhost.localdomain>
To: linux-kernel@vger.kernel.org
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Message-id: <200903141244.45321.frank.mehnert@sun.com>
Organization: Sun Microsystems
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart3384037.3asJlLO9yH
Content-transfer-encoding: 7BIT
References: <200903042025.46861.frank.mehnert@sun.com>
 <200903131600.00463.frank.mehnert@sun.com>
 <1236964416.4529.125.camel@localhost.localdomain>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3384037.3asJlLO9yH
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Venki,

thanks for these explanations. So vm_insert_page() is only meant for
RAM pages and remap_pfn_range() can be used for any mappings (inclusive
I/O memory), is that right?

Thanks,

=46rank

On Friday 13 March 2009, Pallipadi, Venkatesh wrote:
> Frank,
>
> The track and untrack is keeping track of memory type for non-RAM
> regions and making sure that the type is in sync for various mappings
> for such addresses. We are not tracking the RAM pages today, so
> vm_insert_page does not have this. vm_insert_mixed is also not covered
> today, as we deferred that and tracking of RAM pages into our next set
> of changes.
>
> Thanks,
> Venki
>
> On Fri, 2009-03-13 at 08:00 -0700, Frank Mehnert wrote:
> > Venki,
> >
> > thanks for your reply. May I ask anyway why this check is done in
> > remap_pfn_range() and vm_insert_pfn() but not in vm_insert_page()?
> >
> > Kind regards,
> >
> > Frank
> >
> > On Tuesday 10 March 2009, Pallipadi, Venkatesh wrote:
> > > Frank,
> > >
> > > Patch here should eliminate the restriction.
> > > http://marc.info/?l=3Dlinux-kernel&m=3D123664923030126&w=3D1
> > >
> > > Thanks,
> > > Venki
> > >
> > > >-----Original Message-----
> > > >From: linux-kernel-owner@vger.kernel.org
> > > >[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Frank Mehne=
rt
> > > >Sent: Tuesday, March 10, 2009 1:04 AM
> > > >To: linux-kernel@vger.kernel.org
> > > >Cc: peterz@infradead.org; Siddha, Suresh B
> > > >Subject: Re: remap_pfn_range() not suitable for physical RAM?
> > > >
> > > >Hi,
> > > >
> > > >sorry for re-posting this message and sorry for addressing you
> > > >directly.
> > > >Perhaps you can help me again or can you give me a pointer for a
> > > > proper documentation of the various *remap* and *vm_insert*
> > > > functions:
> > > >
> > > >On Wednesday 04 March 2009, Frank Mehnert wrote:
> > > >> since 2.6.29-rcX it seems to be not allowed anymore to use
> > > >> remap_pfn_range() to remap physical RAM to userland. This
> > > >> restriction applies only if CONFIG_X86_PAT is enabled. It seems th=
at
> > > >
> > > >vm_insert_page()
> > > >
> > > >> does not have this restriction. Am I correct? And what is the reas=
on
> > > >> for this restriction?
> > > >
> > > >Kind regards,
> > > >
> > > >Frank
> > > >--
> > > >Dr.-Ing. Frank Mehnert    Sun Microsystems    http://www.sun.com/
> > > >--
> > >
> > > To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l"
> > > in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



=2D-=20
Dr.-Ing. Frank Mehnert    Sun Microsystems    http://www.sun.com/

--nextPart3384037.3asJlLO9yH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm7mKoACgkQ6z8pigLf3Ec7UwCeNnnFL4Yh/Q7Fe1TvyjvhO918
ABwAn3dmlu4m7J5KYxWOoJbC9pWk55b4
=Zx9n
-----END PGP SIGNATURE-----

--nextPart3384037.3asJlLO9yH--
