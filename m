Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYJ3LZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYJ3LZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbYJ3LZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:25:10 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:33658 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbYJ3LZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:25:09 -0400
Subject: Re: [PATCH 1/2] lockdep: implement full check without irq checking
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1225365316.7803.69.camel@twins>
References: <1224790541.6002.53.camel@johannes.berg>
	 <1224791072.6002.63.camel@johannes.berg>
	 <1225293796.9315.4.camel@lappy.programming.kicks-ass.net>
	 <1225362995.3690.10.camel@johannes.berg>  <1225365316.7803.69.camel@twins>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HR6nfM7RHznSg/NIpSN6"
Date: Thu, 30 Oct 2008 12:25:05 +0100
Message-Id: <1225365905.3690.30.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HR6nfM7RHznSg/NIpSN6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 12:15 +0100, Peter Zijlstra wrote:
> On Thu, 2008-10-30 at 11:36 +0100, Johannes Berg wrote:
>=20
> > > del_timer_sync():
> > >=20
> > >   local_irq_save(flags);
> > >   lock_aquire(my fake timer lock);
> > >   lock_release(...);
> > >   local_irq_restore(flags);
> > >=20
> > > and make that conditional CONFIG_PROVE_LOCKING and or wrap it up
> > > somewhere..
> >=20
> > Yeah, that is possible, but it seemed to me that would affect the
> > performance of del_timer_sync() quite a bit. Not sure it matters. And o=
n
> > powerpc (which I care about) it won't actually affect performance much
> > because we lazily disable IRQs, but still. The >=3D 2 change also seeme=
d
> > to generate smaller code?
>=20
> Its debug code, and I the >=3D 2 change makes the code much less obvious.
>=20
> So I prefer the slightly less performant but conceptually cleaner IRQ
> disable variant.

Alright. Thomas, shout if you want this code at all, then I'll clean it
up and resend, I don't particularly care, just did it to see if it was
possible.

johannes

--=-HR6nfM7RHznSg/NIpSN6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCZmNAAoJEKVg1VMiehFYSH4P/1UiVE7d+VhZQB+zVV2eNBQH
kW08sR0tKyXqCmLJWfxy13L2sVJ3YnAmhcCTVOXRlu/q4Z4C3WylYBrpuF+GDY5T
gJTRK2KatXoX6ze6OwmGKf6nmh6q8p2jpMqR8DZxwLh5lX98be6MVi8SBFwL4XHi
wGJ+H+ZvWf7q/QeC26OMEwaCgKuoLXjTRVTa2DwZR/NfjySOUHT6VW6+q9feAkvf
l8PuaRehnl/WkgO2kxoe1scPjMFtxpeYi2Ganf3IjXjkWJU5CiP5bVsNvUc2l0Wi
+zHL5iLNg6w474HlQUjbAvjB0SAEEIr4AFsHPjD+e/IsOsBil3Avz8F1zECcy5zd
buz5m5+eETeaBpKGbWqHAC/4cD2P/wxIgdcxGii/PJZvEVAcHdnpSP+K9HcTigte
d9/Z3doHLK/DX49WA1rMx1LwgAHgh4asVLwzjleqTGkjuY86G8N5xIcR1eQK3tnr
Zt67TFKCeCDH+yURoqufUBEitA9C7bIdFbsKocNbTLDah/L+L5KbyqWsX/9KtOP4
0YbOKgMu4+8xzx3lLL/sfrNQ+oz73LAAb9awGYjkeJ0i6vsOIgl/2Zc35thV/5iL
eiAl0PeunVAUPxDD7e9cNfBbDtmufOXW9j0eUbo2K/st47XBn9W+Wwxg3vqQbUPh
pESLCzQlpOtJgqrTRjNI
=BQfu
-----END PGP SIGNATURE-----

--=-HR6nfM7RHznSg/NIpSN6--

