Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbXKNIQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbXKNIQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 03:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbXKNIP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 03:15:56 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:47335 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbXKNIPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 03:15:54 -0500
Date: Wed, 14 Nov 2007 09:15:51 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: perex@suse.cz, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/4] sound/pci: Drop unnecessary continue
Message-ID: <Pine.LNX.4.64.0711140915220.26019@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Continue is not needed at the bottom of a loop.

The semantic patch implementing this change is as follows:

@@
@@

for (...;...;...) {
   ...
   if (...) {
     ...
-   continue;
   }
}

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p -b -B a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
--- a/sound/pci/intel8x0.c 2007-10-22 11:25:53.000000000 +0200
+++ b/sound/pci/intel8x0.c 2007-11-13 23:53:44.000000000 +0100
@@ -2144,7 +2144,6 @@ static int __devinit snd_intel8x0_mixer(
  				snd_printk(KERN_ERR "Unable to initialize codec #%d\n", i);
  			if (i == 0)
  				goto __err;
-			continue;
  		}
  	}
  	/* tune up the primary codec */
