Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbZDOSjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbZDOSjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 14:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZDOSjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 14:39:09 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2110 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbZDOSjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 14:39:08 -0400
Subject: [PATCH] hda_intel.c - Consolidate bitfields
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Peer Chen <peerchen@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 11:39:01 -0700
Message-Id: <1239820741.26340.175.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit fa00e046b41663cbda9b1affc0594669e5f14219
added a new bitfield not adjacent to other
bitfields in the same struct.  Moved the new one.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index bc882f8..21e99cf 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -312,7 +312,6 @@ struct azx_dev {
 	unsigned int period_bytes; /* size of the period in bytes */
 	unsigned int frags;	/* number for period in the play buffer */
 	unsigned int fifo_size;	/* FIFO size */
-	unsigned int start_flag: 1;	/* stream full start flag */
 	unsigned long start_jiffies;	/* start + minimum jiffies */
 	unsigned long min_jiffies;	/* minimum jiffies before position is valid */
 
@@ -333,6 +332,7 @@ struct azx_dev {
 	unsigned int opened :1;
 	unsigned int running :1;
 	unsigned int irq_pending :1;
+	unsigned int start_flag: 1;	/* stream full start flag */
 	/*
 	 * For VIA:
 	 *  A flag to ensure DMA position is 0


