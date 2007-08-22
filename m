Return-Path: <linux-kernel-owner+w=401wt.eu-S933212AbXHVSP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbXHVSP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759745AbXHVSPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:15:13 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:42392 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761484AbXHVSPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:15:10 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [2.6.20.17 review 35/58] forcedeth bug fix: realtek phy
Date: Wed, 22 Aug 2007 20:15:03 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>, Greg Kroah-Hartman <gregkh@suse.de>
References: <20070822083844.%N@1wt.eu> <20070822084026.%N@1wt.eu>
In-Reply-To: <20070822084026.%N@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3351992.1b2ERlbxTu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708222015.04141.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3351992.1b2ERlbxTu
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

even if Greg is waiting for some special invitation=20
(http://lkml.org/lkml/2007/8/14/229), I suggest putting this patch by Ayaz =
on=20
top:

http://lkml.org/lkml/2007/8/10/296

Perhaps Ayaz wants to give Greg the clarification he needs... :sigh:

bye,

Prakash


On the day of Wednesday 22 August 2007 Willy Tarreau hast written:
> This patch contains errata fixes for the realtek phy. It only renamed the
> defines to be phy specific.
>
> Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  drivers/net/forcedeth.c |   54
> +++++++++++++++++++++++++++++++++++++++++++++++ 1 files changed, 54
> insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
> index c383dc3..dbfdbed 100644
> --- a/drivers/net/forcedeth.c
> +++ b/drivers/net/forcedeth.c
> @@ -554,6 +554,7 @@ union ring_type {
>  #define PHY_OUI_MARVELL	0x5043
>  #define PHY_OUI_CICADA	0x03f1
>  #define PHY_OUI_VITESSE	0x01c1
> +#define PHY_OUI_REALTEK	0x01c1
>  #define PHYID1_OUI_MASK	0x03ff
>  #define PHYID1_OUI_SHFT	6
>  #define PHYID2_OUI_MASK	0xfc00
> @@ -583,6 +584,13 @@ union ring_type {
>  #define PHY_VITESSE_INIT8	0x0100
>  #define PHY_VITESSE_INIT9	0x8f82
>  #define PHY_VITESSE_INIT10	0x0
> +#define PHY_REALTEK_INIT_REG1	0x1f
> +#define PHY_REALTEK_INIT_REG2	0x19
> +#define PHY_REALTEK_INIT_REG3	0x13
> +#define PHY_REALTEK_INIT1	0x0000
> +#define PHY_REALTEK_INIT2	0x8e00
> +#define PHY_REALTEK_INIT3	0x0001
> +#define PHY_REALTEK_INIT4	0xad17
>
>  #define PHY_GIGABIT	0x0100
>
> @@ -1106,6 +1114,28 @@ static int phy_init(struct net_device *dev)
>  			return PHY_ERROR;
>  		}
>  	}
> +	if (np->phy_oui =3D=3D PHY_OUI_REALTEK) {
> +		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT1))
> { +			printk(KERN_INFO "%s: phy init failed.
> ", pci_name(np->pci_dev));
> +			return PHY_ERROR;
> +		}
> +		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG2, PHY_REALTEK_INIT2))
> { +			printk(KERN_INFO "%s: phy init failed.
> ", pci_name(np->pci_dev));
> +			return PHY_ERROR;
> +		}
> +		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT3))
> { +			printk(KERN_INFO "%s: phy init failed.
> ", pci_name(np->pci_dev));
> +			return PHY_ERROR;
> +		}
> +		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG3, PHY_REALTEK_INIT4))
> { +			printk(KERN_INFO "%s: phy init failed.
> ", pci_name(np->pci_dev));
> +			return PHY_ERROR;
> +		}
> +		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT1))
> { +			printk(KERN_INFO "%s: phy init failed.
> ", pci_name(np->pci_dev));
> +			return PHY_ERROR;
> +		}
> +	}
>
>  	/* set advertise register */
>  	reg =3D mii_rw(dev, np->phyaddr, MII_ADVERTISE, MII_READ);
> @@ -1242,6 +1272,30 @@ static int phy_init(struct net_device *dev)
>  			return PHY_ERROR;
>  		}
>  	}
> +	if (np->phy_oui =3D=3D PHY_OUI_REALTEK) {
> +		/* reset could have cleared these out, set them back */
> +		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT1))
> { +			printk(KERN_INFO "%s: phy init failed.
> ", pci_name(np->pci_dev));
> +			return PHY_ERROR;
> +		}
> +		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG2, PHY_REALTEK_INIT2))
> { +			printk(KERN_INFO "%s: phy init failed.
> ", pci_name(np->pci_dev));
> +			return PHY_ERROR;
> +		}
> +		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT3))
> { +			printk(KERN_INFO "%s: phy init failed.
> ", pci_name(np->pci_dev));
> +			return PHY_ERROR;
> +		}
> +		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG3, PHY_REALTEK_INIT4))
> { +			printk(KERN_INFO "%s: phy init failed.
> ", pci_name(np->pci_dev));
> +			return PHY_ERROR;
> +		}
> +		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT1))
> { +			printk(KERN_INFO "%s: phy init failed.
> ", pci_name(np->pci_dev));
> +			return PHY_ERROR;
> +		}
> +	}
> +
>  	/* some phys clear out pause advertisment on reset, set it back */
>  	mii_rw(dev, np->phyaddr, MII_ADVERTISE, reg);
>
> --
> 1.5.2.5



=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart3351992.1b2ERlbxTu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.6 (GNU/Linux)

iD8DBQBGzH0oxU2n/+9+t5gRAt9gAKD3Eaclsfc4CxaD3YoYgSdN9w3hWACeOXzB
9xc0brrJMNNvRT9iekxOm04=
=lfnj
-----END PGP SIGNATURE-----

--nextPart3351992.1b2ERlbxTu--
