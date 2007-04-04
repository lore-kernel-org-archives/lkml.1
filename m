Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbXDDG2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbXDDG2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992705AbXDDG21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:28:27 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:25028 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992704AbXDDG2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:28:15 -0400
X-IronPort-AV: i="4.14,367,1170651600"; 
   d="scan'208"; a="26306160:sNHT20699203"
Subject: [PATCH] move die notifier handling to common code fix
	vmalloc_sync_all in nommu
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Christoph Hellwig <hch@lst.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 04 Apr 2007 14:28:27 +0800
Message-Id: <1175668107.10608.40.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 mm/nommu.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 2d0a82f..0016557 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -261,6 +261,14 @@ void vunmap(void *addr)
 }
 
 /*
+ * Implement a stub for vmalloc_sync_all() if the architecture chose not to
+ * have one.
+ */
+void  __attribute__((weak)) vmalloc_sync_all(void)
+{
+}
+
+/*
  *  sys_brk() for the most part doesn't need the global kernel
  *  lock, except when an application is doing something nasty
  *  like trying to un-brk an area that has already been mapped
-- 
1.5.0.5

