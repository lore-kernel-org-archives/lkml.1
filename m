Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbXDREbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbXDREbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXDREbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:31:00 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:51494 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbXDREa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
        b=gTK+INa0H0qXLhMfQ5cPb1+7qtFKCAdvjolgUZ87+xcv9dmOiILwQGVqDEut25j8pw+FeIkxzDDA1rJw/nzfyk3IvzKI2WtNPwG4Few9r6v2aeYk0169nlwyBs/WdRBdwG0UMNQ9mUtbPanQzdTh0a0HDNKJWI6OGZFVJmhw3tw=
Date: Tue, 17 Apr 2007 21:30:48 -0700
From: Mike Mattie <codermattie@gmail.com>
To: Adrian Bunk <bunk@stusta.de>, Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.21-rc7 hpt366 driver broken
Message-ID: <20070417213048.033af0fc@reforged>
In-Reply-To: <20070416202515.2fe46f65@reforged>
References: <20070415224846.52a465b6@reforged>
	<20070416043822.0ea2490e@reforged>
	<20070416143613.GD10338@stusta.de>
	<20070416182112.4fcbb87f@reforged>
	<20070416194303.58545412@reforged>
	<20070416202515.2fe46f65@reforged>
X-Mailer: Claws Mail 2.6.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_0jVpk.eY/GCJXZAjt.FgeJq";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_0jVpk.eY/GCJXZAjt.FgeJq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Apr 2007 20:25:15 -0700
Mike Mattie <codermattie@gmail.com> wrote:

I have added Sergei Shtylyov to the address list after seeing his recent po=
sts on hpt366 issues, and the
git changelog for the hpt366.c driver. I am very confident that I have pinp=
ointed the defect in the driver.

> On Mon, 16 Apr 2007 19:43:03 -0700
> Mike Mattie <codermattie@gmail.com> wrote:
>=20
> > On Mon, 16 Apr 2007 18:21:12 -0700
> > Mike Mattie <codermattie@gmail.com> wrote:
> >=20
> > > On Mon, 16 Apr 2007 16:36:13 +0200
> > > Adrian Bunk <bunk@stusta.de> wrote:
> > >=20
> > > > [ Cc's added, full bug report was in
> > > > http://lkml.org/lkml/2007/4/16/18 ]
> > > >=20
> > > > On Mon, Apr 16, 2007 at 04:38:22AM -0700, Mike Mattie wrote:
> > > > > On Sun, 15 Apr 2007 22:48:46 -0700
> > > > > Mike Mattie <codermattie@gmail.com> wrote:
> > > > >=20
> > > > > > Hello,
> > > > > >=20
> > > > > > I am testing the 2.6.21-rc7 kernel release. The IDE hpt366
> > > > > > driver is crashing hanging the boot. I have basically the
> > > > > > same config as 2.6.20.7 which works fine (except for
> > > > > > netconsole mentioned in a previous mail).
> > > > > >=20
> > > > > > here is the hand-copied info:
> > > > > >=20
> > > > > > * "unable to handle paging request" , null deref
> > > > > > * EIP @ init_chipset_hpt366
> > > > > >=20
> > > > >=20
> > > > > > I am running a git-bisect to see if I can resolve it to a
> > > > > > commit.
> > > > >=20
> > > > > This was identified as the first broken commit:
> > > > >=20
> > > > > commit 7b73ee05d0acb926923d43d78b61add776ea4bb1
> > > > > Author: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> > > > > Date:   Wed Feb 7 18:18:16 2007 +0100
> > > > >=20
> > > > >     hpt366: init code rewrite
> > > > >=20
> > > > > Reverting is conflicted so it will be a bit longer before I
> > > > > pin-point any other build-breaks.
> > > >=20
> > > > Thanks for your report.
> > > >=20
> > > > Can you use a digital camera for taking a photograph of the
> > > > crash?
> > >=20
> > > I can later on tonight, by about 11PM west coast. I also saw
> > > some hex offsets after the function pointed to by EIP, is there
> > > a way to decode that to a line number ? I have debugging symbols
> > > enabled.
> > >=20
> > > I am also doing printk breadcrumbs to pin it down to a block
> > > or a line.
> >=20
> > I have narrowed the crash with breadcrumbs down to these lines:
> >=20
> >=20
> > 	/*
> > 	 * Only try the DPLL if we don't have a table for the PCI
> > clock that
> > 	 * we are running at for HPT370/A, always use it  for
> > anything newer... *
> > 	 * NOTE: Using the internal DPLL results in slow reads on 33
> > MHz PCI.
> > 	 * We also  don't like using  the DPLL because this causes
> > glitches
> > 	 * on PRST-/SRST- when the state engine gets reset...
> > 	 */
> > 	if (info->chip_type >=3D HPT374 || info->settings[clock] =3D=3D
> > NULL) { u16 f_low, delta =3D pci_clk < 50 ? 2 : 4;
> > 		int adjust;
> >=20
> > 		printk(KERN_INFO "inside the if\n");
> >=20
> > 		 /*
> > 		  * Select 66 MHz DPLL clock only if UltraATA/133
> > mode is
> > 		  * supported/enabled, use 50 MHz DPLL clock
> > otherwise... */
> > 		if (info->max_mode =3D=3D 0x04) {
> > 			dpll_clk =3D 66;
> > 			clock =3D ATA_CLOCK_66MHZ;
> > 		} else if (dpll_clk) {	/* HPT36x chips don't
> > have DPLL */ dpll_clk =3D 50;
> > 			clock =3D ATA_CLOCK_50MHZ;
> > 		}
> >=20
> > 		if (info->settings[clock] =3D=3D NULL) {
>                 ^^^^^^^^ crashes here
>=20
> since info is deref'd all over the place I am assuming it is the array
> that is blowing up.
>=20
> I printk'd the value of clock which is "4". that array is either not
> setup correctly , or it is out-of-bounds (speculation)

here on line 493: the hpt302n ( The chipset I have ) is the only struct wit=
hout
a .settings field , I am extremely confident this is the exact location of =
the bug.

static struct hpt_info hpt302n __devinitdata =3D {
	.chip_type	=3D HPT302N,
	.max_mode	=3D HPT302_ALLOW_ATA133_6 ? 4 : 3,
	.dpll_clk	=3D 77,
};

I do not know enough about the HPT chips to correctly select which settings=
 group
this field should be initialized to. Please take a look, the fix now should=
 be very
easy.

> > 			printk(KERN_ERR "%s: unknown bus timing!\n",
> > name); kfree(info);
> > 			return -EIO;
> > 		}
> >=20
> > 		printk(KERN_INFO "select DPLL clock\n");
> >=20
> > This is right around 1171 , (skewed by the crumbs I added). The last
> > message I receive is "inside if" , it dies before "select DPLL
> > clock".
> >=20
> > Without knowing much about the structs I am not sure what to
> > print-out. I will narrow it further, and maybe even compare against
> > what the old working kernel had for variable values. That would take
> > some time though.
> >=20
> > >=20
> > > > cu
> > > > Adrian
> > > >=20
> > > > --
> > > >=20
> > > >        "Is there not promise of rain?" Ling Tan asked suddenly
> > > > out of the darkness. There had been need of rain for many
> > > > days. "Only a promise," Lao Er said.
> > > >                                        Pearl S. Buck - Dragon
> > > > Seed
> > > >=20

--Sig_0jVpk.eY/GCJXZAjt.FgeJq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJZ79dfRchrkBInkRAo+qAJ0dr5PAcEfv6QetyadX6TaeAdJ4zACfaGlu
6NjliYSYn1aDepJpbPs/lS4=
=sk1U
-----END PGP SIGNATURE-----

--Sig_0jVpk.eY/GCJXZAjt.FgeJq--
