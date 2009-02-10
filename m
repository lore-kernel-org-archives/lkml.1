Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbZBJWA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbZBJWA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZBJWAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:00:12 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:43856 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbZBJWAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:00:11 -0500
Subject: Re: Gem GTT mmaps..
From: Eric Anholt <eric@anholt.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200902061424.02906.jbarnes@virtuousgeek.org>
References: <498A1760.7010108@shipmail.org>
	 <200902060914.59956.jbarnes@virtuousgeek.org>
	 <498CAD2F.5070806@shipmail.org>
	 <200902061424.02906.jbarnes@virtuousgeek.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uTgtQNGBMjuHz47LaCN2"
Date: Tue, 10 Feb 2009 14:00:01 -0800
Message-Id: <1234303201.32506.8.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uTgtQNGBMjuHz47LaCN2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-06 at 14:24 -0800, Jesse Barnes wrote:
> On Friday, February 6, 2009 1:35 pm Thomas Hellstr=C3=B6m wrote:
> > Jesse Barnes wrote:
> > > On Thursday, February 5, 2009 10:37 am Jesse Barnes wrote:
> > >> So if we leave the lookup reference around from the GTT mapping ioct=
l,
> > >> that would take care of new mappings.  And if we added/removed
> > >> references at VM open/close time, we should be covered for fork.  Bu=
t is
> > >> it ok to add a new unref in the finish ioctl for GTT mapped objects?=
  I
> > >> don't think so, because we don't know for sure if the caller was the=
 one
> > >> that created the new fake offset (which would be one way of detectin=
g
> > >> whether it was GTT mapped). Seems like we need a new unmap ioctl?  O=
r we
> > >> could put the mapping ref/unref in libdrm, where it would be tracked=
 on
> > >> a per-process basis...
> > >
> > > Ah but maybe we should just tear down the fake offset at unmap time; =
then
> > > we'd be able to use it as an existence test for the mapping and get t=
he
> > > refcounting right.  The last thing I thought of was whether we'd be o=
k in
> > > a map_gtt -> crash case.  I *think* the vm_close code will deal with
> > > that, if we do a deref there?
> >
> > Yes, an mmap() is always paired with a vm_close(), and the vm_close()
> > also happens in a crash situation.
>=20
> This one should cover the cases you found.
>   - ref at map time will keep the object around so fault shouldn't fail
>   - additional threads will take their refs in vm_open/close
>   - unmap will unref and remove mmap_offset allowing object to be freed

sw_finish doesn't mean unmap (note that it doesn't actually unmap).

If you want to actually unmap, that should be done with munmap.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-uTgtQNGBMjuHz47LaCN2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmR+OAACgkQHUdvYGzw6vcFRwCeLYgbuKOycBUFBZztDPnw0ODz
MAwAn3bNs/vkOvtpOfqazWzbv/2o0DEa
=FBP9
-----END PGP SIGNATURE-----

--=-uTgtQNGBMjuHz47LaCN2--
