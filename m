Return-Path: <linux-kernel-owner+w=401wt.eu-S937595AbXHLS7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937595AbXHLS7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 14:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934336AbXHLS7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 14:59:35 -0400
Received: from mail.ocs.com.au ([203.34.248.175]:23482 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934581AbXHLS7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 14:59:34 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
From: Keith Owens <kaos@ocs.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, tony.luck@intel.com
Subject: Re: [patch 09/23] Add cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64 
In-reply-to: Your message of "Sun, 12 Aug 2007 10:54:43 -0400."
             <20070812145838.211752593@polymtl.ca> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 13 Aug 2007 04:59:29 +1000
Message-ID: <16002.1186945169@ocs10w.ocs.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers (on Sun, 12 Aug 2007 10:54:43 -0400) wrote:
>Add the primitives cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64. They
>use cmpxchg_acq as underlying macro, just like the already existing ia64
>cmpxchg().
>
>Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>CC: clameter@sgi.com
>CC: tony.luck@intel.com
>---
> include/asm-ia64/intrinsics.h |    4 ++++
> 1 file changed, 4 insertions(+)
>
>Index: linux-2.6-lttng/include/asm-ia64/intrinsics.h
>===================================================================
>--- linux-2.6-lttng.orig/include/asm-ia64/intrinsics.h	2007-07-20 18:36:09.000000000 -0400
>+++ linux-2.6-lttng/include/asm-ia64/intrinsics.h	2007-07-20 19:29:17.000000000 -0400
>@@ -158,6 +158,10 @@ extern long ia64_cmpxchg_called_with_bad
> 
> /* for compatibility with other platforms: */
> #define cmpxchg(ptr,o,n)	cmpxchg_acq(ptr,o,n)
>+#define cmpxchg_local(ptr,o,n)	cmpxchg_acq(ptr,o,n)
>+
>+#define cmpxchg64(ptr,o,n)		cmpxchg_acq(ptr,o,n)
>+#define cmpxchg64_local(ptr,o,n)	cmpxchg_acq(ptr,o,n)

As a matter of coding style, I prefer

#define cmpxchg_local	cmpxchg
#define cmpxchg64_local	cmpxchg64

Which makes it absolutely clear that they are the same code.  With your
patch, humans have to do a string compare of two defines to see if they
are the same.

