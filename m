Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443AbXEYDBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbXEYDBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 23:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbXEYDAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 23:00:54 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:55940 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbXEYDAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 23:00:53 -0400
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org>
References: <1179870110.16656.2.camel@localhost>
	 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
	 <1180008394.15600.26.camel@localhost>
	 <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
	 <20070524200435.GA9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
	 <20070524220017.GC9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
	 <20070524221743.GD9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
	 <20070524231852.GG9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
	 <1180058123.3997.91.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org>
	 <1180059605.3997.100.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Xa/Wqm/bvniMqISkyWMM"
Date: Fri, 25 May 2007 13:00:40 +1000
Message-Id: <1180062040.3997.112.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Xa/Wqm/bvniMqISkyWMM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-05-24 at 19:41 -0700, Linus Torvalds wrote:
>=20
> On Fri, 25 May 2007, Nigel Cunningham wrote:
> >=20
> > To answer the question, I guess the answer is that although they're
> > different creatures, they have similarities. This is one of them, which
> > is why I could make the mistake I did. Nothing in the issue being
> > discussed was unique to suspend-to-ram. Perhaps we (or at least I) focu=
s
> > too much on the similarities, but that doesn't mean they're not there.
>=20
> I agree that the current bug is not unique to STR. In fact, I think Roman=
o=20
> tested both STD and STR, and both had the same bug with the 60s timeout.
>=20
> But what irritates me is that STR really shouldn't have _had_ that bug at=
=20
> all. The only reason STR had the same bug as STD was exactly the fact tha=
t=20
> the two features are too closely inter-twined in the kernel.=20
>=20
> That irritates me hugely. We had a bug we should never had had! We had a=20
> bug because people are sharing code that shouldn't be shared! We had a bu=
g=20
> because of code that makes no sense in the first place!
>=20
> I agree that disk snapshotting is much harder. If we had a bug just in=20
> that part, I wouldn't mind it so much. Getting hard problems wrong isn't=20
> something you should be ashamed of. What I mind is that the _easier_=20
> problem got infected by all the bugs from the _harder_ issue. That just=20
> makes me really really angry and frustrated.
>=20
> Look at it this way: if you designed a CPU, and you made the integer=20
> code-path share everything with the floating point side, because "additio=
n=20
> is addition", and as a result the latency for the simple arithmetic and=20
> logical ops in integer ALU was four cycles, what would you be?
>=20
> You'd be a moron, that's what.=20
>=20
> And that is _exactly_ what the current STD/STR code does. It says "suspen=
d=20
> is suspend" and tries to share the same pipeline, even though the two=20
> operations are totally different, and share nothing but the name people=20
> use for it (and even the name is really pretty weak, and I've tried to=20
> get people to use some other name for STD).

I think I get what you're trying to say, but I also think you're either
overstating your case ("...totally different and share nothing but the
name...") or underestimating the similiarity - they both need (albeit
for different reasons) to do the cpu hotplugging, driver suspending
(yeah, there are similarities and differences there) and irq disabling.
That's _some_ similarity. Apart from that, yeah - they are totally
different.

Re the name, we discussed changing the name of Suspend2 on IRC a night
or two ago. We came to the conclusion that, for better or for worse,
it's too well known now. I can see your logic in wanting to
differentiate them, but I seem to be a bit stuck :\. Push some more.
Maybe we'll get there anyway :) Maybe you can get rid of that horrible,
unpronounceable 'swsusp' name while you're at it? :)

> So yes,the two things _do_ share the problem, but they really really=20
> shouldn't. There's no reason to think that they should. And it drives me=20
> absolutely bonkers that people seem to have such a hard time seeing that.
>=20
> That said, I think freezing is crap even for snapshotting/suspend-to-disk=
,=20
> but the point of the above rant is to show how insane it is to think that=
=20
> problems and complexity in one area should translate into problems and=20
> complexity in another area.

Does that imply that you'd prefer to see filesystem checkpointing code,
that you think freezing can be done better, or do you have some other
solution that hasn't occurred to me?

> And if the snapshot people want to screw up their snapshots with freezing=
,=20
> I don't actually care that much. I'd much rather have working STR. As it=20
> is now, they're now _both_ broken.

Fair enough :).

Nigel

--=-Xa/Wqm/bvniMqISkyWMM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGVlFYN0y+n1M3mo0RAmKIAJ9KqQv260S2mZqXO91c/qePquW/YQCbBqAH
cO7JM6BBOJ9jL6qCuvyTShg=
=Ena1
-----END PGP SIGNATURE-----

--=-Xa/Wqm/bvniMqISkyWMM--

