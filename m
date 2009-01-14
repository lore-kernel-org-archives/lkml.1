Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbZANSU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbZANSU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbZANSUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:20:08 -0500
Received: from mail.klingt.org ([86.59.21.178]:33326 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbZANSUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:20:06 -0500
Subject: Re: 2.6.28-rc9: oprofile regression
From: Tim Blechmann <tim@klingt.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
       venkatesh.pallipadi@intel.com
In-Reply-To: <alpine.LFD.2.00.0901141739580.3598@localhost.localdomain>
References: <1229869416.6911.1.camel@thinkpad>
	 <1229894585.6898.6.camel@thinkpad>  <49544497.9020900@linux.intel.com>
	 <1230894257.6072.10.camel@thinkpad>
	 <alpine.LFD.2.00.0901141739580.3598@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-w/LXGLw+6VejTPk+ApmZ"
Date: Wed, 14 Jan 2009 18:19:44 +0000
Message-Id: <1231957184.13033.70.camel@thinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (klingt.org [127.0.0.1]); Wed, 14 Jan 2009 19:19:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-w/LXGLw+6VejTPk+ApmZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-14 at 18:10 +0100, Thomas Gleixner wrote:
> On Fri, 2 Jan 2009, Tim Blechmann wrote:
> > On Fri, 2008-12-26 at 03:42 +0100, Andi Kleen wrote:
> > > Tim Blechmann wrote:
> > > >> i am experiencing an issue, similar to the one reported in
> > > >> http://lkml.org/lkml/2008/10/30/319.
> > > >=20
> > > > bisecting showed, that commit b99170288421c79f0c2efa8b33e26e65f4bb7=
fb8
> > > > (oprofile: Implement Intel architectural perfmon support) caused th=
e
> > > > problem.=20
> > > > oddly, the newly introduced api is not used, since the model struct=
 is
> > > > set during the ppro_init call ...
> > >=20
> > > We're still investigating the problem. Thanks for the report.
> >=20
> > btw, this issue still exists in tip/oprofile ... not sure, whether this
> > may be related, but i am running the machine in 64-bit mode ...
>=20
> can you please apply the patch below and provide the output ?

[29030.863352] oprofile: using NMI interrupt.
[29051.826778] ppro counter_width: 40
[29051.826783] ppro counter_width: 40


> That's one of the subtle differences to the 2.6.27 code, where the
> counter width is fixed to 32bit, which is correct anyway as the
> counter MSRs can only write the lower 32bits and sign extend bit 31
> according to intel documentation.

this code (line 81/82), changes counter_width from 32 to 40.

if (counter_width < eax.split.bit_width)
        counter_width =3D eax.split.bit_width;

however when removing these lines, and thus keeping the value 32 for
counter_width, doesn't change the behavior, only one NMI per cpu.

best, tim

--
tim@klingt.org
http://tim.klingt.org

It is better to make a piece of music than to perform one, better to
perform one than to listen to one, better to listen to one than to
misuse it as a means of distraction, entertainment, or acquisition of
'culture'.
  John Cage

--=-w/LXGLw+6VejTPk+ApmZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkluLLwACgkQdL+4qsZfVssuBwCgpheaO9OcHuoxlOBQbb9eMMeq
wYAAnjK65hs5wEqi1MszfvHtPAmaaeDx
=fghU
-----END PGP SIGNATURE-----

--=-w/LXGLw+6VejTPk+ApmZ--

