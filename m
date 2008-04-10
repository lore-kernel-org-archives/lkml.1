Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYDJKHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYDJKHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 06:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYDJKHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 06:07:04 -0400
Received: from mail1.bur.st ([203.82.212.241]:46512 "EHLO creep.bur.st"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752265AbYDJKHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 06:07:03 -0400
Date: Thu, 10 Apr 2008 11:59:30 +0200
From: Rodney Lorrimar <rodney@rodney.id.au>
To: Pavel Machek <pavel@suse.cz>
Cc: jikos@suse.cz, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew McNabb <amcnabb@mcnabbs.org>
Subject: Re: [PATCH] Input: adbhid - fix capslock key state after suspend
Message-ID: <20080410095930.GA2945@solaria.local>
References: <20080328001556.GA30148@solaria.local> <20080328105855.GA1686@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20080328105855.GA1686@elf.ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 28, 2008 at 11:58:55AM +0100, Pavel Machek wrote:
> On Fri 2008-03-28 01:15:56, Rodney Lorrimar wrote:
> > If the adbhid module parameter restore_capslock_events is used,
> > sometimes capslock will get stuck down after resuming.
>=20
> Hmmm, why does that need to be a parameter? I mean... can we just do
> the right thing?

Hi Pavel,

Sorry for taking so long to answer your questions. We can mostly do
the right thing. I suppose it was a parameter so the quirk fixing
didn't ruin the fun for the majority of users who don't remap their
capslock. I know of two issues with the code:

1. Under heavy capslock usage the capslock key will sometimes get
   stuck down.
2. If the capslock LED is on and the power button is pressed, a "power
   button release" key event won't happen until capslock is pressed
   again. So in some situations (e.g. with pbbuttonsd) the next time
   capslock is hit the machine will suspend.


I will send a patch for 2, and continue to investigate 1.

Regarding the original patch, I think it's worth applying. If 1 is
fixable then I will prepare two more patches to fix problem 1 and
remove the parameter.


Rodney

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH/eUCbBchLr+YxKcRAg2IAJ4gIuRbzkd5K+D66XB+FZHG+qtWXwCgmDik
WhziST4pHKHJbgCPAb9kc9g=
=M/6n
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
