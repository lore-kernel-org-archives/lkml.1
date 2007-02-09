Return-Path: <linux-kernel-owner+w=401wt.eu-S1946436AbXBINLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946436AbXBINLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 08:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946437AbXBINLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 08:11:39 -0500
Received: from psmtp03.wxs.nl ([195.121.247.12]:48018 "EHLO psmtp03.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946436AbXBINLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 08:11:38 -0500
Date: Fri, 09 Feb 2007 14:13:03 +0100
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: [ck] Re: Swap prefetch merge plans
In-reply-to: <200702092321.20615.kernel@kolivas.org>
To: ck@vds.kolivas.org
Cc: Con Kolivas <kernel@kolivas.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Message-id: <200702091413.06949.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart3721857.1fhjQWpekj
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.5 + Features
References: <200702091038.37143.kernel@kolivas.org>
 <200702092054.10232.ocilent1@gmail.com> <200702092321.20615.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3721857.1fhjQWpekj
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> > > Hold.
> > Why hold?
>
> > It's been shown this patchset really helps desktop users.
>
> Has it?  I don't think I've ever observed any benefits from it and I don't
> think anyone has ever got down and worked out what its drawbacks might be,
> and seen if they can be demonstrated in practice.

Well, I'd say it's disadvantage is that you might use the buffered diskdata=
 in=20
memory (which will be replaced with application data from swap) when you co=
me=20
back using the computer. But it's far more likely you'll use the app data,=
=20
that's why swap prefetch helps. Anyway, I'm sure you got some response from=
=20
users who did like it. Now I know the desktop isn't the focus of the Linux=
=20
Kernel Developers, and you probably have much to hefty hardware to notice a=
ny=20
difference. Heck, after my upgrade to 3GB ram, I never noticed swap prefetc=
h=20
anymore...

But there ARE ppl using KDE or Gnome on a 256 MB ram system (or even less) =
and=20
they would notice this. I know I do on my 192-mb-ram laptop with Kubuntu...=
=20
It's lovely to do some compiling task, then while you work in vi swap=20
prefetch ensures everything is smooth when you try to continue browsing wit=
h=20
firefox...

> I also have vague memories of some serious-sounding review comments about
> the code from Nick.

Nick's comment, replying to me some time ago:

> > well, the reason i use it is my computer is much more reactive in the
> > morning. linux uses to get very slow after a night of not-doing-much
> > except some 'sleep 5h && blabla' and cron stuff. in the morning it takes
> > a few HOURS to get up and running smoothly. with swap prefetch, it
> > actually feels faster compared to a fresh boot. now you can force swap
> > prefetch to start working, i use it now and then after some heavy taskts
> > which pulled everything to swap.
>
> I have two issues with this argument (not that I'm trying to say it
> couldn't make a difference in your case).
>
> Firstly, swap prefetch actually doesn't handle the midnight updatedb
> pageout problem nicely. It doesn't do any prefetching when the
> pagecache/vfs cache fills memory (which is what would have to happen for
> updatedb to push stuff into swap).

But doesn't it prefetch stuff after updatedb has run and the computer is id=
le?=20
Updatedb here runs at night, and swap prefetch is supposed to get my app da=
ta=20
back in memory during the time after updatedb pushed it out, right? Maybe C=
on=20
can explain here...

> Secondly, with or without swap prefetch, I think we can do a better job of
> handling these use-once patterns to begin with.
well, i'd love to see you elaborate on this. I mean, if the kernel could be=
=20
made smarter and swap prefetch wouldn't be needed, great...

> > Why keep it in -mm for so long?
>
> I'm waiting to be shown that its benefits exceed its costs.  Sometimes
> that's hard.

Nobody has said anything about costs, indeed. Now afaik, swap prefetch is=20
designed to have no/as little as possible costs, so that makes sense. Does =
it=20
have to have some bugs, which have to be adressed, before it can enter? I'm=
=20
sure this can be arranged, right, Con?

Sorry if I sound sarcastic. I'm no hacker myself, and sometimes these=20
discussions don't make sense to me. A bit like the Staircase thingy ->

"hi, I've got this piece of code which does the same as that piece, but=20
better"
"Why didn't you improve the old code?"
"This is a better design -> half the code but doing a better job"
"Well, it's not tested as much, so it won't go in. Go away!"

There where those comments from Torvalds some time ago in an interview, abo=
ut=20
the kernel community becoming harder to get involved with. As an outsider, =
it=20
sure seems so. I read frustrations everywhere. What about the kevent guy, h=
is=20
blog: http://tservice.net.ru/~s0mbre/blog

I stumbled upon it when reading LWN. Seems pretty sad... I don't get the=20
technical stuff, but the frustration almost blows up your monitor. Is there=
=20
something fundamentally wrong with the kernel-hackers-culture, or are these=
=20
incidents?

grtz

Jos

=2D-=20
Disclaimer:

Alles wat ik doe denk en zeg is gebaseerd op het wereldbeeld wat ik nu heb.=
=20
Ik ben niet verantwoordelijk voor wijzigingen van de wereld, of het beeld w=
at=20
ik daarvan heb, noch voor de daaruit voortvloeiende gedragingen van mezelf.=
=20
Alles wat ik zeg is aardig bedoeld, tenzij expliciet vermeld.

--nextPart3721857.1fhjQWpekj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBFzHNi+wgQ1AD35iwRAhuJAJ9/wNjX/3p+eTB3qiuPZXyFE0dpvQCgkMR1
bWUw+dDzIBnOVbfK+oLkzLY=
=s9oR
-----END PGP SIGNATURE-----

--nextPart3721857.1fhjQWpekj--
