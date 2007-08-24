Return-Path: <linux-kernel-owner+w=401wt.eu-S1760459AbXHXHL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459AbXHXHL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 03:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbXHXHLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 03:11:48 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:53686 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbXHXHLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 03:11:48 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2007 03:11:48 EDT
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-scsi@vger.kernel.org
Subject: Re: [PATCH 19/30] scsi: Remove explicit casts of [kv]alloc return values in osst driver
Date: Fri, 24 Aug 2007 09:04:58 +0200
User-Agent: KMail/1.9.7
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Willem Riede <osst@riede.org>, osst-users@lists.sourceforge.net
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com> <aaed77aa8511322bc32b406a952c7c960091ff3b.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <aaed77aa8511322bc32b406a952c7c960091ff3b.1187912217.git.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1560431.S3jFJPvFbj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708240905.04994.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1560431.S3jFJPvFbj
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Jesper Juhl wrote:
> [kv]alloc() return void *. No need to cast the return value.

> @@ -5756,7 +5756,7 @@ static int osst_probe(struct device *dev)
>  	write_lock(&os_scsi_tapes_lock);
>  	if (os_scsi_tapes == NULL) {
>  		os_scsi_tapes =
> -			(struct osst_tape **)kmalloc(osst_max_dev * sizeof(struct osst_tape *),
> +			kmalloc(osst_max_dev * sizeof(struct osst_tape *),
>  				   GFP_ATOMIC);
>  		if (os_scsi_tapes == NULL) {
>  			write_unlock(&os_scsi_tapes_lock);

Three lines later:

		for (i=0; i < osst_max_dev; ++i) os_scsi_tapes[i] = NULL;

This wants to be

os_scsi_tapes = kcalloc(osst_max_dev, sizeof(struct osst_tape *), GFP_ATOMIC);

Eike

--nextPart1560431.S3jFJPvFbj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGzoMgXKSJPmm5/E4RAr/CAJwKMeoBd9YsFnCF1hZQqQEOl6HwzQCeOY4w
q/aoFsU+p8qt4Ax4dk4CZHM=
=f5Xx
-----END PGP SIGNATURE-----

--nextPart1560431.S3jFJPvFbj--
