Return-Path: <linux-kernel-owner+w=401wt.eu-S932649AbZJPPgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbZJPPgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760713AbZJPPgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:36:15 -0400
Received: from ms01.sssup.it ([193.205.80.99]:37452 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760698AbZJPPgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:36:10 -0400
Subject: [RFC 0/12][PATCH] SCHED_DEADLINE (new version of SCHED_EDF)
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: raistlin@linux.it, linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2olyLWlhUBPiVLQjzAMB"
Date: Fri, 16 Oct 2009 17:35:24 +0200
Message-Id: <1255707324.6228.448.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2olyLWlhUBPiVLQjzAMB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Peter, Hi all,

Given all the comments and feedback we got, here it is the new version
of our EDF patch, this time in a split series. :-)

Special thanks to all the one that gave us any kind of suggestion,
especially during last RTLWS in Dresden.

The rationale/motivation for the new scheduler is the same of the first
e-mail (http://lwn.net/Articles/353797/), thus I only add some new and
(I think) interesting links:
 - Ericsson posting about SCHED_EDF/DEADLINE
    https://labs.ericsson.com/blog/making-linux-more-real-time

 - The slides we presented at RTLWS in Dresden:
    http://retis.sssup.it/people/faggioli/sched_deadline/rtlw_EDF.pdf

 - Luca Abeni's presentation about using deadline based reservation=20
   schedulers for IRQ-Threads:
    http://www.disi.unitn.it/~abeni/rtlws-slides.pdf

Moreover, we moved the project on gitorious.org, therefore:
 http://gitorious.org/sched_deadline

I am also setting up right now the Wiki section, where you can find some
more detailed usage instructions, examples and overhead estimation:
 http://gitorious.org/sched_deadline/pages/Home

Git repositories are up and running, and ready at:
(mainline)
 git://gitorious.org/sched_deadline/linux-deadline.git sched-deadline=20

(sched-devel)
 git://gitorious.org/sched_deadline/linux-deadline.git sched-devel-deadline

(preempt-rt [*])
 git://gitorious.org/sched_deadline/linux-deadline.git rt-deadline

The new project homepage is
 http://www.evidence.eu.com/sched_deadline.html

Here the main changes we did, following what many of you --and mainly
Peter-- suggested:
- name changed from SCHED_EDF to SCHED_DEADLINE

- SCHED_DEADLINE has higher priority than SCHED_FIFO/SCHED_RR

- flags added in sched_param_ex to signal deadline misses
  (in case of utilization > 100%) and/or budget overruns

- new sched_*_ex prototypes, with a len field to accomodate the size of
  sched_param_ex, trying to avoid further ABI issues if it changes

- new syscall sched_wait_interval added. It behaves like clock_nanosleep
  but, for a SCHED_DEADLINE task, it also represent the end of the
  current instance (sched_yield no longer needed)

- on fork, child starts but with 0 bandwidth (i.e., it does not start! :-D)

- bug fixing :)

Any feedback and contribution is welcome.

Many thanks,

             Dario Faggioli
             Claudio Scordino
             Michael Trimarchi

[*] porting toward preempt-rt is work in progress. Code is there, but we
are testing and fixing it, with the help of Luca and Nicola from
Trento... So don't consider it as the final version!


--=-2olyLWlhUBPiVLQjzAMB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrYkrwACgkQk4XaBE3IOsS/TQCcCBFlsWazx60DmP5hPOuqvnF5
UnEAn25uvjprv5Pf+GCWVlX8yM3bRS9t
=//gZ
-----END PGP SIGNATURE-----

--=-2olyLWlhUBPiVLQjzAMB--

