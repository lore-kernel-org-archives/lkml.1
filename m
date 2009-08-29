Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbZH2XLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbZH2XLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 19:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbZH2XLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 19:11:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58942 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbZH2XLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 19:11:21 -0400
Message-Id: <20090829231121.144124147@bombadil.infradead.org>
User-Agent: quilt/0.47-1
Date: Sat, 29 Aug 2009 19:03:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: liml@rtr.ca, jens.axboe@oracle.com, matthew@wil.cx, dwmw2@infradead.org,
       David Woodhouse <David.Woodhouse@intel.com>,
       Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 1/7] Make DISCARD_BARRIER and DISCARD_NOBARRIER writes instead of reads
References: <20090829230332.017137693@bombadil.infradead.org>
Content-Disposition: inline; filename=discard-mark-requests-as-write
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>

The commands are conceptually writes, and in the case of IDE and SCSI
commands actually are writes.  They were only reads because we thought
that would interact better with the elevators.  Now the elevators know
about discard requests, that advantage no longer exists.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5bed436..28f8e5d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -161,8 +161,8 @@ struct inodes_stat_t {
  * These aren't really reads or writes, they pass down information about
  * parts of device that are now unused by the file system.
  */
-#define DISCARD_NOBARRIER (1 << BIO_RW_DISCARD)
-#define DISCARD_BARRIER ((1 << BIO_RW_DISCARD) | (1 << BIO_RW_BARRIER))
+#define DISCARD_NOBARRIER (WRITE | (1 << BIO_RW_DISCARD))
+#define DISCARD_BARRIER (DISCARD_NOBARRIER | (1 << BIO_RW_BARRIER))
 
 #define SEL_IN		1
 #define SEL_OUT		2

