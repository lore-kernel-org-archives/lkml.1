Return-Path: <linux-kernel-owner+w=401wt.eu-S935842AbXGZSB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935842AbXGZSB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933723AbXGZSBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:01:44 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:23075 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933832AbXGZSBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:01:42 -0400
Date: Thu, 26 Jul 2007 20:00:47 +0200
From: Christian Krafft <krafft@de.ibm.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch] nfs: fix locking in nfs/inode.c in
 nfs_free_open_context
Message-ID: <20070726200047.1225c084@localhost>
In-Reply-To: <1185466097.6585.186.camel@localhost>
References: <20070725170837.5fba5fd1@localhost>
	<20070726144433.080126f7@localhost>
	<1185456203.6585.180.camel@localhost>
	<200707261713.07936.arnd@arndb.de>
	<1185466097.6585.186.camel@localhost>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
X-Face: `W@`hRxh5l!3-i=A%w>*|0PiG}G;2Y!DoiUjUcBX:Xf)vV'7+Is>5$*66xg5jwQA8P65#e
 <*gu)O37;+RS9iC[c7wnR]O0%dkLr^g_f1`&sfIQe&BG$E)b=GyjfCE$Ao'.6#^8@+z^`v
 qs#^Z%sWk_290zu+7nql/d?=lf<5^JI(C?MeXv;Tz)`xYOe<*"3'M?r2NHOdm_&jy-0Gp,
 3VVLR;cE=X-;J?p6b~_?K+jTAJrnGuuO%<!$3".gR,z_~jYJ"be)qH1(1A?koh`}d6Le|k
 CE<Y)JAsm
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_u=AGWOTks8W.wY=.rOwdmbr";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_u=AGWOTks8W.wY=.rOwdmbr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Jul 2007 12:08:17 -0400
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Thu, 2007-07-26 at 17:13 +0200, Arnd Bergmann wrote:
> > Unfortunately, you didn't answer my question. The observed problem is
> > that the final kref_put gets called at a time where there are still
> > references to the context in nfsi->open_files, and other threads
> > therefore do get at them.
>=20
> Actually, I thought I did: I said we need to grab the lock atomically
> with the last put. See below.
>=20
> > The patch holds the i_lock around the kref_put to prevent others
> > from searching the list. Ugly, I know, but it seems that's the
> > price you pay for using a kref in such unconventional ways, i.e.
> > not counting every reference.
>=20
> Really ugly. Here's an alternative that is a lot more palatable.

Indeed, and it also compiles ;-)
I started a test run using this patch, we'll see in a few hours ...

--=20
Mit freundlichen Gruessen,
kind regards,

Christian Krafft
IBM Systems & Technology Group,
Linux Kernel Development
IT Specialist


Vorsitzender des Aufsichtsrats:	Martin Jetter
Geschaeftsfuehrung:		Herbert Kircher
Sitz der Gesellschaft:		Boeblingen
Registriergericht:		Amtsgericht Stuttgart, HRB 243294


--Sig_u=AGWOTks8W.wY=.rOwdmbr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGqOFa6rqK4qDx+dcRAi9QAKCfJT89mNW+vk2yfVFobrJ4qxhXFwCcDwoA
R56y46/jODlVVul1TwsnJIs=
=DmWY
-----END PGP SIGNATURE-----

--Sig_u=AGWOTks8W.wY=.rOwdmbr--
