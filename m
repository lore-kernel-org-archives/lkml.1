Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZLBM50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZLBM50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 07:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbZLBM5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 07:57:25 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:33059 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbZLBM5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 07:57:24 -0500
Date: Wed, 2 Dec 2009 12:56:52 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Dave Airlie <airlied@linux.ie>, Thomas Hellstrom <thellstrom@vmware.com>,
       Jerome Glisse <jglisse@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: [PATCH] DRM: Fix build error in include/drm/ttm/ttm_memory.h
Message-ID: <20091202125651.GA19748@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/drm/ttm/ttm_memory.h uses struct page * without having included
the required headers or a forward declaration resulting in the following
build error for mtx1_defconfig on Linus' master branch, possibly others:

  CC [M]  drivers/gpu/drm/ttm/ttm_memory.o
In file included from /home/ralf/src/linux/linux-mips/drivers/gpu/drm/ttm/ttm_memory.c:28:
/home/ralf/src/linux/linux-mips/include/drm/ttm/ttm_memory.h:154: warning: ‘struct page’ declared inside parameter list
/home/ralf/src/linux/linux-mips/include/drm/ttm/ttm_memory.h:154: warning: its scope is only this definition or declaration, which is probably not what you want
/home/ralf/src/linux/linux-mips/include/drm/ttm/ttm_memory.h:156: warning: ‘struct page’ declared inside parameter list
/home/ralf/src/linux/linux-mips/drivers/gpu/drm/ttm/ttm_memory.c:537: error: conflicting types for ‘ttm_mem_global_alloc_page’
/home/ralf/src/linux/linux-mips/include/drm/ttm/ttm_memory.h:152: note: previous declaration of ‘ttm_mem_global_alloc_page’ was here
/home/ralf/src/linux/linux-mips/drivers/gpu/drm/ttm/ttm_memory.c:560: error: conflicting types for ‘ttm_mem_global_free_page’
/home/ralf/src/linux/linux-mips/include/drm/ttm/ttm_memory.h:155: note: previous declaration of ‘ttm_mem_global_free_page’ was here
make[6]: *** [drivers/gpu/drm/ttm/ttm_memory.o] Error 1
make[5]: *** [drivers/gpu/drm/ttm] Error 2
make[4]: *** [drivers/gpu/drm] Error 2
make[3]: *** [drivers/gpu] Error 2
make[2]: *** [drivers] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Fixed by adding a forward declaration.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 include/drm/ttm/ttm_memory.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/drm/ttm/ttm_memory.h b/include/drm/ttm/ttm_memory.h
index 6983a7c..95355ee 100644
--- a/include/drm/ttm/ttm_memory.h
+++ b/include/drm/ttm/ttm_memory.h
@@ -143,6 +143,8 @@ static inline void ttm_mem_unregister_shrink(struct ttm_mem_global *glob,
 	spin_unlock(&glob->lock);
 }
 
+struct page;
+
 extern int ttm_mem_global_init(struct ttm_mem_global *glob);
 extern void ttm_mem_global_release(struct ttm_mem_global *glob);
 extern int ttm_mem_global_alloc(struct ttm_mem_global *glob, uint64_t memory,
