Return-Path: <linux-kernel-owner+w=401wt.eu-S1763939AbXJETlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763939AbXJETlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759784AbXJETk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:40:56 -0400
Received: from smtp2.netcabo.pt ([212.113.174.29]:22142 "EHLO
	exch01smtp09.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759298AbXJETky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:40:54 -0400
X-Greylist: delayed 679 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Oct 2007 15:40:54 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtajAJYtBkdViow7PGdsb2JhbACBWYxWAQEBAR0Y
Date: Fri, 5 Oct 2007 20:29:31 +0100
From: Luciano Rocha <strange@nsk.no-ip.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: can't change euid 0 to uid != running user
Message-ID: <20071005192931.GB12135@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <strange@nsk.no-ip.org>,
	Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org
References: <20071005142541.GA9224@bit.office.eurotux.com> <2c0942db0710050828jcb161c0qc10e65f7f65af6c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
In-Reply-To: <2c0942db0710050828jcb161c0qc10e65f7f65af6c4@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-OriginalArrivalTime: 05 Oct 2007 19:29:33.0716 (UTC) FILETIME=[0EE80D40:01C80786]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 05, 2007 at 08:28:50AM -0700, Ray Lee wrote:
> On 10/5/07, Luciano Rocha <strange@nsk.no-ip.org> wrote:
> > I have the following problem:
> > $ sudo -u ie -s # or sudo su ie
> > unable to change to runas uid: Resource temporarily unavailable
> >
> > Works:
> > $ sudo su, followed by su ie
> >
> > The first sudo also worked while I had a shell under user ie.
> >
> > When I exited, it stopped working, but it is now working every time I
> > trie it.
> >
> > dmesg shows:
> >
> > [82602.729330] kobject_add failed for 504 with -EEXIST, don't try to
> >                register things with the same name in the same directory.
> > [82602.729365]  [<c04b9195>] kobject_shadow_add+0x16e/0x1a0
> > [82602.729383]  [<c04b9480>] kobject_set_name+0x29/0x92
> > [82602.729504]  [<c04238ea>] user_kobject_create+0x6a/0x90
> > [82602.729520]  [<c0423cce>] alloc_uid+0x18f/0x1d7
> > [82602.729530]  [<c0427030>] set_user+0x1c/0x8f
> > [82602.729539]  [<c0428b5f>] sys_setresuid+0xd5/0x162
> > [82602.729552]  [<c0403e6a>] syscall_call+0x7/0xb
> > [82602.729575]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >
> > $ git describe
> > v2.6.23-rc9-156-ga95dacb
> >
> > (Clone of Linus' tree, after rc9, with some patches from
> > mingo/linux-2.6-sched-devel.git, and a fix for lguest (didn't link due
> > to kasprintf)).
>=20
> Hmm, it works for me under 2.6.23-rc6, so it's either a difference
> between our .configs or a late regression. If you could bisect the
> problem (starting with reverting Ingo's sched devel patches and lguest
> patches, and trying that), then that would tell us where the issue is.

I'll try a clean Linus' tree tomorrow and see if I can reproduce the
problem.

--=20
lfr
0/0

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHBpCbinSul6a7oB8RApQXAJ4l3qOfgRUeNED+d4J3K1KHBc2flQCdGR59
sYHfASpTDd9CU/uLed21Kuk=
=YiAP
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
