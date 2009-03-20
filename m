Return-Path: <linux-kernel-owner+w=401wt.eu-S1757775AbZCTOSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775AbZCTOSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 10:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbZCTOSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 10:18:25 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:32692 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753651AbZCTOSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 10:18:17 -0400
Message-ID: <49C3A564.8070207@shipmail.org>
Date: Fri, 20 Mar 2009 15:17:08 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
Organization: VMware
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Dave Airlie <airlied@gmail.com>, David Airlie <airlied@linux.ie>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
 changes
References: <20090319040809.GA29249@kroah.com> <21d7e9970903182348v57a78188ocefe138d353ee197@mail.gmail.com> <49C21B0B.4060809@shipmail.org> <20090319201136.GB17094@kroah.com> <49C2ADA8.2090405@shipmail.org> <20090320002314.GA18781@kroah.com>
In-Reply-To: <20090320002314.GA18781@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------070305090506020700070505"
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070305090506020700070505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Greg KH wrote:
> On Thu, Mar 19, 2009 at 09:40:08PM +0100, Thomas Hellstr=F6m wrote:
>  =20
>> Greg KH wrote:
>>    =20
>>> On Thu, Mar 19, 2009 at 11:14:35AM +0100, Thomas Hellstr=F6m wrote:
>>>  =20
>>>      =20
>>>>> First off, the non-staging patches need more complete changelog ent=
ries,
>>>>> a bit of meaning goes a long way. I'll ack them if they are documen=
ted=20
>>>>> and
>>>>> make sense. The unlocked ioctl hook makes sense to me at least!
>>>>>        =20
>>>>>          =20
>>>> For the non-staging patches, (which also sit in the modesetting-newt=
tm=20
>>>> tree), I can add some more elaborate comments. However I think all o=
f
>>>> them are targeted to support functionality for TTM, so unless the TT=
M
>>>> code goes into staging or mainstream, there is little point in mergi=
ng
>>>> them to core drm before other drivers find them useful.
>>>>
>>>> Although I see the patch adding TTM is including some backwards
>>>> compatibility defines (In particular the PAT compat stuff) that need=
s
>>>> to be stripped.
>>>>    =20
>>>>        =20
>>> Great, care to respin it and send it to me?
>>>
>>>      =20
>> Greg,
>> A clean TTM patch was sent to Intel with the other patches.
>> I'm not sure why it got lost along the way?
>>    =20
>
> As there seems to be an unknown number of people in the "intel chain"
> that resulted in me finally getting these patches, I don't hold out muc=
h
> hope that I'm going to be able to get more than what I already got from
> them :(
>
> So, any chance you could just resend it?  I'll be glad to trade it for =
a
> beer at the next conference :)
>
> thanks,
>
> greg k-h
>  =20
So, a beer it is :)

I'm attaching it with the latest TTM bugfixes and passing checkpatch.pl.
Note that this is against the DRM tree, not the staging tree.

Actually, there are two patches. One exporting the X86 PAT=20
pgprot_writecombine functionality, as the
psb / mrst architecture is dependant on it. There's no IO region we can=20
write-combine like for a traditional GPU, and not even the VDC GTT=20
supports traditional write-combining.

The psb / mrst part is not included, though but it should be sufficient=20
just to replace the ttm files
and remove those files not in this patch.

Now while we're at it, we could perhaps discuss the placement of TTM.
It will probably see some continous evolvement; Dave has suggested it=20
being a submodule on its own,
but nothing that should stop upstream merging or have a dramatic impact=20
on the in-kernel interfaces.
And there is another user of TTM as well, the openChrome drm module.
It's user mode interface is quite fixed save for the video decoder=20
functionality, and that can be stripped until there is user-space=20
support, so this module is probably mature enough to go at least into=20
the staging tree if not mainstream.

That would suggest placing TTM not as a subdirectory of the psb module=20
but as a freestanding subdirectory either of drm in mainstream or in=20
staging. Suggestions?

I attach the patches to the mail, rather than sending them standalone as=20
they will likely need some massaging by Greg.

/Thomas






--------------070305090506020700070505
Content-Type: text/x-patch;
 name="0001-x86-pat-Export-pgprot_writecombine.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-x86-pat-Export-pgprot_writecombine.patch"

>From c8c206700e1dfcf9485996692fdc666a71bafcf3 Mon Sep 17 00:00:00 2001
From: Thomas Hellstrom <thellstrom@vmware.com>
Date: Fri, 20 Mar 2009 14:13:07 +0100
Subject: [PATCH] x86 pat: Export pgprot_writecombine()

This is used by the TTM GPU memory management system.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 arch/x86/mm/pat.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 7b61036..a931d8c 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -14,6 +14,7 @@
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/module.h>
 
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
@@ -861,6 +862,8 @@ pgprot_t pgprot_writecombine(pgprot_t prot)
 	else
 		return pgprot_noncached(prot);
 }
+EXPORT_SYMBOL(pgprot_writecombine);
+
 
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_X86_PAT)
 
-- 
1.5.4.3


--------------070305090506020700070505
Content-Type: text/x-patch;
 name="0002-Add-the-TTM-gpu-memory-subsystem.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-Add-the-TTM-gpu-memory-subsystem.patch"

>From 863d645566e1c4fe3e2a4b143a1395f0a71d6195 Mon Sep 17 00:00:00 2001
From: Thomas Hellstrom <thellstrom@vmware.com>
Date: Fri, 20 Mar 2009 14:14:51 +0100
Subject: [PATCH] Add the TTM gpu memory subsystem.

Targeted as either a backing implementation to GEM for hardware
that needs write-combined system memory pages or has dedicated
VRAM, or standalone for the same types of hardware.

Features include fine-grained locking, X86 PAT support and built-in
GPU buffer object synchronization.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 drivers/gpu/drm/ttm/ttm_agp_backend.c    |  149 +++
 drivers/gpu/drm/ttm/ttm_bo.c             | 1713 ++++++++++++++++++++++++++++++
 drivers/gpu/drm/ttm/ttm_bo_util.c        |  540 ++++++++++
 drivers/gpu/drm/ttm/ttm_bo_vm.c          |  436 ++++++++
 drivers/gpu/drm/ttm/ttm_execbuf_util.c   |  115 ++
 drivers/gpu/drm/ttm/ttm_fence.c          |  610 +++++++++++
 drivers/gpu/drm/ttm/ttm_fence_user.c     |  240 +++++
 drivers/gpu/drm/ttm/ttm_lock.c           |  162 +++
 drivers/gpu/drm/ttm/ttm_memory.c         |  232 ++++
 drivers/gpu/drm/ttm/ttm_object.c         |  443 ++++++++
 drivers/gpu/drm/ttm/ttm_placement_user.c |  469 ++++++++
 drivers/gpu/drm/ttm/ttm_tt.c             |  627 +++++++++++
 include/drm/ttm/ttm_bo_api.h             |  581 ++++++++++
 include/drm/ttm/ttm_bo_driver.h          |  869 +++++++++++++++
 include/drm/ttm/ttm_execbuf_util.h       |  110 ++
 include/drm/ttm/ttm_fence_api.h          |  279 +++++
 include/drm/ttm/ttm_fence_driver.h       |  308 ++++++
 include/drm/ttm/ttm_fence_user.h         |  147 +++
 include/drm/ttm/ttm_lock.h               |  182 ++++
 include/drm/ttm/ttm_memory.h             |  154 +++
 include/drm/ttm/ttm_object.h             |  269 +++++
 include/drm/ttm/ttm_placement_common.h   |   94 ++
 include/drm/ttm/ttm_placement_user.h     |  259 +++++
 include/drm/ttm/ttm_userobj_api.h        |   79 ++
 24 files changed, 9067 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpu/drm/ttm/ttm_agp_backend.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_bo.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_bo_util.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_bo_vm.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_execbuf_util.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_fence.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_fence_user.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_lock.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_memory.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_object.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_placement_user.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_tt.c
 create mode 100644 include/drm/ttm/ttm_bo_api.h
 create mode 100644 include/drm/ttm/ttm_bo_driver.h
 create mode 100644 include/drm/ttm/ttm_execbuf_util.h
 create mode 100644 include/drm/ttm/ttm_fence_api.h
 create mode 100644 include/drm/ttm/ttm_fence_driver.h
 create mode 100644 include/drm/ttm/ttm_fence_user.h
 create mode 100644 include/drm/ttm/ttm_lock.h
 create mode 100644 include/drm/ttm/ttm_memory.h
 create mode 100644 include/drm/ttm/ttm_object.h
 create mode 100644 include/drm/ttm/ttm_placement_common.h
 create mode 100644 include/drm/ttm/ttm_placement_user.h
 create mode 100644 include/drm/ttm/ttm_userobj_api.h

diff --git a/drivers/gpu/drm/ttm/ttm_agp_backend.c b/drivers/gpu/drm/ttm/ttm_agp_backend.c
new file mode 100644
index 0000000..6844107
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_agp_backend.c
@@ -0,0 +1,149 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ *          Keith Packard.
+ */
+
+#include "ttm/ttm_bo_driver.h"
+#ifdef TTM_HAS_AGP
+#include "ttm/ttm_placement_common.h"
+#include <linux/agp_backend.h>
+#include <asm/agp.h>
+#include <linux/io.h>
+
+struct ttm_agp_backend {
+	struct ttm_backend backend;
+	struct agp_memory *mem;
+	struct agp_bridge_data *bridge;
+};
+
+static int ttm_agp_populate(struct ttm_backend *backend,
+			    unsigned long num_pages, struct page **pages,
+			    struct page *dummy_read_page)
+{
+	struct ttm_agp_backend *agp_be =
+	    container_of(backend, struct ttm_agp_backend, backend);
+	struct page **cur_page, **last_page = pages + num_pages;
+	struct agp_memory *mem;
+
+	mem = agp_allocate_memory(agp_be->bridge, num_pages, AGP_USER_MEMORY);
+	if (unlikely(mem == NULL))
+		return -ENOMEM;
+
+	mem->page_count = 0;
+	for (cur_page = pages; cur_page < last_page; ++cur_page) {
+		struct page *page = *cur_page;
+		if (!page)
+			page = dummy_read_page;
+
+		mem->memory[mem->page_count++] =
+		    phys_to_gart(page_to_phys(page));
+	}
+	agp_be->mem = mem;
+	return 0;
+}
+
+static int ttm_agp_bind(struct ttm_backend *backend, struct ttm_mem_reg *bo_mem)
+{
+	struct ttm_agp_backend *agp_be =
+	    container_of(backend, struct ttm_agp_backend, backend);
+	struct agp_memory *mem = agp_be->mem;
+	int cached = (bo_mem->flags & TTM_PL_FLAG_CACHED);
+	int ret;
+
+	mem->is_flushed = 1;
+	mem->type = (cached) ? AGP_USER_CACHED_MEMORY : AGP_USER_MEMORY;
+
+	ret = agp_bind_memory(mem, bo_mem->mm_node->start);
+	if (ret)
+		printk(KERN_ERR "AGP Bind memory failed.\n");
+
+	return ret;
+}
+
+static int ttm_agp_unbind(struct ttm_backend *backend)
+{
+	struct ttm_agp_backend *agp_be =
+	    container_of(backend, struct ttm_agp_backend, backend);
+
+	if (agp_be->mem->is_bound)
+		return agp_unbind_memory(agp_be->mem);
+	else
+		return 0;
+}
+
+static void ttm_agp_clear(struct ttm_backend *backend)
+{
+	struct ttm_agp_backend *agp_be =
+	    container_of(backend, struct ttm_agp_backend, backend);
+	struct agp_memory *mem = agp_be->mem;
+
+	if (mem) {
+		ttm_agp_unbind(backend);
+		agp_free_memory(mem);
+	}
+	agp_be->mem = NULL;
+}
+
+static void ttm_agp_destroy(struct ttm_backend *backend)
+{
+	struct ttm_agp_backend *agp_be =
+	    container_of(backend, struct ttm_agp_backend, backend);
+
+	if (agp_be->mem)
+		ttm_agp_clear(backend);
+	kfree(agp_be);
+}
+
+static struct ttm_backend_func ttm_agp_func = {
+	.populate = ttm_agp_populate,
+	.clear = ttm_agp_clear,
+	.bind = ttm_agp_bind,
+	.unbind = ttm_agp_unbind,
+	.destroy = ttm_agp_destroy,
+};
+
+struct ttm_backend *ttm_agp_backend_init(struct ttm_bo_device *bdev,
+					 struct agp_bridge_data *bridge)
+{
+	struct ttm_agp_backend *agp_be;
+
+	agp_be = kmalloc(sizeof(*agp_be), GFP_KERNEL);
+	if (!agp_be)
+		return NULL;
+
+	agp_be->mem = NULL;
+	agp_be->bridge = bridge;
+	agp_be->backend.func = &ttm_agp_func;
+	agp_be->backend.bdev = bdev;
+	return &agp_be->backend;
+}
+
+#endif
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
new file mode 100644
index 0000000..de3ec09
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -0,0 +1,1713 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#include "ttm/ttm_bo_driver.h"
+#include "ttm/ttm_placement_common.h"
+#include <linux/jiffies.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/file.h>
+
+#define TTM_ASSERT_LOCKED(param)
+#define TTM_DEBUG(fmt, arg...)
+#define TTM_BO_HASH_ORDER 13
+
+static int ttm_bo_setup_vm(struct ttm_buffer_object *bo);
+static void ttm_bo_unmap_virtual(struct ttm_buffer_object *bo);
+static int ttm_bo_swapout(struct ttm_mem_shrink *shrink);
+
+static inline uint32_t ttm_bo_type_flags(unsigned type)
+{
+	return 1 << (type);
+}
+
+static void ttm_bo_release_list(struct kref *list_kref)
+{
+	struct ttm_buffer_object *bo =
+	    container_of(list_kref, struct ttm_buffer_object, list_kref);
+	struct ttm_bo_device *bdev = bo->bdev;
+
+	BUG_ON(atomic_read(&bo->list_kref.refcount));
+	BUG_ON(atomic_read(&bo->kref.refcount));
+	BUG_ON(atomic_read(&bo->cpu_writers));
+	BUG_ON(bo->sync_obj != NULL);
+	BUG_ON(bo->mem.mm_node != NULL);
+	BUG_ON(!list_empty(&bo->lru));
+	BUG_ON(!list_empty(&bo->ddestroy));
+
+	if (bo->ttm)
+		ttm_tt_destroy(bo->ttm);
+	if (bo->destroy)
+		bo->destroy(bo);
+	else {
+		ttm_mem_global_free(bdev->mem_glob, bo->acc_size, false);
+		kfree(bo);
+	}
+}
+
+int ttm_bo_wait_unreserved(struct ttm_buffer_object *bo, bool interruptible)
+{
+
+	if (interruptible) {
+		int ret = 0;
+
+		ret = wait_event_interruptible(bo->event_queue,
+					       atomic_read(&bo->reserved) == 0);
+		if (unlikely(ret != 0))
+			return -ERESTART;
+	} else {
+		wait_event(bo->event_queue, atomic_read(&bo->reserved) == 0);
+	}
+	return 0;
+}
+
+static void ttm_bo_add_to_lru(struct ttm_buffer_object *bo)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_mem_type_manager *man;
+
+	BUG_ON(!atomic_read(&bo->reserved));
+
+	if (!(bo->mem.flags & TTM_PL_FLAG_NO_EVICT)) {
+
+		BUG_ON(!list_empty(&bo->lru));
+
+		man = &bdev->man[bo->mem.mem_type];
+		list_add_tail(&bo->lru, &man->lru);
+		kref_get(&bo->list_kref);
+
+		if (bo->ttm != NULL) {
+			list_add_tail(&bo->swap, &bdev->swap_lru);
+			kref_get(&bo->list_kref);
+		}
+	}
+}
+
+/**
+ * Call with the lru_lock held.
+ */
+
+static int ttm_bo_del_from_lru(struct ttm_buffer_object *bo)
+{
+	int put_count = 0;
+
+	if (!list_empty(&bo->swap)) {
+		list_del_init(&bo->swap);
+		++put_count;
+	}
+	if (!list_empty(&bo->lru)) {
+		list_del_init(&bo->lru);
+		++put_count;
+	}
+
+	/*
+	 * TODO: Add a driver hook to delete from
+	 * driver-specific LRU's here.
+	 */
+
+	return put_count;
+}
+
+int ttm_bo_reserve_locked(struct ttm_buffer_object *bo,
+			  bool interruptible,
+			  bool no_wait, bool use_sequence, uint32_t sequence)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	int ret;
+
+	while (unlikely(atomic_cmpxchg(&bo->reserved, 0, 1) != 0)) {
+		if (use_sequence && bo->seq_valid &&
+			(sequence - bo->val_seq < (1 << 31))) {
+			return -EAGAIN;
+		}
+
+		if (no_wait)
+			return -EBUSY;
+
+		spin_unlock(&bdev->lru_lock);
+		ret = ttm_bo_wait_unreserved(bo, interruptible);
+		spin_lock(&bdev->lru_lock);
+
+		if (unlikely(ret))
+			return ret;
+	}
+
+	if (use_sequence) {
+		bo->val_seq = sequence;
+		bo->seq_valid = true;
+	} else {
+		bo->seq_valid = false;
+	}
+
+	return 0;
+}
+
+static void ttm_bo_ref_bug(struct kref *list_kref)
+{
+	BUG();
+}
+
+int ttm_bo_reserve(struct ttm_buffer_object *bo,
+		   bool interruptible,
+		   bool no_wait, bool use_sequence, uint32_t sequence)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	int put_count = 0;
+	int ret;
+
+	spin_lock(&bdev->lru_lock);
+	ret = ttm_bo_reserve_locked(bo, interruptible, no_wait, use_sequence,
+				    sequence);
+	if (likely(ret == 0))
+		put_count = ttm_bo_del_from_lru(bo);
+	spin_unlock(&bdev->lru_lock);
+
+	while (put_count--)
+		kref_put(&bo->list_kref, ttm_bo_ref_bug);
+
+	return ret;
+}
+
+void ttm_bo_unreserve(struct ttm_buffer_object *bo)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+
+	spin_lock(&bdev->lru_lock);
+	ttm_bo_add_to_lru(bo);
+	atomic_set(&bo->reserved, 0);
+	wake_up_all(&bo->event_queue);
+	spin_unlock(&bdev->lru_lock);
+}
+
+/*
+ * Call bo->mutex locked.
+ */
+
+static int ttm_bo_add_ttm(struct ttm_buffer_object *bo)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	int ret = 0;
+	uint32_t page_flags = 0;
+
+	TTM_ASSERT_LOCKED(&bo->mutex);
+	bo->ttm = NULL;
+
+	switch (bo->type) {
+	case ttm_bo_type_device:
+	case ttm_bo_type_kernel:
+		bo->ttm = ttm_tt_create(bdev, bo->num_pages << PAGE_SHIFT,
+					page_flags, bdev->dummy_read_page);
+		if (unlikely(bo->ttm == NULL))
+			ret = -ENOMEM;
+		break;
+	case ttm_bo_type_user:
+		bo->ttm = ttm_tt_create(bdev, bo->num_pages << PAGE_SHIFT,
+					page_flags | TTM_PAGE_FLAG_USER,
+					bdev->dummy_read_page);
+		if (unlikely(bo->ttm == NULL))
+			ret = -ENOMEM;
+		break;
+
+		ret = ttm_tt_set_user(bo->ttm, current,
+				      bo->buffer_start, bo->num_pages);
+		if (unlikely(ret != 0))
+			ttm_tt_destroy(bo->ttm);
+		break;
+	default:
+		printk(KERN_ERR "Illegal buffer object type\n");
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static int ttm_bo_handle_move_mem(struct ttm_buffer_object *bo,
+				  struct ttm_mem_reg *mem,
+				  bool evict, bool interruptible, bool no_wait)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	bool old_is_pci = ttm_mem_reg_is_pci(bdev, &bo->mem);
+	bool new_is_pci = ttm_mem_reg_is_pci(bdev, mem);
+	struct ttm_mem_type_manager *old_man = &bdev->man[bo->mem.mem_type];
+	struct ttm_mem_type_manager *new_man = &bdev->man[mem->mem_type];
+	int ret = 0;
+
+	if (old_is_pci || new_is_pci ||
+	    ((mem->flags & bo->mem.flags & TTM_PL_MASK_CACHING) == 0))
+		ttm_bo_unmap_virtual(bo);
+
+	/*
+	 * Create and bind a ttm if required.
+	 */
+
+	if (!(new_man->flags & TTM_MEMTYPE_FLAG_FIXED) && (bo->ttm == NULL)) {
+		ret = ttm_bo_add_ttm(bo);
+		if (ret)
+			goto out_err;
+
+		ret = ttm_tt_set_placement_caching(bo->ttm, mem->flags);
+		if (ret)
+			return ret;
+
+		if (mem->mem_type != TTM_PL_SYSTEM) {
+			ret = ttm_tt_bind(bo->ttm, mem);
+			if (ret)
+				goto out_err;
+		}
+
+		if (bo->mem.mem_type == TTM_PL_SYSTEM) {
+
+			struct ttm_mem_reg *old_mem = &bo->mem;
+			uint32_t save_flags = old_mem->flags;
+			uint32_t save_proposed_flags = old_mem->proposed_flags;
+
+			*old_mem = *mem;
+			mem->mm_node = NULL;
+			old_mem->proposed_flags = save_proposed_flags;
+			ttm_flag_masked(&save_flags, mem->flags,
+					TTM_PL_MASK_MEMTYPE);
+			goto moved;
+		}
+
+	}
+
+	if (!(old_man->flags & TTM_MEMTYPE_FLAG_FIXED) &&
+	    !(new_man->flags & TTM_MEMTYPE_FLAG_FIXED))
+		ret = ttm_bo_move_ttm(bo, evict, no_wait, mem);
+	else if (bdev->driver->move)
+		ret = bdev->driver->move(bo, evict, interruptible,
+					 no_wait, mem);
+	else
+		ret = ttm_bo_move_memcpy(bo, evict, no_wait, mem);
+
+	if (ret)
+		goto out_err;
+
+moved:
+	if (bo->priv_flags & TTM_BO_PRIV_FLAG_EVICTED) {
+		ret = bdev->driver->invalidate_caches(bdev, bo->mem.flags);
+		if (ret)
+			printk(KERN_ERR "Can not flush read caches\n");
+	}
+
+	ttm_flag_masked(&bo->priv_flags,
+			(evict) ? TTM_BO_PRIV_FLAG_EVICTED : 0,
+			TTM_BO_PRIV_FLAG_EVICTED);
+
+	if (bo->mem.mm_node)
+		bo->offset = (bo->mem.mm_node->start << PAGE_SHIFT) +
+		    bdev->man[bo->mem.mem_type].gpu_offset;
+
+	return 0;
+
+out_err:
+	new_man = &bdev->man[bo->mem.mem_type];
+	if ((new_man->flags & TTM_MEMTYPE_FLAG_FIXED) && bo->ttm) {
+		ttm_tt_unbind(bo->ttm);
+		ttm_tt_destroy(bo->ttm);
+		bo->ttm = NULL;
+	}
+
+	return ret;
+}
+
+static int ttm_bo_expire_sync_obj(struct ttm_buffer_object *bo,
+				  bool allow_errors)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_bo_driver *driver = bdev->driver;
+
+	if (bo->sync_obj) {
+		if (bdev->nice_mode) {
+			unsigned long _end = jiffies + 3 * HZ;
+			int ret;
+			do {
+				ret = ttm_bo_wait(bo, false, false, false);
+				if (ret && allow_errors)
+					return ret;
+
+			} while (ret && !time_after_eq(jiffies, _end));
+
+			if (bo->sync_obj) {
+				bdev->nice_mode = false;
+				printk(KERN_ERR "Detected probable GPU lockup. "
+				       "Evicting buffer.\n");
+			}
+		}
+		if (bo->sync_obj) {
+			driver->sync_obj_unref(&bo->sync_obj);
+			bo->priv_flags &= ~TTM_BO_PRIV_FLAG_MOVING;
+		}
+	}
+	return 0;
+}
+
+/**
+ * If bo idle, remove from delayed- and lru lists, and unref.
+ * If not idle, and already on delayed list, do nothing.
+ * If not idle, and not on delayed list, put on delayed list,
+ *   up the list_kref and schedule a delayed list check.
+ */
+
+static void ttm_bo_cleanup_refs(struct ttm_buffer_object *bo, bool remove_all)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_bo_driver *driver = bdev->driver;
+
+	mutex_lock(&bo->mutex);
+
+	if (bo->sync_obj && driver->sync_obj_signaled(bo->sync_obj,
+						      bo->sync_obj_arg)) {
+		driver->sync_obj_unref(&bo->sync_obj);
+		bo->priv_flags &= ~TTM_BO_PRIV_FLAG_MOVING;
+	}
+
+	if (bo->sync_obj && remove_all)
+		(void)ttm_bo_expire_sync_obj(bo, false);
+
+	if (!bo->sync_obj) {
+		int put_count;
+
+		if (bo->ttm)
+			ttm_tt_unbind(bo->ttm);
+		spin_lock(&bdev->lru_lock);
+		if (!list_empty(&bo->ddestroy)) {
+			list_del_init(&bo->ddestroy);
+			kref_put(&bo->list_kref, ttm_bo_ref_bug);
+		}
+		if (bo->mem.mm_node) {
+			drm_mm_put_block(bo->mem.mm_node);
+			bo->mem.mm_node = NULL;
+		}
+		put_count = ttm_bo_del_from_lru(bo);
+		spin_unlock(&bdev->lru_lock);
+		mutex_unlock(&bo->mutex);
+		while (put_count--)
+			kref_put(&bo->list_kref, ttm_bo_release_list);
+
+		return;
+	}
+
+	spin_lock(&bdev->lru_lock);
+	if (list_empty(&bo->ddestroy)) {
+		spin_unlock(&bdev->lru_lock);
+		driver->sync_obj_flush(bo->sync_obj, bo->sync_obj_arg);
+		spin_lock(&bdev->lru_lock);
+		if (list_empty(&bo->ddestroy)) {
+			kref_get(&bo->list_kref);
+			list_add_tail(&bo->ddestroy, &bdev->ddestroy);
+		}
+		spin_unlock(&bdev->lru_lock);
+		schedule_delayed_work(&bdev->wq,
+				      ((HZ / 100) < 1) ? 1 : HZ / 100);
+	} else
+		spin_unlock(&bdev->lru_lock);
+
+	mutex_unlock(&bo->mutex);
+	return;
+}
+
+/**
+ * Traverse the delayed list, and call ttm_bo_cleanup_refs on all
+ * encountered buffers.
+ */
+
+static int ttm_bo_delayed_delete(struct ttm_bo_device *bdev, bool remove_all)
+{
+	struct ttm_buffer_object *entry, *nentry;
+	struct list_head *list, *next;
+	int ret;
+
+	spin_lock(&bdev->lru_lock);
+	list_for_each_safe(list, next, &bdev->ddestroy) {
+		entry = list_entry(list, struct ttm_buffer_object, ddestroy);
+		nentry = NULL;
+
+		/*
+		 * Protect the next list entry from destruction while we
+		 * unlock the lru_lock.
+		 */
+
+		if (next != &bdev->ddestroy) {
+			nentry = list_entry(next, struct ttm_buffer_object,
+					    ddestroy);
+			kref_get(&nentry->list_kref);
+		}
+		kref_get(&entry->list_kref);
+
+		spin_unlock(&bdev->lru_lock);
+		ttm_bo_cleanup_refs(entry, remove_all);
+		kref_put(&entry->list_kref, ttm_bo_release_list);
+		spin_lock(&bdev->lru_lock);
+
+		if (nentry) {
+			bool next_onlist = !list_empty(next);
+			kref_put(&nentry->list_kref, ttm_bo_release_list);
+
+			/*
+			 * Someone might have raced us and removed the
+			 * next entry from the list. We don't bother restarting
+			 * list traversal.
+			 */
+
+			if (!next_onlist)
+				break;
+		}
+	}
+	ret = !list_empty(&bdev->ddestroy);
+	spin_unlock(&bdev->lru_lock);
+
+	return ret;
+}
+
+static void ttm_bo_delayed_workqueue(struct work_struct *work)
+{
+	struct ttm_bo_device *bdev =
+	    container_of(work, struct ttm_bo_device, wq.work);
+
+	if (ttm_bo_delayed_delete(bdev, false)) {
+		schedule_delayed_work(&bdev->wq,
+				      ((HZ / 100) < 1) ? 1 : HZ / 100);
+	}
+}
+
+static void ttm_bo_release(struct kref *kref)
+{
+	struct ttm_buffer_object *bo =
+	    container_of(kref, struct ttm_buffer_object, kref);
+	struct ttm_bo_device *bdev = bo->bdev;
+
+	if (likely(bo->vm_node != NULL)) {
+		rb_erase(&bo->vm_rb, &bdev->addr_space_rb);
+		drm_mm_put_block(bo->vm_node);
+	}
+	write_unlock(&bdev->vm_lock);
+	ttm_bo_cleanup_refs(bo, false);
+	kref_put(&bo->list_kref, ttm_bo_release_list);
+	write_lock(&bdev->vm_lock);
+}
+
+void ttm_bo_unref(struct ttm_buffer_object **p_bo)
+{
+	struct ttm_buffer_object *bo = *p_bo;
+	struct ttm_bo_device *bdev = bo->bdev;
+
+	*p_bo = NULL;
+	write_lock(&bdev->vm_lock);
+	kref_put(&bo->kref, ttm_bo_release);
+	write_unlock(&bdev->vm_lock);
+}
+
+static int ttm_bo_evict(struct ttm_buffer_object *bo, unsigned mem_type,
+			bool interruptible, bool no_wait)
+{
+	int ret = 0;
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_mem_reg evict_mem;
+
+	if (bo->mem.mem_type != mem_type)
+		goto out;
+
+	ret = ttm_bo_wait(bo, false, interruptible, no_wait);
+	if (ret && ret != -ERESTART) {
+		printk(KERN_ERR "Failed to expire sync object before "
+		       "buffer eviction.\n");
+		goto out;
+	}
+
+	BUG_ON(!atomic_read(&bo->reserved));
+
+	evict_mem = bo->mem;
+	evict_mem.mm_node = NULL;
+
+	evict_mem.proposed_flags = bdev->driver->evict_flags(bo);
+	BUG_ON(ttm_bo_type_flags(mem_type) & evict_mem.proposed_flags);
+
+	ret = ttm_bo_mem_space(bo, &evict_mem, interruptible, no_wait);
+	if (unlikely(ret != 0 && ret != -ERESTART)) {
+		evict_mem.proposed_flags = TTM_PL_FLAG_SYSTEM;
+		BUG_ON(ttm_bo_type_flags(mem_type) & evict_mem.proposed_flags);
+		ret = ttm_bo_mem_space(bo, &evict_mem, interruptible, no_wait);
+	}
+
+	if (ret) {
+		if (ret != -ERESTART)
+			printk(KERN_ERR "Failed to find memory space for "
+			       "buffer 0x%p eviction.\n", bo);
+		goto out;
+	}
+
+	ret = ttm_bo_handle_move_mem(bo, &evict_mem, true, interruptible,
+				     no_wait);
+	if (ret) {
+		if (ret != -ERESTART)
+			printk(KERN_ERR "Buffer eviction failed\n");
+		goto out;
+	}
+
+	spin_lock(&bdev->lru_lock);
+	if (evict_mem.mm_node) {
+		drm_mm_put_block(evict_mem.mm_node);
+		evict_mem.mm_node = NULL;
+	}
+	spin_unlock(&bdev->lru_lock);
+
+	ttm_flag_masked(&bo->priv_flags, TTM_BO_PRIV_FLAG_EVICTED,
+			TTM_BO_PRIV_FLAG_EVICTED);
+
+out:
+	return ret;
+}
+
+/**
+ * Repeatedly evict memory from the LRU for @mem_type until we create enough
+ * space, or we've evicted everything and there isn't enough space.
+ */
+static int ttm_bo_mem_force_space(struct ttm_bo_device *bdev,
+				  struct ttm_mem_reg *mem,
+				  uint32_t mem_type,
+				  bool interruptible, bool no_wait)
+{
+	struct drm_mm_node *node;
+	struct ttm_buffer_object *entry;
+	struct ttm_mem_type_manager *man = &bdev->man[mem_type];
+	struct list_head *lru;
+	unsigned long num_pages = mem->num_pages;
+	int put_count = 0;
+	int ret;
+
+retry_pre_get:
+	ret = drm_mm_pre_get(&man->manager);
+	if (unlikely(ret != 0))
+		return ret;
+
+	spin_lock(&bdev->lru_lock);
+	do {
+		node = drm_mm_search_free(&man->manager, num_pages,
+					  mem->page_alignment, 1);
+		if (node)
+			break;
+
+		lru = &man->lru;
+		if (list_empty(lru))
+			break;
+
+		entry = list_first_entry(lru, struct ttm_buffer_object, lru);
+		kref_get(&entry->list_kref);
+
+		ret = ttm_bo_reserve_locked(entry, interruptible,
+					    no_wait, false, 0);
+
+		if (likely(ret == 0))
+			put_count = ttm_bo_del_from_lru(entry);
+
+		spin_unlock(&bdev->lru_lock);
+
+		if (unlikely(ret != 0))
+			return ret;
+
+		while (put_count--)
+			kref_put(&entry->list_kref, ttm_bo_ref_bug);
+
+		mutex_lock(&entry->mutex);
+		ret = ttm_bo_evict(entry, mem_type, interruptible, no_wait);
+		mutex_unlock(&entry->mutex);
+
+		ttm_bo_unreserve(entry);
+
+		kref_put(&entry->list_kref, ttm_bo_release_list);
+		if (ret)
+			return ret;
+
+		spin_lock(&bdev->lru_lock);
+	} while (1);
+
+	if (!node) {
+		spin_unlock(&bdev->lru_lock);
+		return -ENOMEM;
+	}
+
+	node = drm_mm_get_block_atomic(node, num_pages, mem->page_alignment);
+	if (unlikely(!node)) {
+		spin_unlock(&bdev->lru_lock);
+		goto retry_pre_get;
+	}
+
+	spin_unlock(&bdev->lru_lock);
+	mem->mm_node = node;
+	mem->mem_type = mem_type;
+	return 0;
+}
+
+static bool ttm_bo_mt_compatible(struct ttm_mem_type_manager *man,
+				 bool disallow_fixed,
+				 uint32_t mem_type,
+				 uint32_t mask, uint32_t *res_mask)
+{
+	uint32_t cur_flags = ttm_bo_type_flags(mem_type);
+
+	if ((man->flags & TTM_MEMTYPE_FLAG_FIXED) && disallow_fixed)
+		return false;
+
+	if ((cur_flags & mask & TTM_PL_MASK_MEM) == 0)
+		return false;
+
+	if ((mask & man->available_caching) == 0)
+		return false;
+	if (mask & man->default_caching)
+		cur_flags |= man->default_caching;
+	else if (mask & TTM_PL_FLAG_CACHED)
+		cur_flags |= TTM_PL_FLAG_CACHED;
+	else if (mask & TTM_PL_FLAG_WC)
+		cur_flags |= TTM_PL_FLAG_WC;
+	else
+		cur_flags |= TTM_PL_FLAG_UNCACHED;
+
+	*res_mask = cur_flags;
+	return true;
+}
+
+/**
+ * Creates space for memory region @mem according to its type.
+ *
+ * This function first searches for free space in compatible memory types in
+ * the priority order defined by the driver.  If free space isn't found, then
+ * ttm_bo_mem_force_space is attempted in priority order to evict and find
+ * space.
+ */
+int ttm_bo_mem_space(struct ttm_buffer_object *bo,
+		     struct ttm_mem_reg *mem, bool interruptible, bool no_wait)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_mem_type_manager *man;
+
+	uint32_t num_prios = bdev->driver->num_mem_type_prio;
+	const uint32_t *prios = bdev->driver->mem_type_prio;
+	uint32_t i;
+	uint32_t mem_type = TTM_PL_SYSTEM;
+	uint32_t cur_flags = 0;
+	bool type_found = false;
+	bool type_ok = false;
+	bool has_eagain = false;
+	struct drm_mm_node *node = NULL;
+	int ret;
+
+	mem->mm_node = NULL;
+	for (i = 0; i < num_prios; ++i) {
+		mem_type = prios[i];
+		man = &bdev->man[mem_type];
+
+		type_ok = ttm_bo_mt_compatible(man,
+					       bo->type == ttm_bo_type_user,
+					       mem_type, mem->proposed_flags,
+					       &cur_flags);
+
+		if (!type_ok)
+			continue;
+
+		if (mem_type == TTM_PL_SYSTEM)
+			break;
+
+		if (man->has_type && man->use_type) {
+			type_found = true;
+			do {
+				ret = drm_mm_pre_get(&man->manager);
+				if (unlikely(ret))
+					return ret;
+
+				spin_lock(&bdev->lru_lock);
+				node = drm_mm_search_free(&man->manager,
+							  mem->num_pages,
+							  mem->page_alignment,
+							  1);
+				if (unlikely(!node)) {
+					spin_unlock(&bdev->lru_lock);
+					break;
+				}
+				node = drm_mm_get_block_atomic(node,
+							       mem->num_pages,
+							       mem->
+							       page_alignment);
+				spin_unlock(&bdev->lru_lock);
+			} while (!node);
+		}
+		if (node)
+			break;
+	}
+
+	if ((type_ok && (mem_type == TTM_PL_SYSTEM)) || node) {
+		mem->mm_node = node;
+		mem->mem_type = mem_type;
+		mem->flags = cur_flags;
+		return 0;
+	}
+
+	if (!type_found)
+		return -EINVAL;
+
+	num_prios = bdev->driver->num_mem_busy_prio;
+	prios = bdev->driver->mem_busy_prio;
+
+	for (i = 0; i < num_prios; ++i) {
+		mem_type = prios[i];
+		man = &bdev->man[mem_type];
+
+		if (!man->has_type)
+			continue;
+
+		if (!ttm_bo_mt_compatible(man,
+					  bo->type == ttm_bo_type_user,
+					  mem_type,
+					  mem->proposed_flags, &cur_flags))
+			continue;
+
+		ret = ttm_bo_mem_force_space(bdev, mem, mem_type,
+					     interruptible, no_wait);
+
+		if (ret == 0 && mem->mm_node) {
+			mem->flags = cur_flags;
+			return 0;
+		}
+
+		if (ret == -ERESTART)
+			has_eagain = true;
+	}
+
+	ret = (has_eagain) ? -ERESTART : -ENOMEM;
+	return ret;
+}
+
+/*
+ * Call bo->mutex locked.
+ * Returns 1 if the buffer is currently rendered to or from. 0 otherwise.
+ */
+
+static int ttm_bo_busy(struct ttm_buffer_object *bo)
+{
+	void *sync_obj = bo->sync_obj;
+	struct ttm_bo_driver *driver = bo->bdev->driver;
+
+	if (sync_obj) {
+		if (driver->sync_obj_signaled(sync_obj, bo->sync_obj_arg)) {
+			driver->sync_obj_unref(&bo->sync_obj);
+			bo->priv_flags &= ~TTM_BO_PRIV_FLAG_MOVING;
+			return 0;
+		}
+		driver->sync_obj_flush(sync_obj, bo->sync_obj_arg);
+		if (driver->sync_obj_signaled(sync_obj, bo->sync_obj_arg)) {
+			driver->sync_obj_unref(&bo->sync_obj);
+			bo->priv_flags &= ~TTM_BO_PRIV_FLAG_MOVING;
+			return 0;
+		}
+		return 1;
+	}
+	return 0;
+}
+
+int ttm_bo_wait_cpu(struct ttm_buffer_object *bo, bool no_wait)
+{
+	int ret = 0;
+
+	if ((atomic_read(&bo->cpu_writers) > 0) && no_wait)
+		return -EBUSY;
+
+	ret = wait_event_interruptible(bo->event_queue,
+				       atomic_read(&bo->cpu_writers) == 0);
+
+	if (ret == -ERESTARTSYS)
+		ret = -ERESTART;
+
+	return ret;
+}
+
+/*
+ * bo->mutex locked.
+ * Note that new_mem_flags are NOT transferred to the bo->mem.proposed_flags.
+ */
+
+int ttm_bo_move_buffer(struct ttm_buffer_object *bo, uint32_t new_mem_flags,
+		       bool interruptible, bool no_wait)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	int ret = 0;
+	struct ttm_mem_reg mem;
+
+	BUG_ON(!atomic_read(&bo->reserved));
+
+	/*
+	 * FIXME: It's possible to pipeline buffer moves.
+	 * Have the driver move function wait for idle when necessary,
+	 * instead of doing it here.
+	 */
+
+	ttm_bo_busy(bo);
+	ret = ttm_bo_wait(bo, false, interruptible, no_wait);
+	if (ret)
+		return ret;
+
+	mem.num_pages = bo->num_pages;
+	mem.size = mem.num_pages << PAGE_SHIFT;
+	mem.proposed_flags = new_mem_flags;
+	mem.page_alignment = bo->mem.page_alignment;
+
+	/*
+	 * Determine where to move the buffer.
+	 */
+
+	ret = ttm_bo_mem_space(bo, &mem, interruptible, no_wait);
+	if (ret)
+		goto out_unlock;
+
+	ret = ttm_bo_handle_move_mem(bo, &mem, false, interruptible, no_wait);
+
+out_unlock:
+	if (ret && mem.mm_node) {
+		spin_lock(&bdev->lru_lock);
+		drm_mm_put_block(mem.mm_node);
+		spin_unlock(&bdev->lru_lock);
+	}
+	return ret;
+}
+
+static int ttm_bo_mem_compat(struct ttm_mem_reg *mem)
+{
+	if ((mem->proposed_flags & mem->flags & TTM_PL_MASK_MEM) == 0)
+		return 0;
+	if ((mem->proposed_flags & mem->flags & TTM_PL_MASK_CACHING) == 0)
+		return 0;
+
+	return 1;
+}
+
+int ttm_buffer_object_validate(struct ttm_buffer_object *bo,
+			       bool interruptible, bool no_wait)
+{
+	int ret;
+
+	BUG_ON(!atomic_read(&bo->reserved));
+	bo->mem.proposed_flags = bo->proposed_flags;
+
+	TTM_DEBUG("Proposed flags 0x%08lx, Old flags 0x%08lx\n",
+		  (unsigned long)bo->mem.proposed_flags,
+		  (unsigned long)bo->mem.flags);
+
+	/*
+	 * Check whether we need to move buffer.
+	 */
+
+	if (!ttm_bo_mem_compat(&bo->mem)) {
+		ret = ttm_bo_move_buffer(bo, bo->mem.proposed_flags,
+					 interruptible, no_wait);
+		if (ret) {
+			if (ret != -ERESTART)
+				printk(KERN_ERR "Failed moving buffer. "
+				       "Proposed placement 0x%08x\n",
+				       bo->mem.proposed_flags);
+			if (ret == -ENOMEM)
+				printk(KERN_ERR "Out of aperture space or "
+				       "DRM memory quota.\n");
+			return ret;
+		}
+	}
+
+	/*
+	 * We might need to add a TTM.
+	 */
+
+	if (bo->mem.mem_type == TTM_PL_SYSTEM && bo->ttm == NULL) {
+		ret = ttm_bo_add_ttm(bo);
+		if (ret)
+			return ret;
+	}
+	/*
+	 * Validation has succeeded, move the access and other
+	 * non-mapping-related flag bits from the proposed flags to
+	 * the active flags
+	 */
+
+	ttm_flag_masked(&bo->mem.flags, bo->proposed_flags,
+			~TTM_PL_MASK_MEMTYPE);
+
+	return 0;
+}
+
+int
+ttm_bo_check_placement(struct ttm_buffer_object *bo,
+		       uint32_t set_flags, uint32_t clr_flags)
+{
+	uint32_t new_mask = set_flags | clr_flags;
+
+	if ((bo->type == ttm_bo_type_user) &&
+	    (clr_flags & TTM_PL_FLAG_CACHED)) {
+		printk(KERN_ERR
+		       "User buffers require cache-coherent memory.\n");
+		return -EINVAL;
+	}
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		if (new_mask & TTM_PL_FLAG_NO_EVICT) {
+			printk(KERN_ERR "Need to be root to modify"
+			       " NO_EVICT status.\n");
+			return -EINVAL;
+		}
+
+		if ((clr_flags & bo->mem.flags & TTM_PL_MASK_MEMTYPE) &&
+		    (bo->mem.flags & TTM_PL_FLAG_NO_EVICT)) {
+			printk(KERN_ERR "Incompatible memory specification"
+			       " for NO_EVICT buffer.\n");
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+int ttm_buffer_object_init(struct ttm_bo_device *bdev,
+			   struct ttm_buffer_object *bo,
+			   unsigned long size,
+			   enum ttm_bo_type type,
+			   uint32_t flags,
+			   uint32_t page_alignment,
+			   unsigned long buffer_start,
+			   bool interruptible,
+			   struct file *persistant_swap_storage,
+			   size_t acc_size,
+			   void (*destroy) (struct ttm_buffer_object *))
+{
+	int ret = 0;
+	unsigned long num_pages;
+
+	size += buffer_start & ~PAGE_MASK;
+	num_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (num_pages == 0) {
+		printk(KERN_ERR "Illegal buffer object size.\n");
+		return -EINVAL;
+	}
+	bo->destroy = destroy;
+
+	mutex_init(&bo->mutex);
+	mutex_lock(&bo->mutex);
+	kref_init(&bo->kref);
+	kref_init(&bo->list_kref);
+	atomic_set(&bo->cpu_writers, 0);
+	atomic_set(&bo->reserved, 1);
+	init_waitqueue_head(&bo->event_queue);
+	INIT_LIST_HEAD(&bo->lru);
+	INIT_LIST_HEAD(&bo->ddestroy);
+	INIT_LIST_HEAD(&bo->swap);
+	bo->bdev = bdev;
+	bo->type = type;
+	bo->num_pages = num_pages;
+	bo->mem.mem_type = TTM_PL_SYSTEM;
+	bo->mem.num_pages = bo->num_pages;
+	bo->mem.mm_node = NULL;
+	bo->mem.page_alignment = page_alignment;
+	bo->buffer_start = buffer_start & PAGE_MASK;
+	bo->priv_flags = 0;
+	bo->mem.flags = (TTM_PL_FLAG_SYSTEM | TTM_PL_FLAG_CACHED);
+	bo->seq_valid = false;
+	bo->persistant_swap_storage = persistant_swap_storage;
+	bo->acc_size = acc_size;
+
+	ret = ttm_bo_check_placement(bo, flags, 0ULL);
+	if (unlikely(ret != 0))
+		goto out_err;
+
+	/*
+	 * If no caching attributes are set, accept any form of caching.
+	 */
+
+	if ((flags & TTM_PL_MASK_CACHING) == 0)
+		flags |= TTM_PL_MASK_CACHING;
+
+	bo->proposed_flags = flags;
+	bo->mem.proposed_flags = flags;
+
+	/*
+	 * For ttm_bo_type_device buffers, allocate
+	 * address space from the device.
+	 */
+
+	if (bo->type == ttm_bo_type_device) {
+		ret = ttm_bo_setup_vm(bo);
+		if (ret)
+			goto out_err;
+	}
+
+	ret = ttm_buffer_object_validate(bo, interruptible, false);
+	if (ret)
+		goto out_err;
+
+	mutex_unlock(&bo->mutex);
+	ttm_bo_unreserve(bo);
+	return 0;
+
+out_err:
+	mutex_unlock(&bo->mutex);
+	ttm_bo_unreserve(bo);
+	ttm_bo_unref(&bo);
+
+	return ret;
+}
+
+static inline size_t ttm_bo_size(struct ttm_bo_device *bdev,
+				 unsigned long num_pages)
+{
+	size_t page_array_size = (num_pages * sizeof(void *) + PAGE_SIZE - 1) &
+	    PAGE_MASK;
+
+	return bdev->ttm_bo_size + 2 * page_array_size;
+}
+
+int ttm_buffer_object_create(struct ttm_bo_device *bdev,
+			     unsigned long size,
+			     enum ttm_bo_type type,
+			     uint32_t flags,
+			     uint32_t page_alignment,
+			     unsigned long buffer_start,
+			     bool interruptible,
+			     struct file *persistant_swap_storage,
+			     struct ttm_buffer_object **p_bo)
+{
+	struct ttm_buffer_object *bo;
+	int ret;
+	struct ttm_mem_global *mem_glob = bdev->mem_glob;
+
+	size_t acc_size =
+	    ttm_bo_size(bdev, (size + PAGE_SIZE - 1) >> PAGE_SHIFT);
+	ret = ttm_mem_global_alloc(mem_glob, acc_size, false, false, false);
+	if (unlikely(ret != 0))
+		return ret;
+
+	bo = kzalloc(sizeof(*bo), GFP_KERNEL);
+
+	if (unlikely(bo == NULL)) {
+		ttm_mem_global_free(mem_glob, acc_size, false);
+		return -ENOMEM;
+	}
+
+	ret = ttm_buffer_object_init(bdev, bo, size, type, flags,
+				     page_alignment, buffer_start,
+				     interruptible,
+				     persistant_swap_storage, acc_size, NULL);
+	if (likely(ret == 0))
+		*p_bo = bo;
+
+	return ret;
+}
+
+static int ttm_bo_leave_list(struct ttm_buffer_object *bo,
+			     uint32_t mem_type, bool allow_errors)
+{
+	int ret;
+
+	mutex_lock(&bo->mutex);
+
+	ret = ttm_bo_expire_sync_obj(bo, allow_errors);
+	if (ret)
+		goto out;
+
+	if (bo->mem.mem_type == mem_type)
+		ret = ttm_bo_evict(bo, mem_type, false, false);
+
+	if (ret) {
+		if (allow_errors) {
+			goto out;
+		} else {
+			ret = 0;
+			printk(KERN_ERR "Cleanup eviction failed\n");
+		}
+	}
+
+out:
+	mutex_unlock(&bo->mutex);
+	return ret;
+}
+
+static int ttm_bo_force_list_clean(struct ttm_bo_device *bdev,
+				   struct list_head *head,
+				   unsigned mem_type, bool allow_errors)
+{
+	struct ttm_buffer_object *entry;
+	int ret;
+	int put_count;
+
+	/*
+	 * Can't use standard list traversal since we're unlocking.
+	 */
+
+	spin_lock(&bdev->lru_lock);
+
+	while (!list_empty(head)) {
+		entry = list_first_entry(head, struct ttm_buffer_object, lru);
+		kref_get(&entry->list_kref);
+		ret = ttm_bo_reserve_locked(entry, false, false, false, 0);
+		put_count = ttm_bo_del_from_lru(entry);
+		spin_unlock(&bdev->lru_lock);
+		while (put_count--)
+			kref_put(&entry->list_kref, ttm_bo_ref_bug);
+		BUG_ON(ret);
+		ret = ttm_bo_leave_list(entry, mem_type, allow_errors);
+		ttm_bo_unreserve(entry);
+		kref_put(&entry->list_kref, ttm_bo_release_list);
+		spin_lock(&bdev->lru_lock);
+	}
+
+	spin_unlock(&bdev->lru_lock);
+
+	return 0;
+}
+
+int ttm_bo_clean_mm(struct ttm_bo_device *bdev, unsigned mem_type)
+{
+	struct ttm_mem_type_manager *man = &bdev->man[mem_type];
+	int ret = -EINVAL;
+
+	if (mem_type >= TTM_NUM_MEM_TYPES) {
+		printk(KERN_ERR "Illegal memory type %d\n", mem_type);
+		return ret;
+	}
+
+	if (!man->has_type) {
+		printk(KERN_ERR "Trying to take down uninitialized "
+		       "memory manager type %u\n", mem_type);
+		return ret;
+	}
+
+	man->use_type = false;
+	man->has_type = false;
+
+	ret = 0;
+	if (mem_type > 0) {
+		ttm_bo_force_list_clean(bdev, &man->lru, mem_type, false);
+
+		spin_lock(&bdev->lru_lock);
+		if (drm_mm_clean(&man->manager))
+			drm_mm_takedown(&man->manager);
+		else
+			ret = -EBUSY;
+
+		spin_unlock(&bdev->lru_lock);
+	}
+
+	return ret;
+}
+
+int ttm_bo_evict_mm(struct ttm_bo_device *bdev, unsigned mem_type)
+{
+	struct ttm_mem_type_manager *man = &bdev->man[mem_type];
+
+	if (mem_type == 0 || mem_type >= TTM_NUM_MEM_TYPES) {
+		printk(KERN_ERR "Illegal memory manager memory type %u.\n",
+		       mem_type);
+		return -EINVAL;
+	}
+
+	if (!man->has_type) {
+		printk(KERN_ERR "Memory type %u has not been initialized.\n",
+		       mem_type);
+		return 0;
+	}
+
+	return ttm_bo_force_list_clean(bdev, &man->lru, mem_type, true);
+}
+
+int ttm_bo_init_mm(struct ttm_bo_device *bdev, unsigned type,
+		   unsigned long p_offset, unsigned long p_size)
+{
+	int ret = -EINVAL;
+	struct ttm_mem_type_manager *man;
+
+	if (type >= TTM_NUM_MEM_TYPES) {
+		printk(KERN_ERR "Illegal memory type %d\n", type);
+		return ret;
+	}
+
+	man = &bdev->man[type];
+	if (man->has_type) {
+		printk(KERN_ERR
+		       "Memory manager already initialized for type %d\n",
+		       type);
+		return ret;
+	}
+
+	ret = bdev->driver->init_mem_type(bdev, type, man);
+	if (ret)
+		return ret;
+
+	ret = 0;
+	if (type != TTM_PL_SYSTEM) {
+		if (!p_size) {
+			printk(KERN_ERR "Zero size memory manager type %d\n",
+			       type);
+			return ret;
+		}
+		ret = drm_mm_init(&man->manager, p_offset, p_size);
+		if (ret)
+			return ret;
+	}
+	man->has_type = true;
+	man->use_type = true;
+	man->size = p_size;
+
+	INIT_LIST_HEAD(&man->lru);
+
+	return 0;
+}
+
+int ttm_bo_device_release(struct ttm_bo_device *bdev)
+{
+	int ret = 0;
+	unsigned i = TTM_NUM_MEM_TYPES;
+	struct ttm_mem_type_manager *man;
+
+	while (i--) {
+		man = &bdev->man[i];
+		if (man->has_type) {
+			man->use_type = false;
+			if ((i != TTM_PL_SYSTEM) && ttm_bo_clean_mm(bdev, i)) {
+				ret = -EBUSY;
+				printk(KERN_ERR "DRM memory manager type %d "
+				       "is not clean.\n", i);
+			}
+			man->has_type = false;
+		}
+	}
+
+	if (!cancel_delayed_work(&bdev->wq))
+		flush_scheduled_work();
+
+	while (ttm_bo_delayed_delete(bdev, true))
+		;
+
+	spin_lock(&bdev->lru_lock);
+	if (list_empty(&bdev->ddestroy))
+		TTM_DEBUG("Delayed destroy list was clean\n");
+
+	if (list_empty(&bdev->man[0].lru))
+		TTM_DEBUG("Swap list was clean\n");
+	spin_unlock(&bdev->lru_lock);
+
+	ttm_mem_unregister_shrink(bdev->mem_glob, &bdev->shrink);
+	BUG_ON(!drm_mm_clean(&bdev->addr_space_mm));
+	write_lock(&bdev->vm_lock);
+	drm_mm_takedown(&bdev->addr_space_mm);
+	write_unlock(&bdev->vm_lock);
+
+	__free_page(bdev->dummy_read_page);
+	return ret;
+}
+
+/*
+ * This function is intended to be called on drm driver load.
+ * If you decide to call it from firstopen, you must protect the call
+ * from a potentially racing ttm_bo_driver_finish in lastclose.
+ * (This may happen on X server restart).
+ */
+
+int ttm_bo_device_init(struct ttm_bo_device *bdev,
+		       struct ttm_mem_global *mem_glob,
+		       struct ttm_bo_driver *driver, uint64_t file_page_offset)
+{
+	int ret = -EINVAL;
+
+	bdev->dummy_read_page = NULL;
+	rwlock_init(&bdev->vm_lock);
+	spin_lock_init(&bdev->lru_lock);
+
+	bdev->driver = driver;
+	bdev->mem_glob = mem_glob;
+
+	memset(bdev->man, 0, sizeof(bdev->man));
+
+	bdev->dummy_read_page = alloc_page(__GFP_ZERO | GFP_DMA32);
+	if (unlikely(bdev->dummy_read_page == NULL)) {
+		ret = -ENOMEM;
+		goto out_err0;
+	}
+
+	/*
+	 * Initialize the system memory buffer type.
+	 * Other types need to be driver / IOCTL initialized.
+	 */
+	ret = ttm_bo_init_mm(bdev, TTM_PL_SYSTEM, 0, 0);
+	if (unlikely(ret != 0))
+		goto out_err1;
+
+	bdev->addr_space_rb = RB_ROOT;
+	ret = drm_mm_init(&bdev->addr_space_mm, file_page_offset, 0x10000000);
+	if (unlikely(ret != 0))
+		goto out_err2;
+
+	INIT_DELAYED_WORK(&bdev->wq, ttm_bo_delayed_workqueue);
+	bdev->nice_mode = true;
+	INIT_LIST_HEAD(&bdev->ddestroy);
+	INIT_LIST_HEAD(&bdev->swap_lru);
+	bdev->dev_mapping = NULL;
+	ttm_mem_init_shrink(&bdev->shrink, ttm_bo_swapout);
+	ret = ttm_mem_register_shrink(mem_glob, &bdev->shrink);
+	if (unlikely(ret != 0)) {
+		printk(KERN_ERR "Could not register buffer object swapout.\n");
+		goto out_err2;
+	}
+	return 0;
+out_err2:
+	ttm_bo_clean_mm(bdev, 0);
+out_err1:
+	__free_page(bdev->dummy_read_page);
+out_err0:
+	return ret;
+}
+
+/*
+ * buffer object vm functions.
+ */
+
+bool ttm_mem_reg_is_pci(struct ttm_bo_device *bdev, struct ttm_mem_reg *mem)
+{
+	struct ttm_mem_type_manager *man = &bdev->man[mem->mem_type];
+
+	if (!(man->flags & TTM_MEMTYPE_FLAG_FIXED)) {
+		if (mem->mem_type == TTM_PL_SYSTEM)
+			return false;
+
+		if (man->flags & TTM_MEMTYPE_FLAG_CMA)
+			return false;
+
+		if (mem->flags & TTM_PL_FLAG_CACHED)
+			return false;
+	}
+	return true;
+}
+
+int ttm_bo_pci_offset(struct ttm_bo_device *bdev,
+		      struct ttm_mem_reg *mem,
+		      unsigned long *bus_base,
+		      unsigned long *bus_offset, unsigned long *bus_size)
+{
+	struct ttm_mem_type_manager *man = &bdev->man[mem->mem_type];
+
+	*bus_size = 0;
+	if (!(man->flags & TTM_MEMTYPE_FLAG_MAPPABLE))
+		return -EINVAL;
+
+	if (ttm_mem_reg_is_pci(bdev, mem)) {
+		*bus_offset = mem->mm_node->start << PAGE_SHIFT;
+		*bus_size = mem->num_pages << PAGE_SHIFT;
+		*bus_base = man->io_offset;
+	}
+
+	return 0;
+}
+
+void ttm_bo_unmap_virtual(struct ttm_buffer_object *bo)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	loff_t offset = (loff_t) bo->addr_space_offset;
+	loff_t holelen = ((loff_t) bo->mem.num_pages) << PAGE_SHIFT;
+
+	if (!bdev->dev_mapping)
+		return;
+
+	unmap_mapping_range(bdev->dev_mapping, offset, holelen, 1);
+}
+
+static void ttm_bo_vm_insert_rb(struct ttm_buffer_object *bo)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct rb_node **cur = &bdev->addr_space_rb.rb_node;
+	struct rb_node *parent = NULL;
+	struct ttm_buffer_object *cur_bo;
+	unsigned long offset = bo->vm_node->start;
+	unsigned long cur_offset;
+
+	while (*cur) {
+		parent = *cur;
+		cur_bo = rb_entry(parent, struct ttm_buffer_object, vm_rb);
+		cur_offset = cur_bo->vm_node->start;
+		if (offset < cur_offset)
+			cur = &parent->rb_left;
+		else if (offset > cur_offset)
+			cur = &parent->rb_right;
+		else
+			BUG();
+	}
+
+	rb_link_node(&bo->vm_rb, parent, cur);
+	rb_insert_color(&bo->vm_rb, &bdev->addr_space_rb);
+}
+
+/**
+ * ttm_bo_setup_vm:
+ *
+ * @bo: the buffer to allocate address space for
+ *
+ * Allocate address space in the drm device so that applications
+ * can mmap the buffer and access the contents. This only
+ * applies to ttm_bo_type_device objects as others are not
+ * placed in the drm device address space.
+ */
+
+static int ttm_bo_setup_vm(struct ttm_buffer_object *bo)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	int ret;
+
+retry_pre_get:
+	ret = drm_mm_pre_get(&bdev->addr_space_mm);
+	if (unlikely(ret != 0))
+		return ret;
+
+	write_lock(&bdev->vm_lock);
+	bo->vm_node = drm_mm_search_free(&bdev->addr_space_mm,
+					 bo->mem.num_pages, 0, 0);
+
+	if (unlikely(bo->vm_node == NULL)) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	bo->vm_node = drm_mm_get_block_atomic(bo->vm_node,
+					      bo->mem.num_pages, 0);
+
+	if (unlikely(bo->vm_node == NULL)) {
+		write_unlock(&bdev->vm_lock);
+		goto retry_pre_get;
+	}
+
+	ttm_bo_vm_insert_rb(bo);
+	write_unlock(&bdev->vm_lock);
+	bo->addr_space_offset = ((uint64_t) bo->vm_node->start) << PAGE_SHIFT;
+
+	return 0;
+out_unlock:
+	write_unlock(&bdev->vm_lock);
+	return ret;
+}
+
+int ttm_bo_wait(struct ttm_buffer_object *bo,
+		bool lazy, bool interruptible, bool no_wait)
+{
+	struct ttm_bo_driver *driver = bo->bdev->driver;
+	void *sync_obj;
+	void *sync_obj_arg;
+	int ret = 0;
+
+	while (bo->sync_obj) {
+		if (driver->sync_obj_signaled(bo->sync_obj, bo->sync_obj_arg)) {
+			driver->sync_obj_unref(&bo->sync_obj);
+			bo->priv_flags &= ~TTM_BO_PRIV_FLAG_MOVING;
+			goto out;
+		}
+		if (no_wait) {
+			ret = -EBUSY;
+			goto out;
+		}
+		sync_obj = driver->sync_obj_ref(bo->sync_obj);
+		sync_obj_arg = bo->sync_obj_arg;
+		mutex_unlock(&bo->mutex);
+		ret = driver->sync_obj_wait(sync_obj, sync_obj_arg,
+					    lazy, interruptible);
+
+		mutex_lock(&bo->mutex);
+		if (unlikely(ret != 0)) {
+			driver->sync_obj_unref(&sync_obj);
+			return ret;
+		}
+
+		if (bo->sync_obj == sync_obj) {
+			driver->sync_obj_unref(&bo->sync_obj);
+			bo->priv_flags &= ~TTM_BO_PRIV_FLAG_MOVING;
+		}
+		driver->sync_obj_unref(&sync_obj);
+	}
+out:
+	return 0;
+}
+
+void ttm_bo_unblock_reservation(struct ttm_buffer_object *bo)
+{
+	atomic_set(&bo->reserved, 0);
+	wake_up_all(&bo->event_queue);
+}
+
+int ttm_bo_block_reservation(struct ttm_buffer_object *bo, bool interruptible,
+			     bool no_wait)
+{
+	int ret;
+
+	while (unlikely(atomic_cmpxchg(&bo->reserved, 0, 1) != 0)) {
+		if (no_wait)
+			return -EBUSY;
+		else if (interruptible) {
+			ret = wait_event_interruptible
+			    (bo->event_queue, atomic_read(&bo->reserved) == 0);
+			if (unlikely(ret != 0))
+				return -ERESTART;
+		} else {
+			wait_event(bo->event_queue,
+				   atomic_read(&bo->reserved) == 0);
+		}
+	}
+	return 0;
+}
+
+int ttm_bo_synccpu_write_grab(struct ttm_buffer_object *bo, bool no_wait)
+{
+	int ret = 0;
+
+	/*
+	 * Using ttm_bo_reserve instead of ttm_bo_block_reservation
+	 * makes sure the lru lists are updated.
+	 */
+
+	ret = ttm_bo_reserve(bo, true, no_wait, false, 0);
+	if (unlikely(ret != 0))
+		return ret;
+	mutex_lock(&bo->mutex);
+	ret = ttm_bo_wait(bo, false, true, no_wait);
+	if (unlikely(ret != 0))
+		goto out_err0;
+	atomic_inc(&bo->cpu_writers);
+out_err0:
+	mutex_unlock(&bo->mutex);
+	ttm_bo_unreserve(bo);
+	return ret;
+}
+
+void ttm_bo_synccpu_write_release(struct ttm_buffer_object *bo)
+{
+	if (atomic_dec_and_test(&bo->cpu_writers))
+		wake_up_all(&bo->event_queue);
+}
+
+/**
+ * A buffer object shrink method that tries to swap out the first
+ * buffer object on the bo_global::swap_lru list.
+ */
+
+static int ttm_bo_swapout(struct ttm_mem_shrink *shrink)
+{
+	struct ttm_bo_device *bdev =
+	    container_of(shrink, struct ttm_bo_device, shrink);
+	struct ttm_buffer_object *bo;
+	int ret = -EBUSY;
+	int put_count;
+	uint32_t swap_placement = (TTM_PL_FLAG_CACHED | TTM_PL_FLAG_SYSTEM);
+
+	spin_lock(&bdev->lru_lock);
+	while (ret == -EBUSY) {
+		if (unlikely(list_empty(&bdev->swap_lru))) {
+			spin_unlock(&bdev->lru_lock);
+			return -EBUSY;
+		}
+
+		bo = list_first_entry(&bdev->swap_lru,
+				      struct ttm_buffer_object, swap);
+		kref_get(&bo->list_kref);
+
+		/**
+		 * Reserve buffer. Since we unlock while sleeping, we need
+		 * to re-check that nobody removed us from the swap-list while
+		 * we slept.
+		 */
+
+		ret = ttm_bo_reserve_locked(bo, false, true, false, 0);
+		if (unlikely(ret == -EBUSY)) {
+			spin_unlock(&bdev->lru_lock);
+			ttm_bo_wait_unreserved(bo, false);
+			kref_put(&bo->list_kref, ttm_bo_release_list);
+			spin_lock(&bdev->lru_lock);
+		}
+	}
+
+	BUG_ON(ret != 0);
+	put_count = ttm_bo_del_from_lru(bo);
+	spin_unlock(&bdev->lru_lock);
+
+	while (put_count--)
+		kref_put(&bo->list_kref, ttm_bo_ref_bug);
+
+	/**
+	 * Wait for GPU, then move to system cached.
+	 */
+
+	mutex_lock(&bo->mutex);
+	ret = ttm_bo_wait(bo, false, false, false);
+	if (unlikely(ret != 0))
+		goto out;
+
+	if ((bo->mem.flags & swap_placement) != swap_placement) {
+		struct ttm_mem_reg evict_mem;
+
+		evict_mem = bo->mem;
+		evict_mem.mm_node = NULL;
+		evict_mem.proposed_flags =
+		    TTM_PL_FLAG_SYSTEM | TTM_PL_FLAG_CACHED;
+		evict_mem.flags = TTM_PL_FLAG_SYSTEM | TTM_PL_FLAG_CACHED;
+		evict_mem.mem_type = TTM_PL_SYSTEM;
+
+		ret = ttm_bo_handle_move_mem(bo, &evict_mem, true, false,
+					     false);
+		if (unlikely(ret != 0))
+			goto out;
+	}
+
+	ttm_bo_unmap_virtual(bo);
+
+	/**
+	 * Swap out. Buffer will be swapped in again as soon as
+	 * anyone tries to access a ttm page.
+	 */
+
+	ret = ttm_tt_swapout(bo->ttm, bo->persistant_swap_storage);
+out:
+	mutex_unlock(&bo->mutex);
+
+	/**
+	 *
+	 * Unreserve without putting on LRU to avoid swapping out an
+	 * already swapped buffer.
+	 */
+
+	atomic_set(&bo->reserved, 0);
+	wake_up_all(&bo->event_queue);
+	kref_put(&bo->list_kref, ttm_bo_release_list);
+	return ret;
+}
+
+void ttm_bo_swapout_all(struct ttm_bo_device *bdev)
+{
+	while (ttm_bo_swapout(&bdev->shrink) == 0)
+		;
+}
diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
new file mode 100644
index 0000000..4562c5b
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -0,0 +1,540 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2007-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#include "ttm/ttm_bo_driver.h"
+#include "ttm/ttm_placement_common.h"
+#include <linux/io.h>
+#include <linux/highmem.h>
+#include <linux/wait.h>
+
+void ttm_bo_free_old_node(struct ttm_buffer_object *bo)
+{
+	struct ttm_mem_reg *old_mem = &bo->mem;
+
+	if (old_mem->mm_node) {
+		spin_lock(&bo->bdev->lru_lock);
+		drm_mm_put_block(old_mem->mm_node);
+		spin_unlock(&bo->bdev->lru_lock);
+	}
+	old_mem->mm_node = NULL;
+}
+
+int ttm_bo_move_ttm(struct ttm_buffer_object *bo,
+		    bool evict, bool no_wait, struct ttm_mem_reg *new_mem)
+{
+	struct ttm_tt *ttm = bo->ttm;
+	struct ttm_mem_reg *old_mem = &bo->mem;
+	uint32_t save_flags = old_mem->flags;
+	uint32_t save_proposed_flags = old_mem->proposed_flags;
+	int ret;
+
+	if (old_mem->mem_type != TTM_PL_SYSTEM) {
+		ttm_tt_unbind(ttm);
+		ttm_bo_free_old_node(bo);
+		ttm_flag_masked(&old_mem->flags, TTM_PL_FLAG_SYSTEM,
+				TTM_PL_MASK_MEM);
+		old_mem->mem_type = TTM_PL_SYSTEM;
+		save_flags = old_mem->flags;
+	}
+
+	ret = ttm_tt_set_placement_caching(ttm, new_mem->flags);
+	if (unlikely(ret != 0))
+		return ret;
+
+	if (new_mem->mem_type != TTM_PL_SYSTEM) {
+		ret = ttm_tt_bind(ttm, new_mem);
+		if (unlikely(ret != 0))
+			return ret;
+	}
+
+	*old_mem = *new_mem;
+	new_mem->mm_node = NULL;
+	old_mem->proposed_flags = save_proposed_flags;
+	ttm_flag_masked(&save_flags, new_mem->flags, TTM_PL_MASK_MEMTYPE);
+	return 0;
+}
+
+int ttm_mem_reg_ioremap(struct ttm_bo_device *bdev, struct ttm_mem_reg *mem,
+			void **virtual)
+{
+	struct ttm_mem_type_manager *man = &bdev->man[mem->mem_type];
+	unsigned long bus_offset;
+	unsigned long bus_size;
+	unsigned long bus_base;
+	int ret;
+	void *addr;
+
+	*virtual = NULL;
+	ret = ttm_bo_pci_offset(bdev, mem, &bus_base, &bus_offset, &bus_size);
+	if (ret || bus_size == 0)
+		return ret;
+
+	if (!(man->flags & TTM_MEMTYPE_FLAG_NEEDS_IOREMAP))
+		addr = (void *)(((u8 *) man->io_addr) + bus_offset);
+	else {
+		if (mem->flags & TTM_PL_FLAG_WC)
+			addr = ioremap_wc(bus_base + bus_offset, bus_size);
+		else
+			addr = ioremap_nocache(bus_base + bus_offset, bus_size);
+		if (!addr)
+			return -ENOMEM;
+	}
+	*virtual = addr;
+	return 0;
+}
+
+void ttm_mem_reg_iounmap(struct ttm_bo_device *bdev, struct ttm_mem_reg *mem,
+			 void *virtual)
+{
+	struct ttm_mem_type_manager *man;
+
+	man = &bdev->man[mem->mem_type];
+
+	if (virtual && (man->flags & TTM_MEMTYPE_FLAG_NEEDS_IOREMAP))
+		iounmap(virtual);
+}
+
+static int ttm_copy_io_page(void *dst, void *src, unsigned long page)
+{
+	uint32_t *dstP =
+	    (uint32_t *) ((unsigned long)dst + (page << PAGE_SHIFT));
+	uint32_t *srcP =
+	    (uint32_t *) ((unsigned long)src + (page << PAGE_SHIFT));
+
+	int i;
+	for (i = 0; i < PAGE_SIZE / sizeof(uint32_t); ++i)
+		iowrite32(ioread32(srcP++), dstP++);
+	return 0;
+}
+
+static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
+				unsigned long page)
+{
+	struct page *d = ttm_tt_get_page(ttm, page);
+	void *dst;
+
+	if (!d)
+		return -ENOMEM;
+
+	src = (void *)((unsigned long)src + (page << PAGE_SHIFT));
+	dst = kmap(d);
+	if (!dst)
+		return -ENOMEM;
+
+	memcpy_fromio(dst, src, PAGE_SIZE);
+	kunmap(d);
+	return 0;
+}
+
+static int ttm_copy_ttm_io_page(struct ttm_tt *ttm, void *dst,
+				unsigned long page)
+{
+	struct page *s = ttm_tt_get_page(ttm, page);
+	void *src;
+
+	if (!s)
+		return -ENOMEM;
+
+	dst = (void *)((unsigned long)dst + (page << PAGE_SHIFT));
+	src = kmap(s);
+	if (!src)
+		return -ENOMEM;
+
+	memcpy_toio(dst, src, PAGE_SIZE);
+	kunmap(s);
+	return 0;
+}
+
+int ttm_bo_move_memcpy(struct ttm_buffer_object *bo,
+		       bool evict, bool no_wait, struct ttm_mem_reg *new_mem)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_mem_type_manager *man = &bdev->man[new_mem->mem_type];
+	struct ttm_tt *ttm = bo->ttm;
+	struct ttm_mem_reg *old_mem = &bo->mem;
+	struct ttm_mem_reg old_copy = *old_mem;
+	void *old_iomap;
+	void *new_iomap;
+	int ret;
+	uint32_t save_flags = old_mem->flags;
+	uint32_t save_proposed_flags = old_mem->proposed_flags;
+	unsigned long i;
+	unsigned long page;
+	unsigned long add = 0;
+	int dir;
+
+	ret = ttm_mem_reg_ioremap(bdev, old_mem, &old_iomap);
+	if (ret)
+		return ret;
+	ret = ttm_mem_reg_ioremap(bdev, new_mem, &new_iomap);
+	if (ret)
+		goto out;
+
+	if (old_iomap == NULL && new_iomap == NULL)
+		goto out2;
+	if (old_iomap == NULL && ttm == NULL)
+		goto out2;
+
+	add = 0;
+	dir = 1;
+
+	if ((old_mem->mem_type == new_mem->mem_type) &&
+	    (new_mem->mm_node->start <
+	     old_mem->mm_node->start + old_mem->mm_node->size)) {
+		dir = -1;
+		add = new_mem->num_pages - 1;
+	}
+
+	for (i = 0; i < new_mem->num_pages; ++i) {
+		page = i * dir + add;
+		if (old_iomap == NULL)
+			ret = ttm_copy_ttm_io_page(ttm, new_iomap, page);
+		else if (new_iomap == NULL)
+			ret = ttm_copy_io_ttm_page(ttm, old_iomap, page);
+		else
+			ret = ttm_copy_io_page(new_iomap, old_iomap, page);
+		if (ret)
+			goto out1;
+	}
+	mb();
+out2:
+	ttm_bo_free_old_node(bo);
+
+	*old_mem = *new_mem;
+	new_mem->mm_node = NULL;
+	old_mem->proposed_flags = save_proposed_flags;
+	ttm_flag_masked(&save_flags, new_mem->flags, TTM_PL_MASK_MEMTYPE);
+
+	if ((man->flags & TTM_MEMTYPE_FLAG_FIXED) && (ttm != NULL)) {
+		ttm_tt_unbind(ttm);
+		ttm_tt_destroy(ttm);
+		bo->ttm = NULL;
+	}
+
+out1:
+	ttm_mem_reg_iounmap(bdev, new_mem, new_iomap);
+out:
+	ttm_mem_reg_iounmap(bdev, &old_copy, old_iomap);
+	return ret;
+}
+
+static void ttm_transfered_destroy(struct ttm_buffer_object *bo)
+{
+	kfree(bo);
+}
+
+/**
+ * ttm_buffer_object_transfer
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ * @new_obj: A pointer to a pointer to a newly created ttm_buffer_object,
+ * holding the data of @bo with the old placement.
+ *
+ * This is a utility function that may be called after an accelerated move
+ * has been scheduled. A new buffer object is created as a placeholder for
+ * the old data while it's being copied. When that buffer object is idle,
+ * it can be destroyed, releasing the space of the old placement.
+ * Returns:
+ * !0: Failure.
+ */
+
+static int ttm_buffer_object_transfer(struct ttm_buffer_object *bo,
+				      struct ttm_buffer_object **new_obj)
+{
+	struct ttm_buffer_object *fbo;
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_bo_driver *driver = bdev->driver;
+
+	fbo = kzalloc(sizeof(*fbo), GFP_KERNEL);
+	if (!fbo)
+		return -ENOMEM;
+
+	*fbo = *bo;
+	mutex_init(&fbo->mutex);
+	mutex_lock(&fbo->mutex);
+
+	init_waitqueue_head(&fbo->event_queue);
+	INIT_LIST_HEAD(&fbo->ddestroy);
+	INIT_LIST_HEAD(&fbo->lru);
+	INIT_LIST_HEAD(&fbo->swap);
+
+	fbo->sync_obj = driver->sync_obj_ref(bo->sync_obj);
+	if (fbo->mem.mm_node)
+		fbo->mem.mm_node->private = (void *)fbo;
+	kref_init(&fbo->list_kref);
+	kref_init(&fbo->kref);
+	fbo->destroy = &ttm_transfered_destroy;
+
+	mutex_unlock(&fbo->mutex);
+
+	*new_obj = fbo;
+	return 0;
+}
+
+pgprot_t ttm_io_prot(uint32_t caching_flags, pgprot_t tmp)
+{
+#if defined(__i386__) || defined(__x86_64__)
+	if (caching_flags & TTM_PL_FLAG_WC)
+		tmp = pgprot_writecombine(tmp);
+	else if (boot_cpu_data.x86 > 3)
+		tmp = pgprot_noncached(tmp);
+
+#elif defined(__powerpc__)
+	if (!(caching_flags & TTM_PL_FLAG_CACHED)) {
+		pgprot_val(tmp) |= _PAGE_NO_CACHE;
+		if (caching_flags & TTM_PL_FLAG_UNCACHED)
+			pgprot_val(tmp) |= _PAGE_GUARDED;
+	}
+#endif
+#if defined(__ia64__)
+	if (caching_flags & TTM_PL_FLAG_WC)
+		tmp = pgprot_writecombine(tmp);
+	else
+		tmp = pgprot_noncached(tmp);
+#endif
+#if defined(__sparc__)
+	if (!(caching_flags & TTM_PL_FLAG_CACHED))
+		tmp = pgprot_noncached(tmp);
+#endif
+	return tmp;
+}
+
+static int ttm_bo_ioremap(struct ttm_buffer_object *bo,
+			  unsigned long bus_base,
+			  unsigned long bus_offset,
+			  unsigned long bus_size,
+			  struct ttm_bo_kmap_obj *map)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_mem_reg *mem = &bo->mem;
+	struct ttm_mem_type_manager *man = &bdev->man[mem->mem_type];
+
+	if (!(man->flags & TTM_MEMTYPE_FLAG_NEEDS_IOREMAP)) {
+		map->bo_kmap_type = ttm_bo_map_premapped;
+		map->virtual = (void *)(((u8 *) man->io_addr) + bus_offset);
+	} else {
+		map->bo_kmap_type = ttm_bo_map_iomap;
+		if (mem->flags & TTM_PL_FLAG_WC)
+			map->virtual = ioremap_wc(bus_base + bus_offset,
+						  bus_size);
+		else
+			map->virtual = ioremap_nocache(bus_base + bus_offset,
+						       bus_size);
+		}
+	return (!map->virtual) ? -ENOMEM : 0;
+}
+
+static int ttm_bo_kmap_ttm(struct ttm_buffer_object *bo,
+			   unsigned long start_page,
+			   unsigned long num_pages,
+			   struct ttm_bo_kmap_obj *map)
+{
+	struct ttm_mem_reg *mem = &bo->mem; pgprot_t prot;
+	struct ttm_tt *ttm = bo->ttm;
+	struct page *d;
+	int i;
+	BUG_ON(!ttm);
+	if (num_pages == 1 && (mem->flags & TTM_PL_FLAG_CACHED)) {
+		/*
+		 * We're mapping a single page, and the desired
+		 * page protection is consistent with the bo.
+		 */
+		map->bo_kmap_type = ttm_bo_map_kmap;
+		map->page = ttm_tt_get_page(ttm, start_page);
+		map->virtual = kmap(map->page);
+	} else {
+		/*
+		 * Populate the part we're mapping;
+		 */
+		for (i = start_page; i < start_page + num_pages; ++i) {
+			d = ttm_tt_get_page(ttm, i);
+			if (!d)
+				return -ENOMEM;
+		}
+
+		/*
+		 * We need to use vmap to get the desired page protection
+		 * or to make the buffer object look contigous.
+		 */
+		prot = (mem->flags & TTM_PL_FLAG_CACHED) ?
+			PAGE_KERNEL :
+			ttm_io_prot(mem->flags, PAGE_KERNEL);
+		map->bo_kmap_type = ttm_bo_map_vmap;
+		map->virtual = vmap(ttm->pages + start_page, num_pages,
+				    0, prot);
+	}
+	return (!map->virtual) ? -ENOMEM : 0;
+}
+
+int ttm_bo_kmap(struct ttm_buffer_object *bo,
+		unsigned long start_page, unsigned long num_pages,
+		struct ttm_bo_kmap_obj *map)
+{
+	int ret;
+	unsigned long bus_base;
+	unsigned long bus_offset;
+	unsigned long bus_size;
+	BUG_ON(!list_empty(&bo->swap));
+	map->virtual = NULL;
+	if (num_pages > bo->num_pages)
+		return -EINVAL;
+	if (start_page > bo->num_pages)
+		return -EINVAL;
+
+	ret = ttm_bo_pci_offset(bo->bdev, &bo->mem, &bus_base,
+				&bus_offset, &bus_size);
+	if (ret)
+		return ret;
+	if (bus_size == 0) {
+		return ttm_bo_kmap_ttm(bo, start_page, num_pages, map);
+	} else {
+		bus_offset += start_page << PAGE_SHIFT;
+		bus_size = num_pages << PAGE_SHIFT;
+		return ttm_bo_ioremap(bo, bus_base, bus_offset, bus_size, map);
+	}
+}
+
+void ttm_bo_kunmap(struct ttm_bo_kmap_obj *map)
+{
+	if (!map->virtual)
+		return;
+	switch (map->bo_kmap_type) {
+	case ttm_bo_map_iomap:
+		iounmap(map->virtual);
+		break;
+	case ttm_bo_map_vmap:
+		vunmap(map->virtual);
+		break;
+	case ttm_bo_map_kmap:
+		kunmap(map->page);
+		break;
+	case ttm_bo_map_premapped:
+		break;
+	default:
+		BUG();
+	}
+	map->virtual = NULL;
+	map->page = NULL;
+}
+
+int ttm_bo_pfn_prot(struct ttm_buffer_object *bo,
+		    unsigned long dst_offset,
+		    unsigned long *pfn, pgprot_t * prot)
+{
+	struct ttm_mem_reg *mem = &bo->mem;
+	struct ttm_bo_device *bdev = bo->bdev;
+	unsigned long bus_offset;
+	unsigned long bus_size;
+	unsigned long bus_base;
+	int ret;
+	ret = ttm_bo_pci_offset(bdev, mem, &bus_base, &bus_offset,
+			&bus_size);
+	if (ret)
+		return -EINVAL;
+	if (bus_size != 0)
+		*pfn = (bus_base + bus_offset + dst_offset) >> PAGE_SHIFT;
+	else
+		if (!bo->ttm)
+			return -EINVAL;
+		else
+			*pfn = page_to_pfn(
+				ttm_tt_get_page(bo->ttm,
+						dst_offset >> PAGE_SHIFT));
+	*prot = (mem->flags & TTM_PL_FLAG_CACHED) ?
+		PAGE_KERNEL : ttm_io_prot(mem->flags, PAGE_KERNEL);
+	return 0;
+}
+
+int ttm_bo_move_accel_cleanup(struct ttm_buffer_object *bo,
+			      void *sync_obj,
+			      void *sync_obj_arg,
+			      bool evict, bool no_wait,
+			      struct ttm_mem_reg *new_mem)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_bo_driver *driver = bdev->driver;
+	struct ttm_mem_type_manager *man = &bdev->man[new_mem->mem_type];
+	struct ttm_mem_reg *old_mem = &bo->mem;
+	int ret;
+	uint32_t save_flags = old_mem->flags;
+	uint32_t save_proposed_flags = old_mem->proposed_flags;
+	struct ttm_buffer_object *ghost_obj;
+	if (bo->sync_obj)
+		driver->sync_obj_unref(&bo->sync_obj);
+	bo->sync_obj = driver->sync_obj_ref(sync_obj);
+	bo->sync_obj_arg = sync_obj_arg;
+	if (evict) {
+		ret = ttm_bo_wait(bo, false, false, false);
+		if (ret)
+			return ret;
+		ttm_bo_free_old_node(bo);
+		if ((man->flags & TTM_MEMTYPE_FLAG_FIXED) &&
+		    (bo->ttm != NULL)) {
+			ttm_tt_unbind(bo->ttm);
+			ttm_tt_destroy(bo->ttm);
+			bo->ttm = NULL;
+		}
+	} else {
+		/**
+		 * This should help pipeline ordinary buffer moves.
+		 *
+		 * Hang old buffer memory on a new buffer object,
+		 * and leave it to be released when the GPU
+		 * operation has completed.
+		 */
+
+		ret = ttm_buffer_object_transfer(bo, &ghost_obj);
+		if (ret)
+			return ret;
+
+		/**
+		 * If we're not moving to fixed memory, the TTM object
+		 * needs to stay alive. Otherwhise hang it on the ghost
+		 * bo to be unbound and destroyed.
+		 */
+
+		if (!(man->flags & TTM_MEMTYPE_FLAG_FIXED))
+			ghost_obj->ttm = NULL;
+		else
+			ghost_obj = NULL;
+
+		bo->priv_flags |= TTM_BO_PRIV_FLAG_MOVING;
+		ttm_bo_unreserve(ghost_obj);
+		ttm_bo_unref(&ghost_obj);
+	}
+
+	*old_mem = *new_mem;
+	new_mem->mm_node = NULL;
+	old_mem->proposed_flags = save_proposed_flags;
+	ttm_flag_masked(&save_flags, new_mem->flags, TTM_PL_MASK_MEMTYPE);
+	return 0;
+}
diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
new file mode 100644
index 0000000..f1110ac
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -0,0 +1,436 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+
+#include "ttm/ttm_bo_driver.h"
+#include "ttm/ttm_placement_common.h"
+#include <linux/mm.h>
+#include <linux/rbtree.h>
+#include <linux/uaccess.h>
+
+#define TTM_BO_VM_NUM_PREFAULT 16
+
+static struct ttm_buffer_object *ttm_bo_vm_lookup_rb(struct ttm_bo_device *bdev,
+						     unsigned long page_start,
+						     unsigned long num_pages)
+{
+	struct rb_node *cur = bdev->addr_space_rb.rb_node;
+	unsigned long cur_offset;
+	struct ttm_buffer_object *bo;
+	struct ttm_buffer_object *best_bo = NULL;
+
+	while (likely(cur != NULL)) {
+		bo = rb_entry(cur, struct ttm_buffer_object, vm_rb);
+		cur_offset = bo->vm_node->start;
+		if (page_start >= cur_offset) {
+			cur = cur->rb_right;
+			best_bo = bo;
+			if (page_start == cur_offset)
+				break;
+		} else
+			cur = cur->rb_left;
+	}
+
+	if (unlikely(best_bo == NULL))
+		return NULL;
+
+	if (unlikely((best_bo->vm_node->start + best_bo->num_pages) <
+		     (page_start + num_pages)))
+		return NULL;
+
+	return best_bo;
+}
+
+static int ttm_bo_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct ttm_buffer_object *bo = (struct ttm_buffer_object *)
+	    vma->vm_private_data;
+	struct ttm_bo_device *bdev = bo->bdev;
+	unsigned long bus_base;
+	unsigned long bus_offset;
+	unsigned long bus_size;
+	unsigned long page_offset;
+	unsigned long page_last;
+	unsigned long pfn;
+	struct ttm_tt *ttm = NULL;
+	struct page *page;
+	int ret;
+	int i;
+	bool is_iomem;
+	unsigned long address = (unsigned long)vmf->virtual_address;
+	int retval = VM_FAULT_NOPAGE;
+
+	ret = ttm_bo_reserve(bo, true, true, false, 0);
+	if (unlikely(ret != 0))
+		return VM_FAULT_NOPAGE;
+
+	mutex_lock(&bo->mutex);
+
+	/*
+	 * Wait for buffer data in transit, due to a pipelined
+	 * move.
+	 */
+
+	if (bo->priv_flags & TTM_BO_PRIV_FLAG_MOVING) {
+		ret = ttm_bo_wait(bo, false, true, false);
+		if (unlikely(ret != 0)) {
+			retval = (ret != -ERESTART) ?
+			    VM_FAULT_SIGBUS : VM_FAULT_NOPAGE;
+			goto out_unlock;
+		}
+	}
+
+	ret = ttm_bo_pci_offset(bdev, &bo->mem, &bus_base, &bus_offset,
+				&bus_size);
+	if (unlikely(ret != 0)) {
+		retval = VM_FAULT_SIGBUS;
+		goto out_unlock;
+	}
+
+	is_iomem = (bus_size != 0);
+
+	page_offset = ((address - vma->vm_start) >> PAGE_SHIFT) +
+	    bo->vm_node->start - vma->vm_pgoff;
+	page_last = ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) +
+	    bo->vm_node->start - vma->vm_pgoff;
+
+	if (unlikely(page_offset >= bo->num_pages)) {
+		retval = VM_FAULT_SIGBUS;
+		goto out_unlock;
+	}
+
+	/*
+	 * Strictly, we're not allowed to modify vma->vm_page_prot here,
+	 * since the mmap_sem is only held in read mode. However, we
+	 * modify only the caching bits of vma->vm_page_prot and
+	 * consider those bits protected by
+	 * the bo->mutex, as we should be the only writers.
+	 * There shouldn't really be any readers of these bits except
+	 * within vm_insert_mixed()? fork?
+	 *
+	 * TODO: Add a list of vmas to the bo, and change the
+	 * vma->vm_page_prot when the object changes caching policy, with
+	 * the correct locks held.
+	 */
+
+	if (is_iomem) {
+		vma->vm_page_prot = ttm_io_prot(bo->mem.flags,
+						vma->vm_page_prot);
+	} else {
+		ttm = bo->ttm;
+		vma->vm_page_prot = (bo->mem.flags & TTM_PL_FLAG_CACHED) ?
+		    vm_get_page_prot(vma->vm_flags) :
+		    ttm_io_prot(bo->mem.flags, vma->vm_page_prot);
+	}
+
+	/*
+	 * Speculatively prefault a number of pages. Only error on
+	 * first page.
+	 */
+
+	for (i = 0; i < TTM_BO_VM_NUM_PREFAULT; ++i) {
+
+		if (is_iomem)
+			pfn = ((bus_base + bus_offset) >> PAGE_SHIFT) +
+			    page_offset;
+		else {
+			page = ttm_tt_get_page(ttm, page_offset);
+			if (unlikely(!page && i == 0)) {
+				retval = VM_FAULT_OOM;
+				goto out_unlock;
+			} else if (unlikely(!page)) {
+				break;
+			}
+			pfn = page_to_pfn(page);
+		}
+
+		ret = vm_insert_mixed(vma, address, pfn);
+
+		/*
+		 * Somebody beat us to this PTE or prefaulting to
+		 * an already populated PTE, or prefaulting error.
+		 */
+
+		if (unlikely((ret == -EBUSY) || (ret != 0 && i > 0)))
+			break;
+		else if (unlikely(ret != 0)) {
+			retval =
+			    (ret == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS;
+			goto out_unlock;
+
+		}
+
+		address += PAGE_SIZE;
+		if (unlikely(++page_offset >= page_last))
+			break;
+	}
+
+out_unlock:
+	mutex_unlock(&bo->mutex);
+	ttm_bo_unreserve(bo);
+	return retval;
+}
+
+static void ttm_bo_vm_open(struct vm_area_struct *vma)
+{
+	struct ttm_buffer_object *bo =
+	    (struct ttm_buffer_object *)vma->vm_private_data;
+
+	(void)ttm_bo_reference(bo);
+}
+
+static void ttm_bo_vm_close(struct vm_area_struct *vma)
+{
+	struct ttm_buffer_object *bo =
+	    (struct ttm_buffer_object *)vma->vm_private_data;
+
+	ttm_bo_unref(&bo);
+	vma->vm_private_data = NULL;
+}
+
+static struct vm_operations_struct ttm_bo_vm_ops = {
+	.fault = ttm_bo_vm_fault,
+	.open = ttm_bo_vm_open,
+	.close = ttm_bo_vm_close
+};
+
+int ttm_bo_mmap(struct file *filp, struct vm_area_struct *vma,
+		struct ttm_bo_device *bdev)
+{
+	struct ttm_bo_driver *driver;
+	struct ttm_buffer_object *bo;
+	int ret;
+
+	read_lock(&bdev->vm_lock);
+	bo = ttm_bo_vm_lookup_rb(bdev, vma->vm_pgoff,
+				 (vma->vm_end - vma->vm_start) >> PAGE_SHIFT);
+	if (likely(bo != NULL))
+		ttm_bo_reference(bo);
+	read_unlock(&bdev->vm_lock);
+
+	if (unlikely(bo == NULL)) {
+		printk(KERN_ERR "Could not find buffer object to map.\n");
+		ret = -EINVAL;
+		goto out_unref;
+	}
+
+	driver = bo->bdev->driver;
+	if (unlikely(!driver->verify_access)) {
+		ret = -EPERM;
+		goto out_unref;
+	}
+	ret = driver->verify_access(bo, filp);
+	if (unlikely(ret != 0))
+		goto out_unref;
+
+	vma->vm_ops = &ttm_bo_vm_ops;
+
+	/*
+	 * Note: We're transferring the bo reference to
+	 * vma->vm_private_data here.
+	 */
+
+	vma->vm_private_data = bo;
+	vma->vm_flags |= VM_RESERVED | VM_IO | VM_MIXEDMAP | VM_DONTEXPAND;
+	return 0;
+out_unref:
+	ttm_bo_unref(&bo);
+	return ret;
+}
+
+int ttm_fbdev_mmap(struct vm_area_struct *vma, struct ttm_buffer_object *bo)
+{
+	if (vma->vm_pgoff != 0)
+		return -EACCES;
+
+	vma->vm_ops = &ttm_bo_vm_ops;
+	vma->vm_private_data = ttm_bo_reference(bo);
+	vma->vm_flags |= VM_RESERVED | VM_IO | VM_MIXEDMAP | VM_DONTEXPAND;
+	return 0;
+}
+
+ssize_t ttm_bo_io(struct ttm_bo_device *bdev, struct file *filp,
+		  const char __user *wbuf, char __user *rbuf, size_t count,
+		  loff_t *f_pos, bool write)
+{
+	struct ttm_buffer_object *bo;
+	struct ttm_bo_driver *driver;
+	struct ttm_bo_kmap_obj map;
+	unsigned long dev_offset = (*f_pos >> PAGE_SHIFT);
+	unsigned long kmap_offset;
+	unsigned long kmap_end;
+	unsigned long kmap_num;
+	size_t io_size;
+	unsigned int page_offset;
+	char *virtual;
+	int ret;
+	bool no_wait = false;
+	bool dummy;
+
+	driver = bo->bdev->driver;
+	read_lock(&bdev->vm_lock);
+	bo = ttm_bo_vm_lookup_rb(bdev, dev_offset, 1);
+	if (likely(bo != NULL))
+		ttm_bo_reference(bo);
+	read_unlock(&bdev->vm_lock);
+
+	if (unlikely(bo == NULL))
+		return -EFAULT;
+
+	if (unlikely(driver->verify_access))
+		return -EPERM;
+
+	ret = driver->verify_access(bo, filp);
+	if (unlikely(ret != 0))
+		goto out_unref;
+
+	kmap_offset = dev_offset - bo->vm_node->start;
+	if (unlikely(kmap_offset) >= bo->num_pages) {
+		ret = -EFBIG;
+		goto out_unref;
+	}
+
+	page_offset = *f_pos & ~PAGE_MASK;
+	io_size = bo->num_pages - kmap_offset;
+	io_size = (io_size << PAGE_SHIFT) - page_offset;
+	if (count < io_size)
+		io_size = count;
+
+	kmap_end = (*f_pos + count - 1) >> PAGE_SHIFT;
+	kmap_num = kmap_end - kmap_offset + 1;
+
+	ret = ttm_bo_reserve(bo, true, no_wait, false, 0);
+
+	switch (ret) {
+	case 0:
+		break;
+	case -ERESTART:
+		ret = -EINTR;
+		goto out_unref;
+	case -EBUSY:
+		ret = -EAGAIN;
+		goto out_unref;
+	default:
+		goto out_unref;
+	}
+
+	ret = ttm_bo_kmap(bo, kmap_offset, kmap_num, &map);
+	if (unlikely(ret != 0))
+		goto out_unref;
+
+	virtual = ttm_kmap_obj_virtual(&map, &dummy);
+	virtual += page_offset;
+
+	if (write)
+		ret = copy_from_user(virtual, wbuf, io_size);
+	else
+		ret = copy_to_user(rbuf, virtual, io_size);
+
+	ttm_bo_kunmap(&map);
+	ttm_bo_unreserve(bo);
+	ttm_bo_unref(&bo);
+
+	if (unlikely(ret != 0))
+		return -EFBIG;
+
+	*f_pos += io_size;
+
+	return io_size;
+out_unref:
+	ttm_bo_unref(&bo);
+	return ret;
+}
+
+ssize_t ttm_bo_fbdev_io(struct ttm_buffer_object *bo, const char __user *wbuf,
+			char __user *rbuf, size_t count, loff_t *f_pos,
+			bool write)
+{
+	struct ttm_bo_kmap_obj map;
+	unsigned long kmap_offset;
+	unsigned long kmap_end;
+	unsigned long kmap_num;
+	size_t io_size;
+	unsigned int page_offset;
+	char *virtual;
+	int ret;
+	bool no_wait = false;
+	bool dummy;
+
+	kmap_offset = (*f_pos >> PAGE_SHIFT);
+	if (unlikely(kmap_offset) >= bo->num_pages)
+		return -EFBIG;
+
+	page_offset = *f_pos & ~PAGE_MASK;
+	io_size = bo->num_pages - kmap_offset;
+	io_size = (io_size << PAGE_SHIFT) - page_offset;
+	if (count < io_size)
+		io_size = count;
+
+	kmap_end = (*f_pos + count - 1) >> PAGE_SHIFT;
+	kmap_num = kmap_end - kmap_offset + 1;
+
+	ret = ttm_bo_reserve(bo, true, no_wait, false, 0);
+
+	switch (ret) {
+	case 0:
+		break;
+	case -ERESTART:
+		return -EINTR;
+	case -EBUSY:
+		return -EAGAIN;
+	default:
+		return ret;
+	}
+
+	ret = ttm_bo_kmap(bo, kmap_offset, kmap_num, &map);
+	if (unlikely(ret != 0))
+		return ret;
+
+	virtual = ttm_kmap_obj_virtual(&map, &dummy);
+	virtual += page_offset;
+
+	if (write)
+		ret = copy_from_user(virtual, wbuf, io_size);
+	else
+		ret = copy_to_user(rbuf, virtual, io_size);
+
+	ttm_bo_kunmap(&map);
+	ttm_bo_unreserve(bo);
+	ttm_bo_unref(&bo);
+
+	if (unlikely(ret != 0))
+		return ret;
+
+	*f_pos += io_size;
+
+	return io_size;
+}
diff --git a/drivers/gpu/drm/ttm/ttm_execbuf_util.c b/drivers/gpu/drm/ttm/ttm_execbuf_util.c
new file mode 100644
index 0000000..e4a50a8
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_execbuf_util.c
@@ -0,0 +1,115 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+
+#include "ttm/ttm_execbuf_util.h"
+#include "ttm/ttm_bo_driver.h"
+#include "ttm/ttm_placement_common.h"
+#include <linux/wait.h>
+#include <linux/sched.h>
+
+void ttm_eu_backoff_reservation(struct list_head *list)
+{
+	struct ttm_validate_buffer *entry;
+
+	list_for_each_entry(entry, list, head) {
+		struct ttm_buffer_object *bo = entry->bo;
+		if (!entry->reserved)
+			continue;
+
+		entry->reserved = false;
+		ttm_bo_unreserve(bo);
+	}
+}
+
+/*
+ * Reserve buffers for validation.
+ *
+ * If a buffer in the list is marked for CPU access, we back off and
+ * wait for that buffer to become free for GPU access.
+ *
+ * If a buffer is reserved for another validation, the validator with
+ * the highest validation sequence backs off and waits for that buffer
+ * to become unreserved. This prevents deadlocks when validating multiple
+ * buffers in different orders.
+ */
+
+int ttm_eu_reserve_buffers(struct list_head *list, uint32_t val_seq)
+{
+	struct ttm_validate_buffer *entry;
+	int ret;
+
+retry:
+	list_for_each_entry(entry, list, head) {
+		struct ttm_buffer_object *bo = entry->bo;
+
+		entry->reserved = false;
+		ret = ttm_bo_reserve(bo, true, false, true, val_seq);
+		if (ret != 0) {
+			ttm_eu_backoff_reservation(list);
+			if (ret == -EAGAIN) {
+				ret = ttm_bo_wait_unreserved(bo, true);
+				if (unlikely(ret != 0))
+					return ret;
+				goto retry;
+			} else
+				return ret;
+		}
+
+		entry->reserved = true;
+		if (unlikely(atomic_read(&bo->cpu_writers) > 0)) {
+			ttm_eu_backoff_reservation(list);
+			ret = ttm_bo_wait_cpu(bo, false);
+			if (ret)
+				return ret;
+			goto retry;
+		}
+	}
+	return 0;
+}
+
+void ttm_eu_fence_buffer_objects(struct list_head *list, void *sync_obj)
+{
+	struct ttm_validate_buffer *entry;
+
+	list_for_each_entry(entry, list, head) {
+		struct ttm_buffer_object *bo = entry->bo;
+		struct ttm_bo_driver *driver = bo->bdev->driver;
+		void *old_sync_obj;
+
+		mutex_lock(&bo->mutex);
+		old_sync_obj = bo->sync_obj;
+		bo->sync_obj = driver->sync_obj_ref(sync_obj);
+		bo->sync_obj_arg = entry->new_sync_obj_arg;
+		mutex_unlock(&bo->mutex);
+		ttm_bo_unreserve(bo);
+		entry->reserved = false;
+		if (old_sync_obj)
+			driver->sync_obj_unref(&old_sync_obj);
+	}
+}
diff --git a/drivers/gpu/drm/ttm/ttm_fence.c b/drivers/gpu/drm/ttm/ttm_fence.c
new file mode 100644
index 0000000..b486497
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_fence.c
@@ -0,0 +1,610 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#include "ttm/ttm_fence_api.h"
+#include "ttm/ttm_fence_driver.h"
+#include <linux/wait.h>
+#include <linux/sched.h>
+
+#include "drmP.h"
+
+/*
+ * Simple implementation for now.
+ */
+
+static void ttm_fence_lockup(struct ttm_fence_object *fence, uint32_t mask)
+{
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+
+	printk(KERN_ERR "GPU lockup dectected on engine %u "
+	       "fence type 0x%08x\n",
+	       (unsigned int)fence->fence_class, (unsigned int)mask);
+	/*
+	 * Give engines some time to idle?
+	 */
+
+	write_lock(&fc->lock);
+	ttm_fence_handler(fence->fdev, fence->fence_class,
+			  fence->sequence, mask, -EBUSY);
+	write_unlock(&fc->lock);
+}
+
+/*
+ * Convenience function to be called by fence::wait methods that
+ * need polling.
+ */
+
+int ttm_fence_wait_polling(struct ttm_fence_object *fence, bool lazy,
+			   bool interruptible, uint32_t mask)
+{
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+	const struct ttm_fence_driver *driver = ttm_fence_driver(fence);
+	uint32_t count = 0;
+	int ret;
+	unsigned long end_jiffies = fence->timeout_jiffies;
+
+	DECLARE_WAITQUEUE(entry, current);
+	add_wait_queue(&fc->fence_queue, &entry);
+
+	ret = 0;
+
+	for (;;) {
+		__set_current_state((interruptible) ?
+				    TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE);
+		if (ttm_fence_object_signaled(fence, mask))
+			break;
+		if (time_after_eq(jiffies, end_jiffies)) {
+			if (driver->lockup)
+				driver->lockup(fence, mask);
+			else
+				ttm_fence_lockup(fence, mask);
+			continue;
+		}
+		if (lazy)
+			schedule_timeout(1);
+		else if ((++count & 0x0F) == 0) {
+			__set_current_state(TASK_RUNNING);
+			schedule();
+			__set_current_state((interruptible) ?
+					    TASK_INTERRUPTIBLE :
+					    TASK_UNINTERRUPTIBLE);
+		}
+		if (interruptible && signal_pending(current)) {
+			ret = -ERESTART;
+			break;
+		}
+	}
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&fc->fence_queue, &entry);
+	return ret;
+}
+
+/*
+ * Typically called by the IRQ handler.
+ */
+
+void ttm_fence_handler(struct ttm_fence_device *fdev, uint32_t fence_class,
+		       uint32_t sequence, uint32_t type, uint32_t error)
+{
+	int wake = 0;
+	uint32_t diff;
+	uint32_t relevant_type;
+	uint32_t new_type;
+	struct ttm_fence_class_manager *fc = &fdev->fence_class[fence_class];
+	const struct ttm_fence_driver *driver = ttm_fence_driver_from_dev(fdev);
+	struct list_head *head;
+	struct ttm_fence_object *fence, *next;
+	bool found = false;
+
+	if (list_empty(&fc->ring))
+		return;
+
+	list_for_each_entry(fence, &fc->ring, ring) {
+		diff = (sequence - fence->sequence) & fc->sequence_mask;
+		if (diff > fc->wrap_diff) {
+			found = true;
+			break;
+		}
+	}
+
+	fc->waiting_types &= ~type;
+	head = (found) ? &fence->ring : &fc->ring;
+
+	list_for_each_entry_safe_reverse(fence, next, head, ring) {
+		if (&fence->ring == &fc->ring)
+			break;
+
+		DRM_DEBUG("Fence 0x%08lx, sequence 0x%08x, type 0x%08x\n",
+			  (unsigned long)fence, fence->sequence,
+			  fence->fence_type);
+
+		if (error) {
+			fence->info.error = error;
+			fence->info.signaled_types = fence->fence_type;
+			list_del_init(&fence->ring);
+			wake = 1;
+			break;
+		}
+
+		relevant_type = type & fence->fence_type;
+		new_type = (fence->info.signaled_types | relevant_type) ^
+		    fence->info.signaled_types;
+
+		if (new_type) {
+			fence->info.signaled_types |= new_type;
+			DRM_DEBUG("Fence 0x%08lx signaled 0x%08x\n",
+				  (unsigned long)fence,
+				  fence->info.signaled_types);
+
+			if (unlikely(driver->signaled))
+				driver->signaled(fence);
+
+			if (driver->needed_flush)
+				fc->pending_flush |=
+				    driver->needed_flush(fence);
+
+			if (new_type & fence->waiting_types)
+				wake = 1;
+		}
+
+		fc->waiting_types |=
+		    fence->waiting_types & ~fence->info.signaled_types;
+
+		if (!(fence->fence_type & ~fence->info.signaled_types)) {
+			DRM_DEBUG("Fence completely signaled 0x%08lx\n",
+				  (unsigned long)fence);
+			list_del_init(&fence->ring);
+		}
+	}
+
+	/*
+	 * Reinstate lost waiting types.
+	 */
+
+	if ((fc->waiting_types & type) != type) {
+		head = head->prev;
+		list_for_each_entry(fence, head, ring) {
+			if (&fence->ring == &fc->ring)
+				break;
+			diff =
+			    (fc->highest_waiting_sequence -
+			     fence->sequence) & fc->sequence_mask;
+			if (diff > fc->wrap_diff)
+				break;
+
+			fc->waiting_types |=
+			    fence->waiting_types & ~fence->info.signaled_types;
+		}
+	}
+
+	if (wake)
+		wake_up_all(&fc->fence_queue);
+}
+
+static void ttm_fence_unring(struct ttm_fence_object *fence)
+{
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+	unsigned long irq_flags;
+
+	write_lock_irqsave(&fc->lock, irq_flags);
+	list_del_init(&fence->ring);
+	write_unlock_irqrestore(&fc->lock, irq_flags);
+}
+
+bool ttm_fence_object_signaled(struct ttm_fence_object *fence, uint32_t mask)
+{
+	unsigned long flags;
+	bool signaled;
+	const struct ttm_fence_driver *driver = ttm_fence_driver(fence);
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+
+	mask &= fence->fence_type;
+	read_lock_irqsave(&fc->lock, flags);
+	signaled = (mask & fence->info.signaled_types) == mask;
+	read_unlock_irqrestore(&fc->lock, flags);
+	if (!signaled && driver->poll) {
+		write_lock_irqsave(&fc->lock, flags);
+		driver->poll(fence->fdev, fence->fence_class, mask);
+		signaled = (mask & fence->info.signaled_types) == mask;
+		write_unlock_irqrestore(&fc->lock, flags);
+	}
+	return signaled;
+}
+
+int ttm_fence_object_flush(struct ttm_fence_object *fence, uint32_t type)
+{
+	const struct ttm_fence_driver *driver = ttm_fence_driver(fence);
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+	unsigned long irq_flags;
+	uint32_t saved_pending_flush;
+	uint32_t diff;
+	bool call_flush;
+
+	if (type & ~fence->fence_type) {
+		DRM_ERROR("Flush trying to extend fence type, "
+			  "0x%x, 0x%x\n", type, fence->fence_type);
+		return -EINVAL;
+	}
+
+	write_lock_irqsave(&fc->lock, irq_flags);
+	fence->waiting_types |= type;
+	fc->waiting_types |= fence->waiting_types;
+	diff = (fence->sequence - fc->highest_waiting_sequence) &
+	    fc->sequence_mask;
+
+	if (diff < fc->wrap_diff)
+		fc->highest_waiting_sequence = fence->sequence;
+
+	/*
+	 * fence->waiting_types has changed. Determine whether
+	 * we need to initiate some kind of flush as a result of this.
+	 */
+
+	saved_pending_flush = fc->pending_flush;
+	if (driver->needed_flush)
+		fc->pending_flush |= driver->needed_flush(fence);
+
+	if (driver->poll)
+		driver->poll(fence->fdev, fence->fence_class,
+			     fence->waiting_types);
+
+	call_flush = (fc->pending_flush != 0);
+	write_unlock_irqrestore(&fc->lock, irq_flags);
+
+	if (call_flush && driver->flush)
+		driver->flush(fence->fdev, fence->fence_class);
+
+	return 0;
+}
+
+/*
+ * Make sure old fence objects are signaled before their fence sequences are
+ * wrapped around and reused.
+ */
+
+void ttm_fence_flush_old(struct ttm_fence_device *fdev,
+			 uint32_t fence_class, uint32_t sequence)
+{
+	struct ttm_fence_class_manager *fc = &fdev->fence_class[fence_class];
+	struct ttm_fence_object *fence;
+	unsigned long irq_flags;
+	const struct ttm_fence_driver *driver = fdev->driver;
+	bool call_flush;
+
+	uint32_t diff;
+
+	write_lock_irqsave(&fc->lock, irq_flags);
+
+	list_for_each_entry_reverse(fence, &fc->ring, ring) {
+		diff = (sequence - fence->sequence) & fc->sequence_mask;
+		if (diff <= fc->flush_diff)
+			break;
+
+		fence->waiting_types = fence->fence_type;
+		fc->waiting_types |= fence->fence_type;
+
+		if (driver->needed_flush)
+			fc->pending_flush |= driver->needed_flush(fence);
+	}
+
+	if (driver->poll)
+		driver->poll(fdev, fence_class, fc->waiting_types);
+
+	call_flush = (fc->pending_flush != 0);
+	write_unlock_irqrestore(&fc->lock, irq_flags);
+
+	if (call_flush && driver->flush)
+		driver->flush(fdev, fence->fence_class);
+
+	/*
+	 * FIXME: Shold we implement a wait here for really old fences?
+	 */
+
+}
+
+int ttm_fence_object_wait(struct ttm_fence_object *fence,
+			  bool lazy, bool interruptible, uint32_t mask)
+{
+	const struct ttm_fence_driver *driver = ttm_fence_driver(fence);
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+	int ret = 0;
+	unsigned long timeout;
+	unsigned long cur_jiffies;
+	unsigned long to_jiffies;
+
+	if (mask & ~fence->fence_type) {
+		DRM_ERROR("Wait trying to extend fence type"
+			  " 0x%08x 0x%08x\n", mask, fence->fence_type);
+		BUG();
+		return -EINVAL;
+	}
+
+	if (driver->wait)
+		return driver->wait(fence, lazy, interruptible, mask);
+
+	ttm_fence_object_flush(fence, mask);
+retry:
+	if (!driver->has_irq ||
+	    driver->has_irq(fence->fdev, fence->fence_class, mask)) {
+
+		cur_jiffies = jiffies;
+		to_jiffies = fence->timeout_jiffies;
+
+		timeout = (time_after(to_jiffies, cur_jiffies)) ?
+		    to_jiffies - cur_jiffies : 1;
+
+		if (interruptible)
+			ret = wait_event_interruptible_timeout
+			    (fc->fence_queue,
+			     ttm_fence_object_signaled(fence, mask), timeout);
+		else
+			ret = wait_event_timeout
+			    (fc->fence_queue,
+			     ttm_fence_object_signaled(fence, mask), timeout);
+
+		if (unlikely(ret == -ERESTARTSYS))
+			return -ERESTART;
+
+		if (unlikely(ret == 0)) {
+			if (driver->lockup)
+				driver->lockup(fence, mask);
+			else
+				ttm_fence_lockup(fence, mask);
+			goto retry;
+		}
+
+		return 0;
+	}
+
+	return ttm_fence_wait_polling(fence, lazy, interruptible, mask);
+}
+
+int ttm_fence_object_emit(struct ttm_fence_object *fence, uint32_t fence_flags,
+			  uint32_t fence_class, uint32_t type)
+{
+	const struct ttm_fence_driver *driver = ttm_fence_driver(fence);
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+	unsigned long flags;
+	uint32_t sequence;
+	unsigned long timeout;
+	int ret;
+
+	ttm_fence_unring(fence);
+	ret = driver->emit(fence->fdev,
+			   fence_class, fence_flags, &sequence, &timeout);
+	if (ret)
+		return ret;
+
+	write_lock_irqsave(&fc->lock, flags);
+	fence->fence_class = fence_class;
+	fence->fence_type = type;
+	fence->waiting_types = 0;
+	fence->info.signaled_types = 0;
+	fence->info.error = 0;
+	fence->sequence = sequence;
+	fence->timeout_jiffies = timeout;
+	if (list_empty(&fc->ring))
+		fc->highest_waiting_sequence = sequence - 1;
+	list_add_tail(&fence->ring, &fc->ring);
+	fc->latest_queued_sequence = sequence;
+	write_unlock_irqrestore(&fc->lock, flags);
+	return 0;
+}
+
+int ttm_fence_object_init(struct ttm_fence_device *fdev,
+			  uint32_t fence_class,
+			  uint32_t type,
+			  uint32_t create_flags,
+			  void (*destroy) (struct ttm_fence_object *),
+			  struct ttm_fence_object *fence)
+{
+	int ret = 0;
+
+	kref_init(&fence->kref);
+	fence->fence_class = fence_class;
+	fence->fence_type = type;
+	fence->info.signaled_types = 0;
+	fence->waiting_types = 0;
+	fence->sequence = 0;
+	fence->info.error = 0;
+	fence->fdev = fdev;
+	fence->destroy = destroy;
+	INIT_LIST_HEAD(&fence->ring);
+	atomic_inc(&fdev->count);
+
+	if (create_flags & TTM_FENCE_FLAG_EMIT) {
+		ret = ttm_fence_object_emit(fence, create_flags,
+					    fence->fence_class, type);
+	}
+
+	return ret;
+}
+
+int ttm_fence_object_create(struct ttm_fence_device *fdev,
+			    uint32_t fence_class,
+			    uint32_t type,
+			    uint32_t create_flags,
+			    struct ttm_fence_object **c_fence)
+{
+	struct ttm_fence_object *fence;
+	int ret;
+
+	ret = ttm_mem_global_alloc(fdev->mem_glob, sizeof(*fence),
+				   false, false, false);
+	if (unlikely(ret != 0)) {
+		printk(KERN_ERR "Out of memory creating fence object\n");
+		return ret;
+	}
+
+	fence = kmalloc(sizeof(*fence), GFP_KERNEL);
+	if (!fence) {
+		printk(KERN_ERR "Out of memory creating fence object\n");
+		ttm_mem_global_free(fdev->mem_glob, sizeof(*fence), false);
+		return -ENOMEM;
+	}
+
+	ret = ttm_fence_object_init(fdev, fence_class, type,
+				    create_flags, NULL, fence);
+	if (ret) {
+		ttm_fence_object_unref(&fence);
+		return ret;
+	}
+	*c_fence = fence;
+
+	return 0;
+}
+
+static void ttm_fence_object_destroy(struct kref *kref)
+{
+	struct ttm_fence_object *fence =
+	    container_of(kref, struct ttm_fence_object, kref);
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+	unsigned long irq_flags;
+
+	write_lock_irqsave(&fc->lock, irq_flags);
+	list_del_init(&fence->ring);
+	write_unlock_irqrestore(&fc->lock, irq_flags);
+
+	atomic_dec(&fence->fdev->count);
+	if (fence->destroy)
+		fence->destroy(fence);
+	else {
+		ttm_mem_global_free(fence->fdev->mem_glob, sizeof(*fence),
+				    false);
+		kfree(fence);
+	}
+}
+
+void ttm_fence_device_release(struct ttm_fence_device *fdev)
+{
+	kfree(fdev->fence_class);
+}
+
+int
+ttm_fence_device_init(int num_classes,
+		      struct ttm_mem_global *mem_glob,
+		      struct ttm_fence_device *fdev,
+		      const struct ttm_fence_class_init *init,
+		      bool replicate_init,
+		      const struct ttm_fence_driver *driver)
+{
+	struct ttm_fence_class_manager *fc;
+	const struct ttm_fence_class_init *fci;
+	int i;
+
+	fdev->mem_glob = mem_glob;
+	fdev->fence_class = kzalloc(num_classes *
+				    sizeof(*fdev->fence_class), GFP_KERNEL);
+
+	if (unlikely(!fdev->fence_class))
+		return -ENOMEM;
+
+	fdev->num_classes = num_classes;
+	atomic_set(&fdev->count, 0);
+	fdev->driver = driver;
+
+	for (i = 0; i < fdev->num_classes; ++i) {
+		fc = &fdev->fence_class[i];
+		fci = &init[(replicate_init) ? 0 : i];
+
+		fc->wrap_diff = fci->wrap_diff;
+		fc->flush_diff = fci->flush_diff;
+		fc->sequence_mask = fci->sequence_mask;
+
+		rwlock_init(&fc->lock);
+		INIT_LIST_HEAD(&fc->ring);
+		init_waitqueue_head(&fc->fence_queue);
+	}
+
+	return 0;
+}
+
+struct ttm_fence_info ttm_fence_get_info(struct ttm_fence_object *fence)
+{
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+	struct ttm_fence_info tmp;
+	unsigned long irq_flags;
+
+	read_lock_irqsave(&fc->lock, irq_flags);
+	tmp = fence->info;
+	read_unlock_irqrestore(&fc->lock, irq_flags);
+
+	return tmp;
+}
+
+void ttm_fence_object_unref(struct ttm_fence_object **p_fence)
+{
+	struct ttm_fence_object *fence = *p_fence;
+
+	*p_fence = NULL;
+	(void)kref_put(&fence->kref, &ttm_fence_object_destroy);
+}
+
+/*
+ * Placement / BO sync object glue.
+ */
+
+bool ttm_fence_sync_obj_signaled(void *sync_obj, void *sync_arg)
+{
+	struct ttm_fence_object *fence = (struct ttm_fence_object *)sync_obj;
+	uint32_t fence_types = (uint32_t) (unsigned long)sync_arg;
+
+	return ttm_fence_object_signaled(fence, fence_types);
+}
+
+int ttm_fence_sync_obj_wait(void *sync_obj, void *sync_arg,
+			    bool lazy, bool interruptible)
+{
+	struct ttm_fence_object *fence = (struct ttm_fence_object *)sync_obj;
+	uint32_t fence_types = (uint32_t) (unsigned long)sync_arg;
+
+	return ttm_fence_object_wait(fence, lazy, interruptible, fence_types);
+}
+
+int ttm_fence_sync_obj_flush(void *sync_obj, void *sync_arg)
+{
+	struct ttm_fence_object *fence = (struct ttm_fence_object *)sync_obj;
+	uint32_t fence_types = (uint32_t) (unsigned long)sync_arg;
+
+	return ttm_fence_object_flush(fence, fence_types);
+}
+
+void ttm_fence_sync_obj_unref(void **sync_obj)
+{
+	ttm_fence_object_unref((struct ttm_fence_object **)sync_obj);
+}
+
+void *ttm_fence_sync_obj_ref(void *sync_obj)
+{
+	return (void *)
+	    ttm_fence_object_ref((struct ttm_fence_object *)sync_obj);
+}
diff --git a/drivers/gpu/drm/ttm/ttm_fence_user.c b/drivers/gpu/drm/ttm/ttm_fence_user.c
new file mode 100644
index 0000000..919339c
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_fence_user.c
@@ -0,0 +1,240 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#include "drmP.h"
+#include "ttm/ttm_fence_user.h"
+#include "ttm/ttm_object.h"
+#include "ttm/ttm_fence_driver.h"
+#include "ttm/ttm_userobj_api.h"
+
+/**
+ * struct ttm_fence_user_object
+ *
+ * @base:    The base object used for user-space visibility and refcounting.
+ *
+ * @fence:   The fence object itself.
+ *
+ */
+
+struct ttm_fence_user_object {
+	struct ttm_base_object base;
+	struct ttm_fence_object fence;
+};
+
+static struct ttm_fence_user_object *
+ttm_fence_user_object_lookup(struct ttm_object_file *tfile, uint32_t handle)
+{
+	struct ttm_base_object *base;
+
+	base = ttm_base_object_lookup(tfile, handle);
+	if (unlikely(base == NULL)) {
+		printk(KERN_ERR "Invalid fence handle 0x%08lx\n",
+		       (unsigned long)handle);
+		return NULL;
+	}
+
+	if (unlikely(base->object_type != ttm_fence_type)) {
+		ttm_base_object_unref(&base);
+		printk(KERN_ERR "Invalid fence handle 0x%08lx\n",
+		       (unsigned long)handle);
+		return NULL;
+	}
+
+	return container_of(base, struct ttm_fence_user_object, base);
+}
+
+/*
+ * The fence object destructor.
+ */
+
+static void ttm_fence_user_destroy(struct ttm_fence_object *fence)
+{
+	struct ttm_fence_user_object *ufence =
+	    container_of(fence, struct ttm_fence_user_object, fence);
+
+	ttm_mem_global_free(fence->fdev->mem_glob, sizeof(*ufence), false);
+	kfree(ufence);
+}
+
+/*
+ * The base object destructor. We basically unly unreference the
+ * attached fence object.
+ */
+
+static void ttm_fence_user_release(struct ttm_base_object **p_base)
+{
+	struct ttm_fence_user_object *ufence;
+	struct ttm_base_object *base = *p_base;
+	struct ttm_fence_object *fence;
+
+	*p_base = NULL;
+
+	if (unlikely(base == NULL))
+		return;
+
+	ufence = container_of(base, struct ttm_fence_user_object, base);
+	fence = &ufence->fence;
+	ttm_fence_object_unref(&fence);
+}
+
+int
+ttm_fence_user_create(struct ttm_fence_device *fdev,
+		      struct ttm_object_file *tfile,
+		      uint32_t fence_class,
+		      uint32_t fence_types,
+		      uint32_t create_flags,
+		      struct ttm_fence_object **fence, uint32_t * user_handle)
+{
+	int ret;
+	struct ttm_fence_object *tmp;
+	struct ttm_fence_user_object *ufence;
+
+	ret = ttm_mem_global_alloc(fdev->mem_glob, sizeof(*ufence), false,
+				   false, false);
+	if (unlikely(ret != 0))
+		return -ENOMEM;
+
+	ufence = kmalloc(sizeof(*ufence), GFP_KERNEL);
+	if (unlikely(ufence == NULL)) {
+		ttm_mem_global_free(fdev->mem_glob, sizeof(*ufence), false);
+		return -ENOMEM;
+	}
+
+	ret = ttm_fence_object_init(fdev,
+				    fence_class,
+				    fence_types, create_flags,
+				    &ttm_fence_user_destroy, &ufence->fence);
+
+	if (unlikely(ret != 0))
+		goto out_err0;
+
+	/*
+	 * One fence ref is held by the fence ptr we return.
+	 * The other one by the base object. Need to up the
+	 * fence refcount before we publish this object to
+	 * user-space.
+	 */
+
+	tmp = ttm_fence_object_ref(&ufence->fence);
+	ret = ttm_base_object_init(tfile, &ufence->base,
+				   false, ttm_fence_type,
+				   &ttm_fence_user_release, NULL);
+
+	if (unlikely(ret != 0))
+		goto out_err1;
+
+	*fence = &ufence->fence;
+	*user_handle = ufence->base.hash.key;
+
+	return 0;
+out_err1:
+	ttm_fence_object_unref(&tmp);
+	tmp = &ufence->fence;
+	ttm_fence_object_unref(&tmp);
+	return ret;
+out_err0:
+	ttm_mem_global_free(fdev->mem_glob, sizeof(*ufence), false);
+	kfree(ufence);
+	return ret;
+}
+
+int ttm_fence_signaled_ioctl(struct ttm_object_file *tfile, void *data)
+{
+	int ret;
+	union ttm_fence_signaled_arg *arg = data;
+	struct ttm_fence_object *fence;
+	struct ttm_fence_info info;
+	struct ttm_fence_user_object *ufence;
+	struct ttm_base_object *base;
+	ret = 0;
+
+	ufence = ttm_fence_user_object_lookup(tfile, arg->req.handle);
+	if (unlikely(ufence == NULL))
+		return -EINVAL;
+
+	fence = &ufence->fence;
+
+	if (arg->req.flush) {
+		ret = ttm_fence_object_flush(fence, arg->req.fence_type);
+		if (unlikely(ret != 0))
+			goto out;
+	}
+
+	info = ttm_fence_get_info(fence);
+	arg->rep.signaled_types = info.signaled_types;
+	arg->rep.fence_error = info.error;
+
+out:
+	base = &ufence->base;
+	ttm_base_object_unref(&base);
+	return ret;
+}
+
+int ttm_fence_finish_ioctl(struct ttm_object_file *tfile, void *data)
+{
+	int ret;
+	union ttm_fence_finish_arg *arg = data;
+	struct ttm_fence_user_object *ufence;
+	struct ttm_base_object *base;
+	struct ttm_fence_object *fence;
+	ret = 0;
+
+	ufence = ttm_fence_user_object_lookup(tfile, arg->req.handle);
+	if (unlikely(ufence == NULL))
+		return -EINVAL;
+
+	fence = &ufence->fence;
+
+	ret = ttm_fence_object_wait(fence,
+				    arg->req.mode & TTM_FENCE_FINISH_MODE_LAZY,
+				    true, arg->req.fence_type);
+	if (likely(ret == 0)) {
+		struct ttm_fence_info info = ttm_fence_get_info(fence);
+
+		arg->rep.signaled_types = info.signaled_types;
+		arg->rep.fence_error = info.error;
+	}
+
+	base = &ufence->base;
+	ttm_base_object_unref(&base);
+
+	return ret;
+}
+
+int ttm_fence_unref_ioctl(struct ttm_object_file *tfile, void *data)
+{
+	struct ttm_fence_unref_arg *arg = data;
+	int ret = 0;
+
+	ret = ttm_ref_object_base_unref(tfile, arg->handle, ttm_fence_type);
+	return ret;
+}
diff --git a/drivers/gpu/drm/ttm/ttm_lock.c b/drivers/gpu/drm/ttm/ttm_lock.c
new file mode 100644
index 0000000..67535fa
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_lock.c
@@ -0,0 +1,162 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2007-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#include "ttm/ttm_lock.h"
+#include <asm/atomic.h>
+#include <linux/errno.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+
+void ttm_lock_init(struct ttm_lock *lock)
+{
+	init_waitqueue_head(&lock->queue);
+	atomic_set(&lock->write_lock_pending, 0);
+	atomic_set(&lock->readers, 0);
+	lock->kill_takers = false;
+	lock->signal = SIGKILL;
+}
+
+void ttm_read_unlock(struct ttm_lock *lock)
+{
+	if (atomic_dec_and_test(&lock->readers))
+		wake_up_all(&lock->queue);
+}
+
+int ttm_read_lock(struct ttm_lock *lock, bool interruptible)
+{
+	while (unlikely(atomic_read(&lock->write_lock_pending) != 0)) {
+		int ret;
+
+		if (!interruptible) {
+			wait_event(lock->queue,
+				   atomic_read(&lock->write_lock_pending) == 0);
+			continue;
+		}
+		ret = wait_event_interruptible
+		    (lock->queue, atomic_read(&lock->write_lock_pending) == 0);
+		if (ret)
+			return -ERESTART;
+	}
+
+	while (unlikely(!atomic_add_unless(&lock->readers, 1, -1))) {
+		int ret;
+		if (!interruptible) {
+			wait_event(lock->queue,
+				   atomic_read(&lock->readers) != -1);
+			continue;
+		}
+		ret = wait_event_interruptible
+		    (lock->queue, atomic_read(&lock->readers) != -1);
+		if (ret)
+			return -ERESTART;
+	}
+
+	if (unlikely(lock->kill_takers)) {
+		send_sig(lock->signal, current, 0);
+		ttm_read_unlock(lock);
+		return -ERESTART;
+	}
+
+	return 0;
+}
+
+static int __ttm_write_unlock(struct ttm_lock *lock)
+{
+	if (unlikely(atomic_cmpxchg(&lock->readers, -1, 0) != -1))
+		return -EINVAL;
+	wake_up_all(&lock->queue);
+	return 0;
+}
+
+static void ttm_write_lock_remove(struct ttm_base_object **p_base)
+{
+	struct ttm_base_object *base = *p_base;
+	struct ttm_lock *lock = container_of(base, struct ttm_lock, base);
+	int ret;
+
+	*p_base = NULL;
+	ret = __ttm_write_unlock(lock);
+	BUG_ON(ret != 0);
+}
+
+int ttm_write_lock(struct ttm_lock *lock,
+		   bool interruptible,
+		   struct ttm_object_file *tfile)
+{
+	int ret = 0;
+
+	atomic_inc(&lock->write_lock_pending);
+
+	while (unlikely(atomic_cmpxchg(&lock->readers, 0, -1) != 0)) {
+		if (!interruptible) {
+			wait_event(lock->queue,
+				   atomic_read(&lock->readers) == 0);
+			continue;
+		}
+		ret = wait_event_interruptible
+		    (lock->queue, atomic_read(&lock->readers) == 0);
+
+		if (ret) {
+			if (atomic_dec_and_test(&lock->write_lock_pending))
+				wake_up_all(&lock->queue);
+			return -ERESTART;
+		}
+	}
+
+	if (atomic_dec_and_test(&lock->write_lock_pending))
+		wake_up_all(&lock->queue);
+
+	if (unlikely(lock->kill_takers)) {
+		send_sig(lock->signal, current, 0);
+		__ttm_write_unlock(lock);
+		return -ERESTART;
+	}
+
+	/*
+	 * Add a base-object, the destructor of which will
+	 * make sure the lock is released if the client dies
+	 * while holding it.
+	 */
+
+	ret = ttm_base_object_init(tfile, &lock->base, false,
+				   ttm_lock_type, &ttm_write_lock_remove, NULL);
+	if (ret)
+		(void)__ttm_write_unlock(lock);
+
+	return ret;
+}
+
+int ttm_write_unlock(struct ttm_lock *lock, struct ttm_object_file *tfile)
+{
+	return ttm_ref_object_base_unref(tfile,
+					 lock->base.hash.key, TTM_REF_USAGE);
+}
diff --git a/drivers/gpu/drm/ttm/ttm_memory.c b/drivers/gpu/drm/ttm/ttm_memory.c
new file mode 100644
index 0000000..344ecdb
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_memory.c
@@ -0,0 +1,232 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+
+#include "ttm/ttm_memory.h"
+#include <linux/spinlock.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/mm.h>
+
+#define TTM_MEMORY_ALLOC_RETRIES 4
+
+/**
+ * At this point we only support a single shrink callback.
+ * Extend this if needed, perhaps using a linked list of callbacks.
+ * Note that this function is reentrant:
+ * many threads may try to swap out at any given time.
+ */
+
+static void ttm_shrink(struct ttm_mem_global *glob, bool from_workqueue,
+		       uint64_t extra)
+{
+	int ret;
+	struct ttm_mem_shrink *shrink;
+	uint64_t target;
+	uint64_t total_target;
+
+	spin_lock(&glob->lock);
+	if (glob->shrink == NULL)
+		goto out;
+
+	if (from_workqueue) {
+		target = glob->swap_limit;
+		total_target = glob->total_memory_swap_limit;
+	} else if (capable(CAP_SYS_ADMIN)) {
+		total_target = glob->emer_total_memory;
+		target = glob->emer_memory;
+	} else {
+		total_target = glob->max_total_memory;
+		target = glob->max_memory;
+	}
+
+	total_target = (extra >= total_target) ? 0 : total_target - extra;
+	target = (extra >= target) ? 0 : target - extra;
+
+	while (glob->used_memory > target ||
+	       glob->used_total_memory > total_target) {
+		shrink = glob->shrink;
+		spin_unlock(&glob->lock);
+		ret = shrink->do_shrink(shrink);
+		spin_lock(&glob->lock);
+		if (unlikely(ret != 0))
+			goto out;
+	}
+out:
+	spin_unlock(&glob->lock);
+}
+
+static void ttm_shrink_work(struct work_struct *work)
+{
+	struct ttm_mem_global *glob =
+	    container_of(work, struct ttm_mem_global, work);
+
+	ttm_shrink(glob, true, 0ULL);
+}
+
+int ttm_mem_global_init(struct ttm_mem_global *glob)
+{
+	struct sysinfo si;
+	uint64_t mem;
+
+	spin_lock_init(&glob->lock);
+	glob->swap_queue = create_singlethread_workqueue("ttm_swap");
+	INIT_WORK(&glob->work, ttm_shrink_work);
+	init_waitqueue_head(&glob->queue);
+
+	si_meminfo(&si);
+
+	mem = si.totalram - si.totalhigh;
+	mem *= si.mem_unit;
+
+	glob->max_memory = mem >> 1;
+	glob->emer_memory = glob->max_memory + (mem >> 2);
+	glob->swap_limit = glob->max_memory - (mem >> 5);
+	glob->used_memory = 0;
+	glob->used_total_memory = 0;
+	glob->shrink = NULL;
+
+	mem = si.totalram;
+	mem *= si.mem_unit;
+
+	glob->max_total_memory = mem >> 1;
+	glob->emer_total_memory = glob->max_total_memory + (mem >> 2);
+
+	glob->total_memory_swap_limit = glob->max_total_memory - (mem >> 5);
+
+	printk(KERN_INFO "TTM available graphics memory: %llu MiB\n",
+	       glob->max_total_memory >> 20);
+	printk(KERN_INFO "TTM available object memory: %llu MiB\n",
+	       glob->max_memory >> 20);
+
+	return 0;
+}
+
+void ttm_mem_global_release(struct ttm_mem_global *glob)
+{
+	printk(KERN_INFO "Used total memory is %llu bytes.\n",
+	       (unsigned long long)glob->used_total_memory);
+	flush_workqueue(glob->swap_queue);
+	destroy_workqueue(glob->swap_queue);
+	glob->swap_queue = NULL;
+}
+
+static inline void ttm_check_swapping(struct ttm_mem_global *glob)
+{
+	bool needs_swapping;
+
+	spin_lock(&glob->lock);
+	needs_swapping = (glob->used_memory > glob->swap_limit ||
+			  glob->used_total_memory >
+			  glob->total_memory_swap_limit);
+	spin_unlock(&glob->lock);
+
+	if (unlikely(needs_swapping))
+		(void)queue_work(glob->swap_queue, &glob->work);
+
+}
+
+void ttm_mem_global_free(struct ttm_mem_global *glob,
+			 uint64_t amount, bool himem)
+{
+	spin_lock(&glob->lock);
+	glob->used_total_memory -= amount;
+	if (!himem)
+		glob->used_memory -= amount;
+	wake_up_all(&glob->queue);
+	spin_unlock(&glob->lock);
+}
+
+static int ttm_mem_global_reserve(struct ttm_mem_global *glob,
+				  uint64_t amount, bool himem, bool reserve)
+{
+	uint64_t limit;
+	uint64_t lomem_limit;
+	int ret = -ENOMEM;
+
+	spin_lock(&glob->lock);
+
+	if (capable(CAP_SYS_ADMIN)) {
+		limit = glob->emer_total_memory;
+		lomem_limit = glob->emer_memory;
+	} else {
+		limit = glob->max_total_memory;
+		lomem_limit = glob->max_memory;
+	}
+
+	if (unlikely(glob->used_total_memory + amount > limit))
+		goto out_unlock;
+	if (unlikely(!himem && glob->used_memory + amount > lomem_limit))
+		goto out_unlock;
+
+	if (reserve) {
+		glob->used_total_memory += amount;
+		if (!himem)
+			glob->used_memory += amount;
+	}
+	ret = 0;
+out_unlock:
+	spin_unlock(&glob->lock);
+	ttm_check_swapping(glob);
+
+	return ret;
+}
+
+int ttm_mem_global_alloc(struct ttm_mem_global *glob, uint64_t memory,
+			 bool no_wait, bool interruptible, bool himem)
+{
+	int count = TTM_MEMORY_ALLOC_RETRIES;
+
+	while (unlikely(ttm_mem_global_reserve(glob, memory,
+					       himem, true) != 0)) {
+		if (no_wait)
+			return -ENOMEM;
+		if (unlikely(count-- == 0))
+			return -ENOMEM;
+		ttm_shrink(glob, false, memory + (memory >> 2) + 16);
+	}
+
+	return 0;
+}
+
+size_t ttm_round_pot(size_t size)
+{
+	if ((size & (size - 1)) == 0)
+		return size;
+	else if (size > PAGE_SIZE)
+		return PAGE_ALIGN(size);
+	else {
+		size_t tmp_size = 4;
+
+		while (tmp_size < size)
+			tmp_size <<= 1;
+
+		return tmp_size;
+	}
+	return 0;
+}
diff --git a/drivers/gpu/drm/ttm/ttm_object.c b/drivers/gpu/drm/ttm/ttm_object.c
new file mode 100644
index 0000000..8c868c8
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_object.c
@@ -0,0 +1,443 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+/** @file ttm_ref_object.c
+ *
+ * Base- and reference object implementation for the various
+ * ttm objects. Implements reference counting, minimal security checks
+ * and release on file close.
+ */
+
+/**
+ * struct ttm_object_file
+ *
+ * @tdev: Pointer to the ttm_object_device.
+ *
+ * @lock: Lock that protects the ref_list list and the
+ * ref_hash hash tables.
+ *
+ * @ref_list: List of ttm_ref_objects to be destroyed at
+ * file release.
+ *
+ * @ref_hash: Hash tables of ref objects, one per ttm_ref_type,
+ * for fast lookup of ref objects given a base object.
+ */
+
+#include "ttm/ttm_object.h"
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <asm/atomic.h>
+
+struct ttm_object_file {
+	struct ttm_object_device *tdev;
+	rwlock_t lock;
+	struct list_head ref_list;
+	struct drm_open_hash ref_hash[TTM_REF_NUM];
+	struct kref refcount;
+};
+
+/**
+ * struct ttm_object_device
+ *
+ * @object_lock: lock that protects the object_hash hash table.
+ *
+ * @object_hash: hash table for fast lookup of object global names.
+ *
+ * @object_count: Per device object count.
+ *
+ * This is the per-device data structure needed for ttm object management.
+ */
+
+struct ttm_object_device {
+	rwlock_t object_lock;
+	struct drm_open_hash object_hash;
+	atomic_t object_count;
+	struct ttm_mem_global *mem_glob;
+};
+
+/**
+ * struct ttm_ref_object
+ *
+ * @hash: Hash entry for the per-file object reference hash.
+ *
+ * @head: List entry for the per-file list of ref-objects.
+ *
+ * @kref: Ref count.
+ *
+ * @obj: Base object this ref object is referencing.
+ *
+ * @ref_type: Type of ref object.
+ *
+ * This is similar to an idr object, but it also has a hash table entry
+ * that allows lookup with a pointer to the referenced object as a key. In
+ * that way, one can easily detect whether a base object is referenced by
+ * a particular ttm_object_file. It also carries a ref count to avoid creating
+ * multiple ref objects if a ttm_object_file references the same base object
+ * more than once.
+ */
+
+struct ttm_ref_object {
+	struct drm_hash_item hash;
+	struct list_head head;
+	struct kref kref;
+	struct ttm_base_object *obj;
+	enum ttm_ref_type ref_type;
+	struct ttm_object_file *tfile;
+};
+
+static inline struct ttm_object_file *
+ttm_object_file_ref(struct ttm_object_file *tfile)
+{
+	kref_get(&tfile->refcount);
+	return tfile;
+}
+
+static void ttm_object_file_destroy(struct kref *kref)
+{
+	struct ttm_object_file *tfile =
+		container_of(kref, struct ttm_object_file, refcount);
+
+	printk(KERN_INFO "Freeing 0x%08lx\n", (unsigned long) tfile);
+	kfree(tfile);
+}
+
+
+static inline void ttm_object_file_unref(struct ttm_object_file **p_tfile)
+{
+	struct ttm_object_file *tfile = *p_tfile;
+
+	*p_tfile = NULL;
+	kref_put(&tfile->refcount, ttm_object_file_destroy);
+}
+
+
+int ttm_base_object_init(struct ttm_object_file *tfile,
+			 struct ttm_base_object *base,
+			 bool shareable,
+			 enum ttm_object_type object_type,
+			 void (*refcount_release) (struct ttm_base_object **),
+			 void (*ref_obj_release) (struct ttm_base_object *,
+						  enum ttm_ref_type ref_type))
+{
+	struct ttm_object_device *tdev = tfile->tdev;
+	int ret;
+
+	base->shareable = shareable;
+	base->tfile = ttm_object_file_ref(tfile);
+	base->refcount_release = refcount_release;
+	base->ref_obj_release = ref_obj_release;
+	base->object_type = object_type;
+	write_lock(&tdev->object_lock);
+	kref_init(&base->refcount);
+	ret = drm_ht_just_insert_please(&tdev->object_hash,
+					&base->hash,
+					(unsigned long)base, 31, 0, 0);
+	write_unlock(&tdev->object_lock);
+	if (unlikely(ret != 0))
+		goto out_err0;
+
+	ret = ttm_ref_object_add(tfile, base, TTM_REF_USAGE, NULL);
+	if (unlikely(ret != 0))
+		goto out_err1;
+
+	ttm_base_object_unref(&base);
+
+	return 0;
+out_err1:
+	(void)drm_ht_remove_item(&tdev->object_hash, &base->hash);
+out_err0:
+	return ret;
+}
+
+static void ttm_release_base(struct kref *kref)
+{
+	struct ttm_base_object *base =
+	    container_of(kref, struct ttm_base_object, refcount);
+	struct ttm_object_device *tdev = base->tfile->tdev;
+
+	(void)drm_ht_remove_item(&tdev->object_hash, &base->hash);
+	write_unlock(&tdev->object_lock);
+	if (base->refcount_release) {
+		ttm_object_file_unref(&base->tfile);
+		base->refcount_release(&base);
+	}
+	write_lock(&tdev->object_lock);
+}
+
+void ttm_base_object_unref(struct ttm_base_object **p_base)
+{
+	struct ttm_base_object *base = *p_base;
+	struct ttm_object_device *tdev = base->tfile->tdev;
+
+	*p_base = NULL;
+
+	/*
+	 * Need to take the lock here to avoid racing with
+	 * users trying to look up the object.
+	 */
+
+	write_lock(&tdev->object_lock);
+	(void)kref_put(&base->refcount, &ttm_release_base);
+	write_unlock(&tdev->object_lock);
+}
+
+struct ttm_base_object *ttm_base_object_lookup(struct ttm_object_file *tfile,
+					       uint32_t key)
+{
+	struct ttm_object_device *tdev = tfile->tdev;
+	struct ttm_base_object *base;
+	struct drm_hash_item *hash;
+	int ret;
+
+	read_lock(&tdev->object_lock);
+	ret = drm_ht_find_item(&tdev->object_hash, key, &hash);
+
+	if (likely(ret == 0)) {
+		base = drm_hash_entry(hash, struct ttm_base_object, hash);
+		kref_get(&base->refcount);
+	}
+	read_unlock(&tdev->object_lock);
+
+	if (unlikely(ret != 0))
+		return NULL;
+
+	if (tfile != base->tfile && !base->shareable) {
+		printk(KERN_ERR "Attempted access of non-shareable object.\n");
+		ttm_base_object_unref(&base);
+		return NULL;
+	}
+
+	return base;
+}
+
+int ttm_ref_object_add(struct ttm_object_file *tfile,
+		       struct ttm_base_object *base,
+		       enum ttm_ref_type ref_type, bool *existed)
+{
+	struct drm_open_hash *ht = &tfile->ref_hash[ref_type];
+	struct ttm_ref_object *ref;
+	struct drm_hash_item *hash;
+	struct ttm_mem_global *mem_glob = tfile->tdev->mem_glob;
+	int ret = -EINVAL;
+
+	if (existed != NULL)
+		*existed = true;
+
+	while (ret == -EINVAL) {
+		read_lock(&tfile->lock);
+		ret = drm_ht_find_item(ht, base->hash.key, &hash);
+
+		if (ret == 0) {
+			ref = drm_hash_entry(hash, struct ttm_ref_object, hash);
+			kref_get(&ref->kref);
+			read_unlock(&tfile->lock);
+			break;
+		}
+
+		read_unlock(&tfile->lock);
+		ret = ttm_mem_global_alloc(mem_glob, sizeof(*ref), false,
+					   false, false);
+		if (unlikely(ret != 0))
+			return ret;
+		ref = kmalloc(sizeof(*ref), GFP_KERNEL);
+		if (unlikely(ref == NULL)) {
+			ttm_mem_global_free(mem_glob, sizeof(*ref), false);
+			return -ENOMEM;
+		}
+
+		ref->hash.key = base->hash.key;
+		ref->obj = base;
+		ref->tfile = tfile;
+		ref->ref_type = ref_type;
+		kref_init(&ref->kref);
+
+		write_lock(&tfile->lock);
+		ret = drm_ht_insert_item(ht, &ref->hash);
+
+		if (likely(ret == 0)) {
+			list_add_tail(&ref->head, &tfile->ref_list);
+			kref_get(&base->refcount);
+			write_unlock(&tfile->lock);
+			if (existed != NULL)
+				*existed = false;
+			break;
+		}
+
+		write_unlock(&tfile->lock);
+		BUG_ON(ret != -EINVAL);
+
+		ttm_mem_global_free(mem_glob, sizeof(*ref), false);
+		kfree(ref);
+	}
+
+	return ret;
+}
+
+static void ttm_ref_object_release(struct kref *kref)
+{
+	struct ttm_ref_object *ref =
+	    container_of(kref, struct ttm_ref_object, kref);
+	struct ttm_base_object *base = ref->obj;
+	struct ttm_object_file *tfile = ref->tfile;
+	struct drm_open_hash *ht;
+	struct ttm_mem_global *mem_glob = tfile->tdev->mem_glob;
+
+	ht = &tfile->ref_hash[ref->ref_type];
+	(void)drm_ht_remove_item(ht, &ref->hash);
+	list_del(&ref->head);
+	write_unlock(&tfile->lock);
+
+	if (ref->ref_type != TTM_REF_USAGE && base->ref_obj_release)
+		base->ref_obj_release(base, ref->ref_type);
+
+	ttm_base_object_unref(&ref->obj);
+	ttm_mem_global_free(mem_glob, sizeof(*ref), false);
+	kfree(ref);
+	write_lock(&tfile->lock);
+}
+
+int ttm_ref_object_base_unref(struct ttm_object_file *tfile,
+			      unsigned long key, enum ttm_ref_type ref_type)
+{
+	struct drm_open_hash *ht = &tfile->ref_hash[ref_type];
+	struct ttm_ref_object *ref;
+	struct drm_hash_item *hash;
+	int ret;
+
+	write_lock(&tfile->lock);
+	ret = drm_ht_find_item(ht, key, &hash);
+	if (unlikely(ret != 0)) {
+		write_unlock(&tfile->lock);
+		return -EINVAL;
+	}
+	ref = drm_hash_entry(hash, struct ttm_ref_object, hash);
+	kref_put(&ref->kref, ttm_ref_object_release);
+	write_unlock(&tfile->lock);
+	return 0;
+}
+
+void ttm_object_file_release(struct ttm_object_file **p_tfile)
+{
+	struct ttm_ref_object *ref;
+	struct list_head *list;
+	unsigned int i;
+	struct ttm_object_file *tfile = *p_tfile;
+
+	*p_tfile = NULL;
+	write_lock(&tfile->lock);
+
+	/*
+	 * Since we release the lock within the loop, we have to
+	 * restart it from the beginning each time.
+	 */
+
+	while (!list_empty(&tfile->ref_list)) {
+		list = tfile->ref_list.next;
+		ref = list_entry(list, struct ttm_ref_object, head);
+		ttm_ref_object_release(&ref->kref);
+	}
+
+	for (i = 0; i < TTM_REF_NUM; ++i)
+		drm_ht_remove(&tfile->ref_hash[i]);
+
+	write_unlock(&tfile->lock);
+	ttm_object_file_unref(&tfile);
+}
+
+struct ttm_object_file *ttm_object_file_init(struct ttm_object_device *tdev,
+					     unsigned int hash_order)
+{
+	struct ttm_object_file *tfile = kmalloc(sizeof(*tfile), GFP_KERNEL);
+	unsigned int i;
+	unsigned int j = 0;
+	int ret;
+
+	if (unlikely(tfile == NULL))
+		return NULL;
+
+	rwlock_init(&tfile->lock);
+	tfile->tdev = tdev;
+	kref_init(&tfile->refcount);
+	INIT_LIST_HEAD(&tfile->ref_list);
+
+	for (i = 0; i < TTM_REF_NUM; ++i) {
+		ret = drm_ht_create(&tfile->ref_hash[i], hash_order);
+		if (ret) {
+			j = i;
+			goto out_err;
+		}
+	}
+
+	return tfile;
+out_err:
+	for (i = 0; i < j; ++i)
+		drm_ht_remove(&tfile->ref_hash[i]);
+
+	kfree(tfile);
+
+	return NULL;
+}
+
+struct ttm_object_device *ttm_object_device_init(struct ttm_mem_global
+						 *mem_glob,
+						 unsigned int hash_order)
+{
+	struct ttm_object_device *tdev = kmalloc(sizeof(*tdev), GFP_KERNEL);
+	int ret;
+
+	if (unlikely(tdev == NULL))
+		return NULL;
+
+	tdev->mem_glob = mem_glob;
+	rwlock_init(&tdev->object_lock);
+	atomic_set(&tdev->object_count, 0);
+	ret = drm_ht_create(&tdev->object_hash, hash_order);
+
+	if (likely(ret == 0))
+		return tdev;
+
+	kfree(tdev);
+	return NULL;
+}
+
+void ttm_object_device_release(struct ttm_object_device **p_tdev)
+{
+	struct ttm_object_device *tdev = *p_tdev;
+
+	*p_tdev = NULL;
+
+	write_lock(&tdev->object_lock);
+	drm_ht_remove(&tdev->object_hash);
+	write_unlock(&tdev->object_lock);
+
+	kfree(tdev);
+}
diff --git a/drivers/gpu/drm/ttm/ttm_placement_user.c b/drivers/gpu/drm/ttm/ttm_placement_user.c
new file mode 100644
index 0000000..fddcc41
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_placement_user.c
@@ -0,0 +1,469 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#include "ttm/ttm_placement_user.h"
+#include "ttm/ttm_bo_driver.h"
+#include "ttm/ttm_object.h"
+#include "ttm/ttm_userobj_api.h"
+#include "ttm/ttm_lock.h"
+
+struct ttm_bo_user_object {
+	struct ttm_base_object base;
+	struct ttm_buffer_object bo;
+};
+
+static size_t pl_bo_size = 0xFFFFFFFF;
+
+static size_t ttm_pl_size(struct ttm_bo_device *bdev, unsigned long num_pages)
+{
+	size_t page_array_size =
+	    (num_pages * sizeof(void *) + PAGE_SIZE - 1) & PAGE_MASK;
+
+	if (unlikely(pl_bo_size == 0xFFFFFFFF)) {
+		pl_bo_size = bdev->ttm_bo_extra_size +
+		    ttm_round_pot(sizeof(struct ttm_bo_user_object));
+	}
+
+	return bdev->ttm_bo_size + 2 * page_array_size;
+}
+
+static struct ttm_bo_user_object *ttm_bo_user_lookup(struct ttm_object_file
+						     *tfile, uint32_t handle)
+{
+	struct ttm_base_object *base;
+
+	base = ttm_base_object_lookup(tfile, handle);
+	if (unlikely(base == NULL)) {
+		printk(KERN_ERR "Invalid buffer object handle 0x%08lx.\n",
+		       (unsigned long)handle);
+		return NULL;
+	}
+
+	if (unlikely(base->object_type != ttm_buffer_type)) {
+		ttm_base_object_unref(&base);
+		printk(KERN_ERR "Invalid buffer object handle 0x%08lx.\n",
+		       (unsigned long)handle);
+		return NULL;
+	}
+
+	return container_of(base, struct ttm_bo_user_object, base);
+}
+
+struct ttm_buffer_object *ttm_buffer_object_lookup(struct ttm_object_file
+						   *tfile, uint32_t handle)
+{
+	struct ttm_bo_user_object *user_bo;
+	struct ttm_base_object *base;
+
+	user_bo = ttm_bo_user_lookup(tfile, handle);
+	if (unlikely(user_bo == NULL))
+		return NULL;
+
+	(void)ttm_bo_reference(&user_bo->bo);
+	base = &user_bo->base;
+	ttm_base_object_unref(&base);
+	return &user_bo->bo;
+}
+
+static void ttm_bo_user_destroy(struct ttm_buffer_object *bo)
+{
+	struct ttm_bo_user_object *user_bo =
+	    container_of(bo, struct ttm_bo_user_object, bo);
+
+	ttm_mem_global_free(bo->bdev->mem_glob, bo->acc_size, false);
+	kfree(user_bo);
+}
+
+static void ttm_bo_user_release(struct ttm_base_object **p_base)
+{
+	struct ttm_bo_user_object *user_bo;
+	struct ttm_base_object *base = *p_base;
+	struct ttm_buffer_object *bo;
+
+	*p_base = NULL;
+
+	if (unlikely(base == NULL))
+		return;
+
+	user_bo = container_of(base, struct ttm_bo_user_object, base);
+	bo = &user_bo->bo;
+	ttm_bo_unref(&bo);
+}
+
+static void ttm_bo_user_ref_release(struct ttm_base_object *base,
+				    enum ttm_ref_type ref_type)
+{
+	struct ttm_bo_user_object *user_bo =
+	    container_of(base, struct ttm_bo_user_object, base);
+	struct ttm_buffer_object *bo = &user_bo->bo;
+
+	switch (ref_type) {
+	case TTM_REF_SYNCCPU_WRITE:
+		ttm_bo_synccpu_write_release(bo);
+		break;
+	default:
+		BUG();
+	}
+}
+
+static void ttm_pl_fill_rep(struct ttm_buffer_object *bo,
+			    struct ttm_pl_rep *rep)
+{
+	struct ttm_bo_user_object *user_bo =
+	    container_of(bo, struct ttm_bo_user_object, bo);
+
+	rep->gpu_offset = bo->offset;
+	rep->bo_size = bo->num_pages << PAGE_SHIFT;
+	rep->map_handle = bo->addr_space_offset;
+	rep->placement = bo->mem.flags;
+	rep->handle = user_bo->base.hash.key;
+	rep->sync_object_arg = (uint32_t) (unsigned long)bo->sync_obj_arg;
+}
+
+int ttm_pl_create_ioctl(struct ttm_object_file *tfile,
+			struct ttm_bo_device *bdev,
+			struct ttm_lock *lock, void *data)
+{
+	union ttm_pl_create_arg *arg = data;
+	struct ttm_pl_create_req *req = &arg->req;
+	struct ttm_pl_rep *rep = &arg->rep;
+	struct ttm_buffer_object *bo;
+	struct ttm_buffer_object *tmp;
+	struct ttm_bo_user_object *user_bo;
+	uint32_t flags;
+	int ret = 0;
+	struct ttm_mem_global *mem_glob = bdev->mem_glob;
+	size_t acc_size =
+	    ttm_pl_size(bdev, (req->size + PAGE_SIZE - 1) >> PAGE_SHIFT);
+	ret = ttm_mem_global_alloc(mem_glob, acc_size, false, false, false);
+	if (unlikely(ret != 0))
+		return ret;
+
+	flags = req->placement;
+	user_bo = kzalloc(sizeof(*user_bo), GFP_KERNEL);
+	if (unlikely(user_bo == NULL)) {
+		ttm_mem_global_free(mem_glob, acc_size, false);
+		return -ENOMEM;
+	}
+
+	bo = &user_bo->bo;
+	ret = ttm_read_lock(lock, true);
+	if (unlikely(ret != 0)) {
+		ttm_mem_global_free(mem_glob, acc_size, false);
+		kfree(user_bo);
+		return ret;
+	}
+
+	ret = ttm_buffer_object_init(bdev, bo, req->size,
+				     ttm_bo_type_device, flags,
+				     req->page_alignment, 0, true,
+				     NULL, acc_size, &ttm_bo_user_destroy);
+	ttm_read_unlock(lock);
+
+	/*
+	 * Note that the ttm_buffer_object_init function
+	 * would've called the destroy function on failure!!
+	 */
+
+	if (unlikely(ret != 0))
+		goto out;
+
+	tmp = ttm_bo_reference(bo);
+	ret = ttm_base_object_init(tfile, &user_bo->base,
+				   flags & TTM_PL_FLAG_SHARED,
+				   ttm_buffer_type,
+				   &ttm_bo_user_release,
+				   &ttm_bo_user_ref_release);
+	if (unlikely(ret != 0))
+		goto out_err;
+
+	mutex_lock(&bo->mutex);
+	ttm_pl_fill_rep(bo, rep);
+	mutex_unlock(&bo->mutex);
+	ttm_bo_unref(&bo);
+out:
+	return 0;
+out_err:
+	ttm_bo_unref(&tmp);
+	ttm_bo_unref(&bo);
+	return ret;
+}
+
+int ttm_pl_ub_create_ioctl(struct ttm_object_file *tfile,
+			   struct ttm_bo_device *bdev,
+			   struct ttm_lock *lock, void *data)
+{
+	union ttm_pl_create_ub_arg *arg = data;
+	struct ttm_pl_create_ub_req *req = &arg->req;
+	struct ttm_pl_rep *rep = &arg->rep;
+	struct ttm_buffer_object *bo;
+	struct ttm_buffer_object *tmp;
+	struct ttm_bo_user_object *user_bo;
+	uint32_t flags;
+	int ret = 0;
+	struct ttm_mem_global *mem_glob = bdev->mem_glob;
+	size_t acc_size =
+	    ttm_pl_size(bdev, (req->size + PAGE_SIZE - 1) >> PAGE_SHIFT);
+	ret = ttm_mem_global_alloc(mem_glob, acc_size, false, false, false);
+	if (unlikely(ret != 0))
+		return ret;
+
+	flags = req->placement;
+	user_bo = kzalloc(sizeof(*user_bo), GFP_KERNEL);
+	if (unlikely(user_bo == NULL)) {
+		ttm_mem_global_free(mem_glob, acc_size, false);
+		return -ENOMEM;
+	}
+	ret = ttm_read_lock(lock, true);
+	if (unlikely(ret != 0)) {
+		ttm_mem_global_free(mem_glob, acc_size, false);
+		kfree(user_bo);
+		return ret;
+	}
+	bo = &user_bo->bo;
+	ret = ttm_buffer_object_init(bdev, bo, req->size,
+				     ttm_bo_type_user, flags,
+				     req->page_alignment, req->user_address,
+				     true, NULL, acc_size,
+				     &ttm_bo_user_destroy);
+
+	/*
+	 * Note that the ttm_buffer_object_init function
+	 * would've called the destroy function on failure!!
+	 */
+	ttm_read_unlock(lock);
+	if (unlikely(ret != 0))
+		goto out;
+
+	tmp = ttm_bo_reference(bo);
+	ret = ttm_base_object_init(tfile, &user_bo->base,
+				   flags & TTM_PL_FLAG_SHARED,
+				   ttm_buffer_type,
+				   &ttm_bo_user_release,
+				   &ttm_bo_user_ref_release);
+	if (unlikely(ret != 0))
+		goto out_err;
+
+	mutex_lock(&bo->mutex);
+	ttm_pl_fill_rep(bo, rep);
+	mutex_unlock(&bo->mutex);
+	ttm_bo_unref(&bo);
+out:
+	return 0;
+out_err:
+	ttm_bo_unref(&tmp);
+	ttm_bo_unref(&bo);
+	return ret;
+}
+
+int ttm_pl_reference_ioctl(struct ttm_object_file *tfile, void *data)
+{
+	union ttm_pl_reference_arg *arg = data;
+	struct ttm_pl_rep *rep = &arg->rep;
+	struct ttm_bo_user_object *user_bo;
+	struct ttm_buffer_object *bo;
+	struct ttm_base_object *base;
+	int ret;
+
+	user_bo = ttm_bo_user_lookup(tfile, arg->req.handle);
+	if (unlikely(user_bo == NULL)) {
+		printk(KERN_ERR "Could not reference buffer object.\n");
+		return -EINVAL;
+	}
+
+	bo = &user_bo->bo;
+	ret = ttm_ref_object_add(tfile, &user_bo->base, TTM_REF_USAGE, NULL);
+	if (unlikely(ret != 0)) {
+		printk(KERN_ERR
+		       "Could not add a reference to buffer object.\n");
+		goto out;
+	}
+
+	mutex_lock(&bo->mutex);
+	ttm_pl_fill_rep(bo, rep);
+	mutex_unlock(&bo->mutex);
+
+out:
+	base = &user_bo->base;
+	ttm_base_object_unref(&base);
+	return ret;
+}
+
+int ttm_pl_unref_ioctl(struct ttm_object_file *tfile, void *data)
+{
+	struct ttm_pl_reference_req *arg = data;
+
+	return ttm_ref_object_base_unref(tfile, arg->handle, TTM_REF_USAGE);
+}
+
+int ttm_pl_synccpu_ioctl(struct ttm_object_file *tfile, void *data)
+{
+	struct ttm_pl_synccpu_arg *arg = data;
+	struct ttm_bo_user_object *user_bo;
+	struct ttm_buffer_object *bo;
+	struct ttm_base_object *base;
+	bool existed;
+	int ret;
+
+	switch (arg->op) {
+	case TTM_PL_SYNCCPU_OP_GRAB:
+		user_bo = ttm_bo_user_lookup(tfile, arg->handle);
+		if (unlikely(user_bo == NULL)) {
+			printk(KERN_ERR
+			       "Could not find buffer object for synccpu.\n");
+			return -EINVAL;
+		}
+		bo = &user_bo->bo;
+		base = &user_bo->base;
+		ret = ttm_bo_synccpu_write_grab(bo,
+						arg->access_mode &
+						TTM_PL_SYNCCPU_MODE_NO_BLOCK);
+		if (unlikely(ret != 0)) {
+			ttm_base_object_unref(&base);
+			goto out;
+		}
+		ret = ttm_ref_object_add(tfile, &user_bo->base,
+					 TTM_REF_SYNCCPU_WRITE, &existed);
+		if (existed || ret != 0)
+			ttm_bo_synccpu_write_release(bo);
+		ttm_base_object_unref(&base);
+		break;
+	case TTM_PL_SYNCCPU_OP_RELEASE:
+		ret = ttm_ref_object_base_unref(tfile, arg->handle,
+						TTM_REF_SYNCCPU_WRITE);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+out:
+	return ret;
+}
+
+int ttm_pl_setstatus_ioctl(struct ttm_object_file *tfile,
+			   struct ttm_lock *lock, void *data)
+{
+	union ttm_pl_setstatus_arg *arg = data;
+	struct ttm_pl_setstatus_req *req = &arg->req;
+	struct ttm_pl_rep *rep = &arg->rep;
+	struct ttm_buffer_object *bo;
+	struct ttm_bo_device *bdev;
+	int ret;
+
+	bo = ttm_buffer_object_lookup(tfile, req->handle);
+	if (unlikely(bo == NULL)) {
+		printk(KERN_ERR
+		       "Could not find buffer object for setstatus.\n");
+		return -EINVAL;
+	}
+
+	bdev = bo->bdev;
+
+	ret = ttm_read_lock(lock, true);
+	if (unlikely(ret != 0))
+		goto out_err0;
+
+	ret = ttm_bo_reserve(bo, true, false, false, 0);
+	if (unlikely(ret != 0))
+		goto out_err1;
+
+	ret = ttm_bo_wait_cpu(bo, false);
+	if (unlikely(ret != 0))
+		goto out_err2;
+
+	mutex_lock(&bo->mutex);
+	ret = ttm_bo_check_placement(bo, req->set_placement,
+				     req->clr_placement);
+	if (unlikely(ret != 0))
+		goto out_err2;
+
+	bo->proposed_flags = (bo->proposed_flags | req->set_placement)
+	    & ~req->clr_placement;
+	ret = ttm_buffer_object_validate(bo, true, false);
+	if (unlikely(ret != 0))
+		goto out_err2;
+
+	ttm_pl_fill_rep(bo, rep);
+out_err2:
+	mutex_unlock(&bo->mutex);
+	ttm_bo_unreserve(bo);
+out_err1:
+	ttm_read_unlock(lock);
+out_err0:
+	ttm_bo_unref(&bo);
+	return ret;
+}
+
+int ttm_pl_waitidle_ioctl(struct ttm_object_file *tfile, void *data)
+{
+	struct ttm_pl_waitidle_arg *arg = data;
+	struct ttm_buffer_object *bo;
+	int ret;
+
+	bo = ttm_buffer_object_lookup(tfile, arg->handle);
+	if (unlikely(bo == NULL)) {
+		printk(KERN_ERR "Could not find buffer object for waitidle.\n");
+		return -EINVAL;
+	}
+
+	ret =
+	    ttm_bo_block_reservation(bo, true,
+				     arg->mode & TTM_PL_WAITIDLE_MODE_NO_BLOCK);
+	if (unlikely(ret != 0))
+		goto out;
+	mutex_lock(&bo->mutex);
+	ret = ttm_bo_wait(bo,
+			  arg->mode & TTM_PL_WAITIDLE_MODE_LAZY,
+			  true, arg->mode & TTM_PL_WAITIDLE_MODE_NO_BLOCK);
+	mutex_unlock(&bo->mutex);
+	ttm_bo_unblock_reservation(bo);
+out:
+	ttm_bo_unref(&bo);
+	return ret;
+}
+
+int ttm_pl_verify_access(struct ttm_buffer_object *bo,
+			 struct ttm_object_file *tfile)
+{
+	struct ttm_bo_user_object *ubo;
+
+	/*
+	 * Check bo subclass.
+	 */
+
+	if (unlikely(bo->destroy != &ttm_bo_user_destroy))
+		return -EPERM;
+
+	ubo = container_of(bo, struct ttm_bo_user_object, bo);
+	if (likely(ubo->base.shareable || ubo->base.tfile == tfile))
+		return 0;
+
+	return -EPERM;
+}
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
new file mode 100644
index 0000000..3db0b34
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -0,0 +1,627 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#include <linux/vmalloc.h>
+#include <linux/sched.h>
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+#include <linux/file.h>
+#include <linux/swap.h>
+#include "ttm/ttm_bo_driver.h"
+#include "ttm/ttm_placement_common.h"
+
+static int ttm_tt_swapin(struct ttm_tt *ttm);
+
+#ifdef CONFIG_X86
+static void ttm_tt_clflush_page(struct page *page)
+{
+	uint8_t *page_virtual;
+	unsigned int i;
+
+	if (unlikely(page == NULL))
+		return;
+
+	page_virtual = kmap_atomic(page, KM_USER0);
+
+	for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
+		clflush(page_virtual + i);
+
+	kunmap_atomic(page_virtual, KM_USER0);
+}
+
+static void ttm_tt_cache_flush_clflush(struct page *pages[],
+				       unsigned long num_pages)
+{
+	unsigned long i;
+
+	mb();
+	for (i = 0; i < num_pages; ++i)
+		ttm_tt_clflush_page(*pages++);
+	mb();
+}
+#else
+static void ttm_tt_ipi_handler(void *null)
+{
+	;
+}
+#endif
+
+void ttm_tt_cache_flush(struct page *pages[], unsigned long num_pages)
+{
+
+#ifdef CONFIG_X86
+	if (cpu_has_clflush) {
+		ttm_tt_cache_flush_clflush(pages, num_pages);
+		return;
+	}
+#else
+	if (on_each_cpu(ttm_tt_ipi_handler, NULL, 1, 1) != 0)
+		printk(KERN_ERR "Timed out waiting for drm cache flush.\n");
+#endif
+}
+
+/**
+ * Allocates storage for pointers to the pages that back the ttm.
+ *
+ * Uses kmalloc if possible. Otherwise falls back to vmalloc.
+ */
+static void ttm_tt_alloc_page_directory(struct ttm_tt *ttm)
+{
+	unsigned long size = ttm->num_pages * sizeof(*ttm->pages);
+	ttm->pages = NULL;
+
+	if (size <= PAGE_SIZE)
+		ttm->pages = kzalloc(size, GFP_KERNEL);
+
+	if (!ttm->pages) {
+		ttm->pages = vmalloc_user(size);
+		if (ttm->pages)
+			ttm->page_flags |= TTM_PAGE_FLAG_VMALLOC;
+	}
+}
+
+static void ttm_tt_free_page_directory(struct ttm_tt *ttm)
+{
+	if (ttm->page_flags & TTM_PAGE_FLAG_VMALLOC) {
+		vfree(ttm->pages);
+		ttm->page_flags &= ~TTM_PAGE_FLAG_VMALLOC;
+	} else {
+		kfree(ttm->pages);
+	}
+	ttm->pages = NULL;
+}
+
+static struct page *ttm_tt_alloc_page(void)
+{
+	return alloc_page(GFP_HIGHUSER | __GFP_ZERO);
+}
+
+static void ttm_tt_free_user_pages(struct ttm_tt *ttm)
+{
+	int write;
+	int dirty;
+	struct page *page;
+	int i;
+	struct ttm_backend *be = ttm->be;
+
+	BUG_ON(!(ttm->page_flags & TTM_PAGE_FLAG_USER));
+	write = ((ttm->page_flags & TTM_PAGE_FLAG_WRITE) != 0);
+	dirty = ((ttm->page_flags & TTM_PAGE_FLAG_USER_DIRTY) != 0);
+
+	if (be)
+		be->func->clear(be);
+
+	for (i = 0; i < ttm->num_pages; ++i) {
+		page = ttm->pages[i];
+		if (page == NULL)
+			continue;
+
+		if (page == ttm->dummy_read_page) {
+			BUG_ON(write);
+			continue;
+		}
+
+		if (write && dirty && !PageReserved(page))
+			set_page_dirty_lock(page);
+
+		ttm->pages[i] = NULL;
+		ttm_mem_global_free(ttm->bdev->mem_glob, PAGE_SIZE, false);
+		put_page(page);
+	}
+	ttm->state = tt_unpopulated;
+	ttm->first_himem_page = ttm->num_pages;
+	ttm->last_lomem_page = -1;
+}
+
+static struct page *__ttm_tt_get_page(struct ttm_tt *ttm, int index)
+{
+	struct page *p;
+	struct ttm_bo_device *bdev = ttm->bdev;
+	struct ttm_mem_global *mem_glob = bdev->mem_glob;
+	int ret;
+
+	while (NULL == (p = ttm->pages[index])) {
+		p = ttm_tt_alloc_page();
+
+		if (!p)
+			return NULL;
+
+		if (PageHighMem(p)) {
+			ret = ttm_mem_global_alloc(mem_glob, PAGE_SIZE,
+						   false, false, true);
+			if (unlikely(ret != 0))
+				goto out_err;
+			ttm->pages[--ttm->first_himem_page] = p;
+		} else {
+			ret = ttm_mem_global_alloc(mem_glob, PAGE_SIZE,
+						   false, false, false);
+			if (unlikely(ret != 0))
+				goto out_err;
+			ttm->pages[++ttm->last_lomem_page] = p;
+		}
+	}
+	return p;
+ out_err:
+	put_page(p);
+	return NULL;
+}
+
+struct page *ttm_tt_get_page(struct ttm_tt *ttm, int index)
+{
+	int ret;
+
+	if (unlikely(ttm->page_flags & TTM_PAGE_FLAG_SWAPPED)) {
+		ret = ttm_tt_swapin(ttm);
+		if (unlikely(ret != 0))
+			return NULL;
+	}
+	return __ttm_tt_get_page(ttm, index);
+}
+
+int ttm_tt_populate(struct ttm_tt *ttm)
+{
+	struct page *page;
+	unsigned long i;
+	struct ttm_backend *be;
+	int ret;
+
+	if (ttm->state != tt_unpopulated)
+		return 0;
+
+	if (unlikely(ttm->page_flags & TTM_PAGE_FLAG_SWAPPED)) {
+		ret = ttm_tt_swapin(ttm);
+		if (unlikely(ret != 0))
+			return ret;
+	}
+
+	be = ttm->be;
+
+	for (i = 0; i < ttm->num_pages; ++i) {
+		page = __ttm_tt_get_page(ttm, i);
+		if (!page)
+			return -ENOMEM;
+	}
+
+	be->func->populate(be, ttm->num_pages, ttm->pages,
+			   ttm->dummy_read_page);
+	ttm->state = tt_unbound;
+	return 0;
+}
+
+#ifdef CONFIG_X86
+static inline int ttm_tt_set_page_caching(struct page *p,
+					  enum ttm_caching_state c_state)
+{
+	if (PageHighMem(p))
+		return 0;
+
+	switch (c_state) {
+	case tt_cached:
+		return set_pages_wb(p, 1);
+	case tt_wc:
+	    return set_memory_wc((unsigned long) page_address(p), 1);
+	default:
+		return set_pages_uc(p, 1);
+	}
+}
+#else /* CONFIG_X86 */
+static inline int ttm_tt_set_page_caching(struct page *p,
+					  enum ttm_caching_state c_state)
+{
+	return 0;
+}
+#endif /* CONFIG_X86 */
+
+/*
+ * Change caching policy for the linear kernel map
+ * for range of pages in a ttm.
+ */
+
+static int ttm_tt_set_caching(struct ttm_tt *ttm,
+			      enum ttm_caching_state c_state)
+{
+	int i, j;
+	struct page *cur_page;
+	int ret;
+
+	if (ttm->caching_state == c_state)
+		return 0;
+
+	if (c_state != tt_cached) {
+		ret = ttm_tt_populate(ttm);
+		if (unlikely(ret != 0))
+			return ret;
+	}
+
+	if (ttm->caching_state == tt_cached)
+		ttm_tt_cache_flush(ttm->pages, ttm->num_pages);
+
+	for (i = 0; i < ttm->num_pages; ++i) {
+		cur_page = ttm->pages[i];
+		if (likely(cur_page != NULL)) {
+			ret = ttm_tt_set_page_caching(cur_page, c_state);
+			if (unlikely(ret != 0))
+				goto out_err;
+		}
+	}
+
+	ttm->caching_state = c_state;
+
+	return 0;
+
+ out_err:
+	for (j = 0; j < i; ++j) {
+		cur_page = ttm->pages[j];
+		if (likely(cur_page != NULL)) {
+			(void)ttm_tt_set_page_caching(cur_page,
+						      ttm->caching_state);
+		}
+	}
+
+	return ret;
+}
+
+int ttm_tt_set_placement_caching(struct ttm_tt *ttm, uint32_t placement)
+{
+	enum ttm_caching_state state;
+
+	if (placement & TTM_PL_FLAG_WC)
+		state = tt_wc;
+	else if (placement & TTM_PL_FLAG_UNCACHED)
+		state = tt_uncached;
+	else
+		state = tt_cached;
+
+	return ttm_tt_set_caching(ttm, state);
+}
+
+static void ttm_tt_free_alloced_pages(struct ttm_tt *ttm)
+{
+	int i;
+	struct page *cur_page;
+	struct ttm_backend *be = ttm->be;
+
+	if (be)
+		be->func->clear(be);
+	(void)ttm_tt_set_caching(ttm, tt_cached);
+	for (i = 0; i < ttm->num_pages; ++i) {
+		cur_page = ttm->pages[i];
+		ttm->pages[i] = NULL;
+		if (cur_page) {
+			if (unlikely(page_count(cur_page) != 1))
+				printk(KERN_ERR "Erroneous page count. "
+				       "Leaking pages.\n");
+			ttm_mem_global_free(ttm->bdev->mem_glob, PAGE_SIZE,
+					    PageHighMem(cur_page));
+			__free_page(cur_page);
+		}
+	}
+	ttm->state = tt_unpopulated;
+	ttm->first_himem_page = ttm->num_pages;
+	ttm->last_lomem_page = -1;
+}
+
+void ttm_tt_destroy(struct ttm_tt *ttm)
+{
+	struct ttm_backend *be;
+
+	if (unlikely(ttm == NULL))
+		return;
+
+	be = ttm->be;
+	if (likely(be != NULL)) {
+		be->func->destroy(be);
+		ttm->be = NULL;
+	}
+
+	if (likely(ttm->pages != NULL)) {
+		if (ttm->page_flags & TTM_PAGE_FLAG_USER)
+			ttm_tt_free_user_pages(ttm);
+		else
+			ttm_tt_free_alloced_pages(ttm);
+
+		ttm_tt_free_page_directory(ttm);
+	}
+
+	if (!(ttm->page_flags & TTM_PAGE_FLAG_PERSISTANT_SWAP) &&
+	    ttm->swap_storage)
+		fput(ttm->swap_storage);
+
+	kfree(ttm);
+}
+
+int ttm_tt_set_user(struct ttm_tt *ttm,
+		    struct task_struct *tsk,
+		    unsigned long start, unsigned long num_pages)
+{
+	struct mm_struct *mm = tsk->mm;
+	int ret;
+	int write = (ttm->page_flags & TTM_PAGE_FLAG_WRITE) != 0;
+	struct ttm_mem_global *mem_glob = ttm->bdev->mem_glob;
+
+	BUG_ON(num_pages != ttm->num_pages);
+	BUG_ON((ttm->page_flags & TTM_PAGE_FLAG_USER) == 0);
+
+	/**
+	 * Account user pages as lowmem pages for now.
+	 */
+
+	ret = ttm_mem_global_alloc(mem_glob, num_pages * PAGE_SIZE,
+				   false, false, false);
+	if (unlikely(ret != 0))
+		return ret;
+
+	down_read(&mm->mmap_sem);
+	ret = get_user_pages(tsk, mm, start, num_pages,
+			     write, 0, ttm->pages, NULL);
+	up_read(&mm->mmap_sem);
+
+	if (ret != num_pages && write) {
+		ttm_tt_free_user_pages(ttm);
+		ttm_mem_global_free(mem_glob, num_pages * PAGE_SIZE, false);
+		return -ENOMEM;
+	}
+
+	ttm->tsk = tsk;
+	ttm->start = start;
+	ttm->state = tt_unbound;
+
+	return 0;
+}
+
+struct ttm_tt *ttm_tt_create(struct ttm_bo_device *bdev, unsigned long size,
+			     uint32_t page_flags, struct page *dummy_read_page)
+{
+	struct ttm_bo_driver *bo_driver = bdev->driver;
+	struct ttm_tt *ttm;
+
+	if (!bo_driver)
+		return NULL;
+
+	ttm = kzalloc(sizeof(*ttm), GFP_KERNEL);
+	if (!ttm)
+		return NULL;
+
+	ttm->bdev = bdev;
+
+	ttm->num_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	ttm->first_himem_page = ttm->num_pages;
+	ttm->last_lomem_page = -1;
+	ttm->caching_state = tt_cached;
+	ttm->page_flags = page_flags;
+
+	ttm->dummy_read_page = dummy_read_page;
+
+	ttm_tt_alloc_page_directory(ttm);
+	if (!ttm->pages) {
+		ttm_tt_destroy(ttm);
+		printk(KERN_ERR "Failed allocating page table\n");
+		return NULL;
+	}
+	ttm->be = bo_driver->create_ttm_backend_entry(bdev);
+	if (!ttm->be) {
+		ttm_tt_destroy(ttm);
+		printk(KERN_ERR "Failed creating ttm backend entry\n");
+		return NULL;
+	}
+	ttm->state = tt_unpopulated;
+	return ttm;
+}
+
+void ttm_tt_unbind(struct ttm_tt *ttm)
+{
+	int ret;
+	struct ttm_backend *be = ttm->be;
+
+	if (ttm->state == tt_bound) {
+		ret = be->func->unbind(be);
+		BUG_ON(ret);
+	}
+	ttm->state = tt_unbound;
+}
+
+int ttm_tt_bind(struct ttm_tt *ttm, struct ttm_mem_reg *bo_mem)
+{
+	int ret = 0;
+	struct ttm_backend *be;
+
+	if (!ttm)
+		return -EINVAL;
+
+	if (ttm->state == tt_bound)
+		return 0;
+
+	be = ttm->be;
+
+	ret = ttm_tt_populate(ttm);
+	if (ret)
+		return ret;
+
+	ret = be->func->bind(be, bo_mem);
+	if (ret) {
+		printk(KERN_ERR "Couldn't bind backend.\n");
+		return ret;
+	}
+
+	ttm->state = tt_bound;
+
+	if (ttm->page_flags & TTM_PAGE_FLAG_USER)
+		ttm->page_flags |= TTM_PAGE_FLAG_USER_DIRTY;
+	return 0;
+}
+
+static int ttm_tt_swapin(struct ttm_tt *ttm)
+{
+	struct address_space *swap_space;
+	struct file *swap_storage;
+	struct page *from_page;
+	struct page *to_page;
+	void *from_virtual;
+	void *to_virtual;
+	int i;
+	int ret;
+
+	if (ttm->page_flags & TTM_PAGE_FLAG_USER) {
+		ret = ttm_tt_set_user(ttm, ttm->tsk, ttm->start,
+				      ttm->num_pages);
+		if (unlikely(ret != 0))
+			return ret;
+
+		ttm->page_flags &= ~TTM_PAGE_FLAG_SWAPPED;
+		return 0;
+	}
+
+	swap_storage = ttm->swap_storage;
+	BUG_ON(swap_storage == NULL);
+
+	swap_space = swap_storage->f_path.dentry->d_inode->i_mapping;
+
+	for (i = 0; i < ttm->num_pages; ++i) {
+		from_page = read_mapping_page(swap_space, i, NULL);
+		if (IS_ERR(from_page))
+			goto out_err;
+		to_page = __ttm_tt_get_page(ttm, i);
+		if (unlikely(to_page == NULL))
+			goto out_err;
+
+		preempt_disable();
+		from_virtual = kmap_atomic(from_page, KM_USER0);
+		to_virtual = kmap_atomic(to_page, KM_USER1);
+		memcpy(to_virtual, from_virtual, PAGE_SIZE);
+		kunmap_atomic(to_virtual, KM_USER1);
+		kunmap_atomic(from_virtual, KM_USER0);
+		preempt_enable();
+		page_cache_release(from_page);
+	}
+
+	if (!(ttm->page_flags & TTM_PAGE_FLAG_PERSISTANT_SWAP))
+		fput(swap_storage);
+	ttm->swap_storage = NULL;
+	ttm->page_flags &= ~TTM_PAGE_FLAG_SWAPPED;
+
+	return 0;
+out_err:
+	ttm_tt_free_alloced_pages(ttm);
+	return -ENOMEM;
+}
+
+int ttm_tt_swapout(struct ttm_tt *ttm, struct file *persistant_swap_storage)
+{
+	struct address_space *swap_space;
+	struct file *swap_storage;
+	struct page *from_page;
+	struct page *to_page;
+	void *from_virtual;
+	void *to_virtual;
+	int i;
+
+	BUG_ON(ttm->state != tt_unbound && ttm->state != tt_unpopulated);
+	BUG_ON(ttm->caching_state != tt_cached);
+
+	/*
+	 * For user buffers, just unpin the pages, as there should be
+	 * vma references.
+	 */
+
+	if (ttm->page_flags & TTM_PAGE_FLAG_USER) {
+		ttm_tt_free_user_pages(ttm);
+		ttm->page_flags |= TTM_PAGE_FLAG_SWAPPED;
+		ttm->swap_storage = NULL;
+		return 0;
+	}
+
+	if (!persistant_swap_storage) {
+		swap_storage = shmem_file_setup("ttm swap",
+						ttm->num_pages << PAGE_SHIFT,
+						0);
+		if (unlikely(IS_ERR(swap_storage))) {
+			printk(KERN_ERR "Failed allocating swap storage.\n");
+			return -ENOMEM;
+		}
+	} else
+		swap_storage = persistant_swap_storage;
+
+	swap_space = swap_storage->f_path.dentry->d_inode->i_mapping;
+
+	for (i = 0; i < ttm->num_pages; ++i) {
+		from_page = ttm->pages[i];
+		if (unlikely(from_page == NULL))
+			continue;
+		to_page = read_mapping_page(swap_space, i, NULL);
+		if (unlikely(to_page == NULL))
+			goto out_err;
+
+		preempt_disable();
+		from_virtual = kmap_atomic(from_page, KM_USER0);
+		to_virtual = kmap_atomic(to_page, KM_USER1);
+		memcpy(to_virtual, from_virtual, PAGE_SIZE);
+		kunmap_atomic(to_virtual, KM_USER1);
+		kunmap_atomic(from_virtual, KM_USER0);
+		preempt_enable();
+		set_page_dirty(to_page);
+		mark_page_accessed(to_page);
+		page_cache_release(to_page);
+	}
+
+	ttm_tt_free_alloced_pages(ttm);
+	ttm->swap_storage = swap_storage;
+	ttm->page_flags |= TTM_PAGE_FLAG_SWAPPED;
+	if (persistant_swap_storage)
+		ttm->page_flags |= TTM_PAGE_FLAG_PERSISTANT_SWAP;
+
+	return 0;
+out_err:
+	if (!persistant_swap_storage)
+		fput(swap_storage);
+
+	return -ENOMEM;
+}
diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
new file mode 100644
index 0000000..ccd3e05
--- /dev/null
+++ b/include/drm/ttm/ttm_bo_api.h
@@ -0,0 +1,581 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#ifndef _TTM_BO_API_H_
+#define _TTM_BO_API_H_
+
+#include "drm_hashtab.h"
+#include <linux/kref.h>
+#include <linux/list.h>
+#include <linux/wait.h>
+#include <linux/mutex.h>
+#include <linux/mm.h>
+#include <linux/rbtree.h>
+
+struct ttm_bo_device;
+
+struct drm_mm_node;
+
+/**
+ * struct ttm_mem_reg
+ *
+ * @mm_node: Memory manager node.
+ * @size: Requested size of memory region.
+ * @num_pages: Actual size of memory region in pages.
+ * @page_alignment: Page alignment.
+ * @flags: Placement flags.
+ * @proposed_flags: Proposed placement flags.
+ *
+ * Structure indicating the placement and space resources used by a
+ * buffer object.
+ */
+
+struct ttm_mem_reg {
+	struct drm_mm_node *mm_node;
+	unsigned long size;
+	unsigned long num_pages;
+	uint32_t page_alignment;
+	uint32_t mem_type;
+	uint32_t flags;
+	uint32_t proposed_flags;
+};
+
+/**
+ * enum ttm_bo_type
+ *
+ * @ttm_bo_type_device:	These are 'normal' buffers that can
+ * be mmapped by user space. Each of these bos occupy a slot in the
+ * device address space, that can be used for normal vm operations.
+ *
+ * @ttm_bo_type_user: These are user-space memory areas that are made
+ * available to the GPU by mapping the buffer pages into the GPU aperture
+ * space. These buffers cannot be mmaped from the device address space.
+ *
+ * @ttm_bo_type_kernel: These buffers are like ttm_bo_type_device buffers,
+ * but they cannot be accessed from user-space. For kernel-only use.
+ */
+
+enum ttm_bo_type {
+	ttm_bo_type_device,
+	ttm_bo_type_user,
+	ttm_bo_type_kernel
+};
+
+struct ttm_tt;
+
+/**
+ * struct ttm_buffer_object
+ *
+ * @bdev: Pointer to the buffer object device structure.
+ * @kref: Reference count of this buffer object. When this refcount reaches
+ * zero, the object is put on the delayed delete list.
+ * @list_kref: List reference count of this buffer object. This member is
+ * used to avoid destruction while the buffer object is still on a list.
+ * Lru lists may keep one refcount, the delayed delete list, and kref != 0
+ * keeps one refcount. When this refcount reaches zero,
+ * the object is destroyed.
+ * @proposed_flags: Proposed placement for the buffer. Changed only by the
+ * creator prior to validation as opposed to bo->mem.proposed_flags which is
+ * changed by the implementation prior to a buffer move if it wants to outsmart
+ * the buffer creator / user. This latter happens, for example, at eviction.
+ * @buffer_start: The virtual user-space start address of ttm_bo_type_user
+ * buffers.
+ * @type: The bo type.
+ * @offset: The current GPU offset, which can have different meanings
+ * depending on the memory type. For SYSTEM type memory, it should be 0.
+ * @mem: structure describing current placement.
+ * @val_seq: Sequence of the validation holding the @reserved lock.
+ * Used to avoid starvation when many processes compete to validate the
+ * buffer. This member is protected by the bo_device::lru_lock.
+ * @seq_valid: The value of @val_seq is valid. This value is protected by
+ * the bo_device::lru_lock.
+ * @lru: List head for the lru list.
+ * @ddestroy: List head for the delayed destroy list.
+ * @swap: List head for swap LRU list.
+ * @persistant_swap_storage: Usually the swap storage is deleted for buffers
+ * pinned in physical memory. If this behaviour is not desired, this member
+ * holds a pointer to a persistant shmem object.
+ * @destroy: Destruction function. If NULL, kfree is used.
+ * @sync_obj_arg: Opaque argument to synchronization object function.
+ * @sync_obj: Pointer to a synchronization object.
+ * @priv_flags: Flags describing buffer object internal state.
+ * @event_queue: Queue for processes waiting on buffer object status change.
+ * @mutex: Lock protecting all members with the exception of constant members
+ * and list heads. We should really use a spinlock here.
+ * @num_pages: Actual number of pages.
+ * @ttm: TTM structure holding system pages.
+ * @vm_hash: Hash item for fast address space lookup. Need to change to a
+ * rb-tree node.
+ * @vm_node: Address space manager node.
+ * @addr_space_offset: Address space offset.
+ * @cpu_writes: For synchronization. Number of cpu writers.
+ * @reserved: Deadlock-free lock used for synchronization state transitions.
+ * @acc_size: Accounted size for this object.
+ *
+ * Base class for TTM buffer object, that deals with data placement and CPU
+ * mappings. GPU mappings are really up to the driver, but for simpler GPUs
+ * the driver can usually use the placement offset @offset directly as the
+ * GPU virtual address. For drivers implementing multiple
+ * GPU memory manager contexts, the driver should manage the address space
+ * in these contexts separately and use these objects to get the correct
+ * placement and caching for these GPU maps. This makes it possible to use
+ * these objects for even quite elaborate memory management schemes.
+ * The destroy member, the API visibility of this object makes it possible
+ * to derive driver specific types.
+ */
+
+struct ttm_buffer_object {
+	struct ttm_bo_device *bdev;
+	struct kref kref;
+	struct kref list_kref;
+
+	/*
+	 * If there is a possibility that the usage variable is zero,
+	 * then dev->struct_mutex should be locked before incrementing it.
+	 */
+
+	uint32_t proposed_flags;
+	unsigned long buffer_start;
+	enum ttm_bo_type type;
+	unsigned long offset;
+	struct ttm_mem_reg mem;
+	uint32_t val_seq;
+	bool seq_valid;
+
+	struct list_head lru;
+	struct list_head ddestroy;
+	struct list_head swap;
+
+	struct file *persistant_swap_storage;
+
+	void (*destroy) (struct ttm_buffer_object *);
+
+	void *sync_obj_arg;
+	void *sync_obj;
+
+	uint32_t priv_flags;
+	wait_queue_head_t event_queue;
+	struct mutex mutex;
+	unsigned long num_pages;
+
+	struct ttm_tt *ttm;
+	struct rb_node vm_rb;
+	struct drm_mm_node *vm_node;
+	uint64_t addr_space_offset;
+
+	atomic_t cpu_writers;
+	atomic_t reserved;
+
+	size_t acc_size;
+};
+
+/**
+ * struct ttm_bo_kmap_obj
+ *
+ * @virtual: The current kernel virtual address.
+ * @page: The page when kmap'ing a single page.
+ * @bo_kmap_type: Type of bo_kmap.
+ *
+ * Object describing a kernel mapping. Since a TTM bo may be located
+ * in various memory types with various caching policies, the
+ * mapping can either be an ioremap, a vmap, a kmap or part of a
+ * premapped region.
+ */
+
+struct ttm_bo_kmap_obj {
+	void *virtual;
+	struct page *page;
+	enum {
+		ttm_bo_map_iomap,
+		ttm_bo_map_vmap,
+		ttm_bo_map_kmap,
+		ttm_bo_map_premapped,
+	} bo_kmap_type;
+};
+
+/**
+ * ttm_bo_reference - reference a struct ttm_buffer_object
+ *
+ * @bo: The buffer object.
+ *
+ * Returns a refcounted pointer to a buffer object.
+ */
+
+static inline struct ttm_buffer_object *
+ttm_bo_reference(struct ttm_buffer_object *bo)
+{
+	kref_get(&bo->kref);
+	return bo;
+}
+
+/**
+ * ttm_bo_wait - wait for buffer idle.
+ *
+ * @bo:  The buffer object.
+ * @interruptible:  Use interruptible wait.
+ * @no_wait:  Return immediately if buffer is busy.
+ *
+ * This function must be called with the bo::mutex held, and makes
+ * sure any previous rendering to the buffer is completed.
+ * Note: It might be necessary to block validations before the
+ * wait by reserving the buffer.
+ * Returns -EBUSY if no_wait is true and the buffer is busy.
+ * Returns -ERESTART if interrupted by a signal.
+ */
+extern int ttm_bo_wait(struct ttm_buffer_object *bo, bool lazy,
+		       bool interruptible, bool no_wait);
+/**
+ * ttm_buffer_object_validate
+ *
+ * @bo: The buffer object.
+ * @interruptible: Sleep interruptible if sleeping.
+ * @no_wait: Return immediately if the buffer is busy.
+ *
+ * Changes placement and caching policy of the buffer object
+ * according to bo::proposed_flags.
+ * Returns
+ * -EINVAL on invalid proposed_flags.
+ * -ENOMEM on out-of-memory condition.
+ * -EBUSY if no_wait is true and buffer busy.
+ * -ERESTART if interrupted by a signal.
+ */
+extern int ttm_buffer_object_validate(struct ttm_buffer_object *bo,
+				      bool interruptible, bool no_wait);
+/**
+ * ttm_bo_unref
+ *
+ * @bo: The buffer object.
+ *
+ * Unreference and clear a pointer to a buffer object.
+ */
+extern void ttm_bo_unref(struct ttm_buffer_object **bo);
+
+/**
+ * ttm_bo_synccpu_write_grab
+ *
+ * @bo: The buffer object:
+ * @no_wait: Return immediately if buffer is busy.
+ *
+ * Synchronizes a buffer object for CPU RW access. This means
+ * blocking command submission that affects the buffer and
+ * waiting for buffer idle. This lock is recursive.
+ * Returns
+ * -EBUSY if the buffer is busy and no_wait is true.
+ * -ERESTART if interrupted by a signal.
+ */
+
+extern int ttm_bo_synccpu_write_grab(struct ttm_buffer_object *bo,
+				     bool no_wait);
+/**
+ * ttm_bo_synccpu_write_release:
+ *
+ * @bo : The buffer object.
+ *
+ * Releases a synccpu lock.
+ */
+extern void ttm_bo_synccpu_write_release(struct ttm_buffer_object *bo);
+
+/**
+ * ttm_buffer_object_init
+ *
+ * @bdev: Pointer to a ttm_bo_device struct.
+ * @bo: Pointer to a ttm_buffer_object to be initialized.
+ * @size: Requested size of buffer object.
+ * @type: Requested type of buffer object.
+ * @flags: Initial placement flags.
+ * @page_alignment: Data alignment in pages.
+ * @buffer_start: Virtual address of user space data backing a
+ * user buffer object.
+ * @interruptible: If needing to sleep to wait for GPU resources,
+ * sleep interruptible.
+ * @persistant_swap_storage: Usually the swap storage is deleted for buffers
+ * pinned in physical memory. If this behaviour is not desired, this member
+ * holds a pointer to a persistant shmem object. Typically, this would
+ * point to the shmem object backing a GEM object if TTM is used to back a
+ * GEM user interface.
+ * @acc_size: Accounted size for this object.
+ * @destroy: Destroy function. Use NULL for kfree().
+ *
+ * This function initializes a pre-allocated struct ttm_buffer_object.
+ * As this object may be part of a larger structure, this function,
+ * together with the @destroy function,
+ * enables driver-specific objects derived from a ttm_buffer_object.
+ * On successful return, the object kref and list_kref are set to 1.
+ * Returns
+ * -ENOMEM: Out of memory.
+ * -EINVAL: Invalid placement flags.
+ * -ERESTART: Interrupted by signal while sleeping waiting for resources.
+ */
+
+extern int ttm_buffer_object_init(struct ttm_bo_device *bdev,
+				  struct ttm_buffer_object *bo,
+				  unsigned long size,
+				  enum ttm_bo_type type,
+				  uint32_t flags,
+				  uint32_t page_alignment,
+				  unsigned long buffer_start,
+				  bool interrubtible,
+				  struct file *persistant_swap_storage,
+				  size_t acc_size,
+				  void (*destroy) (struct ttm_buffer_object *));
+/**
+ * ttm_bo_synccpu_object_init
+ *
+ * @bdev: Pointer to a ttm_bo_device struct.
+ * @bo: Pointer to a ttm_buffer_object to be initialized.
+ * @size: Requested size of buffer object.
+ * @type: Requested type of buffer object.
+ * @flags: Initial placement flags.
+ * @page_alignment: Data alignment in pages.
+ * @buffer_start: Virtual address of user space data backing a
+ * user buffer object.
+ * @interruptible: If needing to sleep while waiting for GPU resources,
+ * sleep interruptible.
+ * @persistant_swap_storage: Usually the swap storage is deleted for buffers
+ * pinned in physical memory. If this behaviour is not desired, this member
+ * holds a pointer to a persistant shmem object. Typically, this would
+ * point to the shmem object backing a GEM object if TTM is used to back a
+ * GEM user interface.
+ * @p_bo: On successful completion *p_bo points to the created object.
+ *
+ * This function allocates a ttm_buffer_object, and then calls
+ * ttm_buffer_object_init on that object.
+ * The destroy function is set to kfree().
+ * Returns
+ * -ENOMEM: Out of memory.
+ * -EINVAL: Invalid placement flags.
+ * -ERESTART: Interrupted by signal while waiting for resources.
+ */
+
+extern int ttm_buffer_object_create(struct ttm_bo_device *bdev,
+				    unsigned long size,
+				    enum ttm_bo_type type,
+				    uint32_t flags,
+				    uint32_t page_alignment,
+				    unsigned long buffer_start,
+				    bool interruptible,
+				    struct file *persistant_swap_storage,
+				    struct ttm_buffer_object **p_bo);
+
+/**
+ * ttm_bo_check_placement
+ *
+ * @bo: the buffer object.
+ * @set_flags: placement flags to set.
+ * @clr_flags: placement flags to clear.
+ *
+ * Performs minimal validity checking on an intended change of
+ * placement flags.
+ * Returns
+ * -EINVAL: Intended change is invalid or not allowed.
+ */
+
+extern int ttm_bo_check_placement(struct ttm_buffer_object *bo,
+				  uint32_t set_flags, uint32_t clr_flags);
+
+/**
+ * ttm_bo_init_mm
+ *
+ * @bdev: Pointer to a ttm_bo_device struct.
+ * @mem_type: The memory type.
+ * @p_offset: offset for managed area in pages.
+ * @p_size: size managed area in pages.
+ *
+ * Initialize a manager for a given memory type.
+ * Note: if part of driver firstopen, it must be protected from a
+ * potentially racing lastclose.
+ * Returns:
+ * -EINVAL: invalid size or memory type.
+ * -ENOMEM: Not enough memory.
+ * May also return driver-specified errors.
+ */
+
+extern int ttm_bo_init_mm(struct ttm_bo_device *bdev, unsigned type,
+			  unsigned long p_offset, unsigned long p_size);
+/**
+ * ttm_bo_clean_mm
+ *
+ * @bdev: Pointer to a ttm_bo_device struct.
+ * @mem_type: The memory type.
+ *
+ * Take down a manager for a given memory type after first walking
+ * the LRU list to evict any buffers left alive.
+ *
+ * Normally, this function is part of lastclose() or unload(), and at that
+ * point there shouldn't be any buffers left created by user-space, since
+ * there should've been removed by the file descriptor release() method.
+ * However, before this function is run, make sure to signal all sync objects,
+ * and verify that the delayed delete queue is empty. The driver must also
+ * make sure that there are no NO_EVICT buffers present in this memory type
+ * when the call is made.
+ *
+ * If this function is part of a VT switch, the caller must make sure that
+ * there are no appications currently validating buffers before this
+ * function is called. The caller can do that by first taking the
+ * struct ttm_bo_device::ttm_lock in write mode.
+ *
+ * Returns:
+ * -EINVAL: invalid or uninitialized memory type.
+ * -EBUSY: There are still buffers left in this memory type.
+ */
+
+extern int ttm_bo_clean_mm(struct ttm_bo_device *bdev, unsigned mem_type);
+
+/**
+ * ttm_bo_evict_mm
+ *
+ * @bdev: Pointer to a ttm_bo_device struct.
+ * @mem_type: The memory type.
+ *
+ * Evicts all buffers on the lru list of the memory type.
+ * This is normally part of a VT switch or an
+ * out-of-memory-space-due-to-fragmentation handler.
+ * The caller must make sure that there are no other processes
+ * currently validating buffers, and can do that by taking the
+ * struct ttm_bo_device::ttm_lock in write mode.
+ *
+ * Returns:
+ * -EINVAL: Invalid or uninitialized memory type.
+ * -ERESTART: The call was interrupted by a signal while waiting to
+ * evict a buffer.
+ */
+
+extern int ttm_bo_evict_mm(struct ttm_bo_device *bdev, unsigned mem_type);
+
+/**
+ * ttm_kmap_obj_virtual
+ *
+ * @map: A struct ttm_bo_kmap_obj returned from ttm_bo_kmap.
+ * @is_iomem: Pointer to an integer that on return indicates 1 if the
+ * virtual map is io memory, 0 if normal memory.
+ *
+ * Returns the virtual address of a buffer object area mapped by ttm_bo_kmap.
+ * If *is_iomem is 1 on return, the virtual address points to an io memory area,
+ * that should strictly be accessed by the iowriteXX() and similar functions.
+ */
+
+static inline void *ttm_kmap_obj_virtual(struct ttm_bo_kmap_obj *map,
+					 bool *is_iomem)
+{
+	*is_iomem = (map->bo_kmap_type == ttm_bo_map_iomap ||
+		     map->bo_kmap_type == ttm_bo_map_premapped);
+	return map->virtual;
+}
+
+/**
+ * ttm_bo_kmap
+ *
+ * @bo: The buffer object.
+ * @start_page: The first page to map.
+ * @num_pages: Number of pages to map.
+ * @map: pointer to a struct ttm_bo_kmap_obj representing the map.
+ *
+ * Sets up a kernel virtual mapping, using ioremap, vmap or kmap to the
+ * data in the buffer object. The ttm_kmap_obj_virtual function can then be
+ * used to obtain a virtual address to the data.
+ *
+ * Returns
+ * -ENOMEM: Out of memory.
+ * -EINVAL: Invalid range.
+ */
+
+extern int ttm_bo_kmap(struct ttm_buffer_object *bo, unsigned long start_page,
+		       unsigned long num_pages, struct ttm_bo_kmap_obj *map);
+
+/**
+ * ttm_bo_kunmap
+ *
+ * @map: Object describing the map to unmap.
+ *
+ * Unmaps a kernel map set up by ttm_bo_kmap.
+ */
+
+extern void ttm_bo_kunmap(struct ttm_bo_kmap_obj *map);
+
+#if 0
+#endif
+
+/**
+ * ttm_fbdev_mmap - mmap fbdev memory backed by a ttm buffer object.
+ *
+ * @vma:       vma as input from the fbdev mmap method.
+ * @bo:        The bo backing the address space. The address space will
+ * have the same size as the bo, and start at offset 0.
+ *
+ * This function is intended to be called by the fbdev mmap method
+ * if the fbdev address space is to be backed by a bo.
+ */
+
+extern int ttm_fbdev_mmap(struct vm_area_struct *vma,
+			  struct ttm_buffer_object *bo);
+
+/**
+ * ttm_bo_mmap - mmap out of the ttm device address space.
+ *
+ * @filp:      filp as input from the mmap method.
+ * @vma:       vma as input from the mmap method.
+ * @bdev:      Pointer to the ttm_bo_device with the address space manager.
+ *
+ * This function is intended to be called by the device mmap method.
+ * if the device address space is to be backed by the bo manager.
+ */
+
+extern int ttm_bo_mmap(struct file *filp, struct vm_area_struct *vma,
+		       struct ttm_bo_device *bdev);
+
+/**
+ * ttm_bo_io
+ *
+ * @bdev:      Pointer to the struct ttm_bo_device.
+ * @filp:      Pointer to the struct file attempting to read / write.
+ * @wbuf:      User-space pointer to address of buffer to write. NULL on read.
+ * @rbuf:      User-space pointer to address of buffer to read into.
+ * Null on write.
+ * @count:     Number of bytes to read / write.
+ * @f_pos:     Pointer to current file position.
+ * @write:     1 for read, 0 for write.
+ *
+ * This function implements read / write into ttm buffer objects,
+ * and is intended to
+ * be called from the fops::read and fops::write method.
+ * Returns:
+ * See man (2) write, man(2) read. In particular, the function may
+ * return -EINTR if interrupted by a signal.
+ */
+
+extern ssize_t ttm_bo_io(struct ttm_bo_device *bdev, struct file *filp,
+			 const char __user *wbuf, char __user *rbuf,
+			 size_t count, loff_t *f_pos, bool write);
+
+extern void ttm_bo_swapout_all(struct ttm_bo_device *bdev);
+
+#endif
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
new file mode 100644
index 0000000..b8f62d9
--- /dev/null
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -0,0 +1,869 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 Vmware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+#ifndef _TTM_BO_DRIVER_H_
+#define _TTM_BO_DRIVER_H_
+
+#include "ttm/ttm_bo_api.h"
+#include "ttm/ttm_memory.h"
+#include "drm_mm.h"
+#include "linux/workqueue.h"
+#include "linux/fs.h"
+#include "linux/spinlock.h"
+
+struct ttm_backend;
+
+struct ttm_backend_func {
+	/**
+	 * struct ttm_backend_func member populate
+	 *
+	 * @backend: Pointer to a struct ttm_backend.
+	 * @num_pages: Number of pages to populate.
+	 * @pages: Array of pointers to ttm pages.
+	 * @dummy_read_page: Page to be used instead of NULL pages in the
+	 * array @pages.
+	 *
+	 * Populate the backend with ttm pages. Depending on the backend,
+	 * it may or may not copy the @pages array.
+	 */
+	int (*populate) (struct ttm_backend *backend,
+			 unsigned long num_pages, struct page **pages,
+			 struct page *dummy_read_page);
+	/**
+	 * struct ttm_backend_func member clear
+	 *
+	 * @backend: Pointer to a struct ttm_backend.
+	 *
+	 * This is an "unpopulate" function. Release all resources
+	 * allocated with populate.
+	 */
+	void (*clear) (struct ttm_backend *backend);
+
+	/**
+	 * struct ttm_backend_func member bind
+	 *
+	 * @backend: Pointer to a struct ttm_backend.
+	 * @bo_mem: Pointer to a struct ttm_mem_reg describing the
+	 * memory type and location for binding.
+	 *
+	 * Bind the backend pages into the aperture in the location
+	 * indicated by @bo_mem. This function should be able to handle
+	 * differences between aperture- and system page sizes.
+	 */
+	int (*bind) (struct ttm_backend *backend, struct ttm_mem_reg *bo_mem);
+
+	/**
+	 * struct ttm_backend_func member unbind
+	 *
+	 * @backend: Pointer to a struct ttm_backend.
+	 *
+	 * Unbind previously bound backend pages. This function should be
+	 * able to handle differences between aperture- and system page sizes.
+	 */
+	int (*unbind) (struct ttm_backend *backend);
+
+	/**
+	 * struct ttm_backend_func member destroy
+	 *
+	 * @backend: Pointer to a struct ttm_backend.
+	 *
+	 * Destroy the backend.
+	 */
+	void (*destroy) (struct ttm_backend *backend);
+};
+
+/**
+ * struct ttm_backend
+ *
+ * @bdev: Pointer to a struct ttm_bo_device.
+ * @flags: For driver use.
+ * @func: Pointer to a struct ttm_backend_func that describes
+ * the backend methods.
+ *
+ */
+
+struct ttm_backend {
+	struct ttm_bo_device *bdev;
+	uint32_t flags;
+	struct ttm_backend_func *func;
+};
+
+#define TTM_PAGE_FLAG_VMALLOC         (1 << 0)
+#define TTM_PAGE_FLAG_USER            (1 << 1)
+#define TTM_PAGE_FLAG_USER_DIRTY      (1 << 2)
+#define TTM_PAGE_FLAG_WRITE           (1 << 3)
+#define TTM_PAGE_FLAG_SWAPPED         (1 << 4)
+#define TTM_PAGE_FLAG_PERSISTANT_SWAP (1 << 5)
+
+enum ttm_caching_state {
+	tt_uncached,
+	tt_wc,
+	tt_cached
+};
+
+/**
+ * struct ttm_tt
+ *
+ * @dummy_read_page: Page to map where the ttm_tt page array contains a NULL
+ * pointer.
+ * @pages: Array of pages backing the data.
+ * @first_himem_page: Himem pages are put last in the page array, which
+ * enables us to run caching attribute changes on only the first part
+ * of the page array containing lomem pages. This is the index of the
+ * first himem page.
+ * @last_lomem_page: Index of the last lomem page in the page array.
+ * @num_pages: Number of pages in the page array.
+ * @bdev: Pointer to the current struct ttm_bo_device.
+ * @be: Pointer to the ttm backend.
+ * @tsk: The task for user ttm.
+ * @start: virtual address for user ttm.
+ * @swap_storage: Pointer to shmem struct file for swap storage.
+ * @caching_state: The current caching state of the pages.
+ * @state: The current binding state of the pages.
+ *
+ * This is a structure holding the pages, caching- and aperture binding
+ * status for a buffer object that isn't backed by fixed (VRAM / AGP)
+ * memory.
+ */
+
+struct ttm_tt {
+	struct page *dummy_read_page;
+	struct page **pages;
+	long first_himem_page;
+	long last_lomem_page;
+	uint32_t page_flags;
+	unsigned long num_pages;
+	struct ttm_bo_device *bdev;
+	struct ttm_backend *be;
+	struct task_struct *tsk;
+	unsigned long start;
+	struct file *swap_storage;
+	enum ttm_caching_state caching_state;
+	enum {
+		tt_bound,
+		tt_unbound,
+		tt_unpopulated,
+	} state;
+};
+
+#define TTM_MEMTYPE_FLAG_FIXED         (1 << 0)	/* Fixed (on-card) PCI memory */
+#define TTM_MEMTYPE_FLAG_MAPPABLE      (1 << 1)	/* Memory mappable */
+#define TTM_MEMTYPE_FLAG_NEEDS_IOREMAP (1 << 2)	/* Fixed memory needs ioremap
+						   before kernel access. */
+#define TTM_MEMTYPE_FLAG_CMA           (1 << 3)	/* Can't map aperture */
+
+/**
+ * struct ttm_mem_type_manager
+ *
+ * @has_type: The memory type has been initialized.
+ * @use_type: The memory type is enabled.
+ * @flags: TTM_MEMTYPE_XX flags identifying the traits of the memory
+ * managed by this memory type.
+ * @gpu_offset: If used, the GPU offset of the first managed page of
+ * fixed memory or the first managed location in an aperture.
+ * @io_offset: The io_offset of the first managed page of IO memory or
+ * the first managed location in an aperture. For TTM_MEMTYPE_FLAG_CMA
+ * memory, this should be set to NULL.
+ * @io_size: The size of a managed IO region (fixed memory or aperture).
+ * @io_addr: Virtual kernel address if the io region is pre-mapped. For
+ * TTM_MEMTYPE_FLAG_NEEDS_IOREMAP there is no pre-mapped io map and
+ * @io_addr should be set to NULL.
+ * @size: Size of the managed region.
+ * @available_caching: A mask of available caching types, TTM_PL_FLAG_XX,
+ * as defined in ttm_placement_common.h
+ * @default_caching: The default caching policy used for a buffer object
+ * placed in this memory type if the user doesn't provide one.
+ * @manager: The range manager used for this memory type. FIXME: If the aperture
+ * has a page size different from the underlying system, the granularity
+ * of this manager should take care of this. But the range allocating code
+ * in ttm_bo.c needs to be modified for this.
+ * @lru: The lru list for this memory type.
+ *
+ * This structure is used to identify and manage memory types for a device.
+ * It's set up by the ttm_bo_driver::init_mem_type method.
+ */
+
+struct ttm_mem_type_manager {
+
+	/*
+	 * No protection. Constant from start.
+	 */
+
+	bool has_type;
+	bool use_type;
+	uint32_t flags;
+	unsigned long gpu_offset;
+	unsigned long io_offset;
+	unsigned long io_size;
+	void *io_addr;
+	uint64_t size;
+	uint32_t available_caching;
+	uint32_t default_caching;
+
+	/*
+	 * Protected by the bdev->lru_lock.
+	 * TODO: Consider one lru_lock per ttm_mem_type_manager.
+	 * Plays ill with list removal, though.
+	 */
+
+	struct drm_mm manager;
+	struct list_head lru;
+};
+
+/**
+ * struct ttm_bo_driver
+ *
+ * @mem_type_prio: Priority array of memory types to place a buffer object in
+ * if it fits without evicting buffers from any of these memory types.
+ * @mem_busy_prio: Priority array of memory types to place a buffer object in
+ * if it needs to evict buffers to make room.
+ * @num_mem_type_prio: Number of elements in the @mem_type_prio array.
+ * @num_mem_busy_prio: Number of elements in the @num_mem_busy_prio array.
+ * @create_ttm_backend_entry: Callback to create a struct ttm_backend.
+ * @invalidate_caches: Callback to invalidate read caches when a buffer object
+ * has been evicted.
+ * @init_mem_type: Callback to initialize a struct ttm_mem_type_manager
+ * structure.
+ * @evict_flags: Callback to obtain placement flags when a buffer is evicted.
+ * @move: Callback for a driver to hook in accelerated functions to
+ * move a buffer.
+ * If set to NULL, a potentially slow memcpy() move is used.
+ * @sync_obj_signaled: See ttm_fence_api.h
+ * @sync_obj_wait: See ttm_fence_api.h
+ * @sync_obj_flush: See ttm_fence_api.h
+ * @sync_obj_unref: See ttm_fence_api.h
+ * @sync_obj_ref: See ttm_fence_api.h
+ */
+
+struct ttm_bo_driver {
+	const uint32_t *mem_type_prio;
+	const uint32_t *mem_busy_prio;
+	uint32_t num_mem_type_prio;
+	uint32_t num_mem_busy_prio;
+
+	/**
+	 * struct ttm_bo_driver member create_ttm_backend_entry
+	 *
+	 * @bdev: The buffer object device.
+	 *
+	 * Create a driver specific struct ttm_backend.
+	 */
+
+	struct ttm_backend *(*create_ttm_backend_entry)
+		(struct ttm_bo_device *bdev);
+
+	/**
+	 * struct ttm_bo_driver member invalidate_caches
+	 *
+	 * @bdev: the buffer object device.
+	 * @flags: new placement of the rebound buffer object.
+	 *
+	 * A previosly evicted buffer has been rebound in a
+	 * potentially new location. Tell the driver that it might
+	 * consider invalidating read (texture) caches on the next command
+	 * submission as a consequence.
+	 */
+
+	int (*invalidate_caches) (struct ttm_bo_device *bdev, uint32_t flags);
+	int (*init_mem_type) (struct ttm_bo_device *bdev, uint32_t type,
+			      struct ttm_mem_type_manager *man);
+	/**
+	 * struct ttm_bo_driver member evict_flags:
+	 *
+	 * @bo: the buffer object to be evicted
+	 *
+	 * Return the bo flags for a buffer which is not mapped to the hardware.
+	 * These will be placed in proposed_flags so that when the move is
+	 * finished, they'll end up in bo->mem.flags
+	 */
+
+	 uint32_t(*evict_flags) (struct ttm_buffer_object *bo);
+	/**
+	 * struct ttm_bo_driver member move:
+	 *
+	 * @bo: the buffer to move
+	 * @evict: whether this motion is evicting the buffer from
+	 * the graphics address space
+	 * @interruptible: Use interruptible sleeps if possible when sleeping.
+	 * @no_wait: whether this should give up and return -EBUSY
+	 * if this move would require sleeping
+	 * @new_mem: the new memory region receiving the buffer
+	 *
+	 * Move a buffer between two memory regions.
+	 */
+	int (*move) (struct ttm_buffer_object *bo,
+		     bool evict, bool interruptible,
+		     bool no_wait, struct ttm_mem_reg *new_mem);
+
+	/**
+	 * struct ttm_bo_driver_member verify_access
+	 *
+	 * @bo: Pointer to a buffer object.
+	 * @filp: Pointer to a struct file trying to access the object.
+	 *
+	 * Called from the map / write / read methods to verify that the
+	 * caller is permitted to access the buffer object.
+	 * This member may be set to NULL, which will refuse this kind of
+	 * access for all buffer objects.
+	 * This function should return 0 if access is granted, -EPERM otherwise.
+	 */
+	int (*verify_access) (struct ttm_buffer_object *bo,
+			      struct file *filp);
+
+	/**
+	 * In case a driver writer dislikes the TTM fence objects,
+	 * the driver writer can replace those with sync objects of
+	 * his / her own. If it turns out that no driver writer is
+	 * using these. I suggest we remove these hooks and plug in
+	 * fences directly. The bo driver needs the following functionality:
+	 * See the corresponding functions in the fence object API
+	 * documentation.
+	 */
+
+	bool (*sync_obj_signaled) (void *sync_obj, void *sync_arg);
+	int (*sync_obj_wait) (void *sync_obj, void *sync_arg,
+			      bool lazy, bool interruptible);
+	int (*sync_obj_flush) (void *sync_obj, void *sync_arg);
+	void (*sync_obj_unref) (void **sync_obj);
+	void *(*sync_obj_ref) (void *sync_obj);
+};
+
+#define TTM_NUM_MEM_TYPES 8
+/* Buffer object is evicted. */
+#define TTM_BO_PRIV_FLAG_EVICTED  (1 << 0)
+/* Buffer object is moving and needs idling before CPU mapping */
+#define TTM_BO_PRIV_FLAG_MOVING   (1 << 1)
+
+/**
+ * struct ttm_bo_device - Buffer object driver device-specific data.
+ *
+ * @mem_glob: Pointer to a struct ttm_mem_global object for accounting.
+ * @driver: Pointer to a struct ttm_bo_driver struct setup by the driver.
+ * @count: Current number of buffer object.
+ * @pages: Current number of pinned pages.
+ * @dummy_read_page: Pointer to a dummy page used for mapping requests
+ * of unpopulated pages.
+ * @shrink: A shrink callback object used for buffre object swap.
+ * @ttm_bo_extra_size: Extra size (sizeof(struct ttm_buffer_object) excluded)
+ * used by a buffer object. This is excluding page arrays and backing pages.
+ * @ttm_bo_size: This is @ttm_bo_extra_size + sizeof(struct ttm_buffer_object).
+ * @man: An array of mem_type_managers.
+ * @addr_space_mm: Range manager for the device address space.
+ * lru_lock: Spinlock that protects the buffer+device lru lists and
+ * ddestroy lists.
+ * @nice_mode: Try nicely to wait for buffer idle when cleaning a manager.
+ * If a GPU lockup has been detected, this is forced to 0.
+ * @dev_mapping: A pointer to the struct address_space representing the
+ * device address space.
+ * @wq: Work queue structure for the delayed delete workqueue.
+ *
+ */
+
+struct ttm_bo_device {
+
+	/*
+	 * Constant after bo device init / atomic.
+	 */
+
+	struct ttm_mem_global *mem_glob;
+	struct ttm_bo_driver *driver;
+	struct page *dummy_read_page;
+	struct ttm_mem_shrink shrink;
+
+	size_t ttm_bo_extra_size;
+	size_t ttm_bo_size;
+
+	rwlock_t vm_lock;
+	/*
+	 * Protected by the vm lock.
+	 */
+	struct ttm_mem_type_manager man[TTM_NUM_MEM_TYPES];
+	struct rb_root addr_space_rb;
+	struct drm_mm addr_space_mm;
+
+	/*
+	 * Might want to change this to one lock per manager.
+	 */
+	spinlock_t lru_lock;
+	/*
+	 * Protected by the lru lock.
+	 */
+	struct list_head ddestroy;
+	struct list_head swap_lru;
+
+	/*
+	 * Protected by load / firstopen / lastclose /unload sync.
+	 */
+
+	bool nice_mode;
+	struct address_space *dev_mapping;
+
+	/*
+	 * Internal protection.
+	 */
+
+	struct delayed_work wq;
+};
+
+/**
+ * ttm_flag_masked
+ *
+ * @old: Pointer to the result and original value.
+ * @new: New value of bits.
+ * @mask: Mask of bits to change.
+ *
+ * Convenience function to change a number of bits identified by a mask.
+ */
+
+static inline uint32_t
+ttm_flag_masked(uint32_t *old, uint32_t new, uint32_t mask)
+{
+	*old ^= (*old ^ new) & mask;
+	return *old;
+}
+
+/**
+ * ttm_tt_create
+ *
+ * @bdev: pointer to a struct ttm_bo_device:
+ * @size: Size of the data needed backing.
+ * @page_flags: Page flags as identified by TTM_PAGE_FLAG_XX flags.
+ * @dummy_read_page: See struct ttm_bo_device.
+ *
+ * Create a struct ttm_tt to back data with system memory pages.
+ * No pages are actually allocated.
+ * Returns:
+ * NULL: Out of memory.
+ */
+extern struct ttm_tt *ttm_tt_create(struct ttm_bo_device *bdev,
+				    unsigned long size,
+				    uint32_t page_flags,
+				    struct page *dummy_read_page);
+
+/**
+ * ttm_tt_set_user:
+ *
+ * @ttm: The struct ttm_tt to populate.
+ * @tsk: A struct task_struct for which @start is a valid user-space address.
+ * @start: A valid user-space address.
+ * @num_pages: Size in pages of the user memory area.
+ *
+ * Populate a struct ttm_tt with a user-space memory area after first pinning
+ * the pages backing it.
+ * Returns:
+ * !0: Error.
+ */
+
+extern int ttm_tt_set_user(struct ttm_tt *ttm,
+			   struct task_struct *tsk,
+			   unsigned long start, unsigned long num_pages);
+
+/**
+ * ttm_ttm_bind:
+ *
+ * @ttm: The struct ttm_tt containing backing pages.
+ * @bo_mem: The struct ttm_mem_reg identifying the binding location.
+ *
+ * Bind the pages of @ttm to an aperture location identified by @bo_mem
+ */
+extern int ttm_tt_bind(struct ttm_tt *ttm, struct ttm_mem_reg *bo_mem);
+
+/**
+ * ttm_ttm_destroy:
+ *
+ * @ttm: The struct ttm_tt.
+ *
+ * Unbind, unpopulate and destroy a struct ttm_tt.
+ */
+extern void ttm_tt_destroy(struct ttm_tt *ttm);
+
+/**
+ * ttm_ttm_unbind:
+ *
+ * @ttm: The struct ttm_tt.
+ *
+ * Unbind a struct ttm_tt.
+ */
+extern void ttm_tt_unbind(struct ttm_tt *ttm);
+
+/**
+ * ttm_ttm_destroy:
+ *
+ * @ttm: The struct ttm_tt.
+ * @index: Index of the desired page.
+ *
+ * Return a pointer to the struct page backing @ttm at page
+ * index @index. If the page is unpopulated, one will be allocated to
+ * populate that index.
+ *
+ * Returns:
+ * NULL on OOM.
+ */
+extern struct page *ttm_tt_get_page(struct ttm_tt *ttm, int index);
+
+/**
+ * ttm_tt_cache_flush:
+ *
+ * @pages: An array of pointers to struct page:s to flush.
+ * @num_pages: Number of pages to flush.
+ *
+ * Flush the data of the indicated pages from the cpu caches.
+ * This is used when changing caching attributes of the pages from
+ * cache-coherent.
+ */
+extern void ttm_tt_cache_flush(struct page *pages[], unsigned long num_pages);
+
+/**
+ * ttm_tt_set_placement_caching:
+ *
+ * @ttm A struct ttm_tt the backing pages of which will change caching policy.
+ * @placement: Flag indicating the desired caching policy.
+ *
+ * This function will change caching policy of any default kernel mappings of
+ * the pages backing @ttm. If changing from cached to uncached or
+ * write-combined,
+ * all CPU caches will first be flushed to make sure the data of the pages
+ * hit RAM. This function may be very costly as it involves global TLB
+ * and cache flushes and potential page splitting / combining.
+ */
+extern int ttm_tt_set_placement_caching(struct ttm_tt *ttm, uint32_t placement);
+extern int ttm_tt_swapout(struct ttm_tt *ttm,
+			  struct file *persistant_swap_storage);
+
+/*
+ * ttm_bo.c
+ */
+
+/**
+ * ttm_mem_reg_is_pci
+ *
+ * @bdev: Pointer to a struct ttm_bo_device.
+ * @mem: A valid struct ttm_mem_reg.
+ *
+ * Returns true if the memory described by @mem is PCI memory,
+ * false otherwise.
+ */
+extern bool ttm_mem_reg_is_pci(struct ttm_bo_device *bdev,
+				   struct ttm_mem_reg *mem);
+
+/**
+ * ttm_bo_mem_space
+ *
+ * @bo: Pointer to a struct ttm_buffer_object. the data of which
+ * we want to allocate space for.
+ * @mem: A struct ttm_mem_reg with the struct ttm_mem_reg::proposed_flags set
+ * up.
+ * @interruptible: Sleep interruptible when sliping.
+ * @no_wait: Don't sleep waiting for space to become available.
+ *
+ * Allocate memory space for the buffer object pointed to by @bo, using
+ * the placement flags in @mem, potentially evicting other idle buffer objects.
+ * This function may sleep while waiting for space to become available.
+ * Returns:
+ * -EBUSY: No space available (only if no_wait == 1).
+ * -ENOMEM: Could not allocate memory for the buffer object, either due to
+ * fragmentation or concurrent allocators.
+ * -ERESTART: An interruptible sleep was interrupted by a signal.
+ */
+extern int ttm_bo_mem_space(struct ttm_buffer_object *bo,
+			    struct ttm_mem_reg *mem,
+			    bool interruptible, bool no_wait);
+/**
+ * ttm_bo_wait_for_cpu
+ *
+ * @bo: Pointer to a struct ttm_buffer_object.
+ * @no_wait: Don't sleep while waiting.
+ *
+ * Wait until a buffer object is no longer sync'ed for CPU access.
+ * Returns:
+ * -EBUSY: Buffer object was sync'ed for CPU access. (only if no_wait == 1).
+ * -ERESTART: An interruptible sleep was interrupted by a signal.
+ */
+
+extern int ttm_bo_wait_cpu(struct ttm_buffer_object *bo, bool no_wait);
+
+/**
+ * ttm_bo_pci_offset - Get the PCI offset for the buffer object memory.
+ *
+ * @bo Pointer to a struct ttm_buffer_object.
+ * @bus_base On return the base of the PCI region
+ * @bus_offset On return the byte offset into the PCI region
+ * @bus_size On return the byte size of the buffer object or zero if
+ * the buffer object memory is not accessible through a PCI region.
+ *
+ * Returns:
+ * -EINVAL if the buffer object is currently not mappable.
+ * 0 otherwise.
+ */
+
+extern int ttm_bo_pci_offset(struct ttm_bo_device *bdev,
+			     struct ttm_mem_reg *mem,
+			     unsigned long *bus_base,
+			     unsigned long *bus_offset,
+			     unsigned long *bus_size);
+
+extern int ttm_bo_device_release(struct ttm_bo_device *bdev);
+
+/**
+ * ttm_bo_device_init
+ *
+ * @bdev: A pointer to a struct ttm_bo_device to initialize.
+ * @mem_global: A pointer to an initialized struct ttm_mem_global.
+ * @driver: A pointer to a struct ttm_bo_driver set up by the caller.
+ * @file_page_offset: Offset into the device address space that is available
+ * for buffer data. This ensures compatibility with other users of the
+ * address space.
+ *
+ * Initializes a struct ttm_bo_device:
+ * Returns:
+ * !0: Failure.
+ */
+extern int ttm_bo_device_init(struct ttm_bo_device *bdev,
+			      struct ttm_mem_global *mem_glob,
+			      struct ttm_bo_driver *driver,
+			      uint64_t file_page_offset);
+
+/**
+ * ttm_bo_reserve:
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ * @interruptible: Sleep interruptible if waiting.
+ * @no_wait: Don't sleep while trying to reserve, rather return -EBUSY.
+ * @use_sequence: If @bo is already reserved, Only sleep waiting for
+ * it to become unreserved if @sequence < (@bo)->sequence.
+ *
+ * Locks a buffer object for validation. (Or prevents other processes from
+ * locking it for validation) and removes it from lru lists, while taking
+ * a number of measures to prevent deadlocks.
+ *
+ * Deadlocks may occur when two processes try to reserve multiple buffers in
+ * different order, either by will or as a result of a buffer being evicted
+ * to make room for a buffer already reserved. (Buffers are reserved before
+ * they are evicted). The following algorithm prevents such deadlocks from
+ * occuring:
+ * 1) Buffers are reserved with the lru spinlock held. Upon successful
+ * reservation they are removed from the lru list. This stops a reserved buffer
+ * from being evicted. However the lru spinlock is released between the time
+ * a buffer is selected for eviction and the time it is reserved.
+ * Therefore a check is made when a buffer is reserved for eviction, that it
+ * is still the first buffer in the lru list, before it is removed from the
+ * list. @check_lru == 1 forces this check. If it fails, the function returns
+ * -EINVAL, and the caller should then choose a new buffer to evict and repeat
+ * the procedure.
+ * 2) Processes attempting to reserve multiple buffers other than for eviction,
+ * (typically execbuf), should first obtain a unique 32-bit
+ * validation sequence number,
+ * and call this function with @use_sequence == 1 and @sequence == the unique
+ * sequence number. If upon call of this function, the buffer object is already
+ * reserved, the validation sequence is checked against the validation
+ * sequence of the process currently reserving the buffer,
+ * and if the current validation sequence is greater than that of the process
+ * holding the reservation, the function returns -EAGAIN. Otherwise it sleeps
+ * waiting for the buffer to become unreserved, after which it retries
+ * reserving.
+ * The caller should, when receiving an -EAGAIN error
+ * release all its buffer reservations, wait for @bo to become unreserved, and
+ * then rerun the validation with the same validation sequence. This procedure
+ * will always guarantee that the process with the lowest validation sequence
+ * will eventually succeed, preventing both deadlocks and starvation.
+ *
+ * Returns:
+ * -EAGAIN: The reservation may cause a deadlock. Release all
+ * buffer reservations,
+ * wait for @bo to become unreserved and try again. (only if use_sequence == 1).
+ * -ERESTART: A wait for the buffer to become unreserved was interrupted by
+ * a signal. Release all buffer reservations and return to user-space.
+ */
+extern int ttm_bo_reserve(struct ttm_buffer_object *bo,
+			  bool interruptible,
+			  bool no_wait, bool use_sequence, uint32_t sequence);
+
+/**
+ * ttm_bo_unreserve
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ *
+ * Unreserve a previous reservation of @bo.
+ */
+extern void ttm_bo_unreserve(struct ttm_buffer_object *bo);
+
+/**
+ * ttm_bo_wait_unreserved
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ *
+ * Wait for a struct ttm_buffer_object to become unreserved.
+ * This is typically used in the execbuf code to relax cpu-usage when
+ * a potential deadlock condition backoff.
+ */
+extern int ttm_bo_wait_unreserved(struct ttm_buffer_object *bo,
+				  bool interruptible);
+
+/**
+ * ttm_bo_block_reservation
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ * @interruptible: Use interruptible sleep when waiting.
+ * @no_wait: Don't sleep, but rather return -EBUSY.
+ *
+ * Block reservation for validation by simply reserving the buffer.
+ * This is intended
+ * for single buffer use only without eviction,
+ * and thus needs no deadlock protection.
+ *
+ * Returns:
+ * -EBUSY: If no_wait == 1 and the buffer is already reserved.
+ * -ERESTART: If interruptible == 1 and the process received a
+ * signal while sleeping.
+ */
+extern int ttm_bo_block_reservation(struct ttm_buffer_object *bo,
+				    bool interruptible, bool no_wait);
+
+/**
+ * ttm_bo_unblock_reservation
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ *
+ * Unblocks reservation leaving lru lists untouched.
+ */
+extern void ttm_bo_unblock_reservation(struct ttm_buffer_object *bo);
+
+/*
+ * ttm_bo_util.c
+ */
+
+/**
+ * ttm_bo_move_ttm
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ * @evict: 1: This is an eviction. Don't try to pipeline.
+ * @no_wait: Never sleep, but rather return with -EBUSY.
+ * @new_mem: struct ttm_mem_reg indicating where to move.
+ *
+ * Optimized move function for a buffer object with both old and
+ * new placement backed by a TTM. The function will, if successful,
+ * free any old aperture space, and set (@new_mem)->mm_node to NULL,
+ * and update the (@bo)->mem placement flags. If unsuccessful, the old
+ * data remains untouched, and it's up to the caller to free the
+ * memory space indicated by @new_mem.
+ * Returns:
+ * !0: Failure.
+ */
+
+extern int ttm_bo_move_ttm(struct ttm_buffer_object *bo,
+			   bool evict, bool no_wait,
+			   struct ttm_mem_reg *new_mem);
+
+/**
+ * ttm_bo_move_memcpy
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ * @evict: 1: This is an eviction. Don't try to pipeline.
+ * @no_wait: Never sleep, but rather return with -EBUSY.
+ * @new_mem: struct ttm_mem_reg indicating where to move.
+ *
+ * Fallback move function for a mappable buffer object in mappable memory.
+ * The function will, if successful,
+ * free any old aperture space, and set (@new_mem)->mm_node to NULL,
+ * and update the (@bo)->mem placement flags. If unsuccessful, the old
+ * data remains untouched, and it's up to the caller to free the
+ * memory space indicated by @new_mem.
+ * Returns:
+ * !0: Failure.
+ */
+
+extern int ttm_bo_move_memcpy(struct ttm_buffer_object *bo,
+			      bool evict,
+			      bool no_wait, struct ttm_mem_reg *new_mem);
+
+/**
+ * ttm_bo_free_old_node
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ *
+ * Utility function to free an old placement after a successful move.
+ */
+extern void ttm_bo_free_old_node(struct ttm_buffer_object *bo);
+
+/**
+ * ttm_bo_move_accel_cleanup.
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ * @sync_obj: A sync object that signals when moving is complete.
+ * @sync_obj_arg: An argument to pass to the sync object idle / wait
+ * functions.
+ * @evict: This is an evict move. Don't return until the buffer is idle.
+ * @no_wait: Never sleep, but rather return with -EBUSY.
+ * @new_mem: struct ttm_mem_reg indicating where to move.
+ *
+ * Accelerated move function to be called when an accelerated move
+ * has been scheduled. The function will create a new temporary buffer object
+ * representing the old placement, and put the sync object on both buffer
+ * objects. After that the newly created buffer object is unref'd to be
+ * destroyed when the move is complete. This will help pipeline
+ * buffer moves.
+ */
+
+extern int ttm_bo_move_accel_cleanup(struct ttm_buffer_object *bo,
+				     void *sync_obj,
+				     void *sync_obj_arg,
+				     bool evict, bool no_wait,
+				     struct ttm_mem_reg *new_mem);
+/**
+ * ttm_io_prot
+ *
+ * @c_state: Caching state.
+ * @tmp: Page protection flag for a normal, cached mapping.
+ *
+ * Utility function that returns the pgprot_t that should be used for
+ * setting up a PTE with the caching model indicated by @c_state.
+ */
+extern pgprot_t ttm_io_prot(enum ttm_caching_state c_state, pgprot_t tmp);
+
+#if (defined(CONFIG_AGP) || (defined(CONFIG_AGP_MODULE) && defined(MODULE)))
+#define TTM_HAS_AGP
+#include <linux/agp_backend.h>
+
+/**
+ * ttm_agp_backend_init
+ *
+ * @bdev: Pointer to a struct ttm_bo_device.
+ * @bridge: The agp bridge this device is sitting on.
+ *
+ * Create a TTM backend that uses the indicated AGP bridge as an aperture
+ * for TT memory. This function uses the linux agpgart interface to
+ * bind and unbind memory backing a ttm_tt.
+ */
+extern struct ttm_backend *ttm_agp_backend_init(struct ttm_bo_device *bdev,
+						struct agp_bridge_data *bridge);
+#endif
+
+#endif
diff --git a/include/drm/ttm/ttm_execbuf_util.h b/include/drm/ttm/ttm_execbuf_util.h
new file mode 100644
index 0000000..6577f63
--- /dev/null
+++ b/include/drm/ttm/ttm_execbuf_util.h
@@ -0,0 +1,110 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#ifndef _TTM_EXECBUF_UTIL_H_
+#define _TTM_EXECBUF_UTIL_H_
+
+#include "ttm/ttm_bo_api.h"
+#include "ttm/ttm_fence_api.h"
+#include <linux/list.h>
+
+/**
+ * struct ttm_validate_buffer
+ *
+ * @head:           list head for thread-private list.
+ * @bo:             refcounted buffer object pointer.
+ * @new_sync_obj_arg: New sync_obj_arg for @bo, to be used once
+ * adding a new sync object.
+ * @reservied:      Indicates whether @bo has been reserved for validation.
+ */
+
+struct ttm_validate_buffer {
+	struct list_head head;
+	struct ttm_buffer_object *bo;
+	void *new_sync_obj_arg;
+	bool reserved;
+};
+
+/**
+ * function ttm_eu_backoff_reservation
+ *
+ * @list:     thread private list of ttm_validate_buffer structs.
+ *
+ * Undoes all buffer validation reservations for bos pointed to by
+ * the list entries.
+ */
+
+extern void ttm_eu_backoff_reservation(struct list_head *list);
+
+/**
+ * function ttm_eu_reserve_buffers
+ *
+ * @list:    thread private list of ttm_validate_buffer structs.
+ * @val_seq: A unique sequence number.
+ *
+ * Tries to reserve bos pointed to by the list entries for validation.
+ * If the function returns 0, all buffers are marked as "unfenced",
+ * taken off the lru lists and are not synced for write CPU usage.
+ *
+ * If the function detects a deadlock due to multiple threads trying to
+ * reserve the same buffers in reverse order, all threads except one will
+ * back off and retry. This function may sleep while waiting for
+ * CPU write reservations to be cleared, and for other threads to
+ * unreserve their buffers.
+ *
+ * This function may return -ERESTART or -EAGAIN if the calling process
+ * receives a signal while waiting. In that case, no buffers on the list
+ * will be reserved upon return.
+ *
+ * Buffers reserved by this function should be unreserved by
+ * a call to either ttm_eu_backoff_reservation() or
+ * ttm_eu_fence_buffer_objects() when command submission is complete or
+ * has failed.
+ */
+
+extern int ttm_eu_reserve_buffers(struct list_head *list, uint32_t val_seq);
+
+/**
+ * function ttm_eu_fence_buffer_objects.
+ *
+ * @list:        thread private list of ttm_validate_buffer structs.
+ * @sync_obj:    The new sync object for the buffers.
+ *
+ * This function should be called when command submission is complete, and
+ * it will add a new sync object to bos pointed to by entries on @list.
+ * It also unreserves all buffers, putting them on lru lists.
+ *
+ */
+
+extern void ttm_eu_fence_buffer_objects(struct list_head *list, void *sync_obj);
+
+#endif
diff --git a/include/drm/ttm/ttm_fence_api.h b/include/drm/ttm/ttm_fence_api.h
new file mode 100644
index 0000000..c06019b
--- /dev/null
+++ b/include/drm/ttm/ttm_fence_api.h
@@ -0,0 +1,279 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+#ifndef _TTM_FENCE_API_H_
+#define _TTM_FENCE_API_H_
+
+#include <linux/list.h>
+#include <linux/kref.h>
+
+#define TTM_FENCE_FLAG_EMIT (1 << 0)
+#define TTM_FENCE_TYPE_EXE  (1 << 0)
+
+struct ttm_fence_device;
+
+/**
+ * struct ttm_fence_info
+ *
+ * @fence_class:    The fence class.
+ * @fence_type:     Bitfield indicating types for this fence.
+ * @signaled_types: Bitfield indicating which types are signaled.
+ * @error:          Last error reported from the device.
+ *
+ * Used as output from the ttm_fence_get_info
+ */
+
+struct ttm_fence_info {
+	uint32_t signaled_types;
+	uint32_t error;
+};
+
+/**
+ * struct ttm_fence_object
+ *
+ * @fdev:            Pointer to the fence device struct.
+ * @kref:            Holds the reference count of this fence object.
+ * @ring:            List head used for the circular list of not-completely
+ *                   signaled fences.
+ * @info:            Data for fast retrieval using the ttm_fence_get_info()
+ * function.
+ * @timeout_jiffies: Absolute jiffies value indicating when this fence
+ *                   object times out and, if waited on, calls ttm_fence_lockup
+ *                   to check for and resolve a GPU lockup.
+ * @sequence:        Fence sequence number.
+ * @waiting_types:   Types currently waited on.
+ * @destroy:         Called to free the fence object, when its refcount has
+ *                   reached zero. If NULL, kfree is used.
+ *
+ * This struct is provided in the driver interface so that drivers can
+ * derive from it and create their own fence implementation. All members
+ * are private to the fence implementation and the fence driver callbacks.
+ * Otherwise a driver may access the derived object using container_of().
+ */
+
+struct ttm_fence_object {
+	struct ttm_fence_device *fdev;
+	struct kref kref;
+	uint32_t fence_class;
+	uint32_t fence_type;
+
+	/*
+	 * The below fields are protected by the fence class
+	 * manager spinlock.
+	 */
+
+	struct list_head ring;
+	struct ttm_fence_info info;
+	unsigned long timeout_jiffies;
+	uint32_t sequence;
+	uint32_t waiting_types;
+	void (*destroy) (struct ttm_fence_object *);
+};
+
+/**
+ * ttm_fence_object_init
+ *
+ * @fdev: Pointer to a struct ttm_fence_device.
+ * @fence_class: Fence class for this fence.
+ * @type: Fence type for this fence.
+ * @create_flags: Flags indicating varios actions at init time. At this point
+ * there's only TTM_FENCE_FLAG_EMIT, which triggers a sequence emission to
+ * the command stream.
+ * @destroy: Destroy function. If NULL, kfree() is used.
+ * @fence: The struct ttm_fence_object to initialize.
+ *
+ * Initialize a pre-allocated fence object. This function, together with the
+ * destroy function makes it possible to derive driver-specific fence objects.
+ */
+
+extern int
+ttm_fence_object_init(struct ttm_fence_device *fdev,
+		      uint32_t fence_class,
+		      uint32_t type,
+		      uint32_t create_flags,
+		      void (*destroy) (struct ttm_fence_object *fence),
+		      struct ttm_fence_object *fence);
+
+/**
+ * ttm_fence_object_create
+ *
+ * @fdev: Pointer to a struct ttm_fence_device.
+ * @fence_class: Fence class for this fence.
+ * @type: Fence type for this fence.
+ * @create_flags: Flags indicating varios actions at init time. At this point
+ * there's only TTM_FENCE_FLAG_EMIT, which triggers a sequence emission to
+ * the command stream.
+ * @c_fence: On successful termination, *(@c_fence) will point to the created
+ * fence object.
+ *
+ * Create and initialize a struct ttm_fence_object. The destroy function will
+ * be set to kfree().
+ */
+
+extern int
+ttm_fence_object_create(struct ttm_fence_device *fdev,
+			uint32_t fence_class,
+			uint32_t type,
+			uint32_t create_flags,
+			struct ttm_fence_object **c_fence);
+
+/**
+ * ttm_fence_object_wait
+ *
+ * @fence: The fence object to wait on.
+ * @lazy: Allow sleeps to reduce the cpu-usage if polling.
+ * @interruptible: Sleep interruptible when waiting.
+ * @type_mask: Wait for the given type_mask to signal.
+ *
+ * Wait for a fence to signal the given type_mask. The function will
+ * perform a fence_flush using type_mask. (See ttm_fence_object_flush).
+ *
+ * Returns
+ * -ERESTART if interrupted by a signal.
+ * May return driver-specific error codes if timed-out.
+ */
+
+extern int
+ttm_fence_object_wait(struct ttm_fence_object *fence,
+		      bool lazy, bool interruptible, uint32_t type_mask);
+
+/**
+ * ttm_fence_object_flush
+ *
+ * @fence: The fence object to flush.
+ * @flush_mask: Fence types to flush.
+ *
+ * Make sure that the given fence eventually signals the
+ * types indicated by @flush_mask. Note that this may or may not
+ * map to a CPU or GPU flush.
+ */
+
+extern int
+ttm_fence_object_flush(struct ttm_fence_object *fence, uint32_t flush_mask);
+
+/**
+ * ttm_fence_get_info
+ *
+ * @fence: The fence object.
+ *
+ * Copy the info block from the fence while holding relevant locks.
+ */
+
+struct ttm_fence_info ttm_fence_get_info(struct ttm_fence_object *fence);
+
+/**
+ * ttm_fence_object_ref
+ *
+ * @fence: The fence object.
+ *
+ * Return a ref-counted pointer to the fence object indicated by @fence.
+ */
+
+static inline struct ttm_fence_object *ttm_fence_object_ref(struct
+							    ttm_fence_object
+							    *fence)
+{
+	kref_get(&fence->kref);
+	return fence;
+}
+
+/**
+ * ttm_fence_object_unref
+ *
+ * @p_fence: Pointer to a ref-counted pinter to a struct ttm_fence_object.
+ *
+ * Unreference the fence object pointed to by *(@p_fence), clearing
+ * *(p_fence).
+ */
+
+extern void ttm_fence_object_unref(struct ttm_fence_object **p_fence);
+
+/**
+ * ttm_fence_object_signaled
+ *
+ * @fence: Pointer to the struct ttm_fence_object.
+ * @mask: Type mask to check whether signaled.
+ *
+ * This function checks (without waiting) whether the fence object
+ * pointed to by @fence has signaled the types indicated by @mask,
+ * and returns 1 if true, 0 if false. This function does NOT perform
+ * an implicit fence flush.
+ */
+
+extern bool
+ttm_fence_object_signaled(struct ttm_fence_object *fence, uint32_t mask);
+
+/**
+ * ttm_fence_class
+ *
+ * @fence: Pointer to the struct ttm_fence_object.
+ *
+ * Convenience function that returns the fence class of a
+ * struct ttm_fence_object.
+ */
+
+static inline uint32_t ttm_fence_class(const struct ttm_fence_object *fence)
+{
+	return fence->fence_class;
+}
+
+/**
+ * ttm_fence_types
+ *
+ * @fence: Pointer to the struct ttm_fence_object.
+ *
+ * Convenience function that returns the fence types of a
+ * struct ttm_fence_object.
+ */
+
+static inline uint32_t ttm_fence_types(const struct ttm_fence_object *fence)
+{
+	return fence->fence_type;
+}
+
+/*
+ * The functions below are wrappers to the above functions, with
+ * similar names but with sync_obj omitted. These wrappers are intended
+ * to be plugged directly into the buffer object driver's sync object
+ * API, if the driver chooses to use ttm_fence_objects as buffer object
+ * sync objects. In the prototypes below, a sync_obj is cast to a
+ * struct ttm_fence_object, whereas a sync_arg is cast to an uint32_t
+ * representing a fence_type argument.
+ */
+
+extern bool ttm_fence_sync_obj_signaled(void *sync_obj, void *sync_arg);
+extern int ttm_fence_sync_obj_wait(void *sync_obj, void *sync_arg,
+				   bool lazy, bool interruptible);
+extern int ttm_fence_sync_obj_flush(void *sync_obj, void *sync_arg);
+extern void ttm_fence_sync_obj_unref(void **sync_obj);
+extern void *ttm_fence_sync_obj_ref(void *sync_obj);
+
+#endif
diff --git a/include/drm/ttm/ttm_fence_driver.h b/include/drm/ttm/ttm_fence_driver.h
new file mode 100644
index 0000000..446d9b0
--- /dev/null
+++ b/include/drm/ttm/ttm_fence_driver.h
@@ -0,0 +1,308 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+#ifndef _TTM_FENCE_DRIVER_H_
+#define _TTM_FENCE_DRIVER_H_
+
+#include <linux/kref.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include "ttm_fence_api.h"
+#include "ttm_memory.h"
+
+/** @file ttm_fence_driver.h
+ *
+ * Definitions needed for a driver implementing the
+ * ttm_fence subsystem.
+ */
+
+/**
+ * struct ttm_fence_class_manager:
+ *
+ * @wrap_diff: Sequence difference to catch 32-bit wrapping.
+ * if (seqa - seqb) > @wrap_diff, then seqa < seqb.
+ * @flush_diff: Sequence difference to trigger fence flush.
+ * if (cur_seq - seqa) > @flush_diff, then consider fence object with
+ * seqa as old an needing a flush.
+ * @sequence_mask: Mask of valid bits in a fence sequence.
+ * @lock: Lock protecting this struct as well as fence objects
+ * associated with this struct.
+ * @ring: Circular sequence-ordered list of fence objects.
+ * @pending_flush: Fence types currently needing a flush.
+ * @waiting_types: Fence types that are currently waited for.
+ * @fence_queue: Queue of waiters on fences belonging to this fence class.
+ * @highest_waiting_sequence: Sequence number of the fence with highest sequence
+ * number and that is waited for.
+ * @latest_queued_sequence: Sequence number of the fence latest
+ * queued on the ring.
+ */
+
+struct ttm_fence_class_manager {
+
+	/*
+	 * Unprotected constant members.
+	 */
+
+	uint32_t wrap_diff;
+	uint32_t flush_diff;
+	uint32_t sequence_mask;
+
+	/*
+	 * The rwlock protects this structure as well as
+	 * the data in all fence objects belonging to this
+	 * class. This should be OK as most fence objects are
+	 * only read from once they're created.
+	 */
+
+	rwlock_t lock;
+	struct list_head ring;
+	uint32_t pending_flush;
+	uint32_t waiting_types;
+	wait_queue_head_t fence_queue;
+	uint32_t highest_waiting_sequence;
+	uint32_t latest_queued_sequence;
+};
+
+/**
+ * struct ttm_fence_device
+ *
+ * @fence_class:  Array of fence class managers.
+ * @num_classes:  Array dimension of @fence_class.
+ * @count:        Current number of fence objects for statistics.
+ * @driver:       Driver struct.
+ *
+ * Provided in the driver interface so that the driver can derive
+ * from this struct for its driver_private, and accordingly
+ * access the driver_private from the fence driver callbacks.
+ *
+ * All members except "count" are initialized at creation and
+ * never touched after that. No protection needed.
+ *
+ * This struct is private to the fence implementation and to the fence
+ * driver callbacks, and may otherwise be used by drivers only to
+ * obtain the derived device_private object using container_of().
+ */
+
+struct ttm_fence_device {
+	struct ttm_mem_global *mem_glob;
+	struct ttm_fence_class_manager *fence_class;
+	uint32_t num_classes;
+	atomic_t count;
+	const struct ttm_fence_driver *driver;
+};
+
+/**
+ * struct ttm_fence_class_init
+ *
+ * @wrap_diff:    Fence sequence number wrap indicator. If
+ * (sequence1 - sequence2) > @wrap_diff, then sequence1 is
+ * considered to be older than sequence2.
+ * @flush_diff:   Fence sequence number flush indicator.
+ * If a non-completely-signaled fence has a fence sequence number
+ * sequence1 and (sequence1 - current_emit_sequence) > @flush_diff,
+ * the fence is considered too old and it will be flushed upon the
+ * next call of ttm_fence_flush_old(), to make sure no fences with
+ * stale sequence numbers remains unsignaled. @flush_diff should
+ * be sufficiently less than @wrap_diff.
+ * @sequence_mask: Mask with valid bits of the fence sequence
+ * number set to 1.
+ *
+ * This struct is used as input to ttm_fence_device_init.
+ */
+
+struct ttm_fence_class_init {
+	uint32_t wrap_diff;
+	uint32_t flush_diff;
+	uint32_t sequence_mask;
+};
+
+/**
+ * struct ttm_fence_driver
+ *
+ * @has_irq: Called by a potential waiter. Should return 1 if a
+ * fence object with indicated parameters is expected to signal
+ * automatically, and 0 if the fence implementation needs to
+ * repeatedly call @poll to make it signal.
+ * @emit:    Make sure a fence with the given parameters is
+ * present in the indicated command stream. Return its sequence number
+ * in "breadcrumb".
+ * @poll:    Check and report sequences of the given "fence_class"
+ *           that have signaled "types"
+ * @flush:   Make sure that the types indicated by the bitfield
+ *           ttm_fence_class_manager::pending_flush will eventually
+ *           signal. These bits have been put together using the
+ *           result from the needed_flush function described below.
+ * @needed_flush: Given the fence_class and fence_types indicated by
+ *           "fence", and the last received fence sequence of this
+ *           fence class, indicate what types need a fence flush to
+ *           signal. Return as a bitfield.
+ * @wait:    Set to non-NULL if the driver wants to override the fence
+ *           wait implementation. Return 0 on success, -EBUSY on failure,
+ *           and -ERESTART if interruptible and a signal is pending.
+ * @signaled:  Driver callback that is called whenever a
+ *           ttm_fence_object::signaled_types has changed status.
+ *           This function is called from atomic context,
+ *           with the ttm_fence_class_manager::lock held in write mode.
+ * @lockup:  Driver callback that is called whenever a wait has exceeded
+ *           the lifetime of a fence object.
+ *           If there is a GPU lockup,
+ *           this function should, if possible, reset the GPU,
+ *           call the ttm_fence_handler with an error status, and
+ *           return. If no lockup was detected, simply extend the
+ *           fence timeout_jiffies and return. The driver might
+ *           want to protect the lockup check with a mutex and cache a
+ *           non-locked-up status for a while to avoid an excessive
+ *           amount of lockup checks from every waiting thread.
+ */
+
+struct ttm_fence_driver {
+	bool (*has_irq) (struct ttm_fence_device *fdev,
+			uint32_t fence_class, uint32_t flags);
+	int (*emit) (struct ttm_fence_device *fdev,
+		     uint32_t fence_class,
+		     uint32_t flags,
+		     uint32_t *breadcrumb, unsigned long *timeout_jiffies);
+	void (*flush) (struct ttm_fence_device *fdev, uint32_t fence_class);
+	void (*poll) (struct ttm_fence_device *fdev,
+		      uint32_t fence_class, uint32_t types);
+	 uint32_t(*needed_flush) (struct ttm_fence_object *fence);
+	int (*wait) (struct ttm_fence_object *fence, bool lazy,
+		     bool interruptible, uint32_t mask);
+	void (*signaled) (struct ttm_fence_object *fence);
+	void (*lockup) (struct ttm_fence_object *fence, uint32_t fence_types);
+};
+
+/**
+ * function ttm_fence_device_init
+ *
+ * @num_classes:      Number of fence classes for this fence implementation.
+ * @mem_global:       Pointer to the global memory accounting info.
+ * @fdev:             Pointer to an uninitialised struct ttm_fence_device.
+ * @init:             Array of initialization info for each fence class.
+ * @replicate_init:   Use the first @init initialization info for all classes.
+ * @driver:           Driver callbacks.
+ *
+ * Initialize a struct ttm_fence_driver structure. Returns -ENOMEM if
+ * out-of-memory. Otherwise returns 0.
+ */
+extern int
+ttm_fence_device_init(int num_classes,
+		      struct ttm_mem_global *mem_glob,
+		      struct ttm_fence_device *fdev,
+		      const struct ttm_fence_class_init *init,
+		      bool replicate_init,
+		      const struct ttm_fence_driver *driver);
+
+/**
+ * function ttm_fence_device_release
+ *
+ * @fdev:             Pointer to the fence device.
+ *
+ * Release all resources held by a fence device. Note that before
+ * this function is called, the caller must have made sure all fence
+ * objects belonging to this fence device are completely signaled.
+ */
+
+extern void ttm_fence_device_release(struct ttm_fence_device *fdev);
+
+/**
+ * ttm_fence_handler - the fence handler.
+ *
+ * @fdev:        Pointer to the fence device.
+ * @fence_class: Fence class that signals.
+ * @sequence:    Signaled sequence.
+ * @type:        Types that signal.
+ * @error:       Error from the engine.
+ *
+ * This function signals all fences with a sequence previous to the
+ * @sequence argument, and belonging to @fence_class. The signaled fence
+ * types are provided in @type. If error is non-zero, the error member
+ * of the fence with sequence = @sequence is set to @error. This value
+ * may be reported back to user-space, indicating, for example an illegal
+ * 3D command or illegal mpeg data.
+ *
+ * This function is typically called from the driver::poll method when the
+ * command sequence preceding the fence marker has executed. It should be
+ * called with the ttm_fence_class_manager::lock held in write mode and
+ * may be called from interrupt context.
+ */
+
+extern void
+ttm_fence_handler(struct ttm_fence_device *fdev,
+		  uint32_t fence_class,
+		  uint32_t sequence, uint32_t type, uint32_t error);
+
+/**
+ * ttm_fence_driver_from_dev
+ *
+ * @fdev:        The ttm fence device.
+ *
+ * Returns a pointer to the fence driver struct.
+ */
+
+static inline const struct ttm_fence_driver *
+ttm_fence_driver_from_dev(struct ttm_fence_device *fdev)
+{
+	return fdev->driver;
+}
+
+/**
+ * ttm_fence_driver
+ *
+ * @fence:        Pointer to a ttm fence object.
+ *
+ * Returns a pointer to the fence driver struct.
+ */
+
+static inline const struct ttm_fence_driver *ttm_fence_driver(struct
+							      ttm_fence_object
+							      *fence)
+{
+	return ttm_fence_driver_from_dev(fence->fdev);
+}
+
+/**
+ * ttm_fence_fc
+ *
+ * @fence:        Pointer to a ttm fence object.
+ *
+ * Returns a pointer to the struct ttm_fence_class_manager for the
+ * fence class of @fence.
+ */
+
+static inline struct ttm_fence_class_manager *ttm_fence_fc(struct
+							   ttm_fence_object
+							   *fence)
+{
+	return &fence->fdev->fence_class[fence->fence_class];
+}
+
+#endif
diff --git a/include/drm/ttm/ttm_fence_user.h b/include/drm/ttm/ttm_fence_user.h
new file mode 100644
index 0000000..120bc44
--- /dev/null
+++ b/include/drm/ttm/ttm_fence_user.h
@@ -0,0 +1,147 @@
+/**************************************************************************
+ *
+ * Copyright 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ **************************************************************************/
+/*
+ * Authors
+ * Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#ifndef TTM_FENCE_USER_H
+#define TTM_FENCE_USER_H
+
+#if !defined(__KERNEL__) && !defined(_KERNEL)
+#include <stdint.h>
+#endif
+
+#define TTM_FENCE_MAJOR 0
+#define TTM_FENCE_MINOR 1
+#define TTM_FENCE_PL    0
+#define TTM_FENCE_DATE  "080819"
+
+/**
+ * struct ttm_fence_signaled_req
+ *
+ * @handle: Handle to the fence object. Input.
+ *
+ * @fence_type: Fence types we want to flush. Input.
+ *
+ * @flush: Boolean. Flush the indicated fence_types. Input.
+ *
+ * Argument to the TTM_FENCE_SIGNALED ioctl.
+ */
+
+struct ttm_fence_signaled_req {
+	uint32_t handle;
+	uint32_t fence_type;
+	int32_t flush;
+	uint32_t pad64;
+};
+
+/**
+ * struct ttm_fence_rep
+ *
+ * @signaled_types: Fence type that has signaled.
+ *
+ * @fence_error: Command execution error.
+ * Hardware errors that are consequences of the execution
+ * of the command stream preceding the fence are reported
+ * here.
+ *
+ * Output argument to the TTM_FENCE_SIGNALED and
+ * TTM_FENCE_FINISH ioctls.
+ */
+
+struct ttm_fence_rep {
+	uint32_t signaled_types;
+	uint32_t fence_error;
+};
+
+union ttm_fence_signaled_arg {
+	struct ttm_fence_signaled_req req;
+	struct ttm_fence_rep rep;
+};
+
+/*
+ * Waiting mode flags for the TTM_FENCE_FINISH ioctl.
+ *
+ * TTM_FENCE_FINISH_MODE_LAZY: Allow for sleeps during polling
+ * wait.
+ *
+ * TTM_FENCE_FINISH_MODE_NO_BLOCK: Don't block waiting for GPU,
+ * but return -EBUSY if the buffer is busy.
+ */
+
+#define TTM_FENCE_FINISH_MODE_LAZY     (1 << 0)
+#define TTM_FENCE_FINISH_MODE_NO_BLOCK (1 << 1)
+
+/**
+ * struct ttm_fence_finish_req
+ *
+ * @handle: Handle to the fence object. Input.
+ *
+ * @fence_type: Fence types we want to finish.
+ *
+ * @mode: Wait mode.
+ *
+ * Input to the TTM_FENCE_FINISH ioctl.
+ */
+
+struct ttm_fence_finish_req {
+	uint32_t handle;
+	uint32_t fence_type;
+	uint32_t mode;
+	uint32_t pad64;
+};
+
+union ttm_fence_finish_arg {
+	struct ttm_fence_finish_req req;
+	struct ttm_fence_rep rep;
+};
+
+/**
+ * struct ttm_fence_unref_arg
+ *
+ * @handle: Handle to the fence object.
+ *
+ * Argument to the TTM_FENCE_UNREF ioctl.
+ */
+
+struct ttm_fence_unref_arg {
+	uint32_t handle;
+	uint32_t pad64;
+};
+
+/*
+ * Ioctl offsets frome extenstion start.
+ */
+
+#define TTM_FENCE_SIGNALED 0x01
+#define TTM_FENCE_FINISH   0x02
+#define TTM_FENCE_UNREF    0x03
+
+#endif
diff --git a/include/drm/ttm/ttm_lock.h b/include/drm/ttm/ttm_lock.h
new file mode 100644
index 0000000..eb2fc30
--- /dev/null
+++ b/include/drm/ttm/ttm_lock.h
@@ -0,0 +1,182 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2007-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+/** @file ttm_lock.h
+ * This file implements a simple replacement for the buffer manager use
+ * of the DRM heavyweight hardware lock.
+ * The lock is a read-write lock. Taking it in read mode is fast, and
+ * intended for in-kernel use only.
+ * Taking it in write mode is slow.
+ *
+ * The write mode is used only when there is a need to block all
+ * user-space processes from validating buffers.
+ * It's allowed to leave kernel space with the write lock held.
+ * If a user-space process dies while having the write-lock,
+ * it will be released during the file descriptor release.
+ *
+ * The read lock is typically placed at the start of an IOCTL- or
+ * user-space callable function that may end up allocating a memory area.
+ * This includes setstatus, super-ioctls and faults; the latter may move
+ * unmappable regions to mappable. It's a bug to leave kernel space with the
+ * read lock held.
+ *
+ * Both read- and write lock taking is interruptible for low signal-delivery
+ * latency. The locking functions will return -ERESTART if interrupted by a
+ * signal.
+ *
+ * Locking order: The lock should be taken BEFORE any TTM mutexes
+ * or spinlocks.
+ *
+ * Typical usages:
+ * a) VT-switching, when we want to clean VRAM and perhaps AGP. The lock
+ * stops it from being repopulated.
+ * b) out-of-VRAM or out-of-aperture space, in which case the process
+ * receiving the out-of-space notification may take the lock in write mode
+ * and evict all buffers prior to start validating its own buffers.
+ */
+
+#ifndef _TTM_LOCK_H_
+#define _TTM_LOCK_H_
+
+#include "ttm_object.h"
+#include <linux/wait.h>
+#include <asm/atomic.h>
+
+/**
+ * struct ttm_lock
+ *
+ * @base: ttm base object used solely to release the lock if the client
+ * holding the lock dies.
+ * @queue: Queue for processes waiting for lock change-of-status.
+ * @write_lock_pending: Flag indicating that a write-lock is pending. Avoids
+ * write lock starvation.
+ * @readers: The lock status: A negative number indicates that a write lock is
+ * held. Positive values indicate number of concurrent readers.
+ */
+
+struct ttm_lock {
+	struct ttm_base_object base;
+	wait_queue_head_t queue;
+	atomic_t write_lock_pending;
+	atomic_t readers;
+	bool kill_takers;
+	int signal;
+};
+
+/**
+ * ttm_lock_init
+ *
+ * @lock: Pointer to a struct ttm_lock
+ * Initializes the lock.
+ */
+extern void ttm_lock_init(struct ttm_lock *lock);
+
+/**
+ * ttm_read_unlock
+ *
+ * @lock: Pointer to a struct ttm_lock
+ *
+ * Releases a read lock.
+ */
+
+extern void ttm_read_unlock(struct ttm_lock *lock);
+
+/**
+ * ttm_read_unlock
+ *
+ * @lock: Pointer to a struct ttm_lock
+ * @interruptible: Interruptible sleeping while waiting for a lock.
+ *
+ * Takes the lock in read mode.
+ * Returns:
+ * -ERESTART If interrupted by a signal and interruptible is true.
+ */
+
+extern int ttm_read_lock(struct ttm_lock *lock, bool interruptible);
+
+/**
+ * ttm_write_lock
+ *
+ * @lock: Pointer to a struct ttm_lock
+ * @interruptible: Interruptible sleeping while waiting for a lock.
+ * @tfile: Pointer to a struct ttm_object_file used to identify the user-space
+ * application taking the lock.
+ *
+ * Takes the lock in write mode.
+ * Returns:
+ * -ERESTART If interrupted by a signal and interruptible is true.
+ * -ENOMEM: Out of memory when locking.
+ */
+extern int ttm_write_lock(struct ttm_lock *lock, bool interruptible,
+			  struct ttm_object_file *tfile);
+
+/**
+ * ttm_write_unlock
+ *
+ * @lock: Pointer to a struct ttm_lock
+ * @tfile: Pointer to a struct ttm_object_file used to identify the user-space
+ * application taking the lock.
+ *
+ * Releases a write lock.
+ * Returns:
+ * -EINVAL If the lock was not held.
+ */
+extern int ttm_write_unlock(struct ttm_lock *lock,
+			    struct ttm_object_file *tfile);
+
+/**
+ * ttm_lock_set_kill
+ *
+ * @lock: Pointer to a struct ttm_lock
+ * @val: Boolean whether to kill processes taking the lock.
+ * @signal: Signal to send to the process taking the lock.
+ *
+ * The kill-when-taking-lock functionality is used to kill processes that keep
+ * on using the TTM functionality when its resources has been taken down, for
+ * example when the X server exits. A typical sequence would look like this:
+ * - X server takes lock in write mode.
+ * - ttm_lock_set_kill() is called with @val set to true.
+ * - As part of X server exit, TTM resources are taken down.
+ * - X server releases the lock on file release.
+ * - Another dri client wants to render, takes the lock and is killed.
+ *
+ */
+
+static inline void ttm_lock_set_kill(struct ttm_lock *lock, bool val,
+				     int signal)
+{
+	lock->kill_takers = val;
+	if (val)
+		lock->signal = signal;
+}
+
+#endif
diff --git a/include/drm/ttm/ttm_memory.h b/include/drm/ttm/ttm_memory.h
new file mode 100644
index 0000000..9bff60f
--- /dev/null
+++ b/include/drm/ttm/ttm_memory.h
@@ -0,0 +1,154 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+
+#ifndef TTM_MEMORY_H
+#define TTM_MEMORY_H
+
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+
+/**
+ * struct ttm_mem_shrink - callback to shrink TTM memory usage.
+ *
+ * @do_shrink: The callback function.
+ *
+ * Arguments to the do_shrink functions are intended to be passed using
+ * inheritance. That is, the argument class derives from struct ttm_mem_srink,
+ * and can be accessed using container_of().
+ */
+
+struct ttm_mem_shrink {
+	int (*do_shrink) (struct ttm_mem_shrink *);
+};
+
+/**
+ * struct ttm_mem_global - Global memory accounting structure.
+ *
+ * @shrink: A single callback to shrink TTM memory usage. Extend this
+ * to a linked list to be able to handle multiple callbacks when needed.
+ * @swap_queue: A workqueue to handle shrinking in low memory situations. We
+ * need a separate workqueue since it will spend a lot of time waiting
+ * for the GPU, and this will otherwise block other workqueue tasks(?)
+ * At this point we use only a single-threaded workqueue.
+ * @work: The workqueue callback for the shrink queue.
+ * @queue: Wait queue for processes suspended waiting for memory.
+ * @lock: Lock to protect the @shrink - and the memory accounting members,
+ * that is, essentially the whole structure with some exceptions.
+ * @emer_memory: Lowmem memory limit available for root.
+ * @max_memory: Lowmem memory limit available for non-root.
+ * @swap_limit: Lowmem memory limit where the shrink workqueue kicks in.
+ * @used_memory: Currently used lowmem memory.
+ * @used_total_memory: Currently used total (lowmem + highmem) memory.
+ * @total_memory_swap_limit: Total memory limit where the shrink workqueue
+ * kicks in.
+ * @max_total_memory: Total memory available to non-root processes.
+ * @emer_total_memory: Total memory available to root processes.
+ *
+ * Note that this structure is not per device. It should be global for all
+ * graphics devices.
+ */
+
+struct ttm_mem_global {
+	struct ttm_mem_shrink *shrink;
+	struct workqueue_struct *swap_queue;
+	struct work_struct work;
+	wait_queue_head_t queue;
+	spinlock_t lock;
+	uint64_t emer_memory;
+	uint64_t max_memory;
+	uint64_t swap_limit;
+	uint64_t used_memory;
+	uint64_t used_total_memory;
+	uint64_t total_memory_swap_limit;
+	uint64_t max_total_memory;
+	uint64_t emer_total_memory;
+};
+
+/**
+ * ttm_mem_init_shrink - initialize a struct ttm_mem_shrink object
+ *
+ * @shrink: The object to initialize.
+ * @func: The callback function.
+ */
+
+static inline void ttm_mem_init_shrink(struct ttm_mem_shrink *shrink,
+				       int (*func) (struct ttm_mem_shrink *))
+{
+	shrink->do_shrink = func;
+}
+
+/**
+ * ttm_mem_register_shrink - register a struct ttm_mem_shrink object.
+ *
+ * @glob: The struct ttm_mem_global object to register with.
+ * @shrink: An initialized struct ttm_mem_shrink object to register.
+ *
+ * Returns:
+ * -EBUSY: There's already a callback registered. (May change).
+ */
+
+static inline int ttm_mem_register_shrink(struct ttm_mem_global *glob,
+					  struct ttm_mem_shrink *shrink)
+{
+	spin_lock(&glob->lock);
+	if (glob->shrink != NULL) {
+		spin_unlock(&glob->lock);
+		return -EBUSY;
+	}
+	glob->shrink = shrink;
+	spin_unlock(&glob->lock);
+	return 0;
+}
+
+/**
+ * ttm_mem_unregister_shrink - unregister a struct ttm_mem_shrink object.
+ *
+ * @glob: The struct ttm_mem_global object to unregister from.
+ * @shrink: A previously registert struct ttm_mem_shrink object.
+ *
+ */
+
+static inline void ttm_mem_unregister_shrink(struct ttm_mem_global *glob,
+					     struct ttm_mem_shrink *shrink)
+{
+	spin_lock(&glob->lock);
+	BUG_ON(glob->shrink != shrink);
+	glob->shrink = NULL;
+	spin_unlock(&glob->lock);
+}
+
+extern int ttm_mem_global_init(struct ttm_mem_global *glob);
+extern void ttm_mem_global_release(struct ttm_mem_global *glob);
+extern int ttm_mem_global_alloc(struct ttm_mem_global *glob, uint64_t memory,
+				bool no_wait, bool interruptible, bool himem);
+extern void ttm_mem_global_free(struct ttm_mem_global *glob,
+				uint64_t amount, bool himem);
+extern size_t ttm_round_pot(size_t size);
+#endif
diff --git a/include/drm/ttm/ttm_object.h b/include/drm/ttm/ttm_object.h
new file mode 100644
index 0000000..31b4cdc
--- /dev/null
+++ b/include/drm/ttm/ttm_object.h
@@ -0,0 +1,269 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+/** @file ttm_ref_object.h
+ *
+ * Base- and reference object implementation for the various
+ * ttm objects. Implements reference counting, minimal security checks
+ * and release on file close.
+ */
+
+#ifndef _TTM_OBJECT_H_
+#define _TTM_OBJECT_H_
+
+#include <linux/list.h>
+#include "drm_hashtab.h"
+#include <linux/kref.h>
+#include <ttm/ttm_memory.h>
+
+/**
+ * enum ttm_ref_type
+ *
+ * Describes what type of reference a ref object holds.
+ *
+ * TTM_REF_USAGE is a simple refcount on a base object.
+ *
+ * TTM_REF_SYNCCPU_READ is a SYNCCPU_READ reference on a
+ * buffer object.
+ *
+ * TTM_REF_SYNCCPU_WRITE is a SYNCCPU_WRITE reference on a
+ * buffer object.
+ *
+ */
+
+enum ttm_ref_type {
+	TTM_REF_USAGE,
+	TTM_REF_SYNCCPU_READ,
+	TTM_REF_SYNCCPU_WRITE,
+	TTM_REF_NUM
+};
+
+/**
+ * enum ttm_object_type
+ *
+ * One entry per ttm object type.
+ * Device-specific types should use the
+ * ttm_driver_typex types.
+ */
+
+enum ttm_object_type {
+	ttm_fence_type,
+	ttm_buffer_type,
+	ttm_lock_type,
+	ttm_driver_type0 = 256,
+	ttm_driver_type1
+};
+
+struct ttm_object_file;
+struct ttm_object_device;
+
+/**
+ * struct ttm_base_object
+ *
+ * @hash: hash entry for the per-device object hash.
+ * @type: derived type this object is base class for.
+ * @shareable: Other ttm_object_files can access this object.
+ *
+ * @tfile: Pointer to ttm_object_file of the creator.
+ * NULL if the object was not created by a user request.
+ * (kernel object).
+ *
+ * @refcount: Number of references to this object, not
+ * including the hash entry. A reference to a base object can
+ * only be held by a ref object.
+ *
+ * @refcount_release: A function to be called when there are
+ * no more references to this object. This function should
+ * destroy the object (or make sure destruction eventually happens),
+ * and when it is called, the object has
+ * already been taken out of the per-device hash. The parameter
+ * "base" should be set to NULL by the function.
+ *
+ * @ref_obj_release: A function to be called when a reference object
+ * with another ttm_ref_type than TTM_REF_USAGE is deleted.
+ * this function may, for example, release a lock held by a user-space
+ * process.
+ *
+ * This struct is intended to be used as a base struct for objects that
+ * are visible to user-space. It provides a global name, race-safe
+ * access and refcounting, minimal access contol and hooks for unref actions.
+ */
+
+struct ttm_base_object {
+	struct drm_hash_item hash;
+	enum ttm_object_type object_type;
+	bool shareable;
+	struct ttm_object_file *tfile;
+	struct kref refcount;
+	void (*refcount_release) (struct ttm_base_object **base);
+	void (*ref_obj_release) (struct ttm_base_object *base,
+				 enum ttm_ref_type ref_type);
+};
+
+/**
+ * ttm_base_object_init
+ *
+ * @tfile: Pointer to a struct ttm_object_file.
+ * @base: The struct ttm_base_object to initialize.
+ * @shareable: This object is shareable with other applcations.
+ * (different @tfile pointers.)
+ * @type: The object type.
+ * @refcount_release: See the struct ttm_base_object description.
+ * @ref_obj_release: See the struct ttm_base_object description.
+ *
+ * Initializes a struct ttm_base_object.
+ */
+
+extern int ttm_base_object_init(struct ttm_object_file *tfile,
+				struct ttm_base_object *base,
+				bool shareable,
+				enum ttm_object_type type,
+				void (*refcount_release) (struct ttm_base_object
+							  **),
+				void (*ref_obj_release) (struct ttm_base_object
+							 *,
+							 enum ttm_ref_type
+							 ref_type));
+
+/**
+ * ttm_base_object_lookup
+ *
+ * @tfile: Pointer to a struct ttm_object_file.
+ * @key: Hash key
+ *
+ * Looks up a struct ttm_base_object with the key @key.
+ * Also verifies that the object is visible to the application, by
+ * comparing the @tfile argument and checking the object shareable flag.
+ */
+
+extern struct ttm_base_object *ttm_base_object_lookup(struct ttm_object_file
+						      *tfile, uint32_t key);
+
+/**
+ * ttm_base_object_unref
+ *
+ * @p_base: Pointer to a pointer referncing a struct ttm_base_object.
+ *
+ * Decrements the base object refcount and clears the pointer pointed to by
+ * p_base.
+ */
+
+extern void ttm_base_object_unref(struct ttm_base_object **p_base);
+
+/**
+ * ttm_ref_object_add.
+ *
+ * @tfile: A struct ttm_object_file representing the application owning the
+ * ref_object.
+ * @base: The base object to reference.
+ * @ref_type: The type of reference.
+ * @existed: Upon completion, indicates that an identical reference object
+ * already existed, and the refcount was upped on that object instead.
+ *
+ * Adding a ref object to a base object is basically like referencing the
+ * base object, but a user-space application holds the reference. When the
+ * file corresponding to @tfile is closed, all its reference objects are
+ * deleted. A reference object can have different types depending on what
+ * it's intended for. It can be refcounting to prevent object destruction,
+ * When user-space takes a lock, it can add a ref object to that lock to
+ * make sure the lock is released if the application dies. A ref object
+ * will hold a single reference on a base object.
+ */
+extern int ttm_ref_object_add(struct ttm_object_file *tfile,
+			      struct ttm_base_object *base,
+			      enum ttm_ref_type ref_type, bool *existed);
+/**
+ * ttm_ref_object_base_unref
+ *
+ * @key: Key representing the base object.
+ * @ref_type: Ref type of the ref object to be dereferenced.
+ *
+ * Unreference a ref object with type @ref_type
+ * on the base object identified by @key. If there are no duplicate
+ * references, the ref object will be destroyed and the base object
+ * will be unreferenced.
+ */
+extern int ttm_ref_object_base_unref(struct ttm_object_file *tfile,
+				     unsigned long key,
+				     enum ttm_ref_type ref_type);
+
+/**
+ * ttm_object_file_init - initialize a struct ttm_object file
+ *
+ * @tdev: A struct ttm_object device this file is initialized on.
+ * @hash_order: Order of the hash table used to hold the reference objects.
+ *
+ * This is typically called by the file_ops::open function.
+ */
+
+extern struct ttm_object_file *ttm_object_file_init(struct ttm_object_device
+						    *tdev,
+						    unsigned int hash_order);
+
+/**
+ * ttm_object_file_release - release data held by a ttm_object_file
+ *
+ * @p_tfile: Pointer to pointer to the ttm_object_file object to release.
+ * *p_tfile will be set to NULL by this function.
+ *
+ * Releases all data associated by a ttm_object_file.
+ * Typically called from file_ops::release. The caller must
+ * ensure that there are no concurrent users of tfile.
+ */
+
+extern void ttm_object_file_release(struct ttm_object_file **p_tfile);
+
+/**
+ * ttm_object device init - initialize a struct ttm_object_device
+ *
+ * @hash_order: Order of hash table used to hash the base objects.
+ *
+ * This function is typically called on device initialization to prepare
+ * data structures needed for ttm base and ref objects.
+ */
+
+extern struct ttm_object_device *ttm_object_device_init
+    (struct ttm_mem_global *mem_glob, unsigned int hash_order);
+
+/**
+ * ttm_object_device_release - release data held by a ttm_object_device
+ *
+ * @p_tdev: Pointer to pointer to the ttm_object_device object to release.
+ * *p_tdev will be set to NULL by this function.
+ *
+ * Releases all data associated by a ttm_object_device.
+ * Typically called from driver::unload before the destruction of the
+ * device private data structure.
+ */
+
+extern void ttm_object_device_release(struct ttm_object_device **p_tdev);
+
+#endif
diff --git a/include/drm/ttm/ttm_placement_common.h b/include/drm/ttm/ttm_placement_common.h
new file mode 100644
index 0000000..694fc51
--- /dev/null
+++ b/include/drm/ttm/ttm_placement_common.h
@@ -0,0 +1,94 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#ifndef _TTM_PL_COMMON_H_
+#define _TTM_PL_COMMON_H_
+/*
+ * Memory regions for data placement.
+ */
+
+#define TTM_PL_SYSTEM           0
+#define TTM_PL_TT               1
+#define TTM_PL_VRAM             2
+#define TTM_PL_PRIV0            3
+#define TTM_PL_PRIV1            4
+#define TTM_PL_PRIV2            5
+#define TTM_PL_PRIV3            6
+#define TTM_PL_PRIV4            7
+#define TTM_PL_PRIV5            8
+#define TTM_PL_SWAPPED          15
+
+#define TTM_PL_FLAG_SYSTEM      (1 << TTM_PL_SYSTEM)
+#define TTM_PL_FLAG_TT          (1 << TTM_PL_TT)
+#define TTM_PL_FLAG_VRAM        (1 << TTM_PL_VRAM)
+#define TTM_PL_FLAG_PRIV0       (1 << TTM_PL_PRIV0)
+#define TTM_PL_FLAG_PRIV1       (1 << TTM_PL_PRIV1)
+#define TTM_PL_FLAG_PRIV2       (1 << TTM_PL_PRIV2)
+#define TTM_PL_FLAG_PRIV3       (1 << TTM_PL_PRIV3)
+#define TTM_PL_FLAG_PRIV4       (1 << TTM_PL_PRIV4)
+#define TTM_PL_FLAG_PRIV5       (1 << TTM_PL_PRIV5)
+#define TTM_PL_FLAG_SWAPPED     (1 << TTM_PL_SWAPPED)
+#define TTM_PL_MASK_MEM         0x0000FFFF
+
+/*
+ * Other flags that affects data placement.
+ * TTM_PL_FLAG_CACHED indicates cache-coherent mappings
+ * if available.
+ * TTM_PL_FLAG_SHARED means that another application may
+ * reference the buffer.
+ * TTM_PL_FLAG_NO_EVICT means that the buffer may never
+ * be evicted to make room for other buffers.
+ */
+
+#define TTM_PL_FLAG_CACHED      (1 << 16)
+#define TTM_PL_FLAG_UNCACHED    (1 << 17)
+#define TTM_PL_FLAG_WC          (1 << 18)
+#define TTM_PL_FLAG_SHARED      (1 << 20)
+#define TTM_PL_FLAG_NO_EVICT    (1 << 21)
+
+#define TTM_PL_MASK_CACHING     (TTM_PL_FLAG_CACHED | \
+				 TTM_PL_FLAG_UNCACHED | \
+				 TTM_PL_FLAG_WC)
+
+#define TTM_PL_MASK_MEMTYPE     (TTM_PL_MASK_MEM | TTM_PL_MASK_CACHING)
+
+/*
+ * Access flags to be used for CPU- and GPU- mappings.
+ * The idea is that the TTM synchronization mechanism will
+ * allow concurrent READ access and exclusive write access.
+ * Currently GPU- and CPU accesses are exclusive.
+ */
+
+#define TTM_ACCESS_READ         (1 << 0)
+#define TTM_ACCESS_WRITE        (1 << 1)
+
+#endif
diff --git a/include/drm/ttm/ttm_placement_user.h b/include/drm/ttm/ttm_placement_user.h
new file mode 100644
index 0000000..bdaf29f
--- /dev/null
+++ b/include/drm/ttm/ttm_placement_user.h
@@ -0,0 +1,259 @@
+/**************************************************************************
+ *
+ * Copyright 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ **************************************************************************/
+/*
+ * Authors
+ * Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#ifndef _TTM_PLACEMENT_USER_H_
+#define _TTM_PLACEMENT_USER_H_
+
+#if !defined(__KERNEL__) && !defined(_KERNEL)
+#include <stdint.h>
+#else
+#include <linux/kernel.h>
+#endif
+
+#include "ttm/ttm_placement_common.h"
+
+#define TTM_PLACEMENT_MAJOR 0
+#define TTM_PLACEMENT_MINOR 1
+#define TTM_PLACEMENT_PL    0
+#define TTM_PLACEMENT_DATE  "080819"
+
+/**
+ * struct ttm_pl_create_req
+ *
+ * @size: The buffer object size.
+ * @placement: Flags that indicate initial acceptable
+ *  placement.
+ * @page_alignment: Required alignment in pages.
+ *
+ * Input to the TTM_BO_CREATE ioctl.
+ */
+
+struct ttm_pl_create_req {
+	uint64_t size;
+	uint32_t placement;
+	uint32_t page_alignment;
+};
+
+/**
+ * struct ttm_pl_create_ub_req
+ *
+ * @size: The buffer object size.
+ * @user_address: User-space address of the memory area that
+ * should be used to back the buffer object cast to 64-bit.
+ * @placement: Flags that indicate initial acceptable
+ *  placement.
+ * @page_alignment: Required alignment in pages.
+ *
+ * Input to the TTM_BO_CREATE_UB ioctl.
+ */
+
+struct ttm_pl_create_ub_req {
+	uint64_t size;
+	uint64_t user_address;
+	uint32_t placement;
+	uint32_t page_alignment;
+};
+
+/**
+ * struct ttm_pl_rep
+ *
+ * @gpu_offset: The current offset into the memory region used.
+ * This can be used directly by the GPU if there are no
+ * additional GPU mapping procedures used by the driver.
+ *
+ * @bo_size: Actual buffer object size.
+ *
+ * @map_handle: Offset into the device address space.
+ * Used for map, seek, read, write. This will never change
+ * during the lifetime of an object.
+ *
+ * @placement: Flag indicating the placement status of
+ * the buffer object using the TTM_PL flags above.
+ *
+ * @sync_object_arg: Used for user-space synchronization and
+ * depends on the synchronization model used. If fences are
+ * used, this is the buffer_object::fence_type_mask
+ *
+ * Output from the TTM_PL_CREATE and TTM_PL_REFERENCE, and
+ * TTM_PL_SETSTATUS ioctls.
+ */
+
+struct ttm_pl_rep {
+	uint64_t gpu_offset;
+	uint64_t bo_size;
+	uint64_t map_handle;
+	uint32_t placement;
+	uint32_t handle;
+	uint32_t sync_object_arg;
+	uint32_t pad64;
+};
+
+/**
+ * struct ttm_pl_setstatus_req
+ *
+ * @set_placement: Placement flags to set.
+ *
+ * @clr_placement: Placement flags to clear.
+ *
+ * @handle: The object handle
+ *
+ * Input to the TTM_PL_SETSTATUS ioctl.
+ */
+
+struct ttm_pl_setstatus_req {
+	uint32_t set_placement;
+	uint32_t clr_placement;
+	uint32_t handle;
+	uint32_t pad64;
+};
+
+/**
+ * struct ttm_pl_reference_req
+ *
+ * @handle: The object to put a reference on.
+ *
+ * Input to the TTM_PL_REFERENCE and the TTM_PL_UNREFERENCE ioctls.
+ */
+
+struct ttm_pl_reference_req {
+	uint32_t handle;
+	uint32_t pad64;
+};
+
+/*
+ * ACCESS mode flags for SYNCCPU.
+ *
+ * TTM_SYNCCPU_MODE_READ will guarantee that the GPU is not
+ * writing to the buffer.
+ *
+ * TTM_SYNCCPU_MODE_WRITE will guarantee that the GPU is not
+ * accessing the buffer.
+ *
+ * TTM_SYNCCPU_MODE_NO_BLOCK makes sure the call does not wait
+ * for GPU accesses to finish but return -EBUSY.
+ *
+ * TTM_SYNCCPU_MODE_TRYCACHED Try to place the buffer in cacheable
+ * memory while synchronized for CPU.
+ */
+
+#define TTM_PL_SYNCCPU_MODE_READ      TTM_ACCESS_READ
+#define TTM_PL_SYNCCPU_MODE_WRITE     TTM_ACCESS_WRITE
+#define TTM_PL_SYNCCPU_MODE_NO_BLOCK  (1 << 2)
+#define TTM_PL_SYNCCPU_MODE_TRYCACHED (1 << 3)
+
+/**
+ * struct ttm_pl_synccpu_arg
+ *
+ * @handle: The object to synchronize.
+ *
+ * @access_mode: access mode indicated by the
+ * TTM_SYNCCPU_MODE flags.
+ *
+ * @op: indicates whether to grab or release the
+ * buffer for cpu usage.
+ *
+ * Input to the TTM_PL_SYNCCPU ioctl.
+ */
+
+struct ttm_pl_synccpu_arg {
+	uint32_t handle;
+	uint32_t access_mode;
+	enum {
+		TTM_PL_SYNCCPU_OP_GRAB,
+		TTM_PL_SYNCCPU_OP_RELEASE
+	} op;
+	uint32_t pad64;
+};
+
+/*
+ * Waiting mode flags for the TTM_BO_WAITIDLE ioctl.
+ *
+ * TTM_WAITIDLE_MODE_LAZY: Allow for sleeps during polling
+ * wait.
+ *
+ * TTM_WAITIDLE_MODE_NO_BLOCK: Don't block waiting for GPU,
+ * but return -EBUSY if the buffer is busy.
+ */
+
+#define TTM_PL_WAITIDLE_MODE_LAZY     (1 << 0)
+#define TTM_PL_WAITIDLE_MODE_NO_BLOCK (1 << 1)
+
+/**
+ * struct ttm_waitidle_arg
+ *
+ * @handle: The object to synchronize.
+ *
+ * @mode: wait mode indicated by the
+ * TTM_SYNCCPU_MODE flags.
+ *
+ * Argument to the TTM_BO_WAITIDLE ioctl.
+ */
+
+struct ttm_pl_waitidle_arg {
+	uint32_t handle;
+	uint32_t mode;
+};
+
+union ttm_pl_create_arg {
+	struct ttm_pl_create_req req;
+	struct ttm_pl_rep rep;
+};
+
+union ttm_pl_reference_arg {
+	struct ttm_pl_reference_req req;
+	struct ttm_pl_rep rep;
+};
+
+union ttm_pl_setstatus_arg {
+	struct ttm_pl_setstatus_req req;
+	struct ttm_pl_rep rep;
+};
+
+union ttm_pl_create_ub_arg {
+	struct ttm_pl_create_ub_req req;
+	struct ttm_pl_rep rep;
+};
+
+/*
+ * Ioctl offsets.
+ */
+
+#define TTM_PL_CREATE      0x00
+#define TTM_PL_REFERENCE   0x01
+#define TTM_PL_UNREF       0x02
+#define TTM_PL_SYNCCPU     0x03
+#define TTM_PL_WAITIDLE    0x04
+#define TTM_PL_SETSTATUS   0x05
+#define TTM_PL_CREATE_UB   0x06
+
+#endif
diff --git a/include/drm/ttm/ttm_userobj_api.h b/include/drm/ttm/ttm_userobj_api.h
new file mode 100644
index 0000000..5309050
--- /dev/null
+++ b/include/drm/ttm/ttm_userobj_api.h
@@ -0,0 +1,79 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#ifndef _TTM_USEROBJ_API_H_
+#define _TTM_USEROBJ_API_H_
+
+#include "ttm/ttm_placement_user.h"
+#include "ttm/ttm_fence_user.h"
+#include "ttm/ttm_object.h"
+#include "ttm/ttm_fence_api.h"
+#include "ttm/ttm_bo_api.h"
+
+struct ttm_lock;
+
+/*
+ * User ioctls.
+ */
+
+extern int ttm_pl_create_ioctl(struct ttm_object_file *tfile,
+			       struct ttm_bo_device *bdev,
+			       struct ttm_lock *lock, void *data);
+extern int ttm_pl_ub_create_ioctl(struct ttm_object_file *tfile,
+				  struct ttm_bo_device *bdev,
+				  struct ttm_lock *lock, void *data);
+extern int ttm_pl_reference_ioctl(struct ttm_object_file *tfile, void *data);
+extern int ttm_pl_unref_ioctl(struct ttm_object_file *tfile, void *data);
+extern int ttm_pl_synccpu_ioctl(struct ttm_object_file *tfile, void *data);
+extern int ttm_pl_setstatus_ioctl(struct ttm_object_file *tfile,
+				  struct ttm_lock *lock, void *data);
+extern int ttm_pl_waitidle_ioctl(struct ttm_object_file *tfile, void *data);
+extern int ttm_fence_signaled_ioctl(struct ttm_object_file *tfile, void *data);
+extern int ttm_fence_finish_ioctl(struct ttm_object_file *tfile, void *data);
+extern int ttm_fence_unref_ioctl(struct ttm_object_file *tfile, void *data);
+
+extern int
+ttm_fence_user_create(struct ttm_fence_device *fdev,
+		      struct ttm_object_file *tfile,
+		      uint32_t fence_class,
+		      uint32_t fence_types,
+		      uint32_t create_flags,
+		      struct ttm_fence_object **fence, uint32_t * user_handle);
+
+extern struct ttm_buffer_object *ttm_buffer_object_lookup(struct ttm_object_file
+							  *tfile,
+							  uint32_t handle);
+
+extern int
+ttm_pl_verify_access(struct ttm_buffer_object *bo,
+		     struct ttm_object_file *tfile);
+#endif
-- 
1.5.4.3


--------------070305090506020700070505--



