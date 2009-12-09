Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbZLITZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbZLITZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbZLITZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:25:00 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:54109 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757330AbZLITY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:24:59 -0500
Date: Wed, 9 Dec 2009 20:25:04 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 9/12] drivers/staging: Correct size given to memset
Message-ID: <Pine.LNX.4.64.0912092024480.1870@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Memset should be given the size of the structure, not the size of the pointer.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T *x;
expression E;
@@

memset(x, E, sizeof(
+ *
 x))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/wlan-ng/prism2fw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -439,7 +439,7 @@ void free_chunks(imgchunk_t *fchunk, uns
 		}
 	}
 	*nfchunks = 0;
-	memset(fchunk, 0, sizeof(fchunk));
+	memset(fchunk, 0, sizeof(*fchunk));
 
 }
 
