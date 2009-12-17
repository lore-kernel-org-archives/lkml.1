Return-Path: <linux-kernel-owner+w=401wt.eu-S936521AbZLQE15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936521AbZLQE15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935698AbZLQEEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:50 -0500
Received: from kroah.org ([198.145.64.141]:55680 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935654AbZLQEEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:43 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:53 2009
Message-Id: <20091217035653.375160006@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Martin Michlmayr <tbm@cyrius.com>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Dave Airlie <airlied@redhat.com>
Subject: [081/151] drm/ttm: Fix build failure due to missing struct page
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Martin Michlmayr <tbm@cyrius.com>

commit c3a73ba13bac7fd96030f39202b2d37fb19c46a6 upstream.

drm/ttm fails to build on MIPS because "struct page" is not known:
| In file included from drivers/gpu/drm/ttm/ttm_memory.c:28:
| include/drm/ttm/ttm_memory.h:154: warning: 'struct page' declared inside parameter list
| include/drm/ttm/ttm_memory.h:154: warning: its scope is only this definition or declaration, which is probably not what you want
| include/drm/ttm/ttm_memory.h:156: warning: 'struct page' declared inside parameter list
| drivers/gpu/drm/ttm/ttm_memory.c:540: error: conflicting types for 'ttm_mem_global_alloc_page'
| include/drm/ttm/ttm_memory.h:154: error: previous declaration of 'ttm_mem_global_alloc_page' was here
| drivers/gpu/drm/ttm/ttm_memory.c:561: error: conflicting types for 'ttm_mem_global_free_page'
| include/drm/ttm/ttm_memory.h:156: error: previous declaration of 'ttm_mem_global_free_page' was here

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Acked-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/drm/ttm/ttm_memory.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/drm/ttm/ttm_memory.h
+++ b/include/drm/ttm/ttm_memory.h
@@ -33,6 +33,7 @@
 #include <linux/wait.h>
 #include <linux/errno.h>
 #include <linux/kobject.h>
+#include <linux/mm.h>
 
 /**
  * struct ttm_mem_shrink - callback to shrink TTM memory usage.


