Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbYAVVPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbYAVVPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbYAVVPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:15:32 -0500
Received: from relay2.sgi.com ([192.48.171.30]:36787 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751757AbYAVVPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:15:31 -0500
Message-Id: <20080122211528.797776000@sgi.com>
References: <20080122211528.602673000@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 22 Jan 2008 13:15:29 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] fix possible undefined PER_CPU_ATTRIBUTES
Content-Disposition: inline; filename=fix-PER_CPU_ATTRIBUTES-define
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure how this leaked out and I haven't caught it yet in my
cross-build testing but to be on the safe side, PER_CPU_ATTRIBUTES
should be defined.

Applies to 2.6.24-rc8-mm1 + percpu changes

Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/percpu.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -9,6 +9,10 @@
 
 #include <asm/percpu.h>
 
+#ifndef PER_CPU_ATTRIBUTES
+#define PER_CPU_ATTRIBUTES
+#endif
+
 #ifdef CONFIG_SMP
 #define DEFINE_PER_CPU(type, name)					\
 	__attribute__((__section__(".data.percpu")))			\

-- 
