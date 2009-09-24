Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbZIXLdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbZIXLdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZIXLdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:33:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZIXLdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:33:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/4] NOMMU: Fallback for is_vmalloc_or_module_addr() should be
	inline
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Thu, 24 Sep 2009 12:33:32 +0100
Message-ID: <20090924113332.6031.11718.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NOMMU fallback for is_vmalloc_or_module_addr() should be static inline,
not just static, in linux/mm.h.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/mm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/linux/mm.h b/include/linux/mm.h
index b6eae5e..23e7fd6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -288,7 +288,7 @@ static inline int is_vmalloc_addr(const void *x)
 #ifdef CONFIG_MMU
 extern int is_vmalloc_or_module_addr(const void *x);
 #else
-static int is_vmalloc_or_module_addr(const void *x)
+static inline int is_vmalloc_or_module_addr(const void *x)
 {
 	return 0;
 }

