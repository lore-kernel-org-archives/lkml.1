Return-Path: <linux-kernel-owner+w=401wt.eu-S1764482AbXHXAKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764482AbXHXAKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932297AbXHXAJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:09:52 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:8003 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759835AbXHXAJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=m28MKdKzC2cILl0y1fEZC3/P2P1ITZ1SwUDVhGZwjLnAXewEEWvlxR7FxkXecZoVIrxjvb1Zn1ggmWO7q6ZiN6u7ypPYAmz5jOkG6LnUMet+lxFzgcXgrRFCpoxZ5fqN2QeHPUsG7WmaWLFsv5SnRDp3gTTZTOjn/LU+krIhwjw=
Message-Id: <fd58f69b12c07872b351261199f3c677c6786f06.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:06:58 +0200
Subject: [PATCH 16/30] net: Avoid pointless allocation casts in BSD compression module
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The general kernel memory allocation functions return void pointers
and there is no need to cast their return values.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/net/bsd_comp.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bsd_comp.c b/drivers/net/bsd_comp.c
index 202d4a4..88edb98 100644
--- a/drivers/net/bsd_comp.c
+++ b/drivers/net/bsd_comp.c
@@ -406,8 +406,7 @@ static void *bsd_alloc (unsigned char *options, int opt_len, int decomp)
  * Allocate space for the dictionary. This may be more than one page in
  * length.
  */
-    db->dict = (struct bsd_dict *) vmalloc (hsize *
-					    sizeof (struct bsd_dict));
+    db->dict = vmalloc(hsize * sizeof(struct bsd_dict));
     if (!db->dict)
       {
 	bsd_free (db);
@@ -426,8 +425,7 @@ static void *bsd_alloc (unsigned char *options, int opt_len, int decomp)
  */
     else
       {
-        db->lens = (unsigned short *) vmalloc ((maxmaxcode + 1) *
-					       sizeof (db->lens[0]));
+        db->lens = vmalloc((maxmaxcode + 1) * sizeof(db->lens[0]));
 	if (!db->lens)
 	  {
 	    bsd_free (db);
-- 
1.5.2.2

