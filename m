Return-Path: <linux-kernel-owner+w=401wt.eu-S1752412AbXKSUUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbXKSUUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 15:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbXKSUU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 15:20:27 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:46303 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbXKSUU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 15:20:26 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAKp9QUdMROHU/2dsb2JhbACBWw
Date: Mon, 19 Nov 2007 15:20:23 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mbligh@google.com
Subject: Re: [PATCH] Cast page_to_pfn to unsigned long in CONFIG_SPARSEMEM
Message-ID: <20071119202023.GA5086@Krystal>
References: <20071113194025.150641834@polymtl.ca> <1195160783.7078.203.camel@localhost> <20071115215142.GA7825@Krystal> <1195164977.27759.10.camel@localhost> <20071116144742.GA17255@Krystal> <1195495626.27759.119.camel@localhost> <20071119185258.GA998@Krystal> <1195501381.27759.127.camel@localhost> <20071119195257.GA3440@Krystal> <1195502983.27759.134.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1195502983.27759.134.camel@localhost>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:19:28 up 16 days,  1:24,  5 users,  load average: 0.34, 0.61,
	0.74
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen (haveblue@us.ibm.com) wrote:
> The only thing I might suggest doing differently is actually using the
> page_to_pfn() definition itself:
> 
> memory_model.h:#define page_to_pfn __page_to_pfn
> 
> The full inline function version should do this already, and we
> shouldn't have any real direct __page_to_pfn() users anyway.    
> 

Like this then..

Cast page_to_pfn to unsigned long in CONFIG_SPARSEMEM

Make sure the type returned by page_to_pfn is always unsigned long. If we
don't cast it explicitly, it can be int on i386, but long on x86_64. This is
especially inelegant for printks.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Dave Hansen <haveblue@us.ibm.com>
CC: linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org
---
 include/asm-generic/memory_model.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-generic/memory_model.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-generic/memory_model.h	2007-11-19 15:06:40.000000000 -0500
+++ linux-2.6-lttng/include/asm-generic/memory_model.h	2007-11-19 15:18:57.000000000 -0500
@@ -76,7 +76,7 @@ struct page;
 extern struct page *pfn_to_page(unsigned long pfn);
 extern unsigned long page_to_pfn(struct page *page);
 #else
-#define page_to_pfn __page_to_pfn
+#define page_to_pfn ((unsigned long)__page_to_pfn)
 #define pfn_to_page __pfn_to_page
 #endif /* CONFIG_OUT_OF_LINE_PFN_TO_PAGE */
 



-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
