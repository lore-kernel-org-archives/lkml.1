Return-Path: <linux-kernel-owner+w=401wt.eu-S933733AbZJIQC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733AbZJIQC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933086AbZJIQC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:02:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933366AbZJIQCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:02:25 -0400
Date: Fri, 9 Oct 2009 12:01:16 -0400
From: Jason Baron <jbaron@redhat.com>
To: swhiteho@redhat.com
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: move gfs2 tracepoints to inclue/trace/events dir
Message-ID: <20091009160115.GA2647@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I'd like to move the gfs2 tracepoints to the the common
include/trace/events directory along with all of the other trace events.
It makes understanding what tracepoints are available easier, and I see
no reason why gfs2 should be different. For example, 'ext4.h' is already
in the include/trace/events directory.

thanks,

-Jason


Signed-off-by: Jason Baron <jbaron@redhat.com>

---

 fs/gfs2/bmap.c              |    2 
 fs/gfs2/glock.c             |    3 
 fs/gfs2/log.c               |    2 
 fs/gfs2/lops.c              |    2 
 fs/gfs2/ops_fstype.c        |    2 
 fs/gfs2/rgrp.c              |    2 
 fs/gfs2/trace_gfs2.h        |  407 -------------------------------------------
 include/trace/events/gfs2.h |  404 +++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 411 insertions(+), 413 deletions(-)
 delete mode 100644 fs/gfs2/trace_gfs2.h
 create mode 100644 include/trace/events/gfs2.h


diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 6d47379..5e630c3 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -13,6 +13,7 @@
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
+#include <trace/events/gfs2.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -25,7 +26,6 @@
 #include "trans.h"
 #include "dir.h"
 #include "util.h"
-#include "trace_gfs2.h"
 
 /* This doesn't need to be that large as max 64 bit pointers in a 4k
  * block is 512, so __u16 is fine for that. It saves stack space to
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index a3f90ad..1239076 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -39,8 +39,9 @@
 #include "super.h"
 #include "util.h"
 #include "bmap.h"
+
 #define CREATE_TRACE_POINTS
-#include "trace_gfs2.h"
+#include <trace/events/gfs2.h>
 
 struct gfs2_gl_hash_bucket {
         struct hlist_head hb_list;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 13c6237..70beadc 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -18,6 +18,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/bio.h>
+#include <trace/events/gfs2.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -28,7 +29,6 @@
 #include "meta_io.h"
 #include "util.h"
 #include "dir.h"
-#include "trace_gfs2.h"
 
 #define PULL 1
 
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 9969ff0..c038ae6 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -15,6 +15,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/bio.h>
 #include <linux/fs.h>
+#include <trace/events/gfs2.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -27,7 +28,6 @@
 #include "rgrp.h"
 #include "trans.h"
 #include "util.h"
-#include "trace_gfs2.h"
 
 /**
  * gfs2_pin - Pin a buffer in memory
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 36b11cb..6b3d6cb 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -19,6 +19,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/slow-work.h>
 #include <linux/quotaops.h>
+#include <trace/events/gfs2.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -34,7 +35,6 @@
 #include "log.h"
 #include "quota.h"
 #include "dir.h"
-#include "trace_gfs2.h"
 
 #define DO 0
 #define UNDO 1
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 8f1cfb0..15332af 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -15,6 +15,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/prefetch.h>
 #include <linux/blkdev.h>
+#include <trace/events/gfs2.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -29,7 +30,6 @@
 #include "util.h"
 #include "log.h"
 #include "inode.h"
-#include "trace_gfs2.h"
 
 #define BFITNOENT ((u32)~0)
 #define NO_BLOCK ((u64)~0)
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
deleted file mode 100644
index 148d55c..0000000
--- a/fs/gfs2/trace_gfs2.h
+++ /dev/null
@@ -1,407 +0,0 @@
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM gfs2
-
-#if !defined(_TRACE_GFS2_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_GFS2_H
-
-#include <linux/tracepoint.h>
-
-#include <linux/fs.h>
-#include <linux/buffer_head.h>
-#include <linux/dlmconstants.h>
-#include <linux/gfs2_ondisk.h>
-#include "incore.h"
-#include "glock.h"
-
-#define dlm_state_name(nn) { DLM_LOCK_##nn, #nn }
-#define glock_trace_name(x) __print_symbolic(x,		\
-			    dlm_state_name(IV),		\
-			    dlm_state_name(NL),		\
-			    dlm_state_name(CR),		\
-			    dlm_state_name(CW),		\
-			    dlm_state_name(PR),		\
-			    dlm_state_name(PW),		\
-			    dlm_state_name(EX))
-
-#define block_state_name(x) __print_symbolic(x,			\
-			    { GFS2_BLKST_FREE, "free" },	\
-			    { GFS2_BLKST_USED, "used" },	\
-			    { GFS2_BLKST_DINODE, "dinode" },	\
-			    { GFS2_BLKST_UNLINKED, "unlinked" })
-
-#define show_glock_flags(flags) __print_flags(flags, "",	\
-	{(1UL << GLF_LOCK),			"l" },		\
-	{(1UL << GLF_DEMOTE),			"D" },		\
-	{(1UL << GLF_PENDING_DEMOTE),		"d" },		\
-	{(1UL << GLF_DEMOTE_IN_PROGRESS),	"p" },		\
-	{(1UL << GLF_DIRTY),			"y" },		\
-	{(1UL << GLF_LFLUSH),			"f" },		\
-	{(1UL << GLF_INVALIDATE_IN_PROGRESS),	"i" },		\
-	{(1UL << GLF_REPLY_PENDING),		"r" },		\
-	{(1UL << GLF_INITIAL),			"I" },		\
-	{(1UL << GLF_FROZEN),			"F" })
-
-#ifndef NUMPTY
-#define NUMPTY
-static inline u8 glock_trace_state(unsigned int state)
-{
-	switch(state) {
-	case LM_ST_SHARED:
-		return DLM_LOCK_PR;
-	case LM_ST_DEFERRED:
-		return DLM_LOCK_CW;
-	case LM_ST_EXCLUSIVE:
-		return DLM_LOCK_EX;
-	}
-	return DLM_LOCK_NL;
-}
-#endif
-
-/* Section 1 - Locking
- *
- * Objectives:
- * Latency: Remote demote request to state change
- * Latency: Local lock request to state change
- * Latency: State change to lock grant
- * Correctness: Ordering of local lock state vs. I/O requests
- * Correctness: Responses to remote demote requests
- */
-
-/* General glock state change (DLM lock request completes) */
-TRACE_EVENT(gfs2_glock_state_change,
-
-	TP_PROTO(const struct gfs2_glock *gl, unsigned int new_state),
-
-	TP_ARGS(gl, new_state),
-
-	TP_STRUCT__entry(
-		__field(	dev_t,	dev			)
-		__field(	u64,	glnum			)
-		__field(	u32,	gltype			)
-		__field(	u8,	cur_state		)
-		__field(	u8,	new_state		)
-		__field(	u8,	dmt_state		)
-		__field(	u8,	tgt_state		)
-		__field(	unsigned long,	flags		)
-	),
-
-	TP_fast_assign(
-		__entry->dev		= gl->gl_sbd->sd_vfs->s_dev;
-		__entry->glnum		= gl->gl_name.ln_number;
-		__entry->gltype		= gl->gl_name.ln_type;
-		__entry->cur_state	= glock_trace_state(gl->gl_state);
-		__entry->new_state	= glock_trace_state(new_state);
-		__entry->tgt_state	= glock_trace_state(gl->gl_target);
-		__entry->dmt_state	= glock_trace_state(gl->gl_demote_state);
-		__entry->flags		= gl->gl_flags;
-	),
-
-	TP_printk("%u,%u glock %d:%lld state %s to %s tgt:%s dmt:%s flags:%s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->gltype,
-		 (unsigned long long)__entry->glnum,
-		  glock_trace_name(__entry->cur_state),
-		  glock_trace_name(__entry->new_state),
-		  glock_trace_name(__entry->tgt_state),
-		  glock_trace_name(__entry->dmt_state),
-		  show_glock_flags(__entry->flags))
-);
-
-/* State change -> unlocked, glock is being deallocated */
-TRACE_EVENT(gfs2_glock_put,
-
-	TP_PROTO(const struct gfs2_glock *gl),
-
-	TP_ARGS(gl),
-
-	TP_STRUCT__entry(
-		__field(        dev_t,  dev                     )
-		__field(	u64,	glnum			)
-		__field(	u32,	gltype			)
-		__field(	u8,	cur_state		)
-		__field(	unsigned long,	flags		)
-	),
-
-	TP_fast_assign(
-		__entry->dev		= gl->gl_sbd->sd_vfs->s_dev;
-		__entry->gltype		= gl->gl_name.ln_type;
-		__entry->glnum		= gl->gl_name.ln_number;
-		__entry->cur_state	= glock_trace_state(gl->gl_state);
-		__entry->flags		= gl->gl_flags;
-	),
-
-	TP_printk("%u,%u glock %d:%lld state %s => %s flags:%s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-                  __entry->gltype, (unsigned long long)__entry->glnum,
-                  glock_trace_name(__entry->cur_state),
-		  glock_trace_name(DLM_LOCK_IV),
-		  show_glock_flags(__entry->flags))
-
-);
-
-/* Callback (local or remote) requesting lock demotion */
-TRACE_EVENT(gfs2_demote_rq,
-
-	TP_PROTO(const struct gfs2_glock *gl),
-
-	TP_ARGS(gl),
-
-	TP_STRUCT__entry(
-		__field(        dev_t,  dev                     )
-		__field(	u64,	glnum			)
-		__field(	u32,	gltype			)
-		__field(	u8,	cur_state		)
-		__field(	u8,	dmt_state		)
-		__field(	unsigned long,	flags		)
-	),
-
-	TP_fast_assign(
-		__entry->dev		= gl->gl_sbd->sd_vfs->s_dev;
-		__entry->gltype		= gl->gl_name.ln_type;
-		__entry->glnum		= gl->gl_name.ln_number;
-		__entry->cur_state	= glock_trace_state(gl->gl_state);
-		__entry->dmt_state	= glock_trace_state(gl->gl_demote_state);
-		__entry->flags		= gl->gl_flags;
-	),
-
-	TP_printk("%u,%u glock %d:%lld demote %s to %s flags:%s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->gltype,
-		  (unsigned long long)__entry->glnum,
-                  glock_trace_name(__entry->cur_state),
-                  glock_trace_name(__entry->dmt_state),
-		  show_glock_flags(__entry->flags))
-
-);
-
-/* Promotion/grant of a glock */
-TRACE_EVENT(gfs2_promote,
-
-	TP_PROTO(const struct gfs2_holder *gh, int first),
-
-	TP_ARGS(gh, first),
-
-	TP_STRUCT__entry(
-		__field(        dev_t,  dev                     )
-		__field(	u64,	glnum			)
-		__field(	u32,	gltype			)
-		__field(	int,	first			)
-		__field(	u8,	state			)
-	),
-
-	TP_fast_assign(
-		__entry->dev	= gh->gh_gl->gl_sbd->sd_vfs->s_dev;
-		__entry->glnum	= gh->gh_gl->gl_name.ln_number;
-		__entry->gltype	= gh->gh_gl->gl_name.ln_type;
-		__entry->first	= first;
-		__entry->state	= glock_trace_state(gh->gh_state);
-	),
-
-	TP_printk("%u,%u glock %u:%llu promote %s %s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->gltype,
-		  (unsigned long long)__entry->glnum,
-		  __entry->first ? "first": "other",
-		  glock_trace_name(__entry->state))
-);
-
-/* Queue/dequeue a lock request */
-TRACE_EVENT(gfs2_glock_queue,
-
-	TP_PROTO(const struct gfs2_holder *gh, int queue),
-
-	TP_ARGS(gh, queue),
-
-	TP_STRUCT__entry(
-		__field(        dev_t,  dev                     )
-		__field(	u64,	glnum			)
-		__field(	u32,	gltype			)
-		__field(	int,	queue			)
-		__field(	u8,	state			)
-	),
-
-	TP_fast_assign(
-		__entry->dev	= gh->gh_gl->gl_sbd->sd_vfs->s_dev;
-		__entry->glnum	= gh->gh_gl->gl_name.ln_number;
-		__entry->gltype	= gh->gh_gl->gl_name.ln_type;
-		__entry->queue	= queue;
-		__entry->state	= glock_trace_state(gh->gh_state);
-	),
-
-	TP_printk("%u,%u glock %u:%llu %squeue %s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->gltype,
-		  (unsigned long long)__entry->glnum,
-		  __entry->queue ? "" : "de",
-		  glock_trace_name(__entry->state))
-);
-
-/* Section 2 - Log/journal
- *
- * Objectives:
- * Latency: Log flush time
- * Correctness: pin/unpin vs. disk I/O ordering
- * Performance: Log usage stats
- */
-
-/* Pin/unpin a block in the log */
-TRACE_EVENT(gfs2_pin,
-
-	TP_PROTO(const struct gfs2_bufdata *bd, int pin),
-
-	TP_ARGS(bd, pin),
-
-	TP_STRUCT__entry(
-		__field(        dev_t,  dev                     )
-		__field(	int,	pin			)
-		__field(	u32,	len			)
-		__field(	sector_t,	block		)
-		__field(	u64,	ino			)
-	),
-
-	TP_fast_assign(
-		__entry->dev		= bd->bd_gl->gl_sbd->sd_vfs->s_dev;
-		__entry->pin		= pin;
-		__entry->len		= bd->bd_bh->b_size;
-		__entry->block		= bd->bd_bh->b_blocknr;
-		__entry->ino		= bd->bd_gl->gl_name.ln_number;
-	),
-
-	TP_printk("%u,%u log %s %llu/%lu inode %llu",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->pin ? "pin" : "unpin",
-		  (unsigned long long)__entry->block,
-		  (unsigned long)__entry->len,
-		  (unsigned long long)__entry->ino)
-);
-
-/* Flushing the log */
-TRACE_EVENT(gfs2_log_flush,
-
-	TP_PROTO(const struct gfs2_sbd *sdp, int start),
-
-	TP_ARGS(sdp, start),
-
-	TP_STRUCT__entry(
-		__field(        dev_t,  dev                     )
-		__field(	int,	start			)
-		__field(	u64,	log_seq			)
-	),
-
-	TP_fast_assign(
-		__entry->dev            = sdp->sd_vfs->s_dev;
-		__entry->start		= start;
-		__entry->log_seq	= sdp->sd_log_sequence;
-	),
-
-	TP_printk("%u,%u log flush %s %llu",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->start ? "start" : "end",
-		  (unsigned long long)__entry->log_seq)
-);
-
-/* Reserving/releasing blocks in the log */
-TRACE_EVENT(gfs2_log_blocks,
-
-	TP_PROTO(const struct gfs2_sbd *sdp, int blocks),
-
-	TP_ARGS(sdp, blocks),
-
-	TP_STRUCT__entry(
-		__field(        dev_t,  dev                     )
-		__field(	int,	blocks			)
-	),
-
-	TP_fast_assign(
-		__entry->dev		= sdp->sd_vfs->s_dev;
-		__entry->blocks		= blocks;
-	),
-
-	TP_printk("%u,%u log reserve %d", MAJOR(__entry->dev),
-		  MINOR(__entry->dev), __entry->blocks)
-);
-
-/* Section 3 - bmap
- *
- * Objectives:
- * Latency: Bmap request time
- * Performance: Block allocator tracing
- * Correctness: Test of disard generation vs. blocks allocated
- */
-
-/* Map an extent of blocks, possibly a new allocation */
-TRACE_EVENT(gfs2_bmap,
-
-	TP_PROTO(const struct gfs2_inode *ip, const struct buffer_head *bh,
-		sector_t lblock, int create, int errno),
-
-	TP_ARGS(ip, bh, lblock, create, errno),
-
-	TP_STRUCT__entry(
-		__field(        dev_t,  dev                     )
-		__field(	sector_t, lblock		)
-		__field(	sector_t, pblock		)
-		__field(	u64,	inum			)
-		__field(	unsigned long, state		)
-		__field(	u32,	len			)
-		__field(	int,	create			)
-		__field(	int,	errno			)
-	),
-
-	TP_fast_assign(
-		__entry->dev            = ip->i_gl->gl_sbd->sd_vfs->s_dev;
-		__entry->lblock		= lblock;
-		__entry->pblock		= buffer_mapped(bh) ?  bh->b_blocknr : 0;
-		__entry->inum		= ip->i_no_addr;
-		__entry->state		= bh->b_state;
-		__entry->len		= bh->b_size;
-		__entry->create		= create;
-		__entry->errno		= errno;
-	),
-
-	TP_printk("%u,%u bmap %llu map %llu/%lu to %llu flags:%08lx %s %d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  (unsigned long long)__entry->inum,
-		  (unsigned long long)__entry->lblock,
-		  (unsigned long)__entry->len,
-		  (unsigned long long)__entry->pblock,
-		  __entry->state, __entry->create ? "create " : "nocreate",
-		  __entry->errno)
-);
-
-/* Keep track of blocks as they are allocated/freed */
-TRACE_EVENT(gfs2_block_alloc,
-
-	TP_PROTO(const struct gfs2_inode *ip, u64 block, unsigned len,
-		u8 block_state),
-
-	TP_ARGS(ip, block, len, block_state),
-
-	TP_STRUCT__entry(
-		__field(        dev_t,  dev                     )
-		__field(	u64,	start			)
-		__field(	u64,	inum			)
-		__field(	u32,	len			)
-		__field(	u8,	block_state		)
-	),
-
-	TP_fast_assign(
-		__entry->dev		= ip->i_gl->gl_sbd->sd_vfs->s_dev;
-		__entry->start		= block;
-		__entry->inum		= ip->i_no_addr;
-		__entry->len		= len;
-		__entry->block_state	= block_state;
-	),
-
-	TP_printk("%u,%u bmap %llu alloc %llu/%lu %s",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  (unsigned long long)__entry->inum,
-		  (unsigned long long)__entry->start,
-		  (unsigned long)__entry->len,
-		  block_state_name(__entry->block_state))
-);
-
-#endif /* _TRACE_GFS2_H */
-
-/* This part must be outside protection */
-#undef TRACE_INCLUDE_PATH
-#define TRACE_INCLUDE_PATH .
-#define TRACE_INCLUDE_FILE trace_gfs2
-#include <trace/define_trace.h>
-
diff --git a/include/trace/events/gfs2.h b/include/trace/events/gfs2.h
new file mode 100644
index 0000000..38db1b7
--- /dev/null
+++ b/include/trace/events/gfs2.h
@@ -0,0 +1,404 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM gfs2
+
+#if !defined(_TRACE_GFS2_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_GFS2_H
+
+#include <linux/tracepoint.h>
+
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/dlmconstants.h>
+#include <linux/gfs2_ondisk.h>
+#include "../../../fs/gfs2/incore.h"
+#include "../../../fs/gfs2/glock.h"
+
+#define dlm_state_name(nn) { DLM_LOCK_##nn, #nn }
+#define glock_trace_name(x) __print_symbolic(x,		\
+			    dlm_state_name(IV),		\
+			    dlm_state_name(NL),		\
+			    dlm_state_name(CR),		\
+			    dlm_state_name(CW),		\
+			    dlm_state_name(PR),		\
+			    dlm_state_name(PW),		\
+			    dlm_state_name(EX))
+
+#define block_state_name(x) __print_symbolic(x,			\
+			    { GFS2_BLKST_FREE, "free" },	\
+			    { GFS2_BLKST_USED, "used" },	\
+			    { GFS2_BLKST_DINODE, "dinode" },	\
+			    { GFS2_BLKST_UNLINKED, "unlinked" })
+
+#define show_glock_flags(flags) __print_flags(flags, "",	\
+	{(1UL << GLF_LOCK),			"l" },		\
+	{(1UL << GLF_DEMOTE),			"D" },		\
+	{(1UL << GLF_PENDING_DEMOTE),		"d" },		\
+	{(1UL << GLF_DEMOTE_IN_PROGRESS),	"p" },		\
+	{(1UL << GLF_DIRTY),			"y" },		\
+	{(1UL << GLF_LFLUSH),			"f" },		\
+	{(1UL << GLF_INVALIDATE_IN_PROGRESS),	"i" },		\
+	{(1UL << GLF_REPLY_PENDING),		"r" },		\
+	{(1UL << GLF_INITIAL),			"I" },		\
+	{(1UL << GLF_FROZEN),			"F" })
+
+#ifndef NUMPTY
+#define NUMPTY
+static inline u8 glock_trace_state(unsigned int state)
+{
+	switch(state) {
+	case LM_ST_SHARED:
+		return DLM_LOCK_PR;
+	case LM_ST_DEFERRED:
+		return DLM_LOCK_CW;
+	case LM_ST_EXCLUSIVE:
+		return DLM_LOCK_EX;
+	}
+	return DLM_LOCK_NL;
+}
+#endif
+
+/* Section 1 - Locking
+ *
+ * Objectives:
+ * Latency: Remote demote request to state change
+ * Latency: Local lock request to state change
+ * Latency: State change to lock grant
+ * Correctness: Ordering of local lock state vs. I/O requests
+ * Correctness: Responses to remote demote requests
+ */
+
+/* General glock state change (DLM lock request completes) */
+TRACE_EVENT(gfs2_glock_state_change,
+
+	TP_PROTO(const struct gfs2_glock *gl, unsigned int new_state),
+
+	TP_ARGS(gl, new_state),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	u64,	glnum			)
+		__field(	u32,	gltype			)
+		__field(	u8,	cur_state		)
+		__field(	u8,	new_state		)
+		__field(	u8,	dmt_state		)
+		__field(	u8,	tgt_state		)
+		__field(	unsigned long,	flags		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= gl->gl_sbd->sd_vfs->s_dev;
+		__entry->glnum		= gl->gl_name.ln_number;
+		__entry->gltype		= gl->gl_name.ln_type;
+		__entry->cur_state	= glock_trace_state(gl->gl_state);
+		__entry->new_state	= glock_trace_state(new_state);
+		__entry->tgt_state	= glock_trace_state(gl->gl_target);
+		__entry->dmt_state	= glock_trace_state(gl->gl_demote_state);
+		__entry->flags		= gl->gl_flags;
+	),
+
+	TP_printk("%u,%u glock %d:%lld state %s to %s tgt:%s dmt:%s flags:%s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->gltype,
+		 (unsigned long long)__entry->glnum,
+		  glock_trace_name(__entry->cur_state),
+		  glock_trace_name(__entry->new_state),
+		  glock_trace_name(__entry->tgt_state),
+		  glock_trace_name(__entry->dmt_state),
+		  show_glock_flags(__entry->flags))
+);
+
+/* State change -> unlocked, glock is being deallocated */
+TRACE_EVENT(gfs2_glock_put,
+
+	TP_PROTO(const struct gfs2_glock *gl),
+
+	TP_ARGS(gl),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	u64,	glnum			)
+		__field(	u32,	gltype			)
+		__field(	u8,	cur_state		)
+		__field(	unsigned long,	flags		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= gl->gl_sbd->sd_vfs->s_dev;
+		__entry->gltype		= gl->gl_name.ln_type;
+		__entry->glnum		= gl->gl_name.ln_number;
+		__entry->cur_state	= glock_trace_state(gl->gl_state);
+		__entry->flags		= gl->gl_flags;
+	),
+
+	TP_printk("%u,%u glock %d:%lld state %s => %s flags:%s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+                  __entry->gltype, (unsigned long long)__entry->glnum,
+                  glock_trace_name(__entry->cur_state),
+		  glock_trace_name(DLM_LOCK_IV),
+		  show_glock_flags(__entry->flags))
+
+);
+
+/* Callback (local or remote) requesting lock demotion */
+TRACE_EVENT(gfs2_demote_rq,
+
+	TP_PROTO(const struct gfs2_glock *gl),
+
+	TP_ARGS(gl),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	u64,	glnum			)
+		__field(	u32,	gltype			)
+		__field(	u8,	cur_state		)
+		__field(	u8,	dmt_state		)
+		__field(	unsigned long,	flags		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= gl->gl_sbd->sd_vfs->s_dev;
+		__entry->gltype		= gl->gl_name.ln_type;
+		__entry->glnum		= gl->gl_name.ln_number;
+		__entry->cur_state	= glock_trace_state(gl->gl_state);
+		__entry->dmt_state	= glock_trace_state(gl->gl_demote_state);
+		__entry->flags		= gl->gl_flags;
+	),
+
+	TP_printk("%u,%u glock %d:%lld demote %s to %s flags:%s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->gltype,
+		  (unsigned long long)__entry->glnum,
+                  glock_trace_name(__entry->cur_state),
+                  glock_trace_name(__entry->dmt_state),
+		  show_glock_flags(__entry->flags))
+
+);
+
+/* Promotion/grant of a glock */
+TRACE_EVENT(gfs2_promote,
+
+	TP_PROTO(const struct gfs2_holder *gh, int first),
+
+	TP_ARGS(gh, first),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	u64,	glnum			)
+		__field(	u32,	gltype			)
+		__field(	int,	first			)
+		__field(	u8,	state			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= gh->gh_gl->gl_sbd->sd_vfs->s_dev;
+		__entry->glnum	= gh->gh_gl->gl_name.ln_number;
+		__entry->gltype	= gh->gh_gl->gl_name.ln_type;
+		__entry->first	= first;
+		__entry->state	= glock_trace_state(gh->gh_state);
+	),
+
+	TP_printk("%u,%u glock %u:%llu promote %s %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->gltype,
+		  (unsigned long long)__entry->glnum,
+		  __entry->first ? "first": "other",
+		  glock_trace_name(__entry->state))
+);
+
+/* Queue/dequeue a lock request */
+TRACE_EVENT(gfs2_glock_queue,
+
+	TP_PROTO(const struct gfs2_holder *gh, int queue),
+
+	TP_ARGS(gh, queue),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	u64,	glnum			)
+		__field(	u32,	gltype			)
+		__field(	int,	queue			)
+		__field(	u8,	state			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= gh->gh_gl->gl_sbd->sd_vfs->s_dev;
+		__entry->glnum	= gh->gh_gl->gl_name.ln_number;
+		__entry->gltype	= gh->gh_gl->gl_name.ln_type;
+		__entry->queue	= queue;
+		__entry->state	= glock_trace_state(gh->gh_state);
+	),
+
+	TP_printk("%u,%u glock %u:%llu %squeue %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->gltype,
+		  (unsigned long long)__entry->glnum,
+		  __entry->queue ? "" : "de",
+		  glock_trace_name(__entry->state))
+);
+
+/* Section 2 - Log/journal
+ *
+ * Objectives:
+ * Latency: Log flush time
+ * Correctness: pin/unpin vs. disk I/O ordering
+ * Performance: Log usage stats
+ */
+
+/* Pin/unpin a block in the log */
+TRACE_EVENT(gfs2_pin,
+
+	TP_PROTO(const struct gfs2_bufdata *bd, int pin),
+
+	TP_ARGS(bd, pin),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	int,	pin			)
+		__field(	u32,	len			)
+		__field(	sector_t,	block		)
+		__field(	u64,	ino			)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bd->bd_gl->gl_sbd->sd_vfs->s_dev;
+		__entry->pin		= pin;
+		__entry->len		= bd->bd_bh->b_size;
+		__entry->block		= bd->bd_bh->b_blocknr;
+		__entry->ino		= bd->bd_gl->gl_name.ln_number;
+	),
+
+	TP_printk("%u,%u log %s %llu/%lu inode %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->pin ? "pin" : "unpin",
+		  (unsigned long long)__entry->block,
+		  (unsigned long)__entry->len,
+		  (unsigned long long)__entry->ino)
+);
+
+/* Flushing the log */
+TRACE_EVENT(gfs2_log_flush,
+
+	TP_PROTO(const struct gfs2_sbd *sdp, int start),
+
+	TP_ARGS(sdp, start),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	int,	start			)
+		__field(	u64,	log_seq			)
+	),
+
+	TP_fast_assign(
+		__entry->dev            = sdp->sd_vfs->s_dev;
+		__entry->start		= start;
+		__entry->log_seq	= sdp->sd_log_sequence;
+	),
+
+	TP_printk("%u,%u log flush %s %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->start ? "start" : "end",
+		  (unsigned long long)__entry->log_seq)
+);
+
+/* Reserving/releasing blocks in the log */
+TRACE_EVENT(gfs2_log_blocks,
+
+	TP_PROTO(const struct gfs2_sbd *sdp, int blocks),
+
+	TP_ARGS(sdp, blocks),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	int,	blocks			)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= sdp->sd_vfs->s_dev;
+		__entry->blocks		= blocks;
+	),
+
+	TP_printk("%u,%u log reserve %d", MAJOR(__entry->dev),
+		  MINOR(__entry->dev), __entry->blocks)
+);
+
+/* Section 3 - bmap
+ *
+ * Objectives:
+ * Latency: Bmap request time
+ * Performance: Block allocator tracing
+ * Correctness: Test of disard generation vs. blocks allocated
+ */
+
+/* Map an extent of blocks, possibly a new allocation */
+TRACE_EVENT(gfs2_bmap,
+
+	TP_PROTO(const struct gfs2_inode *ip, const struct buffer_head *bh,
+		sector_t lblock, int create, int errno),
+
+	TP_ARGS(ip, bh, lblock, create, errno),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	sector_t, lblock		)
+		__field(	sector_t, pblock		)
+		__field(	u64,	inum			)
+		__field(	unsigned long, state		)
+		__field(	u32,	len			)
+		__field(	int,	create			)
+		__field(	int,	errno			)
+	),
+
+	TP_fast_assign(
+		__entry->dev            = ip->i_gl->gl_sbd->sd_vfs->s_dev;
+		__entry->lblock		= lblock;
+		__entry->pblock		= buffer_mapped(bh) ?  bh->b_blocknr : 0;
+		__entry->inum		= ip->i_no_addr;
+		__entry->state		= bh->b_state;
+		__entry->len		= bh->b_size;
+		__entry->create		= create;
+		__entry->errno		= errno;
+	),
+
+	TP_printk("%u,%u bmap %llu map %llu/%lu to %llu flags:%08lx %s %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long long)__entry->inum,
+		  (unsigned long long)__entry->lblock,
+		  (unsigned long)__entry->len,
+		  (unsigned long long)__entry->pblock,
+		  __entry->state, __entry->create ? "create " : "nocreate",
+		  __entry->errno)
+);
+
+/* Keep track of blocks as they are allocated/freed */
+TRACE_EVENT(gfs2_block_alloc,
+
+	TP_PROTO(const struct gfs2_inode *ip, u64 block, unsigned len,
+		u8 block_state),
+
+	TP_ARGS(ip, block, len, block_state),
+
+	TP_STRUCT__entry(
+		__field(        dev_t,  dev                     )
+		__field(	u64,	start			)
+		__field(	u64,	inum			)
+		__field(	u32,	len			)
+		__field(	u8,	block_state		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= ip->i_gl->gl_sbd->sd_vfs->s_dev;
+		__entry->start		= block;
+		__entry->inum		= ip->i_no_addr;
+		__entry->len		= len;
+		__entry->block_state	= block_state;
+	),
+
+	TP_printk("%u,%u bmap %llu alloc %llu/%lu %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long long)__entry->inum,
+		  (unsigned long long)__entry->start,
+		  (unsigned long)__entry->len,
+		  block_state_name(__entry->block_state))
+);
+
+#endif /* _TRACE_GFS2_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+

