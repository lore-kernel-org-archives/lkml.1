Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbYL2SKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbYL2SKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 13:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYL2SKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 13:10:01 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:40565 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYL2SKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 13:10:00 -0500
Message-ID: <49591331.9080403@novell.com>
Date: Mon, 29 Dec 2008 13:13:05 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] RT scheduler updates for tip
References: <493939B1.40506@novell.com> <20081208143228.GF14856@elte.hu> <20081208161246.GB4570@elte.hu> <493E8246.1090309@novell.com> <20081212113415.GH32640@elte.hu> <20081212114952.GA16976@elte.hu> <4958EEB6.5020105@novell.com>
In-Reply-To: <4958EEB6.5020105@novell.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFE09EDE8989DE9D2F5396357"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFE09EDE8989DE9D2F5396357
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Ingo Molnar wrote:
>  =20
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>    =20
>>>
>>> Could you send a delta fix against cpus4096 for that bug you fixed?
>>>    =20
>>>      =20

Hi Ingo,
  I have rebased the series against tip/cpus4096 as of today.  I
built/boot this kernel for both SMP/UP on a 4-way x86_64 box, and they
look sane.  Let me know if they still look broken to you.

The following changes since commit 6092848a2a23b660150a38bc06f59d75838d70=
c8:
  Sergio Luis (1):
        x86: mark get_cpu_leaves() with __cpuinit annotation

are available in the git repository at:

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
 5 files changed, 311 insertions(+), 114 deletions(-)



--------------enigFE09EDE8989DE9D2F5396357
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAklZEzEACgkQlOSOBdgZUxlWiQCfRCjZRPDn5k/D3kdB1zAFIxq8
vp8AnR69HkP3SXnVDvfkeWCv/u2UsCWe
=wrYc
-----END PGP SIGNATURE-----

--------------enigFE09EDE8989DE9D2F5396357--
