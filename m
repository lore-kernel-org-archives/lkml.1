Return-Path: <linux-kernel-owner+w=401wt.eu-S932864AbYBHPNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864AbYBHPNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 10:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759092AbYBHPNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 10:13:45 -0500
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:47301 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757664AbYBHPNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 10:13:43 -0500
From: Prakash Punnoor <prakash@punnoor.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Date: Fri, 8 Feb 2008 16:13:35 +0100
User-Agent: KMail/1.9.7
Cc: mingo@elte.hu, tglx@linutronix.de, lenb@kernel.org,
       linux-kernel@vger.kernel.org
References: <20080207195519.GA21772@basil.nowhere.org> <200802072221.19099.prakash@punnoor.de> <20080208113638.GA4745@one.firstfloor.org>
In-Reply-To: <20080208113638.GA4745@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3023262.yLajEcYNs4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802081613.39906.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3023262.yLajEcYNs4
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On the day of Friday 08 February 2008 Andi Kleen hast written:
> On Thu, Feb 07, 2008 at 10:21:18PM +0100, Prakash Punnoor wrote:
> > On the day of Thursday 07 February 2008 Andi Kleen hast written:
> > > Replace the old "for all of nvidia" quirk with a quirk containing pci
> > > device ID. I goobled this list together from pci.ids and googling and
> > > it may be incomplete, but so far I haven't had complaints.
> > >
> > > +	QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x02f0, nvidia_timer), /* mcp 51/nf4 ?
> > > */
> >
> > If you want to skip timer override on this board, this is a *NAK* from
> > me. I told you the last time, it only works reliably here on MCP51 with
> > timer
>
> Hmm, if you told me it got lost somewhere, sorry.

I at least found this post: http://lkml.org/lkml/2006/8/13/2 though I remeb=
er=20
we had some discussions. ;-)

>
> > override working. Even before Asus released a bios which had an option =
to
> > enable the hpet, I needed the override or I got irratic behaviour. Since
> > I got hpet enabled I gave up on arguing as the wrongly triggered quirk
> > didn't bug me anymore.
>
> Ok we can keep the HPET check if that makes you more happy.
>
> > IIRC my nforce2 needed the override. I didn't see that in the list.
>
> The list only contains IDs where the override should be ignored; so
> if it has a correct one and it's not there everything is fine.

Sorry, I meant the opposite. I needed the acpi_skip_timer_override kernel=20
parameter for nforce2, thus no override. So this chipset is missing here. A=
t=20
least I remember that my nforce2 needed the skipping,=20
otherwise the timer stayed in XT-PIC mode even when APIC was requested.

> I'm appending a revised patch. Does it work for you?

I haven't tested it, but it would "work" as it would bail out in my case=20
because of the hpet check. The problem I see with this approach - as with t=
he=20
old one -  it simply wants to ignore the override for a whole bunch of=20
chipsets. (The old one is catastrophic as it even doesn't care for chipset=
=20
revision.)  And checking for hpet is just heuristics (or what is the=20
rationale behind it?) not a real check whether the override should be ignor=
ed=20
or not. Are you actually sure that so many nforceX boards have broken biose=
s?=20
References? I would prefer a DMI check and only apply the quirk for *known*=
=20
broken bioses instead fo "blindly" doing it as in my case my mcp51 system i=
s=20
unstable with the quirk applied - it *never* needed the quirk.

I found this:
http://www.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/test/2.6.5/=
20040422223905-nforce2_timer.patch

So it seems the original (proposed?) version did a DMI check for known brok=
en=20
bioses. Why was this approach abandoned?

According to
http://lkml.org/lkml/2006/10/19/427
it seems only nforce2 and perhaps some nforce3 are relevant.


To sum it up, I think it is a step into the right direction, but still not=
=20
correct.
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart3023262.yLajEcYNs4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHrHGjxU2n/+9+t5gRAiY+AKD1sFh3T9z5fm0lnmj8NYnNTj2r3gCgrwup
NRIwGCgU/EZtEX3Fbc2u8SY=
=tAHx
-----END PGP SIGNATURE-----

--nextPart3023262.yLajEcYNs4--
