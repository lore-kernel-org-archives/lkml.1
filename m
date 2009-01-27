Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbZA0VX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbZA0VX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbZA0VXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:23:38 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:50071 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbZA0VXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:23:37 -0500
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
From: Eric Anholt <eric@anholt.net>
To: Mark Knecht <markknecht@gmail.com>
Cc: Jonathan Campbell <jon@nerdgrounds.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
In-Reply-To: <5bdc1c8b0901270937h27c48290p4fb5233f06593e44@mail.gmail.com>
References: <497E4531.20800@nerdgrounds.com>
	 <5bdc1c8b0901261859g58a413e1x52208a6f2c1f9ccd@mail.gmail.com>
	 <1233031451.4851.31.camel@gaiman>
	 <5bdc1c8b0901270937h27c48290p4fb5233f06593e44@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-08in04HvOb4CIlsE+3XT"
Date: Tue, 27 Jan 2009 13:23:34 -0800
Message-Id: <1233091414.25539.8.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-08in04HvOb4CIlsE+3XT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-27 at 09:37 -0800, Mark Knecht wrote:
> On Mon, Jan 26, 2009 at 8:44 PM, Eric Anholt <eric@anholt.net> wrote:
> > On Mon, 2009-01-26 at 18:59 -0800, Mark Knecht wrote:
> <SNIP>
> >> >
> >>
> >> Can the GPU use the data placed in your file system? Do you have
> >> strong control as to exactly how the data is mapped into VRAM? I'm
> >> thinking about parallel processing  - Linux puts data there and then
> >> the GPU works on it to produce a result which Linux can eventually
> >> fetch.
> >
> > For that you want something like GEM, which is aware of the graphics
> > pipeline and the cache management necessary.  Wrapping a filesystem
> > around it shouldn't be hard, and would be of some use for debugging.
> >
> > --
> > Eric Anholt
>=20
> Right. I agree. However over time a number of us in the pro-audio area
> have thought about using the GPU for things like building complex
> reverb convolutions in real-time. Lots of parallelism in the math.
> These machines are not typically very graphically intensive and the
> VRAM on the cards isn't required but it's there. Somehow being able to
> get data in and out of the VRAM using standard file commands, letting
> something like GEM do the work, and then getting the data back seems
> appealing.

The way you want do that is using OpenGL to put your data in textures
and framebuffer objects, and render them.  With KMS, we'll be able to
support EGL even on the console so you can do the work without having an
X environment set up.

The problem with vramfs as a basis for GPU offload is that most GPU
tasks end up at some point exceeding the size of available
aperture/VRAM.  So you need code that manages loading buffer objects in
and out on demand, managing the execution pipeline and GPU and CPU
caches as required.  We have that with GEM already.

Remember, writing data to an aperture isn't the hard part of offloading
to the GPU, programming the GPU is.  That's why you use OpenGL or
another abstraction to do it.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-08in04HvOb4CIlsE+3XT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl/e1MACgkQHUdvYGzw6vf4IwCfba3OcV9prnNOUG5FYAeo6sxT
w8oAoIUa8Hc1pfyoZxqCwchuW+fMY5i0
=jhXY
-----END PGP SIGNATURE-----

--=-08in04HvOb4CIlsE+3XT--
