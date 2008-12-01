Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbYLARIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbYLARIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 12:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYLARIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 12:08:40 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:42533 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbYLARIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 12:08:39 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding the	device
Date: Mon, 1 Dec 2008 18:08:30 +0100
User-Agent: KMail/1.9.10
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Alex Chiang <achiang@hp.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci" <linux-pci@vger.kernel.org>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com> <200811281942.31754.eike-kernel@sf-tec.de> <Pine.LNX.4.58.0811281303230.30153@shell4.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0811281303230.30153@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6244774.97xlM0aTeu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812011808.31906.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6244774.97xlM0aTeu
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Trent Piepho wrote:
> On Fri, 28 Nov 2008, Rolf Eike Beer wrote:
> > Trent Piepho wrote:
> > > On Wed, 26 Nov 2008, Darrick J. Wong wrote:
> > > > On Wed, Nov 26, 2008 at 03:55:35PM -0700, Alex Chiang wrote:
> > > > > > Maybe it's different on powerpc then?  My pseudo-hotplugable
> > > > > > device is also the only thing connected to the PCI-E host bus
> > > > > > controller. At boot the controller is empty and so I think some
> > > > > > code to enable its BARs gets skipped.  But without the
> > > > > > pci_enable_device(), I get this:
> > > > > >
> > > > > > 01:00.0 Signal processing controller: Freescale Semiconductor I=
nc
> > > > > > Aurora Nexus Trace Interface Flags: fast devsel, IRQ 255
> > > > > >         Memory at 40000000 (64-bit, prefetchable) [disabled]
> > > > > > [size=3D4K]
> > > >
> > > >                            Are you referring to this? ^^^^^^^^^^
> > > >
> > > > Without seeing the raw dump of the PCI config space, it looks to me
> > > > like the memory space enable bit of the PCICMD register is unset.=20
> > > > Probably the device driver should call pci_enable_device() at init
> > > > time, though I suppose you did say earlier that there is no driver.
> > >
> > > Yes, that's it.  It seems like since the BARs are normally enabled
> > > after a device is scanned at boot time that they should also be enabl=
ed
> > > when a device is found by a fakephp rescan.  So I thought it seemed
> > > reasonable to put pci_enable_device() in fakephp.
> >
> > No, pci_enable_device() will be called by the device driver. The hotplug
> > drivers have nothing to do with that.
>
> I guess you didn't read the part about there not being a device driver?

I read it, but that's the way a kernel works: if you want to talk to a devi=
ce,=20
get a driver. You can write a rather minimal one that does only=20
pci_enable_device() on probe and pci_disable_device() on remove. Try the on=
e=20
posted by Chris Wright in "[PATCH 2/2] PCI: pci-stub module to reserve pci=
=20
device" as a starting point.

Eike

--nextPart6244774.97xlM0aTeu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk0Gg8ACgkQXKSJPmm5/E7fqwCfU+j12oWsQ8GxQORTo3gsbL7p
7kMAnjeymkF97/IkqQQPASbTPYYpbGb0
=qJm8
-----END PGP SIGNATURE-----

--nextPart6244774.97xlM0aTeu--
