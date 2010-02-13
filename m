Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0BMM2O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 07:28:14 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:45606 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab0BMM2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 07:28:12 -0500
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Feb 2010 07:28:11 EST
Date: Sat, 13 Feb 2010 13:22:37 +0100
From: Pierre Ossman <pierre-list@ossman.eu>
To: "Hardys Lv(WH)" <hardys.lv@o2micro.com>, linux-mmc@vger.kernel.org
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH] v2.6.32: Add new device IDs and quircks for
 MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND SDIO SUBSYSTEM
Message-ID: <20100213132237.7c35603a@mjolnir.ossman.eu>
In-Reply-To: <84ABC3D12F787146ABE5E1D559D966F3AD49A9@cd-exch2003.nt-fsrvr.o2micro.com>
References: <84ABC3D12F787146ABE5E1D559D966F3AD49A9@cd-exch2003.nt-fsrvr.o2micro.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-20385-1266063760-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-20385-1266063760-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This should go to linux-mmc@vger.kernel.org (cc:d). And you should
probably resend it with the patch as an attachment as your mail client
seems to fudge it up pretty heavily. Lastly, have a look at
Documentation/SubmittingPatches as there is some formalia you need to
take care of.

Rgds
Pierre

On Thu, 4 Feb 2010 15:23:29 +0800
"Hardys Lv(WH)" <hardys.lv@o2micro.com> wrote:

> =20
>=20
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
>=20
> index e035664..f38bd1f 100644
>=20
> --- a/drivers/mmc/host/sdhci-pci.c
>=20
> +++ b/drivers/mmc/host/sdhci-pci.c
>=20
> @@ -285,6 +285,73 @@ static const struct sdhci_pci_fixes sdhci_jmicron =3D
> {
>=20
>         .resume             =3D jmicron_resume,
>=20
>  };
>=20
> =20
>=20
> +/* SysKonnect CardBus2SDIO extra registers */
>=20
> +#define SYSKT_CTRL             0x200
>=20
> +#define SYSKT_RDFIFO_STAT       0x204
>=20
> +#define SYSKT_WRFIFO_STAT       0x208
>=20
> +#define SYSKT_POWER_DATA       0x20c
>=20
> +#define   SYSKT_POWER_330    0xef
>=20
> +#define   SYSKT_POWER_300    0xf8
>=20
> +#define   SYSKT_POWER_184    0xcc
>=20
> +#define SYSKT_POWER_CMD                0x20d
>=20
> +#define   SYSKT_POWER_START        (1 << 7)
>=20
> +#define SYSKT_POWER_STATUS 0x20e
>=20
> +#define   SYSKT_POWER_STATUS_OK       (1 << 0)
>=20
> +#define SYSKT_BOARD_REV                  0x210
>=20
> +#define SYSKT_CHIP_REV             0x211
>=20
> +#define SYSKT_CONF_DATA          0x212
>=20
> +#define   SYSKT_CONF_DATA_1V8     (1 << 2)
>=20
> +#define   SYSKT_CONF_DATA_2V5     (1 << 1)
>=20
> +#define   SYSKT_CONF_DATA_3V3     (1 << 0)
>=20
> +
>=20
> +static int syskt_probe(struct sdhci_pci_chip *chip)
>=20
> +{
>=20
> +       if ((chip->pdev->class & 0x0000FF) =3D=3D PCI_SDHCI_IFVENDOR) {
>=20
> +                chip->pdev->class &=3D ~0x0000FF;
>=20
> +                chip->pdev->class |=3D PCI_SDHCI_IFDMA;
>=20
> +       }
>=20
> +       return 0;
>=20
> +}
>=20
> +
>=20
> +static int syskt_probe_slot(struct sdhci_pci_slot *slot)
>=20
> +{
>=20
> +       int tm, ps;
>=20
> +
>=20
> +       u8 board_rev =3D readb(slot->host->ioaddr + SYSKT_BOARD_REV);
>=20
> +       u8  chip_rev =3D readb(slot->host->ioaddr + SYSKT_CHIP_REV);
>=20
> +       dev_info(&slot->chip->pdev->dev, "SysKonnect CardBus2SDIO, "
>=20
> +                                            "board rev %d.%d, chip rev
> %d.%d\n",
>=20
> +                                            board_rev >> 4, board_rev &
> 0xf,
>=20
> +                                            chip_rev >> 4,  chip_rev &
> 0xf);
>=20
> +       if (chip_rev >=3D 0x20)
>=20
> +                slot->host->quirks |=3D SDHCI_QUIRK_FORCE_DMA;
>=20
> +
>=20
> +       writeb(SYSKT_POWER_330, slot->host->ioaddr + SYSKT_POWER_DATA);
>=20
> +       writeb(SYSKT_POWER_START, slot->host->ioaddr + SYSKT_POWER_CMD);
>=20
> +       udelay(50);
>=20
> +       tm =3D 10;  /* Wait max 1 ms */
>=20
> +       do {
>=20
> +                ps =3D readw(slot->host->ioaddr + SYSKT_POWER_STATUS);
>=20
> +                if (ps & SYSKT_POWER_STATUS_OK)
>=20
> +                          break;
>=20
> +                udelay(100);
>=20
> +       } while (--tm);
>=20
> +       if (!tm) {
>=20
> +                dev_err(&slot->chip->pdev->dev,
>=20
> +                          "power regulator never stabilized");
>=20
> +                writeb(0, slot->host->ioaddr + SYSKT_POWER_CMD);
>=20
> +                return -ENODEV;
>=20
> +       }
>=20
> +
>=20
> +       return 0;
>=20
> +}
>=20
> +
>=20
> +static const struct sdhci_pci_fixes sdhci_syskt =3D {
>=20
> +       .quirks                =3D SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER,
>=20
> +       .probe                =3D syskt_probe,
>=20
> +       .probe_slot       =3D syskt_probe_slot,
>=20
> +};
>=20
> +
>=20
>  static int via_probe(struct sdhci_pci_chip *chip)
>=20
>  {
>=20
>         if (chip->pdev->revision =3D=3D 0x10)
>=20
> @@ -297,6 +364,14 @@ static const struct sdhci_pci_fixes sdhci_via =3D {
>=20
>         .probe                =3D via_probe,
>=20
>  };
>=20
> =20
>=20
> +#ifndef PCI_DEVICE_ID_O2_8120
>=20
> +#define PCI_DEVICE_ID_O2_8120                  0x8120
>=20
> +#endif
>=20
> +
>=20
> +#ifndef PCI_DEVICE_ID_O2_8220
>=20
> +#define PCI_DEVICE_ID_O2_8220                  0x8220
>=20
> +#endif
>=20
> +
>=20
>  static const struct pci_device_id pci_ids[] __devinitdata =3D {
>=20
>         {
>=20
>                   .vendor               =3D PCI_VENDOR_ID_RICOH,
>=20
> @@ -363,6 +438,14 @@ static const struct pci_device_id pci_ids[]
> __devinitdata =3D {
>=20
>         },
>=20
> =20
>=20
>         {
>=20
> +                .vendor               =3D PCI_VENDOR_ID_SYSKONNECT,
>=20
> +                .device               =3D 0x8000,
>=20
> +                .subvendor        =3D PCI_ANY_ID,
>=20
> +                .subdevice        =3D PCI_ANY_ID,
>=20
> +                .driver_data       =3D (kernel_ulong_t)&sdhci_syskt,
>=20
> +       },
>=20
> +
>=20
> +       {
>=20
>                   .vendor               =3D PCI_VENDOR_ID_VIA,
>=20
>                   .device               =3D 0x95d0,
>=20
>                   .subvendor        =3D PCI_ANY_ID,
>=20
> @@ -370,6 +453,22 @@ static const struct pci_device_id pci_ids[]
> __devinitdata =3D {
>=20
>                   .driver_data       =3D (kernel_ulong_t)&sdhci_via,
>=20
>         },
>=20
> =20
>=20
> +       {
>=20
> +                .vendor               =3D PCI_VENDOR_ID_O2,
>=20
> +                .device               =3D PCI_DEVICE_ID_O2_8120,
>=20
> +                .subvendor        =3D PCI_ANY_ID,
>=20
> +                .subdevice        =3D PCI_ANY_ID,
>=20
> +                .driver_data       =3D (kernel_ulong_t)&sdhci_o2,
>=20
> +       },
>=20
> +
>=20
> +       {
>=20
> +                .vendor               =3D PCI_VENDOR_ID_O2,
>=20
> +                .device               =3D PCI_DEVICE_ID_O2_8220,
>=20
> +                .subvendor        =3D PCI_ANY_ID,
>=20
> +                .subdevice        =3D PCI_ANY_ID,
>=20
> +                .driver_data       =3D (kernel_ulong_t)&sdhci_o2,
>=20
> +       },
>=20
> +
>=20
>         {        /* Generic SD host controller */
>=20
>                   PCI_DEVICE_CLASS((PCI_CLASS_SYSTEM_SDHCI << 8),
> 0xFFFF00)
>=20
>         },
>=20
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>=20
> index c279fbc..b2c26ff 100644
>=20
> --- a/drivers/mmc/host/sdhci.c
>=20
> +++ b/drivers/mmc/host/sdhci.c
>=20
> @@ -478,6 +478,15 @@ static int sdhci_adma_table_pre(struct sdhci_host
> *host,
>=20
>                   desc[1] =3D 0x00;
>=20
>                   desc[0] =3D 0x21; /* tran, valid */
>=20
> =20
>=20
> +                /*
>=20
> +                * Some host controller only doesn't support attribute
> nop
>=20
> +                * as the last ADMA table entry.
>=20
> +               */
>=20
> +                if ((host->quirks & SDHCI_QUICK_ADMA_TABLE_ENTRY) &&
>=20
> +                          (i =3D=3D (host->sg_count-1))) {
>=20
> +                          desc[0] =3D 0x23; /* tran, valid, end*/
>=20
> +                }
>=20
> +
>=20
>                   desc +=3D 8;
>=20
> =20
>=20
>                   /*
>=20
> diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
>=20
> index ce5f1d7..2fa8245 100644
>=20
> --- a/drivers/mmc/host/sdhci.h
>=20
> +++ b/drivers/mmc/host/sdhci.h
>=20
> @@ -8,6 +8,8 @@
>=20
>   * the Free Software Foundation; either version 2 of the License, or
> (at
>=20
>   * your option) any later version.
>=20
>   */
>=20
> +#ifndef __SDHCI_H
>=20
> +#define __SDHCI_H
>=20
> =20
>=20
>  #include <linux/scatterlist.h>
>=20
>  #include <linux/compiler.h>
>=20
> @@ -234,6 +236,8 @@ struct sdhci_host {
>=20
>  #define SDHCI_QUIRK_DELAY_AFTER_POWER                     (1<<23)
>=20
>  /* Controller uses SDCLK instead of TMCLK for data timeouts */
>=20
>  #define SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK                (1<<24)
>=20
> +/* Controller only support ADMA table entry with attr=3D0x21 or 0x23 */
>=20
> +#define SDHCI_QUICK_ADMA_TABLE_ENTRY                        (1<<25)
>=20
> =20
>=20
>         int                        irq;             /* Device IRQ */
>=20
>         void __iomem *                  ioaddr;               /* Mapped
> address */
>=20
> @@ -408,3 +412,5 @@ extern void sdhci_remove_host(struct sdhci_host
> *host, int dead);
>=20
>  extern int sdhci_suspend_host(struct sdhci_host *host, pm_message_t
> state);
>=20
>  extern int sdhci_resume_host(struct sdhci_host *host);
>=20
>  #endif
>=20
> +
>=20
> +#endif /* __SDHCI_H */
>=20


--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-20385-1266063760-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAkt2mZAACgkQ7b8eESbyJLgLrwCfXDR3T6/IkaSVWAQHEQ1O+qP9
Gr8AoLgqBN2lwAGSGyCS0cCfWiI558dE
=l7G1
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-20385-1266063760-0001-2--
