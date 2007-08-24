Return-Path: <linux-kernel-owner+w=401wt.eu-S934094AbXHXAMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094AbXHXAMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964817AbXHXAM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:12:26 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:9849 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964800AbXHXAMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:12:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=owSaILWYoenyjTlVHMGcTVAd/2K7Bk1nOxrffsJHYFuM9kvKB3ONWAKOqi7Q2S3vFx8uca/JK9MffX2sEu6tziuCyI7W9zqJdI63VeG9m9F0bKC+U975dM/bGtBLjX81QLdYcIrvQCcFa85zTwsEqqtdyRV24KgDDXzu07B8uKs=
Message-Id: <85cd9d8df6b94f6dbf4842a4b2aabe05737a3b46.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:09:34 +0200
Subject: [PATCH 17/30] isdn: Get rid of some pointless allocation casts in common and bsd comp.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Karsten Keil <kkeil@suse.de>, Kai Germaschewski <kai.germaschewski@gmx.de>,
       isdn4linux@listserv.isdn4linux.de,
       Michael Hipp <Michael.Hipp@student.uni-tuebingen.de>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc() returns a void pointer - no need to cast the return value.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/isdn/i4l/isdn_bsdcomp.c |    5 ++---
 drivers/isdn/i4l/isdn_common.c  |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_bsdcomp.c b/drivers/isdn/i4l/isdn_bsdcomp.c
index 90a2379..02d9918 100644
--- a/drivers/isdn/i4l/isdn_bsdcomp.c
+++ b/drivers/isdn/i4l/isdn_bsdcomp.c
@@ -341,7 +341,7 @@ static void *bsd_alloc (struct isdn_ppp_comp_data *data)
 	 * Allocate space for the dictionary. This may be more than one page in
 	 * length.
 	 */
-	db->dict = (struct bsd_dict *) vmalloc (hsize * sizeof (struct bsd_dict));
+	db->dict = vmalloc(hsize * sizeof(struct bsd_dict));
 	if (!db->dict) {
 		bsd_free (db);
 		return NULL;
@@ -354,8 +354,7 @@ static void *bsd_alloc (struct isdn_ppp_comp_data *data)
 	if (!decomp)
 		db->lens = NULL;
 	else {
-		db->lens = (unsigned short *) vmalloc ((maxmaxcode + 1) *
-			sizeof (db->lens[0]));
+		db->lens = vmalloc((maxmaxcode + 1) * sizeof(db->lens[0]));
 		if (!db->lens) {
 			bsd_free (db);
 			return (NULL);
diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index c97330b..ec5f404 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -2291,7 +2291,7 @@ static int __init isdn_init(void)
 	int i;
 	char tmprev[50];
 
-	if (!(dev = (isdn_dev *) vmalloc(sizeof(isdn_dev)))) {
+	if (!(dev = vmalloc(sizeof(isdn_dev)))) {
 		printk(KERN_WARNING "isdn: Could not allocate device-struct.\n");
 		return -EIO;
 	}
-- 
1.5.2.2

