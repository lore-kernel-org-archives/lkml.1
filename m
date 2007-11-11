Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbXKKW0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbXKKW0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 17:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbXKKW0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 17:26:39 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:60036 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbXKKW0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 17:26:38 -0500
Date: Sun, 11 Nov 2007 17:25:26 -0500
Message-Id: <200711112225.lABMPQP1024641@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>
Subject: [PATCH] init/calibrate.c compile error (MMOTM-2007-11-10-19-05)
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using -mm (MMOTM-2007-11-10-19-05) and getting

$ make
  CC      init/calibrate.o
In file included from include/linux/jiffies.h:8,
                 from init/calibrate.c:7:
include/linux/timex.h:246: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'read_current_timer'
init/calibrate.c: In function 'calibrate_delay_direct':
init/calibrate.c:41: error: implicit declaration of function 'read_current_timer'
make[1]: *** [init/calibrate.o] Error 1
make: *** [init] Error 2

That's because the definition of __devinit isn't known at that point.  The
following small patch appears to fix the compilation error.  Someone should
verify that it's the proper fix.

Cheers,
Erez.



Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

diff --git a/include/linux/timex.h b/include/linux/timex.h
index 40383f9..57bb18c 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -55,6 +55,7 @@
 
 #include <linux/compiler.h>
 #include <linux/time.h>
+#include <linux/init.h>
 
 #include <asm/param.h>

