Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbXD3Kay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbXD3Kay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbXD3K2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:28:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:43009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965271AbXD3K2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:28:02 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, rusty@rustcorp.com.au, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [27/40] i386: Define per_cpu_offset
Message-Id: <20070430102801.A714015206@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:28:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Define per_cpu_offset in asm-i386/percpu.h when SMP defined, like
asm-generic/percpu.h does for UP.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>

---
 include/asm-i386/percpu.h |    2 ++
 1 file changed, 2 insertions(+)

===================================================================
Index: linux/include/asm-i386/percpu.h
===================================================================
--- linux.orig/include/asm-i386/percpu.h
+++ linux/include/asm-i386/percpu.h
@@ -47,6 +47,8 @@
 /* This is used for other cpus to find our section. */
 extern unsigned long __per_cpu_offset[];
 
+#define per_cpu_offset(x) (__per_cpu_offset[x])
+
 /* Separate out the type, so (int[3], foo) works. */
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
 #define DEFINE_PER_CPU(type, name) \
