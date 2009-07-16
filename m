Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbZGPMR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbZGPMR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 08:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbZGPMR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 08:17:56 -0400
Received: from ms01.sssup.it ([193.205.80.99]:33886 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755433AbZGPMRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 08:17:55 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ted Baker <baker@cs.fsu.edu>, Chris Friesen <cfriesen@nortel.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1247731113.15471.24.camel@twins>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>
	 <1247505941.7500.39.camel@twins>
	 <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu>
	 <20090713201305.GA25386@cs.fsu.edu> <4A5BAAE7.5020906@nortel.com>
	 <20090715231109.GH14993@cs.fsu.edu>  <1247731113.15471.24.camel@twins>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0QERlx0qfh2blMbyId6I"
Date: Thu, 16 Jul 2009 14:17:51 +0200
Message-Id: <1247746671.5775.279.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0QERlx0qfh2blMbyId6I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 09:58 +0200, Peter Zijlstra wrote:=20
> > Again, I don't think that either PP or PI is appropriate for use
> > in a (SMP) kernel. For non-blocking locks, the current
> > no-preeemption spinlock mechanism works.  For higher-level
> > (blocking) locks, I'm attracted to Jim Anderson's model of
> > non-preemptable critical sections, combined with FIFO queue
> > service.
>=20
But, if I remember well how FMLP works, there is not that much
difference between them two... I mean, if you, at any (kernel|user)
level define a short critical section, this is protected by a
non-preemptive FIFO "queue lock", which is how Linux implements --at
least on x86-- spinlocks! :-O

Also, I'm not sure I can find in the FMLP paper information about the
possibility of a task to suspend itself (e.g., I/O completion) while
holding a short lock... I assume this is not recommended, but may be
wrong, and, in that case, I hope Prof. Anderson and Bjorn will excuse
and correct me. :-)

On the other hand, if with "blocking locks" you intended the long ones,
I think they hare dealt right with suspension and priority inheritance,
even in there.

> Right, so there's two points here I think:
>=20
>  A) making most locks preemptible
>  B) adding PI to all preemptible locks
>=20
> I think that we can all agree that if you do A, B makes heaps of sense,
> right?
>=20
I don't know about all, but I do... I hope I'm not offending anyone
saying that I like priority inheritance!! :-P

> Of course, when the decreased period is still sufficient for the
> application at hand, the non-preemptible case allows for better
> analysis.
>=20
Sure! I am impressed as well by the amazing results approaches like the
FMLP give in term of schedulabiulity analysis, and think a little bit of
spinning would not hurt that much, but not to the point of moving all
the locking to spinlocks. :-)

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-0QERlx0qfh2blMbyId6I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpfGmkACgkQk4XaBE3IOsT0EwCdHyfbCSU/pUqWTPii+dcBD/BD
o+sAnAvxx4FLDHBrVRn0/Bee11dlrHzi
=QAyg
-----END PGP SIGNATURE-----

--=-0QERlx0qfh2blMbyId6I--

