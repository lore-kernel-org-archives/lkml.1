Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbXLCKPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbXLCKPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 05:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbXLCKPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 05:15:40 -0500
Received: from chello089077114002.chello.pl ([89.77.114.2]:32800 "EHLO
	astralstorm.puszkin.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbXLCKPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 05:15:39 -0500
Date: Mon, 3 Dec 2007 11:15:20 +0100
From: Radoslaw Szkodzinski (AstralStorm) <lkml@astralstorm.puszkin.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203111520.33ed2139@astralstorm.puszkin.org>
In-Reply-To: <20071203095501.GB28560@one.firstfloor.org>
References: <20071201092037.GA32544@elte.hu>
	<p737ijwylet.fsf@bingen.suse.de>
	<20071202185945.GA25990@elte.hu>
	<20071202114152.3bf4332d@laptopd505.fenrus.org>
	<20071202200953.GA23994@one.firstfloor.org>
	<20071202202602.GA16480@elte.hu>
	<20071202204725.GA25891@one.firstfloor.org>
	<20071202144331.6abf1289@laptopd505.fenrus.org>
	<20071203000741.GB26636@one.firstfloor.org>
	<20071202165913.3eaebee6@laptopd505.fenrus.org>
	<20071203095501.GB28560@one.firstfloor.org>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4Jt+VUVLhtZR6gKDmRydhyK";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/4Jt+VUVLhtZR6gKDmRydhyK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Dec 2007 10:55:01 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> On Sun, Dec 02, 2007 at 04:59:13PM -0800, Arjan van de Ven wrote:
> > On Mon, 3 Dec 2007 01:07:41 +0100
> > Andi Kleen <andi@firstfloor.org> wrote:
> >=20
> > > This patch will likely work against that by breaking error paths.
> >=20
> > it won't break error paths, it will at most put a warning in the log.
> > It doesn't kill or otherwise damage the system or process.
>=20
> From the user perspective a kernel randomly throwing backtraces is=20
> a broken kernel.=20

Throwing in my 2c:
Kernel waiting 2 minutes on TASK_UNINTERRUPTIBLE is certainly broken.
I wouldn't wait that long for the system to become responsive, I yanked
the power cord already.

Hm, that's already detected with sleep_uninterruptible logic.

A task that's not killable for more than 2 minutes is broken still, but
less so.

> > > > This patch is a step in the right direction there, by quite a
> > > > lot.
> > > >=20
> > > > I really don't understand what your objection is to this patch...
> > > > is it that an enterprise distro can't ship with it on? (Which is
> > > > fine btw)
> > >=20
> > > Any distribution aimed at end users cannot ship with it on.=20
> >=20
> > That's a pretty bold statement; assuming that the TASK_KILLABLE patch
> > is in, I don't see the problem.
>=20
> iirc TASK_KILLABLE fixed NFS only. While that's a good thing there are
> unfortunately a lot more subsystems that would need the same treatment.

Yes, that's exactly why the patch is needed - to find the bugs and fix
them. Otherwise you'll have problems finding some places to convert to
TASK_KILLABLE.

CIFS and similar have to be fixed - it tends to lock the app
using it, in unkillable state.

> > > Also in general I have my doubts that the false positive:real bug
> > > ratio of this warning is well balanced.
> >=20
> > I'll just have to disagree with you then; but both of us are making
> > wild guesses. Only one way to get the real false positive percentage.
>=20
> Yes let's break things first instead of looking at the implications close=
ly.

Throwing _rare_ stack traces is not breakage. 120s task_uninterruptible
in the usual case (no errors) is already broken - there are no sane
loads that can invoke that IMO.

A stack trace on x subsystem error is not that bad, especially as these=20
are limited to 10 per session.=20

Disclaimer: I am not a kernel developer, just a user.

--Sig_/4Jt+VUVLhtZR6gKDmRydhyK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHU9c/BlhXA0ALOYMRAl6oAKCofBLZijEMORvfAJvD52GSAW5eKQCeMwNT
Ztv5vIAfCXYGaOwZVV56By4=
=ZnRu
-----END PGP SIGNATURE-----

--Sig_/4Jt+VUVLhtZR6gKDmRydhyK--
