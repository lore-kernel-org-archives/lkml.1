Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbXKAAxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbXKAAxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 20:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbXKAAxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 20:53:25 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51573 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752608AbXKAAxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 20:53:24 -0400
Date: Wed, 31 Oct 2007 17:53:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
In-Reply-To: <20071031.175124.84905325.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0710311752380.25515@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0710311724490.25361@schroedinger.engr.sgi.com>
 <20071031.172741.192929676.davem@davemloft.net>
 <Pine.LNX.4.64.0710311730280.25414@schroedinger.engr.sgi.com>
 <20071031.175124.84905325.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch fixes build failures with DEBUG_VM disabled.

Well there is more there. Last minute mods sigh. With DEBUG_VM you likely 
need this patch.


---
 include/linux/percpu.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2007-10-31 17:48:38.020499686 -0700
+++ linux-2.6/include/linux/percpu.h	2007-10-31 17:51:01.423372247 -0700
@@ -36,7 +36,7 @@
 #ifdef CONFIG_DEBUG_VM
 #define __percpu_disguise(pdata) ((void *)~(unsigned long)(pdata))
 #else
-#define __percpu_disguide(pdata) ((void *)(pdata))
+#define __percpu_disguise(pdata) ((void *)(pdata))
 #endif
 
 /* 
@@ -53,7 +53,7 @@
 
 #define this_cpu_ptr(ptr)           			\
 ({							\
-	void *p = ptr;					\
+	void *p = __percpu_disguise(ptr);		\
     	(__typeof__(ptr))(p + this_cpu_offset());	\
 })
 
