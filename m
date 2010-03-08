Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab0CHKLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 05:11:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50310 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab0CHKLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 05:11:12 -0500
Message-ID: <4B94CBE7.70604@cn.fujitsu.com>
Date: Mon, 08 Mar 2010 18:05:27 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 2/4] nodemask: fix the declaration of NODEMASK_ALLOC()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from V1 to V2:
- None

we can't declarate two variable at the same scope by NODEMASK_ALLOC().

this patch fixes it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 include/linux/nodemask.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index c4fa64b..dba35e4 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -483,7 +483,7 @@ static inline int num_node_state(enum node_states state)
 			type *name = kmalloc(sizeof(*name), gfp_flags)
 #define NODEMASK_FREE(m)			kfree(m)
 #else
-#define NODEMASK_ALLOC(type, name, gfp_flags)	type _name, *name = &_name
+#define NODEMASK_ALLOC(type, name, gfp_flags)	type _##name, *name = &_##name
 #define NODEMASK_FREE(m)			do {} while (0)
 #endif
 
-- 
1.6.5.2


