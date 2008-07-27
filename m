Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbYG0SSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbYG0SSA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 14:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759054AbYG0SRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 14:17:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:57459 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034AbYG0SRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 14:17:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:sender;
        b=GRfeNto95aHUpwY5XJAXNFpj6BTdzONGaJ/M5tH725atlwEeCrGS9fl9b7MmGAQDDY
         xtEeTyeWqkwaT5b6+RIiD/yQZrtNziqfJlOX6ivG16Gok0r9ZcqrZM/0VY40j87cf0pW
         VSwTY1/oz6QKAtK/ZOs9N89Wntwi1e8aKXuUM=
Date: Sun, 27 Jul 2008 23:47:00 +0530
From: Rabin Vincent <rabin@rab.in>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akataria@vmware.com, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Remove stray <6> in BogoMIPS printk
Message-ID: <20080727181700.GA2074@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the extra KERN_INFO which causes this:
Calibrating delay loop... <6>179.40 BogoMIPS (lpj=897024)
                          ^^^

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 init/calibrate.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index 7963e3f..51c5cec 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -170,7 +170,7 @@ void __cpuinit calibrate_delay(void)
 				loops_per_jiffy &= ~loopbit;
 		}
 	}
-	printk(KERN_INFO "%lu.%02lu BogoMIPS (lpj=%lu)\n",
-			loops_per_jiffy/(500000/HZ),
-			(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
+	printk("%lu.%02lu BogoMIPS (lpj=%lu)\n",
+		loops_per_jiffy/(500000/HZ),
+		(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
 }
-- 
1.5.6.3

