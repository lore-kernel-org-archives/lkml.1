Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbZIJVRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbZIJVRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 17:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbZIJVRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 17:17:41 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60719 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbZIJVRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 17:17:40 -0400
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nikos Chantziaras <realnc@arcor.de>, Mike Galbraith <efault@gmx.de>,
       Jens Axboe <jens.axboe@oracle.com>, Con Kolivas <kernel@kolivas.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Martin Steigerwald <Martin@lichtvoll.de>
Date: Thu, 10 Sep 2009 23:17:34 +0200
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6553077.vMGuPfo92V";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200909102317.41062.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6553077.vMGuPfo92V
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Uhoh, it seems I configured my kernel's scheduler to produce keyboard=20
failure. The many o's in my last mails where not intended.

Let's see whether its better with:

shambhala:/proc/sys/kernel> echo 2000000 >=20
/proc/sys/kernel/sched_wakeup_granularity_ns

=46irst time I just lost the keyboard in X for a while in such a way that=20
even a Strg-Alt-F1 did not yield any effect. None of what I typed appeared=
=20
anywhere, not in the mail composer window nor in a Konsole terminal or in=20
the Kickoff menu search field. Mouse still worked okay. I was able to log=20
out via mouse. Then even in KDM the keyboard did not work. Suddenly it=20
produced repeating key input events without me typing anything anymore.=20
Like the second time with those o's where I pressed on send instead of=20
save as draft accidentally.

I did not have any keyboard issues like this recently nor in the last year=
=20
or longer. Let's see whether that raised wakeup_granulaty helps. Desktop=20
experience seems still quite fluid, maybe not as fluid as with the settings=
=20
below. But I prefer a working keyboard in order to finish up this mail.

Am Donnerstag 10 September 2009 schrieb Ingo Molnar:
> * Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > Am Mittwoch 09 September 2009 schrieb Peter Zijlstra:
> > > On Wed, 2009-09-09 at 12:05 +0300, Nikos Chantziaras wrote:
> > > > Thank you for mentioning min_granularity.  After:
> > > >
> > > >    echo 10000000 > /proc/sys/kernel/sched_latency_ns
> > > >    echo 2000000 > /proc/sys/kernel/sched_min_granularity_ns
> > >
> > > You might also want to do:
> > >
> > >      echo 2000000 > /proc/sys/kernel/sched_wakeup_granularity_ns
> > >
> > > That affects when a newly woken task will preempt an already
> > > running task.
> >
> > Heh that scheduler thing again... and unfortunately Col appearing
> > to feel hurt while I am think that Ingo is honest on his offer on
> > collaboration...
> >
> > While it makes fun playing with that numbers and indeed
> > experiencing subjectively a more fluid deskopt how about just a
> >
> > echo "This is a f* desktop!" > /proc/sys/kernel/sched_workload
>=20
> No need to do that, that's supposed to be the default :-) The knobs
> are really just there to help us make it even more so - i.e. you
> dont need to tune them. But it really relies on people helping us
> out and tell us which combinations work best ...

Well currently I have:

shambhala:/proc/sys/kernel> grep "" sched_latency_ns=20
sched_min_granularity_ns sched_wakeup_granularity_ns
sched_latency_ns:100000
sched_min_granularity_ns:200000
sched_wakeup_granularity_ns:0

And this give me *a completely different* desktop experience.

I am using KDE 4.3.1 on a mixture of Debian Squeeze/Sid/Experimental, with=
=20
compositing. And now when I flip desktops or open a window I can *actually=
=20
see* the animation. Before I just saw two to five steps of the animation,=20
now its really a lot more fluid.=20

perceived _latency--! Well its like opening the eyes again cause I tended=20
to take the jerky behavior as normal and possibly related to having KDE=20
4.3.1 with compositing enabled on a ThinkPad T42 with=20


01:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV350=20
[Mobility Radeon 9600 M10] [1002:4e50]
(with OSS Radeon driver)

which I consider to be low end for that workload. But then why actually?=20
Next to me is a Sam440ep with PPC 440 667 MHz and and even older Radeon M9=
=20
with AmigaOS 4.1 and some simple transparency effects with compositing. And=
=20
well this combo does feel like it wheel spins cause the hardware is=20
actually to fast [2nd keyboard borkage, somewhere before where the first=20
where I saved as draft] for that operating system. So actually I knew=20
there could be less waiting and less latency. (Granted AmigaOS 4.1 is much=
=20
more minimalistic also in terms on features and no complete memory=20
protection and message passing by exchanging pointers and whatnot).

At least to summarize this: With those settings I just keep switching=20
desktops and opening windows to enjoy the effects. Desktops flip over=20
fluently and windows zoom in on opening fluently either.

All those experiences are with:

shambhala:~> cat /proc/version
Linux version 2.6.31-rc7-tp42-toi-3.0.1-04741-g57e61c0 (martin@shambhala)=20
(gcc version 4.3.3 (Debian 4.3.3-10) ) #6 PREEMPT Sun Aug 23 10:51:32 CEST=
=20
2009

(Nigel Cunningham's tuxonice-head git from about 10 days ago)

Keyboard still working. Possibly it really has got broken with zero as=20
wakeup granularity.

> > Or to say it in other words: The Linux kernel should not require
> > me to fine-tune three or more values to have the scheduler act in
> > a way that matches my workload.
> >
> > I am willing to test stuff on my work thinkpad and my Amarok
> > thinkpad in order to help improving with that.
>=20
> It would be great if you could check latest -tip:
>=20
>   http://people.redhat.com/mingo/tip.git/README
>=20
> and compare it to vanilla .31?
>=20
> Also, could you outline the interactivity problems/complaints you
> have?

Hmmm, would there be a simple possibilty to somehow merge tuxonice git and=
=20
your tip.git into a nice TuxOnIce + scheduler enhanced kernel? I do tend=20
not to stick with non TuxOnIce enabled kernels for too long. At least not=20
on my work thinkpad and my Amarok thinkpad cause I believe that reboots=20
are just for kernel upgrades (with API changes that is) ;-).

Apart from that I lack time to compile a kernel a day at the moment like=20
in good old RSDL, SD and CFS testing times ;-). But next kernel, 2.6.31-
not-a-rc, is due and I take suggestions for that one. Preferably I would=20
like to have it with TuxOnIce tough.

Problems I faced:

1) Well those effect issues. Jerky at best. Animations which should have=20
had 25 frames per second at least, showed 2-5 frames a second. Above=20
tuning helped a lot with that. On the other hand DVD playback with Dragon=20
Player (and Xine) seems just fine - I thought at least. Maybe I should=20
compare watching StarTrek NG with and without scheduler latency fixes. And=
=20
maybe I find some additional frames per duration there too.

2) Some jerks here and there. Difficult to categorize. It sometimes just=20
happens that the machine does not follow where I put my attention. Like a=20
distracted human who has other things to do than listening to me. This=20
could be trying to enter some text in a Qt text input widget. But I need=20
to look more carefully as to when, where and why. This is just too fuzzy.

3) Sometimes even typing as a visible latency. Its difficult to spot the=20
cause for that stuff. When I type I expect to see each letter as I type it.

4) I/O latencies causing the machine to actually stall for seconds. But=20
this one got much better when I switched to 2.6.31 - I had to skip 2.6.30=20
cause it didn't tuxonice nicely, even 2.6.31 did not until it reached rc5.=
=20
It seems even way better after switching from XFS to Ext4. But well that=20
is a different issue. And at the moment I am quite happy with that.

5) Some window manager operations like resizing windows take very long=20
with compositing. But I think this issue may lie elsewhere. Cause these=20
did not improve with above settings while many compositing effects did. I=20
dunno where that slow window resizing comes from. Whether its a=20
compositing / KWin / Qt refresh issue or something scheduler or something=20
gfx driver related.

Keyboard is still working, yay! So the X.org keyboard driver might get=20
irritated with zero as wakeup granularity.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart6553077.vMGuPfo92V
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqpbO4ACgkQmRvqrKWZhMek9gCfWnoktZ7gGmTSSSrxnQC7edgW
Sd8AnjfzbqEZCt8tWB5jiMOVuerFk+Hl
=efKA
-----END PGP SIGNATURE-----

--nextPart6553077.vMGuPfo92V--
