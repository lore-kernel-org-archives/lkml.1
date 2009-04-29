Return-Path: <linux-kernel-owner+w=401wt.eu-S1761810AbZD2Wd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761810AbZD2Wd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759639AbZD2WVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:38 -0400
Received: from kroah.org ([198.145.64.141]:40532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759412AbZD2WVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:34 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:27 2009
Message-Id: <20090429220927.836931426@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:31 -0700
From: Greg KH <gregkh@suse.de>
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
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 32/58] hpt366: fix HPT370 DMA timeouts
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=0069-hpt366-fix-HPT370-DMA-timeouts.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ide/pci/hpt366.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -114,6 +114,8 @@
  *   the register setting lists into the table indexed by the clock selected
  * - set the correct hwif->ultra_mask for each individual chip
  * - add Ultra and MW DMA mode filtering for the HPT37[24] based SATA cards
+ * - stop resetting HPT370's state machine before each DMA transfer as that has
+ *   caused more harm than good
  *	Sergei Shtylyov, <sshtylyov@ru.mvista.com> or <source@mvista.com>
  */
 
@@ -134,7 +136,7 @@
 #define DRV_NAME "hpt366"
 
 /* various tuning parameters */
-#define HPT_RESET_STATE_ENGINE
+#undef	HPT_RESET_STATE_ENGINE
 #undef	HPT_DELAY_INTERRUPT
 #define HPT_SERIALIZE_IO	0
 


