Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbXFLQxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbXFLQxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 12:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbXFLQxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 12:53:05 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:1584 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbXFLQxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 12:53:03 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: ck@vds.kolivas.org
Subject: Re: call for more SD versus CFS comparisons (was: Re: [ck] Mainline plans)
Date: Tue, 12 Jun 2007 18:52:51 +0200
User-Agent: KMail/1.9.7
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <466DE921.9030709@debianpt.org> (sfid-20070612_171838_254605_20164719)
In-Reply-To: <466DE921.9030709@debianpt.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1304084.aiDCFZYDjH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706121852.58161.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1304084.aiDCFZYDjH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Dienstag 12 Juni 2007 schrieb Miguel Figueiredo:
> Hi all,
>
> some results based on massing_intr.c by Satoru, can be found on
> http://people.redhat.com/mingo/cfs-scheduler/tools/massive_intr.c

Hi Miquel, Ingo, Con!

I have been a week without internet access. I have been testing 2.6.21.3 +=
=20
sws2 2.2.10 and cfs-v15 and ck2 on both my T42 and my Amarok machine T23=20
[1].

=46rom subjective feedback I can't tell a difference anymore. But I usually=
=20
do not play 3D games or use Beryl / Compiz (except for showing it off).

I did not yet test with disabled NEED_RESCHED CFS workaround as Ingo asked=
=20
my in private mail. This is a work-around to fix the audio skipping=20
problems on my Amarok machine. I will compile a CFS v16 and test with=20
this work-around disabled.

I had one issue with CFS v15 at least, but its not easy to reproduce. I=20
usually test Amarok playback while kernel package make (kernel compile),=20
opening a lot of KDE apps (Konqueror mainly) and moving the Amarok window=20
like mad. After it I close the windows of that KDE apps again. For=20
Konqueror I can use the menu entry "Close all instances" since I have 20+=20
of them open. When I do this, all windows will be closed and I=20
occassionally get some audio skips there. AFAIR it didn't happen with SD=20
there on my tests with it.

One issue on SD I had was some audio skips *directly* after resume (with=20
suspend2). I did not see these with CFS-v15.

Both are issues that are not easy to trackdown, test reproducably for me.

I am willing to run other tests on my Amarok machine. Since I can't tell a=
=20
subjective difference anymore this likely involved running some=20
benchmarks. Test would be whether sound playback is 100% OK during=20
running that benchmark.

To make it comparative it would be nice if a certain test producedure is=20
done on several machines by several people. What would be good test=20
scenarios?=20

I am interested in desktop loads, and would like stuff like this:

1) Generating high load on the X server.

2) Starting loads of applications and stopping them again quickly. Maybe=20
its possible to simulate my manually starting KDE apps by clicking around=20
in the startbar wildly and stopping them again (to track this CFS issue).

3) Starting one or more computational expensive tasks like kernel=20
compiles.

4) Putting load onto the VM layer / block layer. I am not sure about this.=
=20
We are testing CPU schedulers, not IO schedulers, but different VM=20
scenarious are still important IMHO.

These are specially interesting IMHO when being combined. I tried to=20
simulate this with my manual point and click testings. (Kernel compile +=20
starting apps + moving Amarok window like mad.)

My main concerns during those tests are:

1) Is audio playback 100% okay? Instead of only hearing whether there are=20
glitches there possible is a way to *measure* them? Could be extended to=20
video playback tough I would expect glitches at a certain load... (well=20
at some point eventually audio play back will stop too)

2) Is the mouse pointer always respsonsive? (When there is something I do=20
not like it is a frozen mouse pointer as I had a lot with earlier CFS=20
versions previous to above workaround). Maybe this can be measured too?=20

Is that the massive_intr testing?

3) How is interactivity? How long does it take till an applications react=20
to a mouse click... but then how on earth do you measure this?

I guess there are other important criterias to have a look - especially=20
also the behavior on a server for example - how does the scheduler behave=20
on a webserver with many clients issuing differently sized requests?

Any suggestions?

Now what would be a testing procedure that is affordable for testers and=20
as relevant to scheduler testing as it could be? My problem with using=20
benchmarks is that I first have to spent lots of time to figure out how=20
they work and how to produce a reasonable setup. If someone - preferably=20
Linux kernel scheduler experts - invent a testing procedure I could=20
follow step by step and then post the results it would be easier for me=20
to collect some useful informations for you Kernel developers.

Without any more extensive testing aside from above mentioned difficult to=
=20
reproduce artifacts in my subjective perception SD (as in 2.6.21-ck2) and=20
CFS-v15 are on par now. So based on that other criteria - code size,=20
design criteria, maintainership, responding to bug reports, further=20
benchmarks and real world usage tests - would need to be used to decide=20
which scheduler should go into the kernel.=20

As I read several times SD is smaller regarding to code size. OTOH to me=20
it seems that Ingo Molnar has more time and ability to support=20
maintainership, but still to what I have seen Con did his best here too=20
and fixed all known issues with SD.

[1] http://martin-steigerwald.de/amarok-machine/

Regards,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1304084.aiDCFZYDjH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGbs9qmRvqrKWZhMcRAn/GAJ92RRBvz1Tf+qmpkFqtkZ3/7/01jQCfbuMi
H3n+/lcM7PCHbZywQhr6E4w=
=os8z
-----END PGP SIGNATURE-----

--nextPart1304084.aiDCFZYDjH--
