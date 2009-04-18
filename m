Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbZDRJOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbZDRJOL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 05:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZDRJNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 05:13:54 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:34941 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbZDRJNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 05:13:53 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-04.arcor-online.net 6D62D33A863
From: Prakash Punnoor <prakash@punnoor.de>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Proposal: make RAID6 code optional
Date: Sat, 18 Apr 2009 11:16:57 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
References: <200904180946.27722.prakash@punnoor.de> <49E98AD2.8060601@msgid.tls.msk.ru>
In-Reply-To: <49E98AD2.8060601@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3476140.tpsoIuz6W5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200904181117.03418.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3476140.tpsoIuz6W5
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Samstag 18 April 2009 10:09:54 Michael Tokarev wrote:
> Prakash Punnoor wrote:
> > Hi,
> >
> > as I am using only RAID5 I wonder why the RAID6 code also needs to be
> > built. Here is a rough patch of making RAID6 optional (but depending on
> > raid456) without reording of functions to minimize ifdef scattering.
> > (I also haven't checked yet who needs ASYNC_MEMCPY and ASYNC_XOR...)
> > It would probably be nicer to make RAID4/5 and RAID6 independently
> > selectable of each other. But that requires more refactoring, as I can
> > see.
>
> Hm.  In "old good days" there were 3 independent kernel modules,
> named raid4, raid5 and raid6.  Later on, they got merged into one
> since they share quite alot of the code, and has only a few specific
> parts.  Now you're trying to separate them back somewhat....
>
> What's your goal?  What's the problem you're trying to solve?

Having duplicate code is not good, of course. But unused code is also not=20
good. As I said, I only use RAID5, so I don't need RAID6 support. The RAID6=
=20
support enlarges kernel (the built-in.o in drivers/md grows from 325kb to=20
414kb in my case), making boot time and compile time longer - admittedly no=
t=20
by a big margin. But then again I could argue: Why not put RAID0,1,10,4,5,6=
=20
into one big module? Makes no sense, huh? For me putting 5 and 6 into one=20
monolithic module makes no sense. A proper architecture would be to have so=
me=20
common shared code (in a separate module?), not a monolithic big one.

Regards,

Prakash

--nextPart3476140.tpsoIuz6W5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAknpmo8ACgkQxU2n/+9+t5gAjQCgnarwbnwbhh6vVIjh28N+tm03
k3MAnR1E4A2hO/bO3IOR/+10X9FLWOIY
=sFld
-----END PGP SIGNATURE-----

--nextPart3476140.tpsoIuz6W5--
