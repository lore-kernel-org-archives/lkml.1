Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbXI3OYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbXI3OYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 10:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756417AbXI3OYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 10:24:41 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:44587 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030AbXI3OYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 10:24:40 -0400
X-Greylist: delayed 2407 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Sep 2007 10:24:40 EDT
Date: Sun, 30 Sep 2007 15:44:24 +0200
From: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.23-rc8-mm2] System hangs (loops?) during boot
Message-ID: <20070930154424.68e4218e@laptop.hypervisor.org>
In-Reply-To: <20070929130234.e5f0f777.akpm@linux-foundation.org>
References: <200709282225.21530.elendil@planet.nl>
	<200709290232.44573.elendil@planet.nl>
	<20070929013702.f56ba268.akpm@linux-foundation.org>
	<200709292140.23593.elendil@planet.nl>
	<20070929130234.e5f0f777.akpm@linux-foundation.org>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/af94/YuftBS8YMX65YwFst.";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/af94/YuftBS8YMX65YwFst.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 29 Sep 2007 13:02:34 -0700 Andrew Morton (AM) wrote:

AM> On Sat, 29 Sep 2007 21:40:22 +0200 Frans Pop <elendil@planet.nl> wrote:
AM>=20
AM> > On Saturday 29 September 2007, you wrote:
AM> > > On Sat, 29 Sep 2007 02:32:44 +0200 Frans Pop <elendil@planet.nl>
AM> > > wrote:
AM> > > > On Friday 28 September 2007, Frans Pop wrote:
AM> > > > > My Toshiba Satellite A40 (i386, P4 Mobile) hangs during boot
AM> > > > > after: Marking TSC unstable due to: possible TSC halt in C2.
AM> > > > > Time: acpi_pm clocksource has been installed.
AM> > > >
AM> > > > A few new boot attempts show the problem is more likely at:
AM> > > > Probing IDE interface ide0...
AM> >=20
AM> > Looks like it is both: hpet killing IDE?
AM> >=20
AM> > > Two iterations should get you into the culprit zone.
AM> >=20
AM> > Thanks for the pointers. Luckily I ended up in a quite narrow zone
AM> > between two of the points you indicated (10 iterations).
AM> >=20
AM> > And the winner is:
AM> >=20
AM> > 3fe6c0016fd863b233097a8219a0d8577c2fd503 is first bad commit
AM> > commit 3fe6c0016fd863b233097a8219a0d8577c2fd503
AM> > Author: Udo A. Steinberg <...>
AM> >     hpet-force-enable-on-ich34
AM> >=20
AM> > Guess the comments about thin ice and testing were justified :-)
AM> >=20
AM> > lspci and a 2.6.23-rc6 dmesg for this system can be found in:
AM> > http://lkml.org/lkml/2007/9/19/300
AM>=20
AM> Great, thanks for doing that.
AM>=20
AM> I guess I'll drop the patch for now in that case.

I somehow doubt that the HPET patch itself is the culprit. In fact, the
reason it shows up on git-bisect is probably because without it HPET
functionality is not enabled on the platform. So the problem could really
be anywhere in the HPET-driven timer infrastructure.

Frans, could you try out the -hrt patchset from Thomas Gleixner and see
if that works? Also, what ICH does your platform have? ICH3 or ICH4?

Cheers,

	- Udo

--Sig_/af94/YuftBS8YMX65YwFst.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG/6g5nhRzXSM7nSkRAjqlAJ9/qVrngzryBZ65x8wstaXXokiBHACfSV84
Uo3U47ortgTEbaDjexA3ka8=
=J9XL
-----END PGP SIGNATURE-----

--Sig_/af94/YuftBS8YMX65YwFst.--
