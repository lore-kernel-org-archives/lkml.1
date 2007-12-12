Return-Path: <linux-kernel-owner+w=401wt.eu-S1759788AbXLLVhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788AbXLLVhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbXLLVhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:37:07 -0500
Received: from qb-out-0506.google.com ([72.14.204.232]:9713 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbXLLVhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:37:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vEEwPSNH+P7DRPX/vSgzm/k5/rpmQi++IWFZw0v8IYiO3nX6g6VXmMgSpsjsI2EbUMOSJP0UQZd48MMI1mnXp6+wlw0K3n9BXX0jZn1Aq9cCiQMh8M7ubZQ9kqAe4r8mDSJD2yjjOnm0N6xfabLAIIUv8GgAWTGYzjKYUrZqZ8w=
Subject: [PATCH] lib: remove fastcall from lib/*
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 13:36:57 -0800
Message-Id: <1197495417.21291.32.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 lib/iomap.c              |   32 ++++++++++++++++----------------
 lib/rwsem-spinlock.c     |   16 ++++++++--------
 lib/rwsem.c              |    8 ++++----
 lib/semaphore-sleepers.c |    8 ++++----
 4 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/lib/iomap.c b/lib/iomap.c
index 72c4268..db004a9 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -69,27 +69,27 @@ static void bad_io_access(unsigned long port, const char *access)
 #define mmio_read32be(addr) be32_to_cpu(__raw_readl(addr))
 #endif
 
-unsigned int fastcall ioread8(void __iomem *addr)
+unsigned int ioread8(void __iomem *addr)
 {
 	IO_COND(addr, return inb(port), return readb(addr));
 	return 0xff;
 }
-unsigned int fastcall ioread16(void __iomem *addr)
+unsigned int ioread16(void __iomem *addr)
 {
 	IO_COND(addr, return inw(port), return readw(addr));
 	return 0xffff;
 }
-unsigned int fastcall ioread16be(void __iomem *addr)
+unsigned int ioread16be(void __iomem *addr)
 {
 	IO_COND(addr, return pio_read16be(port), return mmio_read16be(addr));
 	return 0xffff;
 }
-unsigned int fastcall ioread32(void __iomem *addr)
+unsigned int ioread32(void __iomem *addr)
 {
 	IO_COND(addr, return inl(port), return readl(addr));
 	return 0xffffffff;
 }
-unsigned int fastcall ioread32be(void __iomem *addr)
+unsigned int ioread32be(void __iomem *addr)
 {
 	IO_COND(addr, return pio_read32be(port), return mmio_read32be(addr));
 	return 0xffffffff;
@@ -110,23 +110,23 @@ EXPORT_SYMBOL(ioread32be);
 #define mmio_write32be(val,port) __raw_writel(be32_to_cpu(val),port)
 #endif
 
-void fastcall iowrite8(u8 val, void __iomem *addr)
+void iowrite8(u8 val, void __iomem *addr)
 {
 	IO_COND(addr, outb(val,port), writeb(val, addr));
 }
-void fastcall iowrite16(u16 val, void __iomem *addr)
+void iowrite16(u16 val, void __iomem *addr)
 {
 	IO_COND(addr, outw(val,port), writew(val, addr));
 }
-void fastcall iowrite16be(u16 val, void __iomem *addr)
+void iowrite16be(u16 val, void __iomem *addr)
 {
 	IO_COND(addr, pio_write16be(val,port), mmio_write16be(val, addr));
 }
-void fastcall iowrite32(u32 val, void __iomem *addr)
+void iowrite32(u32 val, void __iomem *addr)
 {
 	IO_COND(addr, outl(val,port), writel(val, addr));
 }
-void fastcall iowrite32be(u32 val, void __iomem *addr)
+void iowrite32be(u32 val, void __iomem *addr)
 {
 	IO_COND(addr, pio_write32be(val,port), mmio_write32be(val, addr));
 }
@@ -193,15 +193,15 @@ static inline void mmio_outsl(void __iomem *addr, const u32 *src, int count)
 }
 #endif
 
-void fastcall ioread8_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread8_rep(void __iomem *addr, void *dst, unsigned long count)
 {
 	IO_COND(addr, insb(port,dst,count), mmio_insb(addr, dst, count));
 }
-void fastcall ioread16_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread16_rep(void __iomem *addr, void *dst, unsigned long count)
 {
 	IO_COND(addr, insw(port,dst,count), mmio_insw(addr, dst, count));
 }
-void fastcall ioread32_rep(void __iomem *addr, void *dst, unsigned long count)
+void ioread32_rep(void __iomem *addr, void *dst, unsigned long count)
 {
 	IO_COND(addr, insl(port,dst,count), mmio_insl(addr, dst, count));
 }
@@ -209,15 +209,15 @@ EXPORT_SYMBOL(ioread8_rep);
 EXPORT_SYMBOL(ioread16_rep);
 EXPORT_SYMBOL(ioread32_rep);
 
-void fastcall iowrite8_rep(void __iomem *addr, const void *src, unsigned long count)
+void iowrite8_rep(void __iomem *addr, const void *src, unsigned long count)
 {
 	IO_COND(addr, outsb(port, src, count), mmio_outsb(addr, src, count));
 }
-void fastcall iowrite16_rep(void __iomem *addr, const void *src, unsigned long count)
+void iowrite16_rep(void __iomem *addr, const void *src, unsigned long count)
 {
 	IO_COND(addr, outsw(port, src, count), mmio_outsw(addr, src, count));
 }
-void fastcall iowrite32_rep(void __iomem *addr, const void *src, unsigned long count)
+void iowrite32_rep(void __iomem *addr, const void *src, unsigned long count)
 {
 	IO_COND(addr, outsl(port, src,count), mmio_outsl(addr, src, count));
 }
diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index c4cfd6c..9df3ca5 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -125,7 +125,7 @@ __rwsem_wake_one_writer(struct rw_semaphore *sem)
 /*
  * get a read lock on the semaphore
  */
-void fastcall __sched __down_read(struct rw_semaphore *sem)
+void __sched __down_read(struct rw_semaphore *sem)
 {
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk;
@@ -168,7 +168,7 @@ void fastcall __sched __down_read(struct rw_semaphore *sem)
 /*
  * trylock for reading -- returns 1 if successful, 0 if contention
  */
-int fastcall __down_read_trylock(struct rw_semaphore *sem)
+int __down_read_trylock(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 	int ret = 0;
@@ -191,7 +191,7 @@ int fastcall __down_read_trylock(struct rw_semaphore *sem)
  * get a write lock on the semaphore
  * - we increment the waiting count anyway to indicate an exclusive lock
  */
-void fastcall __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
+void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk;
@@ -231,7 +231,7 @@ void fastcall __sched __down_write_nested(struct rw_semaphore *sem, int subclass
 	;
 }
 
-void fastcall __sched __down_write(struct rw_semaphore *sem)
+void __sched __down_write(struct rw_semaphore *sem)
 {
 	__down_write_nested(sem, 0);
 }
@@ -239,7 +239,7 @@ void fastcall __sched __down_write(struct rw_semaphore *sem)
 /*
  * trylock for writing -- returns 1 if successful, 0 if contention
  */
-int fastcall __down_write_trylock(struct rw_semaphore *sem)
+int __down_write_trylock(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 	int ret = 0;
@@ -260,7 +260,7 @@ int fastcall __down_write_trylock(struct rw_semaphore *sem)
 /*
  * release a read lock on the semaphore
  */
-void fastcall __up_read(struct rw_semaphore *sem)
+void __up_read(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
@@ -275,7 +275,7 @@ void fastcall __up_read(struct rw_semaphore *sem)
 /*
  * release a write lock on the semaphore
  */
-void fastcall __up_write(struct rw_semaphore *sem)
+void __up_write(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
@@ -292,7 +292,7 @@ void fastcall __up_write(struct rw_semaphore *sem)
  * downgrade a write lock into a read lock
  * - just wake up any readers at the front of the queue
  */
-void fastcall __downgrade_write(struct rw_semaphore *sem)
+void __downgrade_write(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
diff --git a/lib/rwsem.c b/lib/rwsem.c
index cdb4e3d..a2bc84c 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -187,7 +187,7 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 /*
  * wait for the read lock to be granted
  */
-struct rw_semaphore fastcall __sched *
+struct rw_semaphore __sched *
 rwsem_down_read_failed(struct rw_semaphore *sem)
 {
 	struct rwsem_waiter waiter;
@@ -201,7 +201,7 @@ rwsem_down_read_failed(struct rw_semaphore *sem)
 /*
  * wait for the write lock to be granted
  */
-struct rw_semaphore fastcall __sched *
+struct rw_semaphore __sched *
 rwsem_down_write_failed(struct rw_semaphore *sem)
 {
 	struct rwsem_waiter waiter;
@@ -216,7 +216,7 @@ rwsem_down_write_failed(struct rw_semaphore *sem)
  * handle waking up a waiter on the semaphore
  * - up_read/up_write has decremented the active part of count if we come here
  */
-struct rw_semaphore fastcall *rwsem_wake(struct rw_semaphore *sem)
+struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
@@ -236,7 +236,7 @@ struct rw_semaphore fastcall *rwsem_wake(struct rw_semaphore *sem)
  * - caller incremented waiting part of count and discovered it still negative
  * - just wake up any readers at the front of the queue
  */
-struct rw_semaphore fastcall *rwsem_downgrade_wake(struct rw_semaphore *sem)
+struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
diff --git a/lib/semaphore-sleepers.c b/lib/semaphore-sleepers.c
index 1281805..d3a6272 100644
--- a/lib/semaphore-sleepers.c
+++ b/lib/semaphore-sleepers.c
@@ -48,12 +48,12 @@
  *    we cannot lose wakeup events.
  */
 
-fastcall void __up(struct semaphore *sem)
+void __up(struct semaphore *sem)
 {
 	wake_up(&sem->wait);
 }
 
-fastcall void __sched __down(struct semaphore * sem)
+void __sched __down(struct semaphore * sem)
 {
 	struct task_struct *tsk = current;
 	DECLARE_WAITQUEUE(wait, tsk);
@@ -90,7 +90,7 @@ fastcall void __sched __down(struct semaphore * sem)
 	tsk->state = TASK_RUNNING;
 }
 
-fastcall int __sched __down_interruptible(struct semaphore * sem)
+int __sched __down_interruptible(struct semaphore * sem)
 {
 	int retval = 0;
 	struct task_struct *tsk = current;
@@ -153,7 +153,7 @@ fastcall int __sched __down_interruptible(struct semaphore * sem)
  * single "cmpxchg" without failure cases,
  * but then it wouldn't work on a 386.
  */
-fastcall int __down_trylock(struct semaphore * sem)
+int __down_trylock(struct semaphore * sem)
 {
 	int sleepers;
 	unsigned long flags;
-- 
1.5.3.7.2212.gd092



