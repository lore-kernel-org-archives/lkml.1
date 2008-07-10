Return-Path: <linux-kernel-owner+w=401wt.eu-S1760626AbYGJSH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626AbYGJSH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760177AbYGJSGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:06:52 -0400
Received: from [194.117.236.238] ([194.117.236.238]:58660 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760169AbYGJSGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:06:51 -0400
Date: Thu, 10 Jul 2008 21:06:06 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: penberg@cs.helsinki.fi
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC PATCH 2/5] Add new GFP flag __GFP_NOTRACE.
Message-ID: <20080710210606.65e240f4@linux360.ro>
In-Reply-To: <1215712946-23572-2-git-send-email-eduard.munteanu@linux360.ro>
References: <1215712946-23572-1-git-send-email-eduard.munteanu@linux360.ro>
 <1215712946-23572-2-git-send-email-eduard.munteanu@linux360.ro>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__GFP_NOTRACE turns off allocator tracing for that particular allocation.

This is used by kmemtrace to correctly classify different kinds of
allocations, without recording one event multiple times. Example: SLAB's
kmalloc() calls kmem_cache_alloc(), but we want to record this only as a
kmalloc.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 include/linux/gfp.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index b414be3..693a5a9 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -43,6 +43,7 @@ struct vm_area_struct;
 #define __GFP_REPEAT	((__force gfp_t)0x400u)	/* See above */
 #define __GFP_NOFAIL	((__force gfp_t)0x800u)	/* See above */
 #define __GFP_NORETRY	((__force gfp_t)0x1000u)/* See above */
+#define __GFP_NOTRACE	((__force gfp_t)0x2000u) /* Inhibit tracing this. */
 #define __GFP_COMP	((__force gfp_t)0x4000u)/* Add compound page metadata */
 #define __GFP_ZERO	((__force gfp_t)0x8000u)/* Return zeroed page on success */
 #define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
-- 
1.5.6.1
