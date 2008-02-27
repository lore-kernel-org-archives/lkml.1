Return-Path: <linux-kernel-owner+w=401wt.eu-S1765804AbYB0DMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765804AbYB0DMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 22:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYB0DMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 22:12:16 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:65220 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYB0DMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 22:12:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=cLzFE+KW5vhp68Ogzvm2QVDVphITONsGdkf/2Wb6CEWB3qLVqEqwNs1C5g3FfyIUPu4wA13t9Y/lnBhnz6ZHJzHxWcVGpk98FFlz0ytaW5HYVc4zKiAyuTqoDuofKEgWaGu9ehH+j4CiNFVjJt0u4oNCtF8vNfsNO+vdrN6rCtU=
Date: Wed, 27 Feb 2008 11:18:18 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: randy.dunlap@oracle.com, davej@codemonkey.org.uk, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] preset_lpj and loops_per_jiffy initialize adjust
Message-ID: <20080227031818.GA2754@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make preset_lpj static.
Give preset lpj value to loops_per_jiffy in lpj_setup.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
init/calibrate.c |    6 +++---
1 file changed, 3 insertions(+), 3 deletions(-)

diff -upr linux/init/calibrate.c linux.new/init/calibrate.c
--- linux/init/calibrate.c	2008-02-27 10:54:15.000000000 +0800
+++ linux.new/init/calibrate.c	2008-02-27 10:54:26.000000000 +0800
@@ -9,10 +9,11 @@
 #include <linux/init.h>
 #include <linux/timex.h>
 
-unsigned long preset_lpj;
+static unsigned long preset_lpj;
 static int __init lpj_setup(char *str)
 {
-	preset_lpj = simple_strtoul(str,NULL,0);
+	loops_per_jiffy = simple_strtoul(str, NULL, 0);
+	preset_lpj = 1;
 	return 1;
 }
 
@@ -117,7 +118,6 @@ void __cpuinit calibrate_delay(void)
 	int lps_precision = LPS_PREC;
 
 	if (preset_lpj) {
-		loops_per_jiffy = preset_lpj;
 		printk("Calibrating delay loop (skipped)... "
 			"%lu.%02lu BogoMIPS preset\n",
 			loops_per_jiffy/(500000/HZ),
