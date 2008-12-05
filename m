Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbYLEOVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbYLEOVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 09:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYLEOVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 09:21:22 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:33405 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYLEOVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 09:21:21 -0500
Message-ID: <493939B1.40506@novell.com>
Date: Fri, 05 Dec 2008 09:24:49 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [git pull] RT scheduler updates for tip
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE1CCFD9537F1241B1101A70C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE1CCFD9537F1241B1101A70C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Ingo,
  FWIW, I have placed all my latest upstream-able scheduler patches into
a branch in my git tree (against tip/master).
=20
=20
git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.gi=
t
sched/latest

Gregory Haskins (11):
      sched: cleanup inc/dec_rt_tasks
      sched: track the next-highest priority on each runqueue
      sched: use highest_prio.curr for pull threshold
      sched: use highest_prio.next to optimize pull operations
      sched: only try to push a task on wakeup if it is migratable
      sched: pull only one task during NEWIDLE balancing to limit
critical section
      sched: make double-lock-balance fair
      sched: add sched_class->needs_post_schedule() member
      plist: fix PLIST_NODE_INIT to work with debug enabled
      sched: create "pushable_tasks" list to limit pushing to one attempt=

      RT: fix push_rt_task() to handle dequeue_pushable properly

 include/linux/init_task.h |    1 +
 include/linux/plist.h     |    9 +-
 include/linux/sched.h     |    2 +
 kernel/sched.c            |   89 +++++++++++--
 kernel/sched_rt.c         |  324
+++++++++++++++++++++++++++++++--------------
 5 files changed, 312 insertions(+), 113 deletions(-)

These are built/booted on my quad-core/x86_64 and look good to me.

1) the first four are the "next-highest" v3 patches that I submitted
yesterday
2) the last seven are patches that Steven has carried in 26-rt that have
not yet been pulled in to tip

I assume there is an implicit ACK from Steven on (2) since he pulled
them into -rt.  We still await comment from Peter re: (1).

Regards,
-Greg



--------------enigE1CCFD9537F1241B1101A70C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkk5ObEACgkQlOSOBdgZUxkK+QCeIYKRaCoVbX/XOIunhNKuKWo+
wNgAoIAjFjrqMFlZq/HHS6jkbXzxbLum
=JwYf
-----END PGP SIGNATURE-----

--------------enigE1CCFD9537F1241B1101A70C--
