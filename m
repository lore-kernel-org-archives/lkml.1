Return-Path: <linux-kernel-owner+w=401wt.eu-S1751535AbZG2IaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbZG2IaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 04:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZG2IaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 04:30:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:59671 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751068AbZG2IaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 04:30:05 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/dLmZJ2wLdupfu5s3nnP9kLd5f55OCv1i7m/NwfZ
	niZ9TC9FlVpUXy
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-fbdev-devel@lists.sourceforge.net
Subject: fbmon.c: err not needed in edid_checksum()
Date: Wed, 29 Jul 2009 10:30:03 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907291030.03277.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMO that variable isn't needed.

Signed-off-by: Toralf Foerster <toralf.foerster@gmx.de>
---
drivers/video/fbmon.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index e1b7073..cea7561 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -257,7 +257,7 @@ static void fix_edid(unsigned char *edid, int fix)
 static int edid_checksum(unsigned char *edid)
 {
 	unsigned char csum = 0, all_null = 0;
-	int i, err = 0, fix = check_edid(edid);
+	int i, fix = check_edid(edid);
 
 	if (fix)
 		fix_edid(edid, fix);
@@ -269,10 +269,10 @@ static int edid_checksum(unsigned char *edid)
 
 	if (csum == 0x00 && all_null) {
 		/* checksum passed, everything's good */
-		err = 1;
+		return 1;
 	}
 
-	return err;
+	return 0;
 }
 
 static int edid_check_header(unsigned char *edid)

-- 
MfG/Sincerely

Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

