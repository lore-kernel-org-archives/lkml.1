Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbXKWHfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbXKWHfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 02:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbXKWHe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 02:34:58 -0500
Received: from chello089077114002.chello.pl ([89.77.114.2]:49112 "EHLO
	astralstorm.puszkin.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbXKWHe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 02:34:58 -0500
Date: Fri, 23 Nov 2007 08:34:47 +0100
From: Radoslaw Szkodzinski (AstralStorm) <lkml@astralstorm.puszkin.org>
To: Dane Mutters <dmutters@gmail.com>
Cc: Diego Calleja <diegocg@gmail.com>, Martin Olsson <mnemo@minimum.se>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it possible to give the user the option to cancel forkbombs?
Message-ID: <20071123083447.3a3e4d23@astralstorm.puszkin.org>
In-Reply-To: <1195322101.15120.3.camel@Orchestrator>
References: <473E815F.30900@minimum.se>
	<20071116213137.6efe3f9e@the-village.bc.nu>
	<473E9290.3040006@minimum.se>
	<1195281942.15929.5.camel@Orchestrator>
	<1195285481.3059.12.camel@twins>
	<473F281B.60408@minimum.se>
	<20071117165325.3e5f571a.diegocg@gmail.com>
	<1195322101.15120.3.camel@Orchestrator>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Je=JBTx6W3g3LWAf/XTiKk6";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Je=JBTx6W3g3LWAf/XTiKk6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 17 Nov 2007 09:55:01 -0800
Dane Mutters <dmutters@gmail.com> wrote:

> I don't know if this is at all feasible, but is it possible to have a
> mechanism that would detect a fork bomb in progress and either stop the
> fork, or allow the user to cancel the operation?  For example, are there
> any legitimate processes (i.e. ones that really need to fork like crazy)
> that would need to generate 200+ processes in less than 1 second?
>=20
> (Note: I'm not a programmer; I'm just throwing out the idea.)
>=20

If the parent PID of the new task is exported through TASKSTATS, you can
do it already in userspace. If not, that data should be exported.

Then you could write a root daemon using netlink, set it to RT priority
and create an inheritable counter in it to thwart binary forking.
The counter would be cleared every x seconds.
No need to do it in the kernel.

--Sig_/Je=JBTx6W3g3LWAf/XTiKk6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQFHRoKcBlhXA0ALOYMRAnvlAJ9S6WOwO9ODKcursdo8l1RaNTmeTQCfV1IW
RmNYz6MKqhTnT2r3BdUnlMU=
=gfV/
-----END PGP SIGNATURE-----

--Sig_/Je=JBTx6W3g3LWAf/XTiKk6--
