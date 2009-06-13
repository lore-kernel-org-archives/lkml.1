Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbZFMLnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbZFMLnl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 07:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZFMLnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 07:43:33 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:41116 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbZFMLnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 07:43:32 -0400
Date: Sat, 13 Jun 2009 13:43:28 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       JosephChan@via.com.tw, Bruce Chang <BruceChang@via.com.tw>
Subject: Re: [PATCH] mmc: Add new via-sdmmc host controller driver
Message-ID: <20090613134328.0c168205@mjolnir.ossman.eu>
In-Reply-To: <20090612075930.GB30843@prithivi.gnumonks.org>
References: <20090612075930.GB30843@prithivi.gnumonks.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-25441-1244893413-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-25441-1244893413-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Jun 2009 15:59:30 +0800
Harald Welte <HaraldWelte@viatech.com> wrote:

> +
> +#define MMC_STOP_TRANSMISSION	12

This define is no longer used.

> +	/* It seems that our DMA can not work normally with 375kHz clock */
> +	/* FIXME: don't brute-force 8MHz but use PIO at 375kHz !! */
> +	addrbase =3D host->pcictrl_mmiobase;
> +	if (readb(addrbase + VIA_CRDR_PCISDCCLK) =3D=3D PCI_CLK_375K) {
> +		dev_info(host->mmc->parent, "forcing card speed to 8MHz\n");
> +		writeb(PCI_CLK_8M, addrbase + VIA_CRDR_PCISDCCLK);
> +	}

This is pretty nasty. Please see if you can provide a workaround some
time soon.

> +	if (ios->power_mode !=3D MMC_POWER_OFF)
> +		via_sdc_set_power(host, ios->vdd);

What if we actually do need to power off?
> +static void __devexit via_sd_remove(struct pci_dev *pcidev)
> +{
> +	struct via_crdr_mmc_host *sdhost;
> +	u8 gatt;
> +
> +	pr_info(DRV_NAME
> +		": VIA SDMMC controller at %s [%04x:%04x] has been removed\n",
> +		pci_name(pcidev), (int)pcidev->vendor, (int)pcidev->device);
> +
> +	sdhost =3D pci_get_drvdata(pcidev);
> +
> +	tasklet_kill(&sdhost->finish_tasklet);
> +
> +	if (&sdhost->timer)
> +		del_timer_sync(&sdhost->timer);
> +
> +	mmc_remove_host(sdhost->mmc);
> +

You need to do the removal as the first step and you might need to
explicitly kill any ongoing requests.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-25441-1244893413-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkozkOQACgkQ7b8eESbyJLjtDACeO3KXmutAvgu001h7QX4fsBpv
1+IAnj47lMXyG0cetnInPKPXVAY48vpX
=K7QD
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-25441-1244893413-0001-2--
