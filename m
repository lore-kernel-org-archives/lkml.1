Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbYIZNYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbYIZNYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 09:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYIZNXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 09:23:55 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:60668 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbYIZNXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 09:23:54 -0400
From: Julien Brunel <brunel@diku.dk>
To: tiwai@suse.de, liam.girdwood@wolfsonmicro.com,
       broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] sound/soc/at32: Useless NULL test
Date: Fri, 26 Sep 2008 15:23:46 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809261523.46747.brunel@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test (ssc != NULL) can only be reached if the call to the function
ssc_request, the result of which ssc is assigned, succeeds. Moreover,
two statements assign NULL to ssc just before a return, which is useless
since it is a local variable. So, we suggest to delete the test and
the two assignments.

A simplified version of the semantic match that finds this problem is
as follows: 
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@bad_null_test@
expression x,E;
@@
x = ssc_request(...)
... when != x = E
* x != NULL
// </smpl>

Signed-off-by:  Julien Brunel <brunel@diku.dk>
Signed-off-by:  Julia Lawall <julia@diku.dk>

---
 sound/soc/at32/playpaq_wm8510.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -u -p a/sound/soc/at32/playpaq_wm8510.c b/sound/soc/at32/playpaq_wm8510.c
--- a/sound/soc/at32/playpaq_wm8510.c
+++ b/sound/soc/at32/playpaq_wm8510.c
@@ -405,7 +405,6 @@ static int __init playpaq_asoc_init(void
 	ssc = ssc_request(0);
 	if (IS_ERR(ssc)) {
 		ret = PTR_ERR(ssc);
-		ssc = NULL;
 		goto err_ssc;
 	}
 	ssc_p->ssc = ssc;
@@ -476,10 +475,7 @@ err_pll0:
 		_gclk0 = NULL;
 	}
 err_gclk0:
-	if (ssc != NULL) {
-		ssc_free(ssc);
-		ssc = NULL;
-	}
+	ssc_free(ssc);
 err_ssc:
 	return ret;
 }
