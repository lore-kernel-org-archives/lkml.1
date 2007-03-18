Return-Path: <linux-kernel-owner+w=401wt.eu-S932267AbXCRKr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbXCRKr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 06:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbXCRKr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 06:47:27 -0400
Received: from smtp15.wxs.nl ([195.121.247.6]:55291 "EHLO smtp15.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267AbXCRKr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 06:47:26 -0400
Date: Sun, 18 Mar 2007 11:50:36 +0100
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: [ck] Re: [ANNOUNCE] RSDL completely fair starvation free
 interactive cpu scheduler
In-reply-to: <200703122352.51257.kernel@kolivas.org>
To: ck@vds.kolivas.org
Cc: Con Kolivas <kernel@kolivas.org>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org
Message-id: <200703181150.40059.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart1202439.q3B4AlMpBk
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.6
References: <200703042335.26785.a1426z@gawab.com>
 <200703121426.00854.a1426z@gawab.com> <200703122352.51257.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1202439.q3B4AlMpBk
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Op Sunday 18 March 2007, schreef Con Kolivas:
> On Monday 12 March 2007 22:26, Al Boldi wrote:
> > Con Kolivas wrote:
> > > On Monday 12 March 2007 15:42, Al Boldi wrote:
> > > > Con Kolivas wrote:
> > > > > On Monday 12 March 2007 08:52, Con Kolivas wrote:
> > > > > > And thank you! I think I know what's going on now. I think each
> > > > > > rotation is followed by another rotation before the higher
> > > > > > priority task is getting a look in in schedule() to even get
> > > > > > quota and add it to the runqueue quota. I'll try a simple change
> > > > > > to see if that helps. Patch coming up shortly.
> > > > >
> > > > > Can you try the following patch and see if it helps. There's also
> > > > > one minor preemption logic fix in there that I'm planning on
> > > > > including. Thanks!
> > > >
> > > > Applied on top of v0.28 mainline, and there is no difference.
> > > >
> > > > What's it look like on your machine?
> > >
> > > The higher priority one always get 6-7ms whereas the lower priority o=
ne
> > > runs 6-7ms and then one larger perfectly bound expiration amount.
> > > Basically exactly as I'd expect. The higher priority task gets
> > > precisely RR_INTERVAL maximum latency whereas the lower priority task
> > > gets RR_INTERVAL min and full expiration (according to the virtual
> > > deadline) as a maximum. That's exactly how I intend it to work. Yes I
> > > realise that the max latency ends up being longer intermittently on t=
he
> > > niced task but that's -in my opinion- perfectly fine as a compromise =
to
> > > ensure the nice 0 one always gets low latency.
> >
> > I think, it should be possible to spread this max expiration latency
> > across the rotation, should it not?
>
> There is a way that I toyed with of creating maps of slots to use for each
> different priority, but it broke the O(1) nature of the virtual deadline
> management. Minimising algorithmic complexity seemed more important to
> maintain than getting slightly better latency spreads for niced tasks. It
> also appeared to be less cache friendly in design. I could certainly try
> and implement it but how much importance are we to place on latency of
> niced tasks? Are you aware of any usage scenario where latency sensitive
> tasks are ever significantly niced in the real world?

I do always nice down heavy games, it makes them more smooth...

=2D-=20
Disclaimer:

Alles wat ik doe denk en zeg is gebaseerd op het wereldbeeld wat ik nu heb.=
=20
Ik ben niet verantwoordelijk voor wijzigingen van de wereld, of het beeld w=
at=20
ik daarvan heb, noch voor de daaruit voortvloeiende gedragingen van mezelf.=
=20
Alles wat ik zeg is aardig bedoeld, tenzij expliciet vermeld.

--nextPart1202439.q3B4AlMpBk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBF/Rl8+wgQ1AD35iwRAsPLAKDUZdEvS5AIie3yTRCwatqGfiKqhQCgt3KY
iqTtD9f2JEfQgiTynaD4ytQ=
=FRzi
-----END PGP SIGNATURE-----

--nextPart1202439.q3B4AlMpBk--
