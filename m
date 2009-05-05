Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbZEENrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbZEENrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbZEENrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:47:12 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59366 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbZEENrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:47:10 -0400
Date: Tue, 5 May 2009 15:47:06 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: richard@rsk.demon.co.uk, gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: p80211wext.c: problem with IW_ENCODE_ALG_WEP
In-Reply-To: <4A004088.7000907@gmail.com>
Message-ID: <Pine.LNX.4.64.0905051545450.9552@pc-004.diku.dk>
References: <Pine.LNX.4.64.0905051522010.9552@pc-004.diku.dk>
 <4A004088.7000907@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The expression !(ext->alg & IW_ENCODE_ALG_WEP) appears to be incorrect,
because there are several possible values for ext->alg that give 1 when
bit-anded with IW_ENCODE_ALG_WEP.  Therefore Richard Kennedy suggested to
rewrite the code with !=

Added \n at the end of the debug string as well.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/wlan-ng/p80211wext.c           |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211wext.c b/drivers/staging/wlan-ng/p80211wext.c
index 96078b0..74eac34 100644
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -1487,8 +1487,8 @@ static int p80211wext_set_encodeext(struct net_device *dev,
 	}
 
 	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY) {
-		if (!(ext->alg & IW_ENCODE_ALG_WEP)) {
-			pr_debug("asked to set a non wep key :(");
+		if (ext->alg != IW_ENCODE_ALG_WEP) {
+			pr_debug("asked to set a non wep key :(\n");
 			return -EINVAL;
 		}
 		if (idx) {
