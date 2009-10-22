Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZJVIL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZJVIL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 04:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZJVILz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 04:11:55 -0400
Received: from ms01.sssup.it ([193.205.80.99]:48908 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751687AbZJVILx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 04:11:53 -0400
Subject: Re: [PATCH] DRTL kernel 2.6.32-rc3 : SCHED_EDF, DI RT-Mutex,
 Deadline  Based Interrupt Handlers
From: Raistlin <raistlin@linux.it>
To: Soumya K S <ssks.mt@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@gandalf.sssup.it>
In-Reply-To: <e932a33e0910210838j3be9286bo3953c4cae3f0e12e@mail.gmail.com>
References: <e932a33e0910210833j1fab6129m23b55101c5978c4a@mail.gmail.com>
	 <e932a33e0910210838j3be9286bo3953c4cae3f0e12e@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7710OQz06+8yY5lmcHp1"
Date: Thu, 22 Oct 2009 09:54:48 +0200
Message-Id: <1256198088.6700.76.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7710OQz06+8yY5lmcHp1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-10-21 at 21:08 +0530, Soumya K S wrote:
> Hello All,
>=20
Hi,

I'm Dario, from Pisa (Italy), and I'm working on EDF scheduling for the
Linux kernel as you do (don't know if you've seen the threads and the
patches, all info here http://gitorious.org/sched_deadline/pages/Home).

> The developed framework allows user to specify the real-time
> strategies for a specific real-time scenario. User specifies
> configurations like scheduling policy, Deadline-miss Fault-tolerance
> limit, interrupt priorities, etc. Real-time applications use onetime
> gateway to notify kernel that they require real-time response. All
> applications use existing POSIX APIs. DRTL scheduler is time-aware and
> uses EDF as the scheduling policy.
>=20
Nice, from here, it seemed we were working on very similar things, and I
was wondering if we could somehow collaborate... :-)

Then I looked at the code and I saw our two designs are quite different,
e.g., you don't constraint execution times, don't run any admission test
to avoid oversubscription and you stop deadline missing tasks... Am I
right?
Even from the implementation point of view, I see you didn't used a new
scheduling class.

However, I think there still would be room for collaboration, if you are
interested in...

> The patch consists of Time aware scheduler having SCHED_EDF as the
> scheduling policy, Deadline based scheduling for Interrupt handlers,
> Deadline Inheritance support for RT-Mutexes.
>=20
I was very curious on how you dealt with deadline inheritance in SMPs,
than I saw this in your patch:

diff -Naur linux-2.6.32-rc3/init/Kconfig linux-2.6.32-rc3-drtl/init/Kconfig
+config SCHED_EDF
+	bool "EDF Scheduler Support"
+	default n
+	depends on !GROUP_SCHED
+	depends on !SMP

:-P

I'm right in the opposite situation, I've got SMP (partitioned for now,
but we're working on migrations) and also CGROUPS support, but we are
still wondering how deadline (or something more sophisticated, like
bandwidth) inheritance could work in such a case...

Again, I think I see collaboration possibilities, again, if you're
interested in...

> The patch is for the kernel version 2.6.32-rc3. It has been tested on
> OMAP3530, ATMEL AT91SAM9261 and X86 platforms.
>=20
Ok... Are you also targeting (or plan to) preempt-rt kernels?

> We look forward for support and feedback about
> DRTL <http://docs.google.com/fileview?id=3D0BzLQtQ1qAO7uYjYyN2QwNGUtYWE2Y=
S00MDc1LWExYWUtZTliNjNjNmZiZTZj&hl=3Den>
> and the patch for its feasibility, scalability and performance.
>=20
Do you already have any numbers or testcase? I have some (well, a few!)
of them... I'll try to find the time to give it a try to your patch with
them...

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-7710OQz06+8yY5lmcHp1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrgD8EACgkQk4XaBE3IOsSgwwCfa3y1D//B4hlWOYojMIsNBdkW
MkcAnj3FqpOFNSUa3HFD/OZGRFiHwxM7
=0eJp
-----END PGP SIGNATURE-----

--=-7710OQz06+8yY5lmcHp1--

