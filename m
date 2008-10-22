Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbYJVNk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbYJVNk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 09:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYJVNkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 09:40:06 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34817 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYJVNkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 09:40:04 -0400
Message-ID: <48FF2E28.6040002@novell.com>
Date: Wed, 22 Oct 2008 09:44:08 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: sched: deep power-saving states
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6CD9CB12A6347803AD463436"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6CD9CB12A6347803AD463436
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

[Resending from my real account... .ml@gmail is for mailing list traffic
 and I forgot to change the "from" field :P)

Hi Arjan,
  I was giving some thought to that topic you brought up at our
LF-end-user session on RT w.r.t. deep power state wakeup adding latency.

As Steven mentioned, we currently have this thing called "cpupri"
(kernel/sched_cpupri.c) in the scheduler which allows us to classify
each core (on a per disjoint cpuset basis) as being either IDLE,
SCHED_OTHER, or RT1 - RT99.  (Note that currently we lump both IDLE and
SCHED_OTHER together as SCHED_OTHER because we don't yet care to
differentiate between them, but I have patches to fix this that I can
submit).

What I was thinking is that a simple mechanism to quantify the
power-state penalty would be to add those states as priority levels in
the cpupri namespace.  E.g. We could substitute IDLE-RUNNING for IDLE,
and add IDLE-PS1, IDLE-PS2, .. IDLE-PSn, OTHER, RT1, .. RT99.  This
means the scheduler would favor waking an IDLE-RUNNING core over an
IDLE-PS1-PSn, etc.  The question in my mind is: can the power-states be
determined in a static fashion such that we know what value to quantify
the idle state before we enter it?  Or is it more dynamic (e.g. the
longer it is in an MWAIT, the deeper the sleep gets).

If its dynamic, is there a deterministic algorithm that could be applied
so that, say, a timer on a different CPU (bsp makes sense to me) could
advance the IDLE-PSx state in cpupri on behalf of the low-power core as
time goes on?

Thoughts?
-Greg



--------------enig6CD9CB12A6347803AD463436
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkj/LigACgkQlOSOBdgZUxnmkACdEkmTWhvcQxjB+Te5BPsmXuN0
6BAAn2rHSxM4JeLOdrcqpRiU7W9NGlsM
=GmM/
-----END PGP SIGNATURE-----

--------------enig6CD9CB12A6347803AD463436--
