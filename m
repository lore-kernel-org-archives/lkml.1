Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbYAWVtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbYAWVtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 16:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYAWVts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 16:49:48 -0500
Received: from 1wt.eu ([62.212.114.60]:1549 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbYAWVtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 16:49:47 -0500
Date: Wed, 23 Jan 2008 22:18:59 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>,
       Jordan Crouse <jordan.crouse@amd.com>, Lars Heete <hel@admin.de>,
       Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/2] x86: GEODE fix MFGPT input clock value
Message-ID: <20080123211859.GA3081@1wt.eu>
References: <20080116165606.3ebc06a4@ephemeral> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <4795B14C.7040502@i4.informatik.rwth-aachen.de> <200801221111.21240.hel@admin.de> <4795D120.7070806@i4.informatik.rwth-aachen.de> <20080122192757.GC5241@cosmic.amd.com> <47965806.6080903@i4.informatik.rwth-aachen.de> <20080122211014.GA27870@elte.hu> <20080123211746.GA2969@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123211746.GA2969@1wt.eu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The GEODE MFGPT code assumed that 32kHz was 32000 Hz while the boards
run on a 32.768 kHz digital watch crystal. In practise, it will not
change the timer's frequency as the skew was only 2.4%, but it
should provide more accurate intervals.

Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kernel/mfgpt_32.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/mfgpt_32.c b/arch/x86/kernel/mfgpt_32.c
index 3960ab7..5519091 100644
--- a/arch/x86/kernel/mfgpt_32.c
+++ b/arch/x86/kernel/mfgpt_32.c
@@ -12,21 +12,21 @@
  */
 
 /*
- * We are using the 32Khz input clock - its the only one that has the
+ * We are using the 32.768Khz input clock - its the only one that has the
  * ranges we find desirable.  The following table lists the suitable
  * divisors and the associated hz, minimum interval
  * and the maximum interval:
  *
- *  Divisor   Hz      Min Delta (S) Max Delta (S)
- *   1        32000     .0005          2.048
- *   2        16000      .001          4.096
- *   4         8000      .002          8.192
- *   8         4000      .004         16.384
- *   16        2000      .008         32.768
- *   32        1000      .016         65.536
- *   64         500      .032        131.072
- *  128         250      .064        262.144
- *  256         125      .128        524.288
+ *  Divisor   Hz      Min Delta (S)  Max Delta (S)
+ *   1        32768   .00048828125      2.000
+ *   2        16384   .0009765625       4.000
+ *   4         8192   .001953125        8.000
+ *   8         4096   .00390625        16.000
+ *   16        2048   .0078125         32.000
+ *   32        1024   .015625          64.000
+ *   64         512   .03125          128.000
+ *  128         256   .0625           256.000
+ *  256         128   .125            512.000
  */
 
 #include <linux/kernel.h>
@@ -45,7 +45,7 @@ static struct mfgpt_timer_t {
 
 #define MFGPT_DIVISOR 16
 #define MFGPT_SCALE  4     /* divisor = 2^(scale) */
-#define MFGPT_HZ  (32000 / MFGPT_DIVISOR)
+#define MFGPT_HZ  (32768 / MFGPT_DIVISOR)
 #define MFGPT_PERIODIC (MFGPT_HZ / HZ)
 
 #ifdef CONFIG_GEODE_MFGPT_TIMER
-- 
1.5.3.4

