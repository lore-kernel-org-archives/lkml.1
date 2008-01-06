Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYAFSJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYAFSJj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 13:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbYAFSJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 13:09:14 -0500
Received: from smtp5-g19.free.fr ([212.27.42.35]:53756 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757210AbYAFSJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 13:09:11 -0500
Date: Sun, 6 Jan 2008 19:08:56 +0100
From: FD Cami <francois.cami@free.fr>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Al Boldi <a1426z@gawab.com>, Jeff Garzik <jeff@garzik.org>,
       Zoltan Boszormenyi <zboszor@dunaweb.hu>
Subject: Re: [PATCH] Re: Forcing modes in libata (was: SATA buffered read
 VERY slow)
Message-ID: <20080106190856.510ab90e@dimension.stilgar.hd.free.fr>
In-Reply-To: <200801061727.38206.bzolnier@gmail.com>
References: <200801051641.03927.a1426z@gawab.com>
	<20080106133609.51203eed@lxorguk.ukuu.org.uk>
	<20080106162100.05096d60@dimension.stilgar.hd.free.fr>
	<200801061727.38206.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/8oe1rEqhMlsdQZa/6y1D2sY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/8oe1rEqhMlsdQZa/6y1D2sY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sun, 6 Jan 2008 17:27:38 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Sunday 06 January 2008, FD Cami wrote:
> > On Sun, 6 Jan 2008 13:36:09 +0000
> > Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >=20
> > > On Sun, 6 Jan 2008 08:03:31 +0300
> > > > > For now you can boot with libata.dma=3D1 to select DMA on disks
> > > > > but not CD
> > > >=20
> > > > Great, but why isn't this in the documentation?
> > >=20
> > > Send patches
> >=20
> > patch attached.
> >=20
> > Description : Add libata.dma=3D to Documentation/kernel-parameters.txt
> >=20
> > Found documentation in :
> > http://www.mail-archive.com/linux-ide%40vger.kernel.org/msg09849.html
> > http://www.redhat.com/archives/fedora-extras-commits/2007-October/msg04=
568.html
> >=20
> > Signed-off-by: Fran=C3=A7ois Cami <francois.cami@free.fr>
>=20
> diff -rU2 linux-2.6.24-rc6/Documentation/kernel-parameters.txt=20
> linux-2.6.24-rc6-mine/Documentation/kernel-parameters.txt
> ---
> linux-2.6.24-rc6/Documentation/kernel-parameters.txt=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A02008-01-06
> 15:58:54.000000000 +0100 +++
> linux-2.6.24-rc6-mine/Documentation/kernel-parameters.txt=C2=A0=C2=A0=C2=
=A02008-01-06
> 16:11:20.000000000 +0100 @@ -883,4 +883,11 @@ C2 power state.=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0libata.dma=3D=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0[LIBATA] DMA control
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0libata.dm=
a=3D0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0Disable all PATA DMA like
> old IDE
>=20
> this doesn't seem entirely correct:
>=20
> * IDE has "hdx=3Dnodma" so you can disable DMA on per-device basis

I think that libata.dma=3D1 is designed to behave like=20
CONFIG_IDEDMA_ONLYDISK used to. "hdx=3Dnodma" is more fine-grained than
this.

> * is this really limited to PATA?

Alan's original patch took care of PATA. SATA support was added
later by Jeff Garzik. Corrected documentation patch attached.

> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0libata.dm=
a=3D1=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0Disk DMA only
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0libata.dm=
a=3D2=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0ATAPI DMA only
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0libata.dm=
a=3D3=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0CF DMA only=20

This is also wrong, it should be "libata.dma=3D4=C2=A0=C2=A0=C2=A0=C2=A0 =
=C2=A0CF DMA only"
Thanks to Zoltan Boszormenyi <zboszor@dunaweb.hu> for catching this
mistake.

Revised patch attached.

Best,

Fran=C3=A7ois

--MP_/8oe1rEqhMlsdQZa/6y1D2sY
Content-Type: text/plain; name=libata-doc-patch2.txt
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=libata-doc-patch2.txt

diff -rU4 linux-2.6.24-rc6/Documentation/kernel-parameters.txt linux-2.6.24-rc6-mine/Documentation/kernel-parameters.txt
--- linux-2.6.24-rc6/Documentation/kernel-parameters.txt	2008-01-06 15:58:54.000000000 +0100
+++ linux-2.6.24-rc6-mine/Documentation/kernel-parameters.txt	2008-01-06 18:46:49.000000000 +0100
@@ -881,8 +881,16 @@
 
 	lapic_timer_c2_ok	[X86-32,x86-64,APIC] trust the local apic timer in
 			C2 power state.
 
+	libata.dma=	[LIBATA] DMA control
+			libata.dma=0	  Disable all PATA and SATA DMA
+			libata.dma=1	  PATA and SATA Disk DMA only
+			libata.dma=2	  ATAPI (CDROM) DMA only
+			libata.dma=4	  Compact Flash DMA only 
+			Combinations also work, so libata.dma=3 enables DMA
+			for disks and CDROMs, but not CFs.
+
 	libata.noacpi	[LIBATA] Disables use of ACPI in libata suspend/resume
 			when set.
 			Format: <int>
 

--MP_/8oe1rEqhMlsdQZa/6y1D2sY--
