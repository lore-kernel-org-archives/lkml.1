Return-Path: <linux-kernel-owner+w=401wt.eu-S1762840AbXHVPAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762840AbXHVPAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760386AbXHVPAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:00:45 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:64800 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758571AbXHVPAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:00:44 -0400
Date: Wed, 22 Aug 2007 11:00:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: [PATCH] define have_arch_cmpxchg()
Message-ID: <20070822150043.GA8504@Krystal>
References: <20070821231216.GA29691@Krystal> <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com> <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com> <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com> <20070822000323.GG29691@Krystal> <Pine.LNX.4.64.0708211704260.7852@schroedinger.engr.sgi.com> <20070822002616.GA1400@Krystal> <Pine.LNX.4.64.0708211731410.3354@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708211731410.3354@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:55:28 up 23 days, 15:14,  4 users,  load average: 0.36, 0.46, 0.40
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

define have_arch_cmpxchg()

* Christoph Lameter (clameter@sgi.com) wrote:
> If we really want to do this then the implementation of all of these 
> components need to result in competitive performance on all platforms.
> 
Here is the first of 2 proposed patches to keep the same performances on
architectures that does not implement cmpxchg_local.

Add have_arch_cmpxchg(), which can be used within the body of functions to
select between irq disable and local_cmpxchg.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/hardirq.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: slab/include/linux/hardirq.h
===================================================================
--- slab.orig/include/linux/hardirq.h	2007-08-22 10:27:07.000000000 -0400
+++ slab/include/linux/hardirq.h	2007-08-22 10:27:46.000000000 -0400
@@ -149,4 +149,10 @@ extern void irq_exit(void);
 #define nmi_enter()		do { lockdep_off(); __irq_enter(); } while (0)
 #define nmi_exit()		do { __irq_exit(); lockdep_on(); } while (0)
 
+#ifdef __HAVE_ARCH_CMPXCHG
+#define have_arch_cmpxchg()	1
+#else
+#define have_arch_cmpxchg()	0
+#endif
+
 #endif /* LINUX_HARDIRQ_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
