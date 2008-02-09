Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYBILxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYBILxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 06:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYBILxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 06:53:16 -0500
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:54115 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552AbYBILxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 06:53:15 -0500
From: Prakash Punnoor <prakash@punnoor.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Date: Sat, 9 Feb 2008 12:53:11 +0100
User-Agent: KMail/1.9.7
Cc: mingo@elte.hu, tglx@linutronix.de, lenb@kernel.org,
       linux-kernel@vger.kernel.org
References: <20080207195519.GA21772@basil.nowhere.org> <200802090008.05430.prakash@punnoor.de> <20080209115920.GB21172@one.firstfloor.org>
In-Reply-To: <20080209115920.GB21172@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6168876.ZRLq9DBlDl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802091253.11478.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6168876.ZRLq9DBlDl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On the day of Saturday 09 February 2008 Andi Kleen hast written:
> > Grr, I don't know why I am discussing with stubborn and/or arrogant devs
> > like you seem to be. But I actually did what you wanted and as *expecte=
d*
> > - as I
>
> Thanks.
>
> > said I understand that trivial piece of code you posted - your patch
> > fails here for my nforce2:
>
> That is 2.6.24 + my patch?  And system didn't boot?
>
> > cat /proc/interrupts
> >            CPU0
> >   0:        832    XT-PIC-XT        timer <---------------- seeing this?
>
> Well it looks like it is ticking. What are the symptoms?

You are seeing it. If you read my other mails you would comprehend it as we=
ll.

> Do you have a full boot log of the failure?

As I said inform yourself, what the intention of the quirk is about. I am=20
tired of this.

>
> > And no, I won't test it on my MCP51 as I *know* what happens: As soon as
> > I disable hpet, the quirk gets triggered and will lock up my system.
>
> I readded the HPET check in v2 especially for you so if HPET is enabled
> no quirk is triggered.

Still you didn't give *any* proof that mcp51 needs quirk at all. I therefor=
e=20
want that line *removed*:

+       QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x02f0, nvidia_timer), /* mcp 51/nf4 =
?=20
*/

=46urthermore my original bios didn't have option to enable hpet. What then=
?=20
Kernel hangs unless I specify acpi_use_timer_override. Great.

Hint: The correct way of quirking would be *only having this one* line:

+       QBRIDGE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE2,=20
nvidia_timer),

According to Len Brown's comment this would work for every nforce2. For eve=
ry=20
other nforceX use DMI Scan and only quirk known broken bioses instead of=20
messing up working boxes.

bye,
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart6168876.ZRLq9DBlDl
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHrZQnxU2n/+9+t5gRAsu0AJ9JBv/cACGkVufMEo0tnkOrCRouuACglPxy
IRI9uTAVq1J9kyRdeMl2bnM=
=gllH
-----END PGP SIGNATURE-----

--nextPart6168876.ZRLq9DBlDl--
