Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbXKAAD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbXKAAD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 20:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbXKAADM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 20:03:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58912 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754116AbXKAADL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 20:03:11 -0400
Message-Id: <20071101000310.217429212@sgi.com>
References: <20071101000211.970501947@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 17:02:14 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 3/7] Allocpercpu: Do __percpu_disguise() only if CONFIG_DEBUG_VM is set
Content-Disposition: inline; filename=opt_disguise
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Disguising costs a few cycles in the hot paths. So switch it off if
we are not debuggin.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/percpu.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2007-10-31 16:40:14.892121256 -0700
+++ linux-2.6/include/linux/percpu.h	2007-10-31 16:41:00.907621059 -0700
@@ -33,7 +33,11 @@
 
 #ifdef CONFIG_SMP
 
+#ifdef CONFIG_DEBUG_VM
 #define __percpu_disguise(pdata) ((void *)~(unsigned long)(pdata))
+#else
+#define __percpu_disguide(pdata) ((void *)(pdata))
+#endif
 
 /* 
  * Use this to get to a cpu's version of the per-cpu object dynamically

-- 
