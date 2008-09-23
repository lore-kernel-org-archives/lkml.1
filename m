Return-Path: <linux-kernel-owner+w=401wt.eu-S1751392AbYIWLtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbYIWLtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYIWLs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:48:58 -0400
Received: from postman.teamix.net ([194.150.191.120]:41313 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752353AbYIWLs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:48:57 -0400
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] CFS scheduler: documentation about scheduling policies
Date: Tue, 23 Sep 2008 13:48:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <200809231101.41624.ms@teamix.de> <20080923091159.GE31189@elte.hu>
In-Reply-To: <20080923091159.GE31189@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1310934.zrDZ4s2nle";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809231348.50834.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1310934.zrDZ4s2nle
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Dienstag, 23. September 2008 schrieb Ingo Molnar:
> * Martin Steigerwald <ms@teamix.de> wrote:
> > The documentation about the CFS scheduler is scarse when it comes to
> > scheduling policies. This patch adds a chapter about the scheduling
> > policies it supports. Peter Zijlstra provided most of the information f=
or
> > it in
> >
> > http://marc.info/?l=3Dlinux-kernel&m=3D122210038326356&w=3D2
> >
> > This patch is based on 2.6.27-rc7.
> >
> > Signed-off-by: Martin Steigerwald <ms@teamix.de>
>
> looks good to me - but could you please do the patch against the latest
> scheduler tree, which has already updated this file (and which made your
> patch not apply cleanly):
>
> =A0 http://people.redhat.com/mingo/tip.git/README
>
> also:
> > --- sched-design-CFS.txt-2.6.27-rc7 =A0 =A0 2008-07-13 23:51:29.0000000=
00
> > +0200 +++ sched-design-CFS.txt =A0 =A0 =A0 =A02008-09-23 10:33:01.10739=
3509 +0200
>
> please use -p1 to create patches - or since you've just set up the
> tip/master tracking, do something like:

Okay, lets see how this works out.

=2D--
=46rom a57581d4ec3b13f63920b89c336ac9c93c6cf9f0 Mon Sep 17 00:00:00 2001
=46rom: Martin Steigerwald <ms@teamix.de>
Date: Tue, 23 Sep 2008 13:45:46 +0200
Subject: [PATCH] CFS: Documentation about scheduling policies

The documentation about the CFS scheduler is scarse when it comes to
scheduling policies. This patch adds a chapter about the scheduling
policies it supports. Peter Zijlstra provided most of the information
for it in

http://marc.info/?l=3Dlinux-kernel&m=3D122210038326356&w=3D2

Signed-off-by: Martin Steigerwald <ms@teamix.de>
=2D--
 Documentation/scheduler/sched-design-CFS.txt |   28 ++++++++++++++++++++++=
++-
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/Documentation/scheduler/sched-design-CFS.txt b/Documentation/s=
cheduler/sched-design-CFS.txt
index b2aa856..9d8eb55 100644
=2D-- a/Documentation/scheduler/sched-design-CFS.txt
+++ b/Documentation/scheduler/sched-design-CFS.txt
@@ -114,7 +114,31 @@ result.
=20
=20
=20
=2D5.  SCHEDULING CLASSES
+5. Scheduling policies
+
+CFS implements three scheduling policies:
+
+  - SCHED_NORMAL (traditionally called SCHED_OTHER): The scheduling
+    policy that is used for regular tasks.
+
+  - SCHED_BATCH: Does not preempt nearly as often as regular tasks
+    would, thereby allowing tasks to run longer and make better use of
+    caches but at the cost of interactivity. This is well suited for
+    batch jobs.
+
+  - SCHED_IDLE: This is even weaker than nice 19, but its not a true
+    idle timer scheduler in order to avoid to get into priority
+    inversion problems which would deadlock the machine.
+
+SCHED_FIFO/_RR are implemented in sched_rt.c and are as specified by
+POSIX.
+
+The command chrt from util-linux-ng 2.13.1.1 can set all of these except
+SCHED_IDLE.
+
+
+
+6.  SCHEDULING CLASSES
=20
 The new CFS scheduler has been designed in such a way to introduce "Schedu=
ling
 Classes," an extensible hierarchy of scheduler modules.  These modules
@@ -179,7 +203,7 @@ This is the (partial) list of the hooks:
=20
=20
=20
=2D6.  GROUP SCHEDULER EXTENSIONS TO CFS
+7.  GROUP SCHEDULER EXTENSIONS TO CFS
=20
 Normally, the scheduler operates on individual tasks and strives to provide
 fair CPU time to each task.  Sometimes, it may be desirable to group tasks=
 and

=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart1310934.zrDZ4s2nle
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjY150ACgkQHhDFkwOZrpBp7QCdG2R9WT4uM7IxBIr7iNs7s0MO
3m4An3QYLJ7Cg2C5ATyakH0e2y9P5JBW
=byQi
-----END PGP SIGNATURE-----

--nextPart1310934.zrDZ4s2nle--
