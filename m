Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab0BDLFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 06:05:32 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:41952 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab0BDLFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 06:05:31 -0500
X-Spam-ASN: 
Date: Thu, 4 Feb 2010 14:05:22 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
       Rodolfo Giometti <giometti@enneenne.com>,
       Rodolfo Giometti <giometti@linux.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       "William S. Brasher" <billb958@door.net>, Reg Clemens <clemens@dwf.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@linux.intel.com>, John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 2/5] pps: capture MONOTONIC_RAW timestamps as well
Message-ID: <20100204140522.42330436@desktopvm.lvknet>
In-Reply-To: <1265235976.3255.67.camel@work-vm>
References: <cover.1265228858.git.lasaine@lvk.cs.msu.su>
 <67507a9818993cfcf0139668c11569a6f3ff1981.1265228858.git.lasaine@lvk.cs.msu.su>
 <1265235976.3255.67.camel@work-vm>
Organization: LVK
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/0mj8pUY6BndtJicboDXKhem";
 protocol="application/pgp-signature"; micalg=PGP-SHA256
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0mj8pUY6BndtJicboDXKhem
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Wed, 03 Feb 2010 14:26:16 -0800
john stultz <johnstul@us.ibm.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Wed, 2010-02-03 at 23:56 +0300, Alexander Gordeev wrote:
> > MONOTONIC_RAW clock timestamps are ideally suited for frequency
> > calculation and also fit well into the original NTP hardpps design.
> > Now phase and frequency can be adjusted separately: the former
> > based on REALTIME clock and the latter based on MONOTONIC_RAW clock.
> > A new function getnstime_raw_and_real is added to timekeeping
> > subsystem to capture both timestamps at the same time and
> > atomically.
>=20
> Hrmm. So while I understand the need for it, the
> getnstime_raw_and_real() makes me cringe a little. Part of the issue
> is that there are multiple CLOCK_IDs and the current interface allows
> for accesses to only one at a time. There's a similar hack in the
> hrtimer code to get the CLOCK_REALTIME and CLOCK_MONOTONIC values at
> the same time. Next I worry that folks will want a
> getnstime_mono_and_raw() or a getnstime_real_mono_and_raw(), then a
> getnstime_real_and_realcoarse(), etc..=20
>=20
> I'm almost thinking the way to handle this would be a better
> abstraction, like a get_two_times(CLOCKID, timepsec*, CLOCKID,
> timespec*). But that might need some further discussion. Anyone else
> have thoughts here?

Agreed with you completely. I don't like the approach but failed to
invent anything better.
=20
> So yea not opposed to this patch, but maybe try to avoid exporting the
> symbol, so modules don't end up using it and we can change it fairly
> easily later.

Well, I'd like to, but how? getnstime_raw_and_real() is used in
module added in one of the next commits.

--=20
  Alexander

--Sig_/0mj8pUY6BndtJicboDXKhem
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAEBCAAGBQJLaqnyAAoJEElrwznyooJbfXoH/iM1SL0vlW4fpmMDyq6PJams
zaaP0rAXyO39GUh/S//UlMuW4sduTttgFdS8beGZ6zuMganUDO3cj79xi0d75Mqr
VXxOF4M5Z0D/NNrVysm0NtbZq3TVubuW25GwkKGONqvohlA+DUcjnUM932QMpoXp
PVEp59hvYDs6KfQsdiTx8CXffLflrwTlG8yRs5D0V86eyw6/Kk8wFhnDAykiRQsP
Y5hH/JetkvSf7dpNh8nbGjLN5Y4Y5jQ0fIZ+OKYPAwZbn2zpYYHJxp/vVdK2GOGX
ErtkKV3Rm3DRUNgWBLkq0sZA6nXtCD5D1olL5kgmQ/hEtc3p5YbHvC+mifmUgyg=
=jxm1
-----END PGP SIGNATURE-----

--Sig_/0mj8pUY6BndtJicboDXKhem--
