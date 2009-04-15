Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbZDOSgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbZDOSgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 14:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZDOSgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 14:36:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60227 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbZDOSgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 14:36:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/5] The default CONFIG_BUG=n version of BUG() should have an
	empty do...while
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 15 Apr 2009 19:34:56 +0100
Message-ID: <20090415183456.11029.28756.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090415183441.11029.30619.stgit@warthog.procyon.org.uk>
References: <20090415183441.11029.30619.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default CONFIG_BUG=n version of BUG() must incorporate an empty a
do...while statement to avoid compilation weirdness.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-generic/bug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 37b82cb..e727fe0 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -88,7 +88,7 @@ extern void warn_slowpath(const char *file, const int line,
 
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
-#define BUG()
+#define BUG() do {} while(0)
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON

