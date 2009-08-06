Return-Path: <linux-kernel-owner+w=401wt.eu-S1751383AbZHFSG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbZHFSG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 14:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbZHFSG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 14:06:28 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:45234 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbZHFSG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 14:06:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=AqVaLJjCHXAO7ntpN/Ym/eg+a0jhXLWqRCXptBkR0ACck/Plz547TTivvt0dQmV5tx
         Bv9nLtcb9fOEOrySSCcFi7nwOUVUOXzAjY0a5yOmq2781O5U7dySQoG2bTShO+gbZcs9
         A+MJCoCy7aQzJs+y5eDntt2WoRX0vixjaSdsg=
Date: Thu, 6 Aug 2009 21:09:30 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Make shr to divide by power of 2
Message-ID: <20090806180930.GA3004@localdomain.by>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Andrew,

drivers/video/console/bitblit.c
'shr' is used to divide by 8 except 'static void bit_putcs'.

Of course, compiler supposed to do something like
	add    $0x7,%eax
	shr    $0x3,%eax
instead of div. Should we rely on this?
============

Make an arithmetic right shift to divide by power of 2.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
diff --git a/drivers/video/console/bitblit.c b/drivers/video/console/bitblit.c
index 69864b1..b816151 100644
--- a/drivers/video/console/bitblit.c
+++ b/drivers/video/console/bitblit.c
@@ -144,7 +144,7 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
 		      int fg, int bg)
 {
 	struct fb_image image;
-	u32 width = (vc->vc_font.width + 7)/8;
+	u32 width = (vc->vc_font.width + 7) >> 3;
 	u32 cellsize = width * vc->vc_font.height;
 	u32 maxcnt = info->pixmap.size/cellsize;
 	u32 scan_align = info->pixmap.scan_align - 1;

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkp7HFoACgkQfKHnntdSXjTKHQQA2LRgBKERxnGhcZNS8M9PIyhv
DMrPF4ei2EsEEAzlIkLByBmbwOp+uoFiFBVDoA7YUa3HfHx6gQ13Gg9vR/R9xRuN
q3a4pmHbtXs7ZQK9mLyVmUJS+/w5d+63quL6Bvn+SFkd/yWjcl4NlU3YevR09vMi
q+Qx67Fm6AyAoZ8LURc=
=Gt+C
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
