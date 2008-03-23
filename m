Return-Path: <linux-kernel-owner+w=401wt.eu-S933467AbYCWI4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467AbYCWI4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760217AbYCWILy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:54 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2347 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760150AbYCWILo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:44 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 036/148] include/asm-x86/floppy.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:11 -0700
Message-Id: <1206259443-13210-37-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/floppy.h |   87 ++++++++++++++++++++++++----------------------
 1 files changed, 45 insertions(+), 42 deletions(-)

diff --git a/include/asm-x86/floppy.h b/include/asm-x86/floppy.h
index a48d715..438b303 100644
--- a/include/asm-x86/floppy.h
+++ b/include/asm-x86/floppy.h
@@ -20,20 +20,21 @@
  * driver otherwise. It doesn't matter much for performance anyway, as most
  * floppy accesses go through the track buffer.
  */
-#define _CROSS_64KB(a,s,vdma) \
-(!(vdma) && ((unsigned long)(a)/K_64 != ((unsigned long)(a) + (s) - 1) / K_64))
+#define _CROSS_64KB(a, s, vdma)						\
+	(!(vdma) &&							\
+	 ((unsigned long)(a)/K_64 != ((unsigned long)(a) + (s) - 1) / K_64))
 
-#define CROSS_64KB(a,s) _CROSS_64KB(a,s,use_virtual_dma & 1)
+#define CROSS_64KB(a, s) _CROSS_64KB(a, s, use_virtual_dma & 1)
 
 
-#define SW fd_routine[use_virtual_dma&1]
+#define SW fd_routine[use_virtual_dma & 1]
 #define CSW fd_routine[can_use_virtual_dma & 1]
 
 
 #define fd_inb(port)		inb_p(port)
-#define fd_outb(value,port)	outb_p(value,port)
+#define fd_outb(value, port)	outb_p(value, port)
 
-#define fd_request_dma()	CSW._request_dma(FLOPPY_DMA,"floppy")
+#define fd_request_dma()	CSW._request_dma(FLOPPY_DMA, "floppy")
 #define fd_free_dma()		CSW._free_dma(FLOPPY_DMA)
 #define fd_enable_irq()		enable_irq(FLOPPY_IRQ)
 #define fd_disable_irq()	disable_irq(FLOPPY_IRQ)
@@ -57,15 +58,15 @@ static irqreturn_t floppy_hardint(int irq, void *dev_id)
 #undef TRACE_FLPY_INT
 
 #ifdef TRACE_FLPY_INT
-	static int calls=0;
-	static int bytes=0;
-	static int dma_wait=0;
+	static int calls;
+	static int bytes;
+	static int dma_wait;
 #endif
 	if (!doing_pdma)
 		return floppy_interrupt(irq, dev_id);
 
 #ifdef TRACE_FLPY_INT
-	if(!calls)
+	if (!calls)
 		bytes = virtual_dma_count;
 #endif
 
@@ -74,42 +75,42 @@ static irqreturn_t floppy_hardint(int irq, void *dev_id)
 		register char *lptr;
 
 		st = 1;
-		for(lcount=virtual_dma_count, lptr=virtual_dma_addr;
-		    lcount; lcount--, lptr++) {
-			st=inb(virtual_dma_port+4) & 0xa0 ;
-			if(st != 0xa0)
+		for (lcount = virtual_dma_count, lptr = virtual_dma_addr;
+		     lcount; lcount--, lptr++) {
+			st = inb(virtual_dma_port + 4) & 0xa0;
+			if (st != 0xa0)
 				break;
-			if(virtual_dma_mode)
-				outb_p(*lptr, virtual_dma_port+5);
+			if (virtual_dma_mode)
+				outb_p(*lptr, virtual_dma_port + 5);
 			else
-				*lptr = inb_p(virtual_dma_port+5);
+				*lptr = inb_p(virtual_dma_port + 5);
 		}
 		virtual_dma_count = lcount;
 		virtual_dma_addr = lptr;
-		st = inb(virtual_dma_port+4);
+		st = inb(virtual_dma_port + 4);
 	}
 
 #ifdef TRACE_FLPY_INT
 	calls++;
 #endif
-	if(st == 0x20)
+	if (st == 0x20)
 		return IRQ_HANDLED;
-	if(!(st & 0x20)) {
+	if (!(st & 0x20)) {
 		virtual_dma_residue += virtual_dma_count;
-		virtual_dma_count=0;
+		virtual_dma_count = 0;
 #ifdef TRACE_FLPY_INT
 		printk("count=%x, residue=%x calls=%d bytes=%d dma_wait=%d\n",
 		       virtual_dma_count, virtual_dma_residue, calls, bytes,
 		       dma_wait);
 		calls = 0;
-		dma_wait=0;
+		dma_wait = 0;
 #endif
 		doing_pdma = 0;
 		floppy_interrupt(irq, dev_id);
 		return IRQ_HANDLED;
 	}
 #ifdef TRACE_FLPY_INT
-	if(!virtual_dma_count)
+	if (!virtual_dma_count)
 		dma_wait++;
 #endif
 	return IRQ_HANDLED;
@@ -117,14 +118,14 @@ static irqreturn_t floppy_hardint(int irq, void *dev_id)
 
 static void fd_disable_dma(void)
 {
-	if(! (can_use_virtual_dma & 1))
+	if (!(can_use_virtual_dma & 1))
 		disable_dma(FLOPPY_DMA);
 	doing_pdma = 0;
 	virtual_dma_residue += virtual_dma_count;
-	virtual_dma_count=0;
+	virtual_dma_count = 0;
 }
 
-static int vdma_request_dma(unsigned int dmanr, const char * device_id)
+static int vdma_request_dma(unsigned int dmanr, const char *device_id)
 {
 	return 0;
 }
@@ -142,7 +143,7 @@ static int vdma_get_dma_residue(unsigned int dummy)
 
 static int fd_request_irq(void)
 {
-	if(can_use_virtual_dma)
+	if (can_use_virtual_dma)
 		return request_irq(FLOPPY_IRQ, floppy_hardint,
 				   IRQF_DISABLED, "floppy", NULL);
 	else
@@ -152,13 +153,13 @@ static int fd_request_irq(void)
 
 static unsigned long dma_mem_alloc(unsigned long size)
 {
-	return __get_dma_pages(GFP_KERNEL|__GFP_NORETRY,get_order(size));
+	return __get_dma_pages(GFP_KERNEL|__GFP_NORETRY, get_order(size));
 }
 
 
 static unsigned long vdma_mem_alloc(unsigned long size)
 {
-	return (unsigned long) vmalloc(size);
+	return (unsigned long)vmalloc(size);
 
 }
 
@@ -166,7 +167,7 @@ static unsigned long vdma_mem_alloc(unsigned long size)
 
 static void _fd_dma_mem_free(unsigned long addr, unsigned long size)
 {
-	if((unsigned long) addr >= (unsigned long) high_memory)
+	if ((unsigned long)addr >= (unsigned long)high_memory)
 		vfree((void *)addr);
 	else
 		free_pages(addr, get_order(size));
@@ -176,10 +177,10 @@ static void _fd_dma_mem_free(unsigned long addr, unsigned long size)
 
 static void _fd_chose_dma_mode(char *addr, unsigned long size)
 {
-	if(can_use_virtual_dma == 2) {
-		if((unsigned long) addr >= (unsigned long) high_memory ||
-		   isa_virt_to_bus(addr) >= 0x1000000 ||
-		   _CROSS_64KB(addr, size, 0))
+	if (can_use_virtual_dma == 2) {
+		if ((unsigned long)addr >= (unsigned long)high_memory ||
+		    isa_virt_to_bus(addr) >= 0x1000000 ||
+		    _CROSS_64KB(addr, size, 0))
 			use_virtual_dma = 1;
 		else
 			use_virtual_dma = 0;
@@ -195,7 +196,7 @@ static int vdma_dma_setup(char *addr, unsigned long size, int mode, int io)
 {
 	doing_pdma = 1;
 	virtual_dma_port = io;
-	virtual_dma_mode = (mode  == DMA_MODE_WRITE);
+	virtual_dma_mode = (mode == DMA_MODE_WRITE);
 	virtual_dma_addr = addr;
 	virtual_dma_count = size;
 	virtual_dma_residue = 0;
@@ -213,18 +214,18 @@ static int hard_dma_setup(char *addr, unsigned long size, int mode, int io)
 	/* actual, physical DMA */
 	doing_pdma = 0;
 	clear_dma_ff(FLOPPY_DMA);
-	set_dma_mode(FLOPPY_DMA,mode);
-	set_dma_addr(FLOPPY_DMA,isa_virt_to_bus(addr));
-	set_dma_count(FLOPPY_DMA,size);
+	set_dma_mode(FLOPPY_DMA, mode);
+	set_dma_addr(FLOPPY_DMA, isa_virt_to_bus(addr));
+	set_dma_count(FLOPPY_DMA, size);
 	enable_dma(FLOPPY_DMA);
 	return 0;
 }
 
 static struct fd_routine_l {
-	int (*_request_dma)(unsigned int dmanr, const char * device_id);
+	int (*_request_dma)(unsigned int dmanr, const char *device_id);
 	void (*_free_dma)(unsigned int dmanr);
 	int (*_get_dma_residue)(unsigned int dummy);
-	unsigned long (*_dma_mem_alloc) (unsigned long size);
+	unsigned long (*_dma_mem_alloc)(unsigned long size);
 	int (*_dma_setup)(char *addr, unsigned long size, int mode, int io);
 } fd_routine[] = {
 	{
@@ -252,7 +253,8 @@ static int FDC2 = -1;
  * is needed to prevent corrupted CMOS RAM in case "insmod floppy"
  * coincides with another rtc CMOS user.		Paul G.
  */
-#define FLOPPY0_TYPE	({				\
+#define FLOPPY0_TYPE					\
+({							\
 	unsigned long flags;				\
 	unsigned char val;				\
 	spin_lock_irqsave(&rtc_lock, flags);		\
@@ -261,7 +263,8 @@ static int FDC2 = -1;
 	val;						\
 })
 
-#define FLOPPY1_TYPE	({				\
+#define FLOPPY1_TYPE					\
+({							\
 	unsigned long flags;				\
 	unsigned char val;				\
 	spin_lock_irqsave(&rtc_lock, flags);		\
-- 
1.5.4.rc2

