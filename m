Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbXHSWUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbXHSWUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbXHSWTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:19:54 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1515 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756049AbXHSWTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:19:52 -0400
Subject: [PATCH 5/5] mm/... convert #include "linux/..." to #include
	<linux/...>
From: Joe Perches <joe@perches.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org
Content-Type: text/plain
Date: Sun, 19 Aug 2007 15:19:43 -0700
Message-Id: <1187561983.4200.145.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(untested)

There are several files that 
#include "linux/file" not #include <linux/file>
#include "asm/file" not #include <asm/file>

Here's a little script that converts them:

egrep -i -r -l --include=*.[ch] \
"^[[:space:]]*\#[[:space:]]*include[[:space:]]*\"(linux|asm)/(.*)\"" * \
| xargs sed -i -e 's/^[[:space:]]*#[[:space:]]*include[[:space:]]*"\(linux\|asm\)\/\(.*\)"/#include <\1\/\2>/g'

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/mm/slab.c b/mm/slab.c
index a684778..976aeff 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -334,7 +334,7 @@ static __always_inline int index_of(const size_t size)
 		return i; \
 	else \
 		i++;
-#include "linux/kmalloc_sizes.h"
+#include <linux/kmalloc_sizes.h>
 #undef CACHE
 		__bad_size();
 	} else


