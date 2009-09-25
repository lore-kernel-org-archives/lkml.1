Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbZIYG17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbZIYG17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 02:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZIYG15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 02:27:57 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:62410 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZIYG14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 02:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=fz2mNgd/ZqY/6kcXtf0Sw/i0BjLi/q1Z5pMsn3hv25/6jR7yQ2sayOBpHC6kkEZQqQ
         gDlC4DfOVVK+ZbqrtXjDvjcWwwI1iivOV4nzN/uNia4tBpQ3z/y+b1fWSXcCytThxctH
         VnWm2uGn7valZaVjmIYiYjwV+oFu1rdmOlG7w=
Date: Fri, 25 Sep 2009 06:27:34 +0000
From: Andy Spencer <andy753421@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix %*s%n in sscanf
Message-ID: <20090925062734.GA9318@c.hsd1.tn.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_c-9434-1253860078-0001-2"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_c-9434-1253860078-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When using %*s, sscanf should honor conversion specifiers immediately following
the %*s. For example, the following code should find the position of the end of
the string "hello".

  int end;
  char buf[] = "hello    world";
  sscanf(buf, "%*s%n", &end);
  printf("%d\n", end);

Ideally, sscanf would advance the fmt and str pointers the same as it would
without the *, but the code for that is rather complicated and is not included
in the patch.

Please CC me in replies.


Signed-off-by: Andy Spencer <andy753421@gmail.com>

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 73a14b8..da2daf2 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1766,7 +1766,7 @@ int vsscanf(const char * buf, const char * fmt, va_list args)
 		 * advance both strings to next white space
 		 */
 		if (*fmt == '*') {
-			while (!isspace(*fmt) && *fmt)
+			while (!isspace(*fmt) && *fmt != '%' && *fmt)
 				fmt++;
 			while (!isspace(*str) && *str)
 				str++;

--=_c-9434-1253860078-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq8Yu4ACgkQz1OYJ/s1XTDyeACfdPJ/LssxjxubsKbzpDsZ67aS
UpEAoN85t8XYyr/84tdNmFpeiD7kRJNR
=KqoF
-----END PGP SIGNATURE-----

--=_c-9434-1253860078-0001-2--
