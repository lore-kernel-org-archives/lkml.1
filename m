Return-Path: <linux-kernel-owner+w=401wt.eu-S1762663AbXHUS3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663AbXHUS3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761521AbXHUS24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:28:56 -0400
Received: from mx34.mail.ru ([194.67.23.200]:11954 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760790AbXHUS2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:28:54 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [2.6.23-rc3 possible regression] 8250 claims nonexisting device blocking IO port
Date: Tue, 21 Aug 2007 22:28:49 +0400
User-Agent: KMail/1.9.7
Cc: linux-serial@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200708181107.56087.arvidjaar@mail.ru> <200708202028.22806.arvidjaar@mail.ru> <200708201111.19023.bjorn.helgaas@hp.com>
In-Reply-To: <200708201111.19023.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3276310.YK32pzLCBs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708212228.50877.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3276310.YK32pzLCBs
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 20 August 2007, Bjorn Helgaas wrote:
> On Monday 20 August 2007 10:28:22 am Andrey Borzenkov wrote:
> > This worked in 2.6.22 with the same quirks. I will test without later b=
ut
> > I fail to see how they are related.
>
> OK, let me know what happens.  The way it's related is that the quirk
> fiddles with the IRDA device, and it probably changes the SIR config
> so that it starts responding at the ttyS3 address.

You are probably right. Disabling quirk makes it work again (with pnp off i=
n=20
smsc-ircc2 of course).

Hmm ... is there any reason why this quirk is in PnP core in the first plac=
e?=20
Would not it be more logical to have it in (PnP) part of smsc-ircc2? This w=
ay=20
it could share code with legacy detection; and it even may have chance to=20
work - assuming BIOS is aware that 0x100 is claimed by PCMCIA it could=20
allocate different port when we try to activate device after that ... shoul=
d=20
I give it a try?

> In your 2.6.23=20
> log, I see this:
>
> [  512.476243] pnp: Device 00:0a activated.
> [  512.476301]  00:0a: SMCf010 not responding at SIR 0x100, FIR 0x2e8;
> auto-configuring [  512.477861] pnp: Device 00:0a disabled.
> [  512.483492] pnp: Device 00:0a activated.
> [  512.483520]  00:0a: not responding at SIR 0x100, FIR 0x2e8; swapping
> SIR/FIR and reconfiguring [  512.485056] pnp: Device 00:0a disabled.
> [  512.491652] pnp: Device 00:0a activated.
> [  512.491679]  00:0a: responds at SIR 0x2e8, FIR 0x100
>
> After the quirk, the FIR part is enabled at 0x100 and we assume (the
> quirk doesn't actually check) the SIR part is enabled at 0x2e8.  The
> 8250 driver will claim a SIR device at 0x2e8 as ttyS3.
>
> Without the quirk, the SIR device seems to be either at 0x100 (where
> the 8250 driver will not look) or is not enabled at all.
>
> Bjorn



--nextPart3276310.YK32pzLCBs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGyy7iR6LMutpd94wRAhm0AJ99m5OU8XmfnfLembjDrZQXhvqugACfZ4Dc
HLoSrpNSL1PcciWe1de6oqM=
=gMS8
-----END PGP SIGNATURE-----

--nextPart3276310.YK32pzLCBs--
