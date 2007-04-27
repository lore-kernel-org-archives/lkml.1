Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbXD0P12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbXD0P12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbXD0P12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:27:28 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:59228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbXD0P11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:27:27 -0400
Subject: Re: [linux-pm] driver power operations (was Re: suspend2 merge)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Nick Piggin <npiggin@suse.de>,
       Ingo Molnar <mingo@elte.hu>, suspend2-devel@lists.suspend2.net,
       Mike Galbraith <efault@gmx.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Adrian Bunk <bunk@stusta.de>,
       Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <200704271720.08150.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0704271008540.3430-100000@iolanthe.rowland.org>
	 <1177684764.3565.20.camel@johannes.berg>
	 <1177685391.3565.22.camel@johannes.berg>  <200704271720.08150.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-osp2hhg194W4i3Vhs4fx"
Date: Fri, 27 Apr 2007 17:27:18 +0200
Message-Id: <1177687638.3565.42.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-osp2hhg194W4i3Vhs4fx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-27 at 17:20 +0200, Rafael J. Wysocki wrote:

> I think we can use 'stages' and pass them as arguments to the functions.
>=20
> In that case we can have two callbacks for the hibernation (I'd prefer to=
 say
> 'hibernation' instead of 'suspend to disk' from now on), one 'quiesce' ca=
llback
> and one 'activate' callback that can be called many times in one
> snapshot/restore cycle with different arguments, for example:

But you're not proposing to add suspend/resume to this interface too, I
hope :)

> quiesce(PREPARE) -- that may be needed for drivers that allocate much mem=
ory
> before quiescing devices (if any)
> ...
> quiesce(PRE_SNAPSHOT)
> ...
> quiesce(PRE_SNAPSHOT_IRQ_OFF)
> ...
> activate(POST_SNAPSHOT_IRQ_OFF)
> ...
> activate(POST_SNAPSHOT)
> ...
> activate(FINISH)

I'm still not sure I like having to switch on the argument for every
implementation. Is it really worth it?

johannes

--=-osp2hhg194W4i3Vhs4fx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMhZW/ETPhpq3jKURAjCcAKCLAlJhQHeG4dnh1E0Wo7XnhNY/CACghT5L
RTKQbNIAYC7XxiC1X6AN8W8=
=XxdO
-----END PGP SIGNATURE-----

--=-osp2hhg194W4i3Vhs4fx--

