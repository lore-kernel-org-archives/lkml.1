Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbZJRDXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbZJRDXl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 23:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbZJRDXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 23:23:40 -0400
Received: from [93.93.128.226] ([93.93.128.226]:45906 "EHLO
	bhuna.collabora.co.uk" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbZJRDXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 23:23:40 -0400
Date: Sat, 17 Oct 2009 23:23:38 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] drm: kill some unused DRM_PROC macros from drmP.h
Message-ID: <20091017232338.38bec649@mycelium.queued.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i915_gem_proc.c appears to have been the last user of the DRM_PROC_*
macros, and it has gone away.  The macros should die as well.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 include/drm/drmP.h |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index c8e64bb..af30da3 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -245,16 +245,6 @@ extern void drm_ut_debug_printk(unsigned int request_level,
 
 #endif
 
-#define DRM_PROC_LIMIT (PAGE_SIZE-80)
-
-#define DRM_PROC_PRINT(fmt, arg...)					\
-   len += sprintf(&buf[len], fmt , ##arg);				\
-   if (len > DRM_PROC_LIMIT) { *eof = 1; return len - offset; }
-
-#define DRM_PROC_PRINT_RET(ret, fmt, arg...)				\
-   len += sprintf(&buf[len], fmt , ##arg);				\
-   if (len > DRM_PROC_LIMIT) { ret; *eof = 1; return len - offset; }
-
 /*@}*/
 
 /***********************************************************************/
-- 
1.5.6.5

