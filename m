Return-Path: <linux-kernel-owner+w=401wt.eu-S1758410AbXKNMjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410AbXKNMjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 07:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbXKNMjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 07:39:37 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:58652 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbXKNMjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 07:39:36 -0500
From: Rolf Eike Beer <eike-hotplug@sf-tec.de>
To: pcihpd-discuss@lists.sourceforge.net
Subject: Re: [Pcihpd-discuss] [PATCH 2/5] Construct one fakephp slot per pci slot
Date: Wed, 14 Nov 2007 13:39:26 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alex Chiang <achiang@hp.com>, gregkh@suse.de, kristen.c.accardi@intel.com,
       lenb@kernel.org, matthew@wil.cx, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113001336.GC13341@ldl.fc.hp.com>
In-Reply-To: <20071113001336.GC13341@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1206831.H0q6VCQRHC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711141339.31839.eike-hotplug@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1206831.H0q6VCQRHC
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Alex Chiang wrote:
> Register one slot per slot, rather than one slot per function.
> Change the name of the slot to fake%d instead of the pci address.
>
> Signed-off-by: Alex Chiang <achiang@hp.com>
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> ---
>  drivers/pci/hotplug/fakephp.c |   75
> +++++++++++++++-------------------------- 1 files changed, 27
> insertions(+), 48 deletions(-)
>
> diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
> index 027f686..828335e 100644
> --- a/drivers/pci/hotplug/fakephp.c
> +++ b/drivers/pci/hotplug/fakephp.c
> @@ -93,6 +93,7 @@ static int add_slot(struct pci_dev *dev)
>  	struct dummy_slot *dslot;
>  	struct hotplug_slot *slot;
>  	int retval =3D -ENOMEM;
> +	static int count =3D 1;
>
>  	slot =3D kzalloc(sizeof(struct hotplug_slot), GFP_KERNEL);
>  	if (!slot)
> @@ -106,7 +107,8 @@ static int add_slot(struct pci_dev *dev)
>  	slot->info->max_bus_speed =3D PCI_SPEED_UNKNOWN;
>  	slot->info->cur_bus_speed =3D PCI_SPEED_UNKNOWN;
>
> -	slot->name =3D &dev->dev.bus_id[0];
> +	slot->name =3D kmalloc(8, GFP_KERNEL);
> +	sprintf(slot->name, "fake%d", count++);
>  	dbg("slot->name =3D %s\n", slot->name);
>
>  	dslot =3D kmalloc(sizeof(struct dummy_slot), GFP_KERNEL);

This is ugly. Please do it the way we already do e.g. for acpiphp: add a=20
char[8] to "struct dummy_slot" and just reference that here. Or better do=20
what this name suggests: kill fakephp completely and use dummyphp[1] instea=
d.

Eike

1) http://opensource.sf-tec.de/kernel/

--nextPart1206831.H0q6VCQRHC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHOuyDXKSJPmm5/E4RAkxCAJ9RdALyQDDbvh0KLyl8zHRqDiK4fwCglC6S
zUbLhcwUg92z/D2QV/hdWds=
=ZVtV
-----END PGP SIGNATURE-----

--nextPart1206831.H0q6VCQRHC--
