Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbZHaSve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbZHaSve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 14:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbZHaSvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 14:51:31 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:38894 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbZHaSva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 14:51:30 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: akataria@vmware.com
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Mon, 31 Aug 2009 20:51:18 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-git; KDE/4.3.0; i686; ; )
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Robert Love <robert.w.love@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dtor@vmware.com>, Maxime Austruy <maustruy@vmware.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com> <200908280803.52025.eike-kernel@sf-tec.de> <1251739571.16169.17.camel@ank32.eng.vmware.com>
In-Reply-To: <1251739571.16169.17.camel@ank32.eng.vmware.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3101854.yE4MISRjWW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200908312051.26264.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3101854.yE4MISRjWW
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Alok Kataria wrote:
> Hi Eike,

> > > +static int __devinit pvscsi_probe(struct pci_dev *pdev,
> > > +				  const struct pci_device_id *id)
> > > +{
> > > +	struct pvscsi_adapter *adapter;
> > > +	struct Scsi_Host *host;
> > > +	unsigned long base, i;
> > > +	int error;
> > > +
> > > +	error =3D -ENODEV;
> > > +
> > > +	if (pci_enable_device(pdev))
> > > +		return error;
> >
> > As always I suggest having a look on devres (see Documentation/driver-
> > model/devres.txt) which could simplify your error handling here and your
> > release function a lot. You only need to make sure it doesn't hurt if a=
ll
> > the PCI resources are freed after the scsi ones as you would end up
> > cleaning the scsi ones by hand and afterwards devres would throw all it
> > handles (which will probably be most of your PCI stuff) away itself.
>
> I took a quick look, but would prefer not to change this right now. Will
> do this as a incremental change later. Hope that is fine.

Just a suggestion ;)

> > > +	adapter->dev  =3D pdev;
> > > +	adapter->host =3D host;
> > > +
> > > +	spin_lock_init(&adapter->hw_lock);
> > > +
> > > +	host->max_channel =3D 0;
> > > +	host->max_id      =3D 16;
> > > +	host->max_lun     =3D 1;
> > > +
> > > +	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &adapter->rev);
> >
> > That's in pdev->revision anyway, isn't it?
>
> Yep, though, its needed in pvscsi_info, so will keep this in adapter
> too.

Yes, but you don't need to do pci_read_config_byte() but simply copying tha=
t=20
over from pdev->revision.

Eike

--nextPart3101854.yE4MISRjWW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkqcG64ACgkQXKSJPmm5/E5ArgCdGG/P36PC17xB124Tf4D+6HxE
bLYAni/qJVXxqLOknsLUkwLmcoAwofDk
=8J4N
-----END PGP SIGNATURE-----

--nextPart3101854.yE4MISRjWW--
