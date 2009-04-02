Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbZDBPFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbZDBPFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762243AbZDBO6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:58:54 -0400
Received: from ottawa-hs-64-26-147-143.d-ip.magma.ca ([64.26.147.143]:41821
	"EHLO gonzo.int.wil.cx" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762196AbZDBO6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:58:51 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com
Cc: David Woodhouse <dwmw2@infradead.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 2/5] Make DISCARD_BARRIER and DISCARD_NOBARRIER writes instead of reads
Date: Thu,  2 Apr 2009 10:37:24 -0400
Message-Id: <1238683047-13588-2-git-send-email-willy@linux.intel.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1238683047-13588-1-git-send-email-willy@linux.intel.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>
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
 include/linux/fs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 61211ad..e5dc992 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -98,8 +98,8 @@ struct inodes_stat_t {
 #define WRITE_SYNC	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
 #define SWRITE_SYNC	(SWRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
 #define WRITE_BARRIER	(WRITE | (1 << BIO_RW_BARRIER))
-#define DISCARD_NOBARRIER (1 << BIO_RW_DISCARD)
-#define DISCARD_BARRIER ((1 << BIO_RW_DISCARD) | (1 << BIO_RW_BARRIER))
+#define DISCARD_NOBARRIER (WRITE | (1 << BIO_RW_DISCARD))
+#define DISCARD_BARRIER (DISCARD_NOBARRIER | (1 << BIO_RW_BARRIER))
 
 #define SEL_IN		1
 #define SEL_OUT		2
-- 
1.6.2.1

