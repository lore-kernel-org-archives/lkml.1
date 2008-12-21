Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbYLUO3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbYLUO3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 09:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYLUO3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 09:29:24 -0500
Received: from server.drzeus.cx ([85.8.24.28]:51628 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751898AbYLUO3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 09:29:24 -0500
Date: Sun, 21 Dec 2008 15:29:15 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mmc_block: ensure all sectors that do not have
 errors are read
Message-ID: <20081221152915.352d5c05@mjolnir.drzeus.cx>
In-Reply-To: <49390BD7.3040305@nokia.com>
References: <48F74121.1020409@nokia.com>
	<20081026123228.26d2a86a@mjolnir.drzeus.cx>
	<4908727F.5080003@nokia.com>
	<20081130200558.21f2561b@mjolnir.drzeus.cx>
	<49390BD7.3040305@nokia.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-26151-1229869761-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-26151-1229869761-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 05 Dec 2008 13:09:11 +0200
Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:

> @@ -281,6 +289,16 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, st=
ruct request *req)
>  		brq.data.sg =3D mq->sg;
>  		brq.data.sg_len =3D mmc_queue_map_sg(mq);
> =20
> +		/*
> +		 * Some drivers expect the sg list to be the same size as the
> +		 * request, which it won't be if we have fallen back to do
> +		 * one sector at a time.
> +		 */
> +		if (disable_multi) {
> +			brq.data.sg->length =3D 512;
> +			brq.data.sg_len =3D 1;
> +		}
> +
>  		mmc_queue_bounce_pre(mq);
> =20
>  		mmc_wait_for_req(card->host, &brq.mrq);

Unfortunately, there is no guarantee that the sg list will be sector
aligned. Look at the code removed in f3eb0aaa02 for how to handle this
properly.

Other than that, the patch looks ready to go.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-26151-1229869761-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklOUsAACgkQ7b8eESbyJLhYagCgjRRamSXbwuWKrmMhlocfi/HE
NfwAoN/WIiP29KRgd7w7Ss2Gj9wTe72l
=zAjA
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-26151-1229869761-0001-2--
