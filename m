Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbYC0OCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbYC0OCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 10:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbYC0OCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 10:02:24 -0400
Received: from mivlgu.ru ([195.20.195.134]:52695 "EHLO mail.mivlgu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371AbYC0OCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 10:02:23 -0400
X-Greylist: delayed 1264 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Mar 2008 10:02:23 EDT
Date: Thu, 27 Mar 2008 16:41:14 +0300
From: Sergey Vlasov <vsu@altlinux.ru>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 6/7] omfs: add checksumming routines
Message-Id: <20080327164114.6c9fc82c.vsu@altlinux.ru>
In-Reply-To: <1206578760-9050-6-git-send-email-me@bobcopeland.com>
References: <1206578760-9050-6-git-send-email-me@bobcopeland.com>
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.12.1; i586-alt-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__27_Mar_2008_16_41_14_+0300_f21iA1aVL5P6nYLo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Mar_2008_16_41_14_+0300_f21iA1aVL5P6nYLo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Wed, 26 Mar 2008 20:45:59 -0400 Bob Copeland wrote:

> OMFS checksums the metadata of all filesystem objects.  This change adds
> the necessary functions to do so.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  fs/omfs/checksum.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 48 insertions(+), 0 deletions(-)
>  create mode 100644 fs/omfs/checksum.c
>
> diff --git a/fs/omfs/checksum.c b/fs/omfs/checksum.c
> new file mode 100644
> index 0000000..d6f1023
> --- /dev/null
> +++ b/fs/omfs/checksum.c
> @@ -0,0 +1,48 @@
> +#include <linux/fs.h>
> +#include <linux/buffer_head.h>
> +#include "omfs.h"
> +
> +#define POLY 0x1021
> +
> +/*
> + * crc-ccitt with MSB first (i.e., backwards), so we can't use the
> + * kernel table as-is.
> + */
> +static u16 omfs_crc(u16 crc, unsigned char *buf, int count)
> +{
> +	int i, j;
> +	for (i = 0; i < count; i++) {
> +		crc ^= buf[i] << 8;
> +		for (j = 0; j < 8; j++)
> +			crc = (crc << 1) ^ ((crc & 0x8000) ? POLY : 0);
> +	}
> +	return crc;
> +}

Is this the same as crc_itu_t() from lib/crc-itu-t.c (also duplicated
in fs/udf/crc.c)?

--Signature=_Thu__27_Mar_2008_16_41_14_+0300_f21iA1aVL5P6nYLo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFH66P8W82GfkQfsqIRAgMWAKCHMVsjTfL5stKx+UJA0eSG/6V/hwCfcaDy
DQM4bN2RTlEV0yyM7pzVsAI=
=7B6V
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Mar_2008_16_41_14_+0300_f21iA1aVL5P6nYLo--
