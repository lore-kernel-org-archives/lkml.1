Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab0CCKxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 05:53:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59989 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab0CCKxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 05:53:23 -0500
Message-ID: <4B8E3ED1.60004@cn.fujitsu.com>
Date: Wed, 03 Mar 2010 18:49:53 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] nodemask: fix the declaration of NODEMASK_ALLOC()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we can't declarate two variable at the same scope by NODEMASK_ALLOC().

this patch fixes it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 include/linux/nodemask.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 454997c..9bd29e0 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -494,7 +494,7 @@ static inline int num_node_state(enum node_states state)
 			type *name = kmalloc(sizeof(*name), gfp_flags)
 #define NODEMASK_FREE(m)			kfree(m)
 #else
-#define NODEMASK_ALLOC(type, name, gfp_flags)	type _name, *name = &_name
+#define NODEMASK_ALLOC(type, name, gfp_flags)	type _##name, *name = &_##name
 #define NODEMASK_FREE(m)			do {} while (0)
 #endif
 
-- 
1.6.5.2

