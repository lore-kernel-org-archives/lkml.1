Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbYGKMgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbYGKMgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYGKMgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:36:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506AbYGKMgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:36:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix FRV irqs_disabled() to return an int, not an unsigned long
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 11 Jul 2008 13:35:43 +0100
Message-ID: <20080711123543.13882.78862.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix FRV irqs_disabled() to return an int, not an unsigned long to avoid this
warning:

kernel/sched.c: In function '__might_sleep':
kernel/sched.c:8198: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-frv/system.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/asm-frv/system.h b/include/asm-frv/system.h
index d3a12a9..7742ec0 100644
--- a/include/asm-frv/system.h
+++ b/include/asm-frv/system.h
@@ -87,7 +87,7 @@ do {								\
 } while(0)
 
 #define irqs_disabled() \
-	({unsigned long flags; local_save_flags(flags); flags; })
+	({unsigned long flags; local_save_flags(flags); !!flags; })
 
 #define	local_irq_save(flags)			\
 do {						\

