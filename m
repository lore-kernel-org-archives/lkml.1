Return-Path: <linux-kernel-owner+w=401wt.eu-S1760899AbXHTQ2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899AbXHTQ2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759630AbXHTQ21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:28:27 -0400
Received: from mx33.mail.ru ([194.67.23.194]:6476 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758575AbXHTQ20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:28:26 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [2.6.23-rc3 possible regression] 8250 claims nonexisting device blocking IO port
Date: Mon, 20 Aug 2007 20:28:22 +0400
User-Agent: KMail/1.9.7
Cc: linux-serial@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200708181107.56087.arvidjaar@mail.ru> <200708192147.47433.bjorn.helgaas@hp.com>
In-Reply-To: <200708192147.47433.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2148326.CPktiLNlLb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708202028.22806.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2148326.CPktiLNlLb
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 20 August 2007, Bjorn Helgaas wrote:
> On Saturday 18 August 2007 01:07:55 am Andrey Borzenkov wrote:
> > This is related to thread "2.6.22-rc: regression: no irda0 interface
> > (2.6.21 was OK), smsc does not find chip" but it is already way too
> > overloaded.
> >
> > In 2.6.23 smsc-ircc2 fails to initialize IrDA controller. Apparently
> > because it by default is using the same IO port as ttyS3 and this is now
> > claimed by 8250.
>
> 8250 should have claimed ttyS3 in 2.6.21 and earlier.  So from
> the 8250 point of view, 2.6.21 and 2.6.23 should behave the same.
>

I only know that this worked in 2.6.21. I remind that previous regression w=
as=20
post-2.6.21 which obviously implies that it did work ...

=46or reference I attach dmesg from 2.6.21. I do not see any ttyS3 there ...

> From the smsc-ircc2 point of view, 2.6.21 and 2.6.23 should work
> the same except for the additional quirk_smc_enable().  If
> 2.6.23 is worse than 2.6.21, please try removing the body of
> quirk_smc_enable() and see whether that makes 2.6.23 as good
> as 2.6.21.
>

This worked in 2.6.22 with the same quirks. I will test without later but I=
=20
fail to see how they are related.

> For smsc-ircc2, 2.6.23 is definitely a regression from 2.6.22,
> because 8250 stayed out of the way in 2.6.22.  But we had to
> revert 8250 back to the 2.6.21 behavior because the change
> swapped ttyS0 and ttyS1 on some machines, so we just have to
> live with that 8250/smsc-ircc2 conflict for the time being.
>

This worked in 2.6.21 and 2.6.22 (and earlier BTW). So if you just had reve=
rt=20
to 2.6.21 it would have worked. Something else changed.

--nextPart2148326.CPktiLNlLb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGycEmR6LMutpd94wRAmisAJ9+w5f4hZox1llatLkoO0Q46W9m6wCfbpVk
F94ZVDoXMTKS7y+AgCJftXM=
=etGl
-----END PGP SIGNATURE-----

--nextPart2148326.CPktiLNlLb--
