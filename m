Return-Path: <linux-kernel-owner+w=401wt.eu-S1760207AbZDWH57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbZDWH57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbZDWHe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:34:27 -0400
Received: from sous-sol.org ([216.99.217.87]:51061 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757403AbZDWHe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:34:26 -0400
Message-Id: <20090423072820.899375499@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:30 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 070/100] hpt366: fix HPT370 DMA timeouts
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=hpt366-fix-hpt370-dma-timeouts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

upstream commit: c018f1ee5cf81e58b93d9e93a2ee39cad13dc1ac

The big driver change in 2.4.19-rc1 introduced a regression for many HPT370[A]
chips -- DMA stopped to work completely, only causing endless timeouts...

The culprit has been identified (at last!): it turned to be the code resetting
the DMA state machine before each transfer. Stop doing it now as this counter-
measure has clearly caused more harm than good.

This should fix the kernel.org bug #7703.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/ide/hpt366.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -114,6 +114,8 @@
  *   the register setting lists into the table indexed by the clock selected
  * - set the correct hwif->ultra_mask for each individual chip
  * - add Ultra and MW DMA mode filtering for the HPT37[24] based SATA cards
+ * - stop resetting HPT370's state machine before each DMA transfer as that has
+ *   caused more harm than good
  *	Sergei Shtylyov, <sshtylyov@ru.mvista.com> or <source@mvista.com>
  */
 
@@ -133,7 +135,7 @@
 #define DRV_NAME "hpt366"
 
 /* various tuning parameters */
-#define HPT_RESET_STATE_ENGINE
+#undef	HPT_RESET_STATE_ENGINE
 #undef	HPT_DELAY_INTERRUPT
 
 static const char *quirk_drives[] = {

