Return-Path: <linux-kernel-owner+w=401wt.eu-S1759860AbZIPQmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860AbZIPQmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759796AbZIPQmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:42:37 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:39788 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759735AbZIPQmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:42:36 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: linux-kernel@vger.kernel.org
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v2 3/3] Optimize the ordering of sections in RW_DATA_SECTION.
Date: Wed, 16 Sep 2009 12:38:39 -0400
Message-Id: <1253119119-18956-4-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253119119-18956-1-git-send-email-tabbott@ksplice.com>
References: <1253119119-18956-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 include/asm-generic/vmlinux.lds.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index a43223a..6357b04 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -720,12 +720,12 @@
 	. = ALIGN(PAGE_SIZE);						\
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {				\
 		INIT_TASK_DATA(inittask)				\
+		NOSAVE_DATA						\
+		PAGE_ALIGNED_DATA(pagealigned)				\
 		CACHELINE_ALIGNED_DATA(cacheline)			\
 		READ_MOSTLY_DATA(cacheline)				\
 		DATA_DATA						\
 		CONSTRUCTORS						\
-		NOSAVE_DATA						\
-		PAGE_ALIGNED_DATA(pagealigned)				\
 	}
 
 #define INIT_TEXT_SECTION(inittext_align)				\
-- 
1.6.3.3

