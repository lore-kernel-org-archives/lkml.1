Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbZGAHEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbZGAHEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZGAHEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:04:37 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:64720 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZGAHEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:04:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=T/O5Wf23Nybrrjd5R471f5bEWwTioWvOgr6Gbcu5oRX+PHRtBaA+R7RI7LyEdNJJZB
         lUmHJp0nA4fAoJD9p4Q501rozjj9eowBabECoZmtUslmE3aOfaW2I2lsmQUWOQDT8cdb
         1G8JKTq8T5u4b4bSA+lrAUogcySV4HopXI3CA=
Subject: Re: [PATCH] MFD: ezx-pcap, fix lock imbalance
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: sameo@linux.intel.com, laforge@openezx.org, linux-kernel@vger.kernel.org
In-Reply-To: <1246431187-23684-1-git-send-email-jirislaby@gmail.com>
References: <1246431187-23684-1-git-send-email-jirislaby@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3D8uMHZMawumnjsFp/HV"
Date: Wed, 01 Jul 2009 04:04:31 -0300
Message-Id: <1246431871.19661.8.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3D8uMHZMawumnjsFp/HV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Em Qua, 2009-07-01 =C3=A0s 08:53 +0200, Jiri Slaby escreveu:
> There is an omitted unlock in pcap_adc_irq ISR on one fail path. Fix that=
.
>=20
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

I would be happy to ack this, however, you are late. ;)

http://patchwork.kernel.org/patch/32002/

Samuel seems to be unreachable ATM, last email I have from him is from
June 16. :(

> ---
>  drivers/mfd/ezx-pcap.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
> index 671a7ef..c1de4af 100644
> --- a/drivers/mfd/ezx-pcap.c
> +++ b/drivers/mfd/ezx-pcap.c
> @@ -238,8 +238,10 @@ static irqreturn_t pcap_adc_irq(int irq, void *_pcap=
)
>  	mutex_lock(&pcap->adc_mutex);
>  	req =3D pcap->adc_queue[pcap->adc_head];
> =20
> -	if (WARN(!req, KERN_WARNING "adc irq without pending request\n"))
> +	if (WARN(!req, KERN_WARNING "adc irq without pending request\n")) {
> +		mutex_unlock(&pcap->adc_mutex);
>  		return IRQ_HANDLED;
> +	}
> =20
>  	/* read requested channels results */
>  	ezx_pcap_read(pcap, PCAP_REG_ADC, &tmp);

--=20
Daniel Ribeiro

--=-3D8uMHZMawumnjsFp/HV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpLCnQACgkQw3OYl0G0liSXZwCgmNpvvcHpSv4SOCE/Epx6Ees0
HREAn3dHUfodnq+fl0Hd3ZJiq/SAhdlb
=3KNp
-----END PGP SIGNATURE-----

--=-3D8uMHZMawumnjsFp/HV--

