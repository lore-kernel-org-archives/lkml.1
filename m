Return-Path: <linux-kernel-owner+w=401wt.eu-S937479AbXGTPg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937479AbXGTPg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964799AbXGTPdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:33:36 -0400
Received: from ns2.suse.de ([195.135.220.15]:54394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936359AbXGTPdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:33:35 -0400
From: Andi Kleen <ak@suse.de>
References: <20070720532.949522000@suse.de>
In-Reply-To: <20070720532.949522000@suse.de>
To: mathieu.desnoyers@polymtl.ca, andi@firstfloor.org, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [8/11] x86_64: x86_64 - Use non locked version for local_cmpxchg()
Message-Id: <20070720153252.C0AC514E79@wotan.suse.de>
Date: Fri, 20 Jul 2007 17:32:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
x86_64 - Use non locked version for local_cmpxchg()

local_cmpxchg() should not use any LOCK prefix. This change probably got lost in
the move to cmpxchg.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
CC: Andi Kleen <andi@firstfloor.org>
---
 include/asm-x86_64/cmpxchg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/asm-x86_64/cmpxchg.h
===================================================================
--- linux.orig/include/asm-x86_64/cmpxchg.h
+++ linux/include/asm-x86_64/cmpxchg.h
@@ -128,7 +128,7 @@ static inline unsigned long __cmpxchg_lo
 	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
 					(unsigned long)(n),sizeof(*(ptr))))
 #define cmpxchg_local(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr),(unsigned long)(o),\
 					(unsigned long)(n),sizeof(*(ptr))))
 
 #endif
