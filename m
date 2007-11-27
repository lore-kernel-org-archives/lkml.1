Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbXK0Bhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbXK0Bhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 20:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXK0Bhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 20:37:40 -0500
Received: from relay1.sgi.com ([192.48.171.29]:53526 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753269AbXK0Bhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 20:37:39 -0500
Date: Mon, 26 Nov 2007 17:37:38 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       tony.luck@intel.com
Subject: Re: [patch 13/14] ia64: Use generic percpu
In-Reply-To: <20071127001432.160399113@sgi.com>
Message-ID: <Pine.LNX.4.64.0711261735001.29915@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <20071127001432.160399113@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Duh. This particular patch assumes already relocated per cpu areas which 
does not work with ia64's per cpu area mapings. This fix is needed:

---
 include/asm-ia64/percpu.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/include/asm-ia64/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/percpu.h	2007-11-26 17:14:22.823022434 -0800
+++ linux-2.6/include/asm-ia64/percpu.h	2007-11-26 17:18:34.063021793 -0800
@@ -9,7 +9,7 @@
 #define PERCPU_ENOUGH_ROOM PERCPU_PAGE_SIZE
 
 #ifdef __ASSEMBLY__
-# define THIS_CPU(var)	(PERCPU_ADDR + per_cpu__##var)  /* use this to mark accesses to per-CPU variables... */
+# define THIS_CPU(var)	per_cpu__##var  /* use this to mark accesses to per-CPU variables... */
 #else /* !__ASSEMBLY__ */
 
 #include <linux/threads.h>
@@ -35,7 +35,7 @@ extern void *per_cpu_init(void);
  * On the positive side, using __ia64_per_cpu_var() instead of __get_cpu_var() is slightly
  * more efficient.
  */
-#define __ia64_per_cpu_var(var)	(*SHIFT_PTR(&per_cpu__##var, PERCPU_ADDR))
+#define __ia64_per_cpu_var(var)	per_cpu__##var
 
 #include <asm-generic/percpu.h>
 
