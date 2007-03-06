Return-Path: <linux-kernel-owner+w=401wt.eu-S1030306AbXCFTCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030306AbXCFTCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030323AbXCFTCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:02:13 -0500
Received: from psmtp02.wxs.nl ([195.121.247.11]:62907 "EHLO psmtp02.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030306AbXCFTCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:02:10 -0500
Date: Tue, 06 Mar 2007 20:04:42 +0100
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free   interactive cpu
 scheduler
In-reply-to: <20070306044112.GA10707@1wt.eu>
To: Willy Tarreau <w@1wt.eu>
Cc: Con Kolivas <kernel@kolivas.org>, Bill Davidsen <davidsen@tmr.com>,
       ck@vds.kolivas.org, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org
Message-id: <200703062004.46050.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart1535898.Ep622qelu3
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.5 + Features
References: <200703041800.53360.kernel@kolivas.org>
 <200703061118.44616.kernel@kolivas.org> <20070306044112.GA10707@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1535898.Ep622qelu3
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Op Tuesday 06 March 2007, schreef Willy Tarreau:
> In a way, I think they are right. Let me explain. Pluggable schedulers are
> useful when you want to switch away from the default one. This is very
> useful during development of a new scheduler, as well as when you're not
> satisfied with the default scheduler. Having this feature will incitate
> many people to develop their own scheduler for their very specific
> workload, and nothing generic. It's a bit what happened after all : you,
> Peter, Nick, and Mike have worked a lot trying to provide alternative
> solutions.

Did that happen for I/O? There are a few schedulers, eg some for servers,=20
other more for desktop or throughput. But not 10 or something...

> But when you think about it, there are other OSes which have only one
> scheduler and which behave very well with tens of thousands of tasks and
> scale very well with lots of CPUs (eg: solaris). So there is a real
> challenge here to try to provide something at least as good and universal
> because we know that it can exist. And this is what you finally did : work
> on a scheduler which ought to be good with any workload.

I can imagine a desktop can work optimally with another scheduler than a ti=
ny=20
embedded OS in a phone or an 8-core system serving a website, or a=20
distributed 512 core system doing heavy scientific calculations?!?

Optimizing for all at the same time involves some compromises, and thus lim=
its=20
performance on certain scenario's, right?

> Then, when we have a generic, good enough scheduler for most situations, I
> think that it could be good to get the plugsched for very specific usages.
> People working in HPC may prefer to allocate ressource differently for
> instance. There may also be people refusing to mix tasks from different
> users on two different siblings of one CPU for security reasons, etc... A=
ll
> those would justify a plugable scheduler. But it should not be an excuse =
to
> provide a set of bad schedulers and no good one.

CFQ does pretty well at most workloads, that's why it's default, right? But=
=20
there is choice, which is a good thing. And the current mainline CPU=20
scheduler isn't bad at all, so having 'no good one' won't happen anyway.

> The CPU scheduler is often compared to the I/O schedulers while in fact
> this is a completely different story. The I/O schedulers are needed becau=
se
> the hardware and filesystems may lead to very different behaviours, and t=
he
> workload may vary a lot (eg: news server, ftp server, cache, desktop, real
> time streaming, ...). But at least, the default I/O scheduler was good
> enough for most usages, and alternative ones are here to provide optimal
> solutions to specific needs.

Ok, for I/O, the diff could be pretty big. But still, there are workloads=20
which could be improved by a certain scheduler, right?

And wouldn't it make sense then to have a choice in the default kernel at=20
boottime? If that wouldn't hurt performance, it would be an improvement for=
=20
desktop distributions like (K)ubuntu who can set staircase by default, and=
=20
server distro's offering RSDL...

At least having a desktop/interactivity optimized scheduler like staircase =
and=20
a fair, throughput-optimized scheduler like RSDL sounds sane. RSDL does=20
better at the msql testcase, staircase is better on the desktop... We're no=
t=20
talking about huge amounts of code, or 10 schedulers, and the diff of a few=
=20
percent and better scaling on many cpu's and processes versus better=20
interactivity on the desktop sounds like it's worth it.

> Regards,
> Willy

--nextPart1535898.Ep622qelu3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBF7btO+wgQ1AD35iwRAnQuAJ4xNPOCMRYuM/OJr22nuEaIiUnXHgCgtMwl
PhtAtzTRGqdT/0mm8QTjIQw=
=NH76
-----END PGP SIGNATURE-----

--nextPart1535898.Ep622qelu3--
