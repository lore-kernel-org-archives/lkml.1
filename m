Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097Ab0CMTf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 14:35:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:46751 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618Ab0CMTf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 14:35:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wF+AF37eZRB+jO9lXHEt5OaCsAiF7+qhASI8YWgGkV+9rkp9wU6gnRvGziclfqV9k4
         EbcMqHo7cmAx6vbrJEqM5RReorbe+I+zaljjUmJ6cgu3fKiuaQz5p6h39MKFRu8A+5zb
         DZBo2RCsoX0RcN/JJdRI3v0uoaEB0MTzxXxAc=
From: Gorskin Ilya <revent82@gmail.com>
To: gregkh@suse.de, hsweeten@visionengravers.com, horms@verge.net.au,
       ss@aao.gov.au
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Gorskin Ilya <revent82@gmail.com>
Subject: [PATCH 3/3] Staging:dt3155: fix coding style issue in dt3155_isr.c This is a patch to the dt3155_isr.c file that fixes up a coding style warning and errors found by the checkpatch.pl tool
Date: Sun, 14 Mar 2010 00:35:17 +0500
Message-Id: <1268508917-17220-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gorskin Ilya <revent82@gmail.com>
---
 drivers/staging/dt3155/dt3155_isr.c |  295 +++++++++++++++++------------------
 1 files changed, 144 insertions(+), 151 deletions(-)

diff --git a/drivers/staging/dt3155/dt3155_isr.c b/drivers/staging/dt3155/dt3155_isr.c
index fd7f93d..9ca6875 100644
--- a/drivers/staging/dt3155/dt3155_isr.c
+++ b/drivers/staging/dt3155/dt3155_isr.c
@@ -1,7 +1,7 @@
 /*
 
 Copyright 1996,2002,2005 Gregory D. Hager, Alfred A. Rizzi, Noah J. Cowan,
-                         Jason Lapenta, Scott Smedley, Greg Sharp
+				Jason Lapenta, Scott Smedley, Greg Sharp
 
 This file is part of the DT3155 Device Driver.
 
@@ -22,7 +22,7 @@ MA 02111-1307 USA
 
    File: dt3155_isr.c
 Purpose: Buffer management routines, and other routines for the ISR
-         (the actual isr is in dt3155_drv.c)
+		(the actual isr is in dt3155_drv.c)
 
 -- Changes --
 
@@ -30,16 +30,16 @@ Purpose: Buffer management routines, and other routines for the ISR
   -------------------------------------------------------------------
   03-Jul-2000 JML       n/a
   02-Apr-2002 SS        Mods to make work with separate allocator
-                        module; Merged John Roll's mods to make work with
-                        multiple boards.
+			module; Merged John Roll's mods to make work with
+			multiple boards.
   10-Jul-2002 GCS       Complete rewrite of setup_buffers to disallow
-                        buffers which span a 4MB boundary.
+			buffers which span a 4MB boundary.
   24-Jul-2002 SS        GPL licence.
   30-Jul-2002 NJC       Added support for buffer loop.
   31-Jul-2002 NJC       Complete rewrite of buffer management
   02-Aug-2002 NJC       Including slab.h instead of malloc.h (no warning).
-                        Also, allocator_init() now returns allocator_max
-                        so cleaned up allocate_buffers() accordingly.
+			Also, allocator_init() now returns allocator_max
+			so cleaned up allocate_buffers() accordingly.
   08-Aug-2005 SS        port to 2.6 kernel.
 
 */
@@ -77,9 +77,9 @@ struct dt3155_fbuffer_s *dt3155_fbuffer[MAXBOARDS] = {NULL
  * are_empty_buffers
  * m is minor # of device
  ***************************/
-inline bool are_empty_buffers( int m )
+inline bool are_empty_buffers(int m)
 {
-  return ( dt3155_fbuffer[ m ]->empty_len );
+  return dt3155_fbuffer[m]->empty_len;
 }
 
 /**************************
@@ -92,56 +92,56 @@ inline bool are_empty_buffers( int m )
  * given by dt3155_fbuffer[m]->empty_buffers[0].
  * empty_buffers should never fill up, though this is not checked.
  **************************/
-inline void push_empty( int index, int m )
+inline void push_empty(int index, int m)
 {
-  dt3155_fbuffer[m]->empty_buffers[ dt3155_fbuffer[m]->empty_len ] = index;
+  dt3155_fbuffer[m]->empty_buffers[dt3155_fbuffer[m]->empty_len] = index;
   dt3155_fbuffer[m]->empty_len++;
 }
 
 /**************************
- * pop_empty( m )
+ * pop_empty(m)
  * m is minor # of device
  **************************/
-inline int pop_empty( int m )
+inline int pop_empty(int m)
 {
   dt3155_fbuffer[m]->empty_len--;
-  return dt3155_fbuffer[m]->empty_buffers[ dt3155_fbuffer[m]->empty_len ];
+  return dt3155_fbuffer[m]->empty_buffers[dt3155_fbuffer[m]->empty_len];
 }
 
 /*************************
- * is_ready_buf_empty( m )
+ * is_ready_buf_empty(m)
  * m is minor # of device
  *************************/
-inline bool is_ready_buf_empty( int m )
+inline bool is_ready_buf_empty(int m)
 {
-  return ((dt3155_fbuffer[ m ]->ready_len) == 0);
+  return ((dt3155_fbuffer[m]->ready_len) == 0);
 }
 
 /*************************
- * is_ready_buf_full( m )
+ * is_ready_buf_full(m)
  * m is minor # of device
  * this should *never* be true if there are any active, locked or empty
  * buffers, since it corresponds to nbuffers ready buffers!!
  * 7/31/02: total rewrite. --NJC
  *************************/
-inline bool is_ready_buf_full( int m )
+inline bool is_ready_buf_full(int m)
 {
-  return ( dt3155_fbuffer[ m ]->ready_len == dt3155_fbuffer[ m ]->nbuffers );
+  return dt3155_fbuffer[m]->ready_len == dt3155_fbuffer[m]->nbuffers;
 }
 
 /*****************************************************
- * push_ready( m, buffer )
+ * push_ready(m, buffer)
  * m is minor # of device
  *
  *****************************************************/
-inline void push_ready( int m, int index )
+inline void push_ready(int m, int index)
 {
   int head = dt3155_fbuffer[m]->ready_head;
 
-  dt3155_fbuffer[ m ]->ready_que[ head ] = index;
-  dt3155_fbuffer[ m ]->ready_head = ( (head + 1) %
-				      (dt3155_fbuffer[ m ]->nbuffers) );
-  dt3155_fbuffer[ m ]->ready_len++;
+  dt3155_fbuffer[m]->ready_que[head] = index;
+  dt3155_fbuffer[m]->ready_head = ((head + 1) %
+				      (dt3155_fbuffer[m]->nbuffers));
+  dt3155_fbuffer[m]->ready_len++;
 
 }
 
@@ -151,12 +151,12 @@ inline void push_ready( int m, int index )
  *
  * Simply comptutes the tail given the head and the length.
  *****************************************************/
-static inline int get_tail( int m )
+static inline int get_tail(int m)
 {
-  return ((dt3155_fbuffer[ m ]->ready_head -
-	   dt3155_fbuffer[ m ]->ready_len +
-	   dt3155_fbuffer[ m ]->nbuffers)%
-	  (dt3155_fbuffer[ m ]->nbuffers));
+  return (dt3155_fbuffer[m]->ready_head -
+	   dt3155_fbuffer[m]->ready_len +
+	   dt3155_fbuffer[m]->nbuffers)%
+	  (dt3155_fbuffer[m]->nbuffers);
 }
 
 
@@ -168,12 +168,12 @@ static inline int get_tail( int m )
  * This assumes that there is a ready buffer ready... should
  * be checked (e.g. with is_ready_buf_empty()  prior to call.
  *****************************************************/
-inline int pop_ready( int m )
+inline int pop_ready(int m)
 {
   int tail;
   tail = get_tail(m);
-  dt3155_fbuffer[ m ]->ready_len--;
-  return dt3155_fbuffer[ m ]->ready_que[ tail ];
+  dt3155_fbuffer[m]->ready_len--;
+  return dt3155_fbuffer[m]->ready_que[tail];
 }
 
 
@@ -181,35 +181,33 @@ inline int pop_ready( int m )
  * printques
  * m is minor # of device
  *****************************************************/
-inline void printques( int m )
+inline void printques(int m)
 {
-  int head = dt3155_fbuffer[ m ]->ready_head;
+  int head = dt3155_fbuffer[m]->ready_head;
   int tail;
-  int num = dt3155_fbuffer[ m ]->nbuffers;
+  int num = dt3155_fbuffer[m]->nbuffers;
   int frame_index;
   int index;
 
   tail = get_tail(m);
 
   printk("\n R:");
-  for ( index = tail; index != head; index++, index = index % (num) )
-    {
-      frame_index = dt3155_fbuffer[ m ]->ready_que[ index ];
-      printk(" %d ", frame_index );
+    for (index = tail; index != head; index++, index = index % (num)) {
+	frame_index = dt3155_fbuffer[m]->ready_que[index];
+	printk(" %d ", frame_index);
     }
 
   printk("\n E:");
-  for ( index = 0; index < dt3155_fbuffer[ m ]->empty_len; index++ )
-    {
-      frame_index = dt3155_fbuffer[ m ]->empty_buffers[ index ];
-      printk(" %d ", frame_index );
+    for (index = 0; index < dt3155_fbuffer[m]->empty_len; index++) {
+	frame_index = dt3155_fbuffer[m]->empty_buffers[index];
+	printk(" %d ", frame_index);
     }
 
-  frame_index = dt3155_fbuffer[ m ]->active_buf;
+  frame_index = dt3155_fbuffer[m]->active_buf;
   printk("\n A: %d", frame_index);
 
-  frame_index = dt3155_fbuffer[ m ]->locked_buf;
-  printk("\n L: %d \n", frame_index );
+  frame_index = dt3155_fbuffer[m]->locked_buf;
+  printk("\n L: %d\n", frame_index);
 
 }
 
@@ -220,11 +218,12 @@ inline void printques( int m )
  *  the start address up to the beginning of the
  *  next 4MB chunk (assuming bufsize < 4MB).
  *****************************************************/
-u32 adjust_4MB (u32 buf_addr, u32 bufsize) {
-  if (((buf_addr+bufsize) & UPPER_10_BITS) != (buf_addr & UPPER_10_BITS))
-    return (buf_addr+bufsize) & UPPER_10_BITS;
-  else
-    return buf_addr;
+u32 adjust_4MB(u32 buf_addr, u32 bufsize)
+{
+    if (((buf_addr+bufsize) & UPPER_10_BITS) != (buf_addr & UPPER_10_BITS))
+	return (buf_addr+bufsize) & UPPER_10_BITS;
+    else
+	return buf_addr;
 }
 
 
@@ -235,7 +234,7 @@ u32 adjust_4MB (u32 buf_addr, u32 bufsize) {
  *  buffers.  If there is not enough free space
  *  try for less memory.
  *****************************************************/
-void allocate_buffers (u32 *buf_addr, u32* total_size_kbs,
+void allocate_buffers(u32 *buf_addr, u32* total_size_kbs,
 		       u32 bufsize)
 {
   /* Compute the minimum amount of memory guaranteed to hold all
@@ -268,15 +267,15 @@ void allocate_buffers (u32 *buf_addr, u32* total_size_kbs,
   printk("DT3155: ...but need at least: %d KB\n", min_size_kbs);
   printk("DT3155: ...the allocator has: %d KB\n", allocator_max);
   size_kbs = (full_size_kbs <= allocator_max ? full_size_kbs : allocator_max);
-  if (size_kbs > min_size_kbs) {
-    if ((*buf_addr = allocator_allocate_dma (size_kbs, GFP_KERNEL)) != 0) {
-      printk("DT3155:  Managed to allocate: %d KB\n", size_kbs);
-      *total_size_kbs = size_kbs;
-      return;
+    if (size_kbs > min_size_kbs) {
+	if ((*buf_addr = allocator_allocate_dma(size_kbs, GFP_KERNEL)) != 0) {
+		printk("DT3155:  Managed to allocate: %d KB\n", size_kbs);
+		*total_size_kbs = size_kbs;
+		return;
+	}
     }
-  }
   /* If we got here, the allocation failed */
-  printk ("DT3155: Allocator failed!\n");
+  printk("DT3155: Allocator failed!\n");
   *buf_addr = 0;
   *total_size_kbs = 0;
   return;
@@ -312,28 +311,26 @@ u32 dt3155_setup_buffers(u32 *allocatorAddr)
   int m;               /* minor # of device, looped for all devs */
 
   /* zero the fbuffer status and address structure */
-  for ( m = 0; m < ndevices; m++)
-    {
-      dt3155_fbuffer[ m ] = &(dt3155_status[ m ].fbuffer);
+    for (m = 0; m < ndevices; m++) {
+	dt3155_fbuffer[m] = &(dt3155_status[m].fbuffer);
 
       /* Make sure the buffering variables are consistent */
       {
-	u8 *ptr = (u8 *) dt3155_fbuffer[ m ];
-	for( index = 0; index < sizeof(struct dt3155_fbuffer_s); index++)
-	  *(ptr++)=0;
+	u8 *ptr = (u8 *) dt3155_fbuffer[m];
+		for (index = 0; index < sizeof(struct dt3155_fbuffer_s); index++)
+			*(ptr++) = 0;
       }
     }
 
   /* allocate a large contiguous chunk of RAM */
-  allocate_buffers (&rambuff_addr, &rambuff_size, bufsize);
+  allocate_buffers(&rambuff_addr, &rambuff_size, bufsize);
   printk("DT3155: mem info\n");
-  printk("  - rambuf_addr = 0x%x \n", rambuff_addr);
-  printk("  - length (kb) = %u \n", rambuff_size);
-  if( rambuff_addr == 0 )
-    {
-      printk( KERN_INFO
-	      "DT3155: Error setup_buffers() allocator dma failed \n" );
-      return -ENOMEM;
+  printk("  - rambuf_addr = 0x%x\n", rambuff_addr);
+  printk("  - length (kb) = %u\n", rambuff_size);
+    if (rambuff_addr == 0) {
+	printk(KERN_INFO
+	    "DT3155: Error setup_buffers() allocator dma failed\n");
+	return -ENOMEM;
     }
   *allocatorAddr = rambuff_addr;
   rambuff_end = rambuff_addr + 1024 * rambuff_size;
@@ -341,70 +338,68 @@ u32 dt3155_setup_buffers(u32 *allocatorAddr)
   /* after allocation, we need to count how many useful buffers there
      are so we can give an equal number to each device */
   rambuff_acm = rambuff_addr;
-  for ( index = 0; index < MAXBUFFERS; index++) {
-    rambuff_acm = adjust_4MB (rambuff_acm, bufsize);/*avoid spanning 4MB bdry*/
-    if (rambuff_acm + bufsize > rambuff_end)
-      break;
-    rambuff_acm += bufsize;
-  }
+    for (index = 0; index < MAXBUFFERS; index++) {
+	rambuff_acm = adjust_4MB(rambuff_acm, bufsize);/*avoid spanning 4MB bdry*/
+	if (rambuff_acm + bufsize > rambuff_end)
+		break;
+	rambuff_acm += bufsize;
+    }
   /* Following line is OK, will waste buffers if index
    * not evenly divisible by ndevices -NJC*/
   numbufs = index / ndevices;
   printk("  - numbufs = %u\n", numbufs);
-  if (numbufs < 2) {
-    printk( KERN_INFO
-	    "DT3155: Error setup_buffers() couldn't allocate 2 bufs/board\n" );
-    return -ENOMEM;
-  }
+    if (numbufs < 2) {
+	printk(KERN_INFO
+	"DT3155: Error setup_buffers() couldn't allocate 2 bufs/board\n");
+	return -ENOMEM;
+    }
 
   /* now that we have board memory we spit it up */
   /* between the boards and the buffers          */
-  rambuff_acm = rambuff_addr;
-  for ( m = 0; m < ndevices; m ++)
-    {
-      rambuff_acm = adjust_4MB (rambuff_acm, bufsize);
-
-      /* Save the start of this boards buffer space (for mmap).  */
-      dt3155_status[ m ].mem_addr = rambuff_acm;
-
-      for (index = 0; index < numbufs; index++)
-	{
-	  rambuff_acm = adjust_4MB (rambuff_acm, bufsize);
-	  if (rambuff_acm + bufsize > rambuff_end) {
-	    /* Should never happen */
-	    printk ("DT3155 PROGRAM ERROR (GCS)\n"
-		    "Error distributing allocated buffers\n");
-	    return -ENOMEM;
-	  }
-
-	  dt3155_fbuffer[ m ]->frame_info[ index ].addr = rambuff_acm;
-	  push_empty( index, m );
-	  /* printk("  - Buffer : %lx\n",
-	   * dt3155_fbuffer[ m ]->frame_info[ index ].addr );
-	   */
-	  dt3155_fbuffer[ m ]->nbuffers += 1;
-	  rambuff_acm += bufsize;
+    rambuff_acm = rambuff_addr;
+    for (m = 0; m < ndevices; m++) {
+	rambuff_acm = adjust_4MB(rambuff_acm, bufsize);
+
+	/* Save the start of this boards buffer space (for mmap).  */
+	dt3155_status[m].mem_addr = rambuff_acm;
+
+	for (index = 0; index < numbufs; index++) {
+		rambuff_acm = adjust_4MB(rambuff_acm, bufsize);
+		if (rambuff_acm + bufsize > rambuff_end) {
+			/* Should never happen */
+			printk("DT3155 PROGRAM ERROR (GCS)\n"
+			"Error distributing allocated buffers\n");
+			return -ENOMEM;
+		}
+
+		dt3155_fbuffer[m]->frame_info[index].addr = rambuff_acm;
+		push_empty(index, m);
+		/* printk("  - Buffer : %lx\n",
+		* dt3155_fbuffer[m]->frame_info[index].addr);
+		*/
+		dt3155_fbuffer[m]->nbuffers += 1;
+		rambuff_acm += bufsize;
 	}
 
-      /* Make sure there is an active buffer there. */
-      dt3155_fbuffer[ m ]->active_buf    = pop_empty( m );
-      dt3155_fbuffer[ m ]->even_happened = 0;
-      dt3155_fbuffer[ m ]->even_stopped  = 0;
+	/* Make sure there is an active buffer there. */
+	dt3155_fbuffer[m]->active_buf    = pop_empty(m);
+	dt3155_fbuffer[m]->even_happened = 0;
+	dt3155_fbuffer[m]->even_stopped  = 0;
 
-      /* make sure there is no locked_buf JML 2/28/00 */
-      dt3155_fbuffer[ m ]->locked_buf = -1;
+	/* make sure there is no locked_buf JML 2/28/00 */
+	dt3155_fbuffer[m]->locked_buf = -1;
 
-      dt3155_status[ m ].mem_size =
-	rambuff_acm - dt3155_status[ m ].mem_addr;
+	dt3155_status[m].mem_size =
+	rambuff_acm - dt3155_status[m].mem_addr;
 
-      /* setup the ready queue */
-      dt3155_fbuffer[ m ]->ready_head = 0;
-      dt3155_fbuffer[ m ]->ready_len = 0;
-      printk("Available buffers for device %d: %d\n",
-	     m, dt3155_fbuffer[ m ]->nbuffers);
+	/* setup the ready queue */
+	dt3155_fbuffer[m]->ready_head = 0;
+	dt3155_fbuffer[m]->ready_len = 0;
+	printk("Available buffers for device %d: %d\n",
+	    m, dt3155_fbuffer[m]->nbuffers);
     }
 
-  return 1;
+    return 1;
 }
 
 /*****************************************************
@@ -415,13 +410,12 @@ u32 dt3155_setup_buffers(u32 *allocatorAddr)
  *
  * m is minor number of device
  *****************************************************/
-static inline void internal_release_locked_buffer( int m )
+static inline void internal_release_locked_buffer(int m)
 {
   /* Pointer into global structure for handling buffers */
-  if ( dt3155_fbuffer[ m ]->locked_buf >= 0 )
-    {
-      push_empty( dt3155_fbuffer[ m ]->locked_buf, m );
-      dt3155_fbuffer[ m ]->locked_buf = -1;
+    if (dt3155_fbuffer[m]->locked_buf >= 0) {
+	push_empty(dt3155_fbuffer[m]->locked_buf, m);
+	dt3155_fbuffer[m]->locked_buf = -1;
     }
 }
 
@@ -433,7 +427,7 @@ static inline void internal_release_locked_buffer( int m )
  * The user function of the above.
  *
  *****************************************************/
-inline void dt3155_release_locked_buffer( int m )
+inline void dt3155_release_locked_buffer(int m)
 {
 	unsigned long int flags;
 	local_save_flags(flags);
@@ -448,28 +442,28 @@ inline void dt3155_release_locked_buffer( int m )
  * m is minor # of device
  *
  *****************************************************/
-inline int dt3155_flush( int m )
+inline int dt3155_flush(int m)
 {
   int index;
   unsigned long int flags;
   local_save_flags(flags);
   local_irq_disable();
 
-  internal_release_locked_buffer( m );
-  dt3155_fbuffer[ m ]->empty_len = 0;
+  internal_release_locked_buffer(m);
+  dt3155_fbuffer[m]->empty_len = 0;
 
-  for ( index = 0; index < dt3155_fbuffer[ m ]->nbuffers; index++ )
-    push_empty( index,  m );
+    for (index = 0; index < dt3155_fbuffer[m]->nbuffers; index++)
+	push_empty(index,  m);
 
   /* Make sure there is an active buffer there. */
-  dt3155_fbuffer[ m ]->active_buf = pop_empty( m );
+  dt3155_fbuffer[m]->active_buf = pop_empty(m);
 
-  dt3155_fbuffer[ m ]->even_happened = 0;
-  dt3155_fbuffer[ m ]->even_stopped  = 0;
+  dt3155_fbuffer[m]->even_happened = 0;
+  dt3155_fbuffer[m]->even_stopped  = 0;
 
   /* setup the ready queue  */
-  dt3155_fbuffer[ m ]->ready_head = 0;
-  dt3155_fbuffer[ m ]->ready_len = 0;
+  dt3155_fbuffer[m]->ready_head = 0;
+  dt3155_fbuffer[m]->ready_len = 0;
 
   local_irq_restore(flags);
 
@@ -485,7 +479,7 @@ inline int dt3155_flush( int m )
  * If the user has a buffer locked it will unlock
  * that buffer before returning the new one.
  *****************************************************/
-inline int dt3155_get_ready_buffer( int m )
+inline int dt3155_get_ready_buffer(int m)
 {
   int frame_index;
   unsigned long int flags;
@@ -493,21 +487,20 @@ inline int dt3155_get_ready_buffer( int m )
   local_irq_disable();
 
 #ifdef DEBUG_QUES_A
-  printques( m );
+  printques(m);
 #endif
 
-  internal_release_locked_buffer( m );
+  internal_release_locked_buffer(m);
 
-  if (is_ready_buf_empty( m ))
-    frame_index = -1;
-  else
-    {
-      frame_index = pop_ready( m );
-      dt3155_fbuffer[ m ]->locked_buf = frame_index;
+    if (is_ready_buf_empty(m))
+	frame_index = -1;
+    else {
+	frame_index = pop_ready(m);
+	dt3155_fbuffer[m]->locked_buf = frame_index;
     }
 
 #ifdef DEBUG_QUES_B
-  printques( m );
+  printques(m);
 #endif
 
   local_irq_restore(flags);
-- 
1.7.0.2

