Return-Path: <linux-kernel-owner+w=401wt.eu-S932406AbXCQMMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406AbXCQMMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 08:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933040AbXCQMMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 08:12:49 -0400
Received: from smtp15.wxs.nl ([195.121.247.6]:44225 "EHLO smtp15.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406AbXCQMMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 08:12:48 -0400
Date: Sat, 17 Mar 2007 13:15:55 +0100
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: [ck] Re: is RSDL an "unfair" scheduler too?
In-reply-to: <20070317114903.GA20673@elte.hu>
To: ck@vds.kolivas.org
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200703171315.59143.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart3560359.k8W3YnNb3v
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.6
References: <200703042335.26785.a1426z@gawab.com>
 <200703172048.46267.kernel@kolivas.org> <20070317114903.GA20673@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3560359.k8W3YnNb3v
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Op Saturday 17 March 2007, schreef Ingo Molnar:
> * Con Kolivas <kernel@kolivas.org> wrote:
> > Despite the claims to the contrary, RSDL does not have _less_
> > heuristics, it does not have _any_. It's purely entitlement based.
>
> RSDL still has heuristics very much, but this time it's hardcoded into
> the design! Let me demonstrate this via a simple experiment.
>
> in the vanilla scheduler, the heuristics are ontop of a fairly basic
> (and fast) scheduler, they are plain visible and thus 'optional'. In
> RSDL, the heuristics are still present but more hidden and more
> engrained into the design.
>
> But it's easy to demonstrate this under RSDL: consider the following two
> scenarios, which implement precisely the same fundamental computing
> workload (everything running on the same, default nice 0 level):
>
> 1) a single task runs almost all the time and sleeps about 1 msec every
>    100 msecs.
>
>    [ run "while N=3D1; do N=3D1; done &" under bash to create such a
>      workload. ]
>
> 2) tasks are in a 'ring' where each runs for 100 msec, sleeps for 1
>    msec and passes the 'token' around to the next task in the ring. (in
>    essence every task will sleep 9900 msecs before getting another run)
>
>    [ run http://redhat.com/~mingo/scheduler-patches/ring-test.c to
>      create this workload. If the 100 tasks default is too much for you
>      then you can run "./ring-test 10" - that will show similar effects.
>    ]
>
> Workload #1 uses 100% of CPU time. Workload #2 uses 99% of CPU time.
> They both do in essence the same thing.
>
> if RSDL had no heuristics at all then if i mixed #1 with #2, both
> workloads would get roughly 50%/50% of the CPU, right? (as happens if i
> mix #1 with #1 - both CPU-intense workloads get half of the CPU)

Isn't RSDL fair to each task? So each of the 101 tasks (1 and 2) gets an eq=
ual=20
share... That doesn't sound unfair to me. if the current scheduler manages =
to=20
give the single task 10 times more cpu to task one, that wouldn't be fair.=
=20
Unless you want to be fair to a single process, no matter how many threads.

> in reality, in the 'ring workload' case, RSDL will only give about _5%_
> of CPU time to the #1 CPU-intense task, and will give 95% of CPU time to
> the #2 'ring' of tasks. So the distribution of timeslices is
> significantly unfair!
>
> Why? Because RSDL still has heuristics, just elsewhere and more hidden:
> in the "straightforward CPU intense task" case RSDL will 'penalize' the
> task by depleting its quota for running nearly all the time, in the
> "ring of tasks" case the 100 tasks will each run near their priority
> maximum, fed by 'major epoch' events of RSDL, thus they get 'rewarded'
> for seemingly sleeping alot and spreading things out. So RSDL has
> fundamental unfairness built in as well - it's just different from the
> vanilla scheduler.

I don't see RSDL having heuristics here - it just gives each task an equal=
=20
share of CPU. The single task gets 1/101th of cpu, equal to all others...

> 	Ingo

I guess I just don't get it, would the current kernel give 50% cpu to the=20
single thread, and 0,5% to each of the 100 other threads?!? How would it do=
=20
that? Does it schedule a process with several threads equal to a process=20
having 1 thread, so each gets an equal share of cpu?

--nextPart3560359.k8W3YnNb3v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBF+9v7+wgQ1AD35iwRAuzyAJ9erzPX4S2Rvc0CP2gr4nfvNF7ENwCgruRH
MhZgkdalxsrpxJwcmM8EU1I=
=E/LZ
-----END PGP SIGNATURE-----

--nextPart3560359.k8W3YnNb3v--
