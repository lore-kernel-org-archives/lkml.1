Return-Path: <linux-kernel-owner+w=401wt.eu-S1764223AbXHKWF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764223AbXHKWF2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 18:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761524AbXHKWFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 18:05:16 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:64399 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761275AbXHKWFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 18:05:14 -0400
Date: Sat, 11 Aug 2007 23:04:17 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] Re: 2.6.23-rc2-mm2: sata disk going slow
In-Reply-To: <20070809224254.11f42716.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708112256150.18054@blonde.wat.veritas.com>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Why is the G5 so slow with 2.6.23-rc2-mm2?  hdparm -t shows 1.8MB/sec
instead of 58MB/sec.  alpm-increase-number-of-allowable-device-flags.patch
(raising ATA_DFLAG_CFG_MASK) turns out to be the guilty party: though the
problem doesn't appear until the next patch, which adds ATA_DFLAG_IPM as
the same bit as ATA_DFLAG_PIO.  Here's a hotfix against top of -rc2-mm2.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 include/linux/libata.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- 2.6.23-rc2-mm2/include/linux/libata.h	2007-08-10 12:14:36.000000000 +0100
+++ linux/include/linux/libata.h	2007-08-11 20:21:59.000000000 +0100
@@ -143,9 +143,9 @@ enum {
 	ATA_DFLAG_IPM		= (1 << 8), /* device supports IPM */
 	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
-	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
-	ATA_DFLAG_NCQ_OFF	= (1 << 9), /* device limited to non-NCQ mode */
-	ATA_DFLAG_SPUNDOWN	= (1 << 10), /* XXX: for spindown_compat */
+	ATA_DFLAG_PIO		= (1 << 12), /* device limited to PIO mode */
+	ATA_DFLAG_NCQ_OFF	= (1 << 13), /* device limited to non-NCQ mode */
+	ATA_DFLAG_SPUNDOWN	= (1 << 14), /* XXX: for spindown_compat */
 	ATA_DFLAG_INIT_MASK	= (1 << 16) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 16),
