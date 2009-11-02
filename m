Return-Path: <linux-kernel-owner+w=401wt.eu-S1756461AbZKBR0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbZKBR0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756446AbZKBR0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:26:53 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:43316 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444AbZKBR0v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:26:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=hTz6i9r0drh9KQ+BWKUjU7V9Sn83iN69yQYHAqy51lVd5qgBECi6Gv/MeElFGUwt4L
         fedxDKsm5NFlfirkiIp5twDouKgGfgCR3/SIcr5aWHFos5F2vc3mSaKIHOVq7BlZ2+2P
         fhl0MQITJDyh+WC8c7IijpcQ1+Cj9k1vYa3BA=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Mon, 2 Nov 2009 15:26:36 -0200
Message-ID: <b8bf37780911020926rd5e40b1h957c803f7bb21196@mail.gmail.com>
Subject: [PATCH v2 5/7] vsprintf: reduce code size by avoiding extra check
To: Frederic Weisbecker <fweisbec@gmail.com>, laijs@cn.fujitsu.com,
       mingo@elte.hu, davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fd3098fe2764b049e23ea125a20979410699d257 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Sun, 1 Nov 2009 13:46:26 -0200
Subject: [PATCH v2 5/7] vsprintf: reduce code size by avoiding extra check
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

   text    data     bss     dec     hex filename
  15735       0       8   15743    3d7f lib/vsprintf.o-before
  15719       0       8   15727    3d6f lib/vsprintf.o-minus-double-check

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 lib/vsprintf.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 14e4197..af79152 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -747,8 +747,9 @@ static char *ip6_compressed_string(char *p, const
char *addr)
 				p = pack_hex_byte(p, hi);
 			else
 				*p++ = hex_asc_lo(hi);
+			p = pack_hex_byte(p, lo);
 		}
-		if (hi || lo > 0x0f)
+		else if (lo > 0x0f)
 			p = pack_hex_byte(p, lo);
 		else
 			*p++ = hex_asc_lo(lo);
-- 
1.6.5.2.140.g5f809
