Return-Path: <linux-kernel-owner+w=401wt.eu-S1031208AbXDZMUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031208AbXDZMUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 08:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031209AbXDZMUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 08:20:22 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:57222 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031208AbXDZMUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 08:20:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
        b=dJVbidqEOEOr8dBgeuw+K3eWLwH6HtGYcBhNhqV+DCbG65HWa6P03pes9tOW5q0o31eHwSWgjTObXQuTQZmmCUS9UYXa9gDqjjkWtZ9tNxP7Mx+RwdEoEZAdt6zu6uyhO24/QsbXCcNCsCaYDMKgThqHPDOksXtox9POb51b808=
Date: Thu, 26 Apr 2007 05:19:53 -0700
From: Mike Mattie <codermattie@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: recomended way to check longest period that interupts are
 disabled ?
Message-ID: <20070426051953.26582bbb@reforged>
In-Reply-To: <1177585912.6815.6.camel@twins>
References: <20070426021350.29ddfa0a@reforged>
	<1177581237.26937.105.camel@twins>
	<20070426040252.3f4fa8cc@reforged>
	<1177585912.6815.6.camel@twins>
X-Mailer: Claws Mail 2.6.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_.Bor+uTwm/b=pwmx4l0P2ES";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_.Bor+uTwm/b=pwmx4l0P2ES
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Apr 2007 13:11:52 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2007-04-26 at 04:02 -0700, Mike Mattie wrote:
> > On Thu, 26 Apr 2007 11:53:57 +0200
> > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >=20
> > > On Thu, 2007-04-26 at 02:13 -0700, Mike Mattie wrote:
> > > > Hello,
> > > >=20
> > > > I am still struggling to track down problems with audio
> > > > playback. I get intermittent:
> > > >=20
> > > > Apr 26 02:01:40 reforged [13230.947879] cannot submit sync urb
> > > > (err =3D -45)
> > > >=20
> > > > I have tackled the scheduler issues to where I really don't
> > > > think the driver is being starved at all. I am running
> > > > audacious like so:
> > > >=20
> > > > schedtool -R -p 50 -n 1 -e audacious
> > > >=20
> > > > At this point the strongest correlation I can get is that
> > > > starting programs seems to trigger the stutter. I have
> > > > suspected IO for some time.
> > > >=20
> > > > My system image , / & /usr are on a libata (VIA PATA) driver.
> > > > I have disabled the write-cache , but I also have noatime set
> > > > on mount, for /usr
> > > >=20
> > > > My big suspicion is that one of my drivers, likely IO is
> > > > disabling interrupts for too long.
> > > >=20
> > > > I have looked but not found a tool for measuring the longest
> > > > period interrupts are disabled and pointing the finger at
> > > > the culprit, could anyone on this list recommend tools that
> > > > might help me pinpoint what is going on ?
> > > >=20
> > > > I would also be delighted for any sort of recommended latency
> > > > testing tools.
> > > >=20
> > > > pin-pointing this is going to be a "learning experience" but
> > > > every time I think I am about to have a bonding moment with=20
> > > > the kernel audio skips; I am highly motivated.
> > >=20
> > > The -rt kernel contains a full latency tracer.
> > >=20
> > > http://people.redhat.com/mingo/realtime-preempt/
> >=20
> > Thanks for the response. That is very helpful. I had
> > looked at it briefly before but at a glance it looked
> > like building a pro-audio workstation, which was a bit
> > over the top for me. At a closer examination most of the
> > stuff in -rt looks generally useful.
> >=20
> > > Some hardware just isn't up to the job though...
> >=20
> > I don't quite understand this. I have a athlon XP 3000+
> > and an audigy NX. Even using the libsamplerate library
> > audacious + alsa only uses 12% of the processor tops.
> >=20
>=20
> Some (broken) hardware, like some VIA IDE controllers just take
> forever to do their thing. In which case you're stuck with it. Not
> all x86 hardware is build to equal standards :-(
>=20
> quite honestly, x86 hardware is a mess.

No disagreement there. It's really hard to pick good
hardware other than remembering the odd kernel hacker
comments , or grepping for expletives in the source
and piping through wc :)

> >=20
> > my next step is to go out and buy a usb card so I can
> > see if I can get the audigy NX on it's own interrupt.
>=20
> I'd try to pinpoint the latency first, might safe on expenses.

definitely.

> > from a look at -RT I need to do this before I can use
> > the fun stuff like interrupt prioritization.
> >=20
> > Maybe a naive question but with the HIRES_TIMERS
> > stuff merged, can the stats/diagnostics now merge
> > into the mainline , or be broken out as a seperate patch ?=20
>=20
> Not sure, it might be. Ingo does all that.
>=20
> > I would really like to see what exactly the mainline is doing ,=20
> > especially so I can come up with a answer for what exactly is
> > wrong with the current system. I would like to change
> > my system knowing what the change is , rather than
> > saying "-rt works but I don't know why".
>=20
> If its a hardware latency, -rt will suffer equally. Either way,
> running -rt will teach you something. Either its mainline borkage, or
> hardware.
>=20
> > One thought I had is that I could use the -rt patches
> > as a starting place for some SystemTap probes. Looking
> > down the road that seems to be the most durable option.
>=20
> Might be, although do remember that traps cost too. But I'm not really
> familiar with all of this.
>=20

Thanks for the comments. After running cyclictest it definitely looks
like the average jitter is really low, around 7-8 . The max is really
high , >100

If I am interpreting this correctly for the most part the jitter is
pretty low, but something horrible is happening that blows up the
max value.

./cyclictest -p 30 -t 6
2.00 1.84 1.41 3/120 13760

T: 0 (13130) P:30 I:1000 C:  42763 Min:      4 Act:   10 Avg:    8 Max:    =
 133
T: 1 (13131) P:29 I:1500 C:  28509 Min:      4 Act:    6 Avg:    7 Max:    =
 114
T: 2 (13132) P:28 I:2000 C:  21382 Min:      4 Act:    7 Avg:    6 Max:    =
 157
T: 3 (13133) P:27 I:2500 C:  17106 Min:      4 Act:   11 Avg:    7 Max:    =
 110
T: 4 (13134) P:26 I:3000 C:  14255 Min:      4 Act:    8 Avg:    7 Max:    =
1011
T: 5 (13135) P:25 I:3500 C:  12218 Min:      4 Act:   12 Avg:    8 Max:    =
 118


Cheers,
Mike Mattie

--Sig_.Bor+uTwm/b=pwmx4l0P2ES
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGMJj4dfRchrkBInkRAhD5AKDsghM1oye+5ucOibcoDgzEC4o3xACg0rtJ
JFlgPXkZ9T0O9uhD3//JV+g=
=tJGM
-----END PGP SIGNATURE-----

--Sig_.Bor+uTwm/b=pwmx4l0P2ES--
