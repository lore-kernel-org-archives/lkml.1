Return-Path: <linux-kernel-owner+w=401wt.eu-S934115AbZAPAxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115AbZAPAxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbZAPAxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:53:22 -0500
Received: from mail.klingt.org ([86.59.21.178]:37581 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164AbZAPAxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:53:21 -0500
Subject: Re: 2.6.28-rc9: oprofile regression
From: Tim Blechmann <tim@klingt.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
       venkatesh.pallipadi@intel.com
In-Reply-To: <alpine.LFD.2.00.0901152135110.3400@localhost.localdomain>
References: <1229869416.6911.1.camel@thinkpad>
	 <1229894585.6898.6.camel@thinkpad>  <49544497.9020900@linux.intel.com>
	 <1230894257.6072.10.camel@thinkpad>
	 <alpine.LFD.2.00.0901141739580.3598@localhost.localdomain>
	 <1231957184.13033.70.camel@thinkpad>
	 <alpine.LFD.2.00.0901150940250.3598@localhost.localdomain>
	 <1232010853.6541.4.camel@thinkpad>
	 <alpine.LFD.2.00.0901152135110.3400@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Xp16/VUeoITDrlvq7Qc6"
Date: Fri, 16 Jan 2009 01:53:01 +0100
Message-Id: <1232067181.6134.74.camel@thinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (klingt.org [127.0.0.1]); Fri, 16 Jan 2009 01:53:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Xp16/VUeoITDrlvq7Qc6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 21:37 +0100, Thomas Gleixner wrote:
> On Thu, 15 Jan 2009, Tim Blechmann wrote:
> > On Thu, 2009-01-15 at 09:46 +0100, Thomas Gleixner wrote:
> > > Tim,
> > >=20
> > > On Wed, 14 Jan 2009, Tim Blechmann wrote:
> > > > this code (line 81/82), changes counter_width from 32 to 40.
> > > >=20
> > > > if (counter_width < eax.split.bit_width)
> > > >         counter_width =3D eax.split.bit_width;
> > > >=20
> > > > however when removing these lines, and thus keeping the value 32 fo=
r
> > > > counter_width, doesn't change the behavior, only one NMI per cpu.
> > >=20
> > > It would only help, when the reported bit_width would be bogus. We
> > > know that you get at least one NMI, so lets look at the results we ge=
t
> > > there.
> >=20
> > it seems, that ppro_check_ctrs is never called:
> > [  982.238639] oprofile: using NMI interrupt.
> >=20
> > hth, tim
>=20
> Hmm, that confuses the hell out of me. Can you try the patch below,
> which restores the original code of writing the counter registers ?

no difference ... i must admit, i already spent some time, trying to
revert the specific changes of this commit ... i gave up to wait for
some help from someone, who actually knows how the code is working ...

possibly it makes sense to compile a full kernel of the first bad kommit
and introduce the different changes one by one ... i will try to find
some time for this during the next few days ...

but if you have more patches, that i can test, please let me know ...

cheers, tim
=20
--
tim@klingt.org
http://tim.klingt.org

Which is more musical, a truck passing by a factory or a truck passing
by a music school?
  John Cage

--=-Xp16/VUeoITDrlvq7Qc6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklv2msACgkQdL+4qsZfVssuiQCeLwaBrk0KtxJ1+8EWU7KMJe9Z
VoYAnAsgByctKiCplVGSvK9f+c3NN+J+
=H5JJ
-----END PGP SIGNATURE-----

--=-Xp16/VUeoITDrlvq7Qc6--

