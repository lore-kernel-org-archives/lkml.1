Return-Path: <linux-kernel-owner+w=401wt.eu-S1759267AbYAJI7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267AbYAJI7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYAJI7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:59:34 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:51700 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYAJI7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:59:33 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2008 03:59:33 EST
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Date: Thu, 10 Jan 2008 09:52:49 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       paolo.ciarrocchi@gmail.com, gorcunov@gmail.com
References: <20080108164015.GC31504@one.firstfloor.org>
In-Reply-To: <20080108164015.GC31504@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart13956404.uocKkaVyG2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801100952.55039.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart13956404.uocKkaVyG2
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Andi Kleen wrote:
> Here's a proposal for some useful code transformations the kernel janitors
> could do as opposed to running checkpatch.pl.
>
> Most ioctl handlers still running implicitely under the big kernel
> lock (BKL). But long term Linux is trying to get away from that. There is=
 a
> new ->unlocked_ioctl entry point that allows ioctls without BKL, but the
> code needs to be explicitely converted to use this.
>
> The first step of getting rid of the BKL is typically to make it visible
> in the source. Once it is visible people will have incentive to eliminate
> it. That is how the BKL conversion project for Linux long ago started too.
> On 2.0 all system calls were still implicitely BKL and in 2.1 the
> lock/unlock_kernel()s were moved into the various syscall functions and
> then step by step eliminated.

Can you explain the rationale behind that running on the BKL? What type of=
=20
things needs to be protected so that this huge hammer is needed? What would=
=20
be an earlier point to release the BKL?

Greetings,

Eike

--nextPart13956404.uocKkaVyG2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHhdzmXKSJPmm5/E4RAqvlAJ4kM4eYK8Qzk4fKVWfsunJulEvjTgCgpafm
GCNInwxY+HQB19+3/bYGVro=
=EJpp
-----END PGP SIGNATURE-----

--nextPart13956404.uocKkaVyG2--
