Return-Path: <linux-kernel-owner+w=401wt.eu-S934970AbYBHTBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934970AbYBHTBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 14:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933366AbYBHTBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 14:01:11 -0500
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:41847 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934476AbYBHTAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 14:00:49 -0500
From: Prakash Punnoor <prakash@punnoor.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Date: Fri, 8 Feb 2008 20:00:39 +0100
User-Agent: KMail/1.9.7
Cc: mingo@elte.hu, tglx@linutronix.de, lenb@kernel.org,
       linux-kernel@vger.kernel.org
References: <20080207195519.GA21772@basil.nowhere.org> <200802081839.18267.prakash@punnoor.de> <20080208190143.GB11573@one.firstfloor.org>
In-Reply-To: <20080208190143.GB11573@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart21475111.Sx4DtrjiUv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802082000.39919.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart21475111.Sx4DtrjiUv
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On the day of Friday 08 February 2008 Andi Kleen hast written:
> On Fri, Feb 08, 2008 at 06:39:17PM +0100, Prakash Punnoor wrote:
> > On the day of Friday 08 February 2008 Andi Kleen hast written:
> > > On Fri, Feb 08, 2008 at 04:13:35PM +0100, Prakash Punnoor wrote:
> > > > Sorry, I meant the opposite. I needed the acpi_skip_timer_override
> > > > kernel parameter for nforce2, thus no override. So this chipset is
> > > > missing here. At least I remember that my nforce2 needed the
> > > > skipping,
> > >
> > > I hope you remember correctly and mean it this time. It would be bett=
er
> > > if you could double check.
> >
> > Yes, confirmed. timer w/o the skipping stays XT-PIC on nforce2.
>
> Confirmed what? Did you test my patch on both machines?
> What was the result?

I confirmed that it (nforce2) needed the acpi_skip_timer_override. If you r=
ead=20
my mail, you knew I didn't test your patch.

> > lspci -n:
>
> Please always send lspci without -n too; I hate looking up hex codes
> by hand when a computer can do that for me.
>
> > 02:00.0 0300: 10de:0281 (rev a1)
> >
> > > I'm a little sceptical because we had this patch in OpenSUSE 10.3
> > > and I didn't think there were complaints from NF2 users.
> > > With the changes you're requesting it turns from something
> > > very well tested into something experimental.
> >
> > Well, even w/o the skipping my nforce2 system wasn't unstable, AFAIK. So
> > I don't think just because of the XT-PIC entry people would complain.
>
> Timer override only does something in APIC mode and when you see XT-PIC
> in /proc/interrupts then you're not in APIC mode. All these patches
> are a no-op in this state.

Perhaps I wasn't percise, Len Brown had it in his earlier patch description=
s:

"
workaround for nForce2 BIOS bug: XT-PIC timer in IOAPIC mode=20
"acpi_skip_timer_override" boot parameter
"

or

"
Since the hardware is connected to APIC pin0, it is a BIOS bug=20
 that an ACPI interrupt source override from pin2 to IRQ0 exists.=20
=20
With this simple 2.6.5 patch you can specify "acpi_skip_timer_override"=20
 to ignore that bogus BIOS directive. The result is with your=20
 ACPI-enabled APIC-enabled kernel, you'll get IRQ0 IO-APIC-edge timer.=20
"

This is exactly what I observed on the nforce2.

My kernels are compiled and configured for APIC. With broken BIOSes the tim=
er=20
ends up as XT-PIC anyway. That is what I wanted to say and which you could=
=20
see from my cat /proc/interrupts dumps.




Why can't the kernel check for this condition and only activate the quirk t=
hen=20
instead of current and your proposed broken behaviour?




> > See why I don't want the quirk to be applied more than needed? *NOT*
> > applying the quirk on nforce2 didn't cause any obvious side effects.
> > APPLYING to mcp51 causes hard lock-ups.
>
> Can you please just test the patches instead of speculating what they
> might do or not do?

No, I do understand C code and I know the ID of my board. So I am not=20
speculating, just saving myself time and hassle.

You are not even taking the time to really read what I say. I am not your  =
=20
guinea pig. Why should I simply waste my time? Esp. my nforce2 system is a=
=20
productive system and I usually don't mess with it. So come up with a patch=
=20
that makes sense (and triggers on my nforce2 and does not trigger on my=20
mcp51) in my eyes, or I won't test anything and keep the NAK.

I don't think you did your research correctly coming up with the first vers=
ion=20
of the patch, as it ignored the nforce2 altogether. And the original versio=
n=20
was made for nforce2 exclusively! So why should I trust that you know what=
=20
you are doing? I don't get the impression. You also didn't gave references=
=20
where you get your IDs in the patch. I at least tried to gave some referenc=
es=20
that putting in those IDs is *wrong*. If you can provide those references=20
(and not some "search for it") you could strengthen your point. Provide som=
e=20
bug reports or lkml posts where users of nforce4, mcp51 needed the=20
skip_override to get their system stable.




I don't care whether this patch has been in some kernel for some time. It i=
s=20
still wrong (worse for nforce2 users, though better for newer nvidia chipse=
t=20
users as at last the quirk doesn't get appield for them)!





BTW, nforce2 lspci:
00:00.0 Host bridge: nVidia Corporation nForce2 AGP (different version?) (r=
ev=20
c1)
00:00.1 RAM memory: nVidia Corporation nForce2 Memory Controller 1 (rev c1)
00:00.2 RAM memory: nVidia Corporation nForce2 Memory Controller 4 (rev c1)
00:00.3 RAM memory: nVidia Corporation nForce2 Memory Controller 3 (rev c1)
00:00.4 RAM memory: nVidia Corporation nForce2 Memory Controller 2 (rev c1)
00:00.5 RAM memory: nVidia Corporation nForce2 Memory Controller 5 (rev c1)
00:01.0 ISA bridge: nVidia Corporation nForce2 ISA Bridge (rev a3)
00:01.1 SMBus: nVidia Corporation nForce2 SMBus (MCP) (rev a2)
00:02.0 USB Controller: nVidia Corporation nForce2 USB Controller (rev a3)
00:02.1 USB Controller: nVidia Corporation nForce2 USB Controller (rev a3)
00:02.2 USB Controller: nVidia Corporation nForce2 USB Controller (rev a3)
00:04.0 Ethernet controller: nVidia Corporation nForce2 Ethernet Controller=
=20
(rev a1)
00:05.0 Multimedia audio controller: nVidia Corporation nForce Audio=20
Processing Unit (rev a2)
00:06.0 Multimedia audio controller: nVidia Corporation nForce2 AC97 Audio=
=20
Controler (MCP) (rev a1)
00:08.0 PCI bridge: nVidia Corporation nForce2 External PCI Bridge (rev a3)
00:09.0 IDE interface: nVidia Corporation nForce2 IDE (rev a2)
00:0d.0 FireWire (IEEE 1394): nVidia Corporation nForce2 FireWire (IEEE 139=
4)=20
Controller (rev a3)
00:1e.0 PCI bridge: nVidia Corporation nForce2 AGP (rev c1)
01:08.0 Network controller: Techsan Electronics Co Ltd B2C2 FlexCopII DVB=20
chip / Technisat SkyStar2 DVB card (rev 01)
02:00.0 VGA compatible controller: nVidia Corporation NV28 [GeForce4 Ti 420=
0=20
AGP 8x] (rev a1)


lspci -n
00:00.0 0600: 10de:01e0 (rev c1)
00:00.1 0500: 10de:01eb (rev c1)
00:00.2 0500: 10de:01ee (rev c1)
00:00.3 0500: 10de:01ed (rev c1)
00:00.4 0500: 10de:01ec (rev c1)
00:00.5 0500: 10de:01ef (rev c1)
00:01.0 0601: 10de:0060 (rev a3)
00:01.1 0c05: 10de:0064 (rev a2)
00:02.0 0c03: 10de:0067 (rev a3)
00:02.1 0c03: 10de:0067 (rev a3)
00:02.2 0c03: 10de:0068 (rev a3)
00:04.0 0200: 10de:0066 (rev a1)
00:05.0 0401: 10de:006b (rev a2)
00:06.0 0401: 10de:006a (rev a1)
00:08.0 0604: 10de:006c (rev a3)
00:09.0 0101: 10de:0065 (rev a2)
00:0d.0 0c00: 10de:006e (rev a3)
00:1e.0 0604: 10de:01e8 (rev c1)
01:08.0 0280: 13d0:2103 (rev 01)
02:00.0 0300: 10de:0281 (rev a1)


bye,
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart21475111.Sx4DtrjiUv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHrKbXxU2n/+9+t5gRAnm0AJwJI3gL4Eg3qAlMnvNfydticC6XTACgjJca
yNEmyw1Nnnu95O+MJWV+g8g=
=ZGC0
-----END PGP SIGNATURE-----

--nextPart21475111.Sx4DtrjiUv--
