Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYCDCDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYCDCDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 21:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbYCDCBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 21:01:17 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:14526 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbYCDCBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 21:01:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UClLfACSCvEY/LN+Zlfur1FllFOmzy0IJNwVgW46Kn6KMP3FleGjIZxQfTTrVrlowVunp056HSshs++CIyZOtIFdzS9M6tu5U2eIKpXHVVgUFj33vGrI9khjwZaCuzBQZRFaEpRFSu1ARGt80JerlZnjqf+6Tvnot2kMwB7ETXE=
Subject: [PATCH 05/13] xfs: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Christoph Hellwig <hch@lst.de>, xfs <xfs-masters@oss.sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
References: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 18:01:01 -0800
Message-Id: <1204596061.22933.57.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/xfs/linux-2.6/kmem.c      |    6 +++---
 fs/xfs/linux-2.6/xfs_buf.c   |    6 +++---
 fs/xfs/linux-2.6/xfs_super.c |    2 +-
 fs/xfs/linux-2.6/xfs_vnode.h |    4 ++--
 fs/xfs/xfs_alloc.c           |   18 +++++++++---------
 fs/xfs/xfs_bmap.c            |   18 +++++++++---------
 fs/xfs/xfs_bmap.h            |    2 +-
 fs/xfs/xfs_bmap_btree.c      |   16 ++++++++--------
 fs/xfs/xfs_filestream.c      |    2 +-
 fs/xfs/xfs_log.c             |    2 +-
 fs/xfs/xfs_log_recover.c     |    4 ++--
 fs/xfs/xfs_trans_ail.c       |    2 +-
 12 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/linux-2.6/kmem.c b/fs/xfs/linux-2.6/kmem.c
index e040f1c..9b1bb17 100644
--- a/fs/xfs/linux-2.6/kmem.c
+++ b/fs/xfs/linux-2.6/kmem.c
@@ -37,7 +37,7 @@ kmem_alloc(size_t size, unsigned int __nocast flags)
 #ifdef DEBUG
 	if (unlikely(!(flags & KM_LARGE) && (size > PAGE_SIZE))) {
 		printk(KERN_WARNING "Large %s attempt, size=%ld\n",
-			__FUNCTION__, (long)size);
+			__func__, (long)size);
 		dump_stack();
 	}
 #endif
@@ -52,7 +52,7 @@ kmem_alloc(size_t size, unsigned int __nocast flags)
 		if (!(++retries % 100))
 			printk(KERN_ERR "XFS: possible memory allocation "
 					"deadlock in %s (mode:0x%x)\n",
-					__FUNCTION__, lflags);
+					__func__, lflags);
 		congestion_wait(WRITE, HZ/50);
 	} while (1);
 }
@@ -129,7 +129,7 @@ kmem_zone_alloc(kmem_zone_t *zone, unsigned int __nocast flags)
 		if (!(++retries % 100))
 			printk(KERN_ERR "XFS: possible memory allocation "
 					"deadlock in %s (mode:0x%x)\n",
-					__FUNCTION__, lflags);
+					__func__, lflags);
 		congestion_wait(WRITE, HZ/50);
 	} while (1);
 }
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index e347bfd..142ddbe 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -400,7 +400,7 @@ _xfs_buf_lookup_pages(
 				printk(KERN_ERR
 					"XFS: possible memory allocation "
 					"deadlock in %s (mode:0x%x)\n",
-					__FUNCTION__, gfp_mask);
+					__func__, gfp_mask);
 
 			XFS_STATS_INC(xb_page_retries);
 			xfsbufd_wakeup(0, gfp_mask);
@@ -598,7 +598,7 @@ xfs_buf_get_flags(
 		error = _xfs_buf_map_pages(bp, flags);
 		if (unlikely(error)) {
 			printk(KERN_WARNING "%s: failed to map pages\n",
-					__FUNCTION__);
+					__func__);
 			goto no_buffer;
 		}
 	}
@@ -778,7 +778,7 @@ xfs_buf_get_noaddr(
 	error = _xfs_buf_map_pages(bp, XBF_MAPPED);
 	if (unlikely(error)) {
 		printk(KERN_WARNING "%s: failed to map pages\n",
-				__FUNCTION__);
+				__func__);
 		goto fail_free_mem;
 	}
 
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 8831d95..a21bb40 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -934,7 +934,7 @@ xfs_fs_clear_inode(
 		xfs_inactive(ip);
 		xfs_iflags_clear(ip, XFS_IMODIFIED);
 		if (xfs_reclaim(ip))
-			panic("%s: cannot reclaim 0x%p\n", __FUNCTION__, inode);
+			panic("%s: cannot reclaim 0x%p\n", __func__, inode);
 	}
 
 	ASSERT(XFS_I(inode) == NULL);
diff --git a/fs/xfs/linux-2.6/xfs_vnode.h b/fs/xfs/linux-2.6/xfs_vnode.h
index b5ea418..46d8237 100644
--- a/fs/xfs/linux-2.6/xfs_vnode.h
+++ b/fs/xfs/linux-2.6/xfs_vnode.h
@@ -303,9 +303,9 @@ extern void xfs_itrace_hold(struct xfs_inode *, char *, int, inst_t *);
 extern void _xfs_itrace_ref(struct xfs_inode *, char *, int, inst_t *);
 extern void xfs_itrace_rele(struct xfs_inode *, char *, int, inst_t *);
 #define xfs_itrace_entry(ip)	\
-	_xfs_itrace_entry(ip, __FUNCTION__, (inst_t *)__return_address)
+	_xfs_itrace_entry(ip, __func__, (inst_t *)__return_address)
 #define xfs_itrace_exit(ip)	\
-	_xfs_itrace_exit(ip, __FUNCTION__, (inst_t *)__return_address)
+	_xfs_itrace_exit(ip, __func__, (inst_t *)__return_address)
 #define xfs_itrace_exit_tag(ip, tag)	\
 	_xfs_itrace_exit(ip, tag, (inst_t *)__return_address)
 #define xfs_itrace_ref(ip)	\
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index bdbfbbe..bd5c017 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -55,17 +55,17 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 ktrace_t *xfs_alloc_trace_buf;
 
 #define	TRACE_ALLOC(s,a)	\
-	xfs_alloc_trace_alloc(__FUNCTION__, s, a, __LINE__)
+	xfs_alloc_trace_alloc(__func__, s, a, __LINE__)
 #define	TRACE_FREE(s,a,b,x,f)	\
-	xfs_alloc_trace_free(__FUNCTION__, s, mp, a, b, x, f, __LINE__)
+	xfs_alloc_trace_free(__func__, s, mp, a, b, x, f, __LINE__)
 #define	TRACE_MODAGF(s,a,f)	\
-	xfs_alloc_trace_modagf(__FUNCTION__, s, mp, a, f, __LINE__)
-#define	TRACE_BUSY(__FUNCTION__,s,ag,agb,l,sl,tp)	\
-	xfs_alloc_trace_busy(__FUNCTION__, s, mp, ag, agb, l, sl, tp, XFS_ALLOC_KTRACE_BUSY, __LINE__)
-#define	TRACE_UNBUSY(__FUNCTION__,s,ag,sl,tp)	\
-	xfs_alloc_trace_busy(__FUNCTION__, s, mp, ag, -1, -1, sl, tp, XFS_ALLOC_KTRACE_UNBUSY, __LINE__)
-#define	TRACE_BUSYSEARCH(__FUNCTION__,s,ag,agb,l,sl,tp)	\
-	xfs_alloc_trace_busy(__FUNCTION__, s, mp, ag, agb, l, sl, tp, XFS_ALLOC_KTRACE_BUSYSEARCH, __LINE__)
+	xfs_alloc_trace_modagf(__func__, s, mp, a, f, __LINE__)
+#define	TRACE_BUSY(__func__,s,ag,agb,l,sl,tp)	\
+	xfs_alloc_trace_busy(__func__, s, mp, ag, agb, l, sl, tp, XFS_ALLOC_KTRACE_BUSY, __LINE__)
+#define	TRACE_UNBUSY(__func__,s,ag,sl,tp)	\
+	xfs_alloc_trace_busy(__func__, s, mp, ag, -1, -1, sl, tp, XFS_ALLOC_KTRACE_UNBUSY, __LINE__)
+#define	TRACE_BUSYSEARCH(__func__,s,ag,agb,l,sl,tp)	\
+	xfs_alloc_trace_busy(__func__, s, mp, ag, agb, l, sl, tp, XFS_ALLOC_KTRACE_BUSYSEARCH, __LINE__)
 #else
 #define	TRACE_ALLOC(s,a)
 #define	TRACE_FREE(s,a,b,x,f)
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 1c0a5a5..798e276 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -323,13 +323,13 @@ xfs_bmap_trace_pre_update(
 	int		whichfork);	/* data or attr fork */
 
 #define	XFS_BMAP_TRACE_DELETE(d,ip,i,c,w)	\
-	xfs_bmap_trace_delete(__FUNCTION__,d,ip,i,c,w)
+	xfs_bmap_trace_delete(__func__,d,ip,i,c,w)
 #define	XFS_BMAP_TRACE_INSERT(d,ip,i,c,r1,r2,w)	\
-	xfs_bmap_trace_insert(__FUNCTION__,d,ip,i,c,r1,r2,w)
+	xfs_bmap_trace_insert(__func__,d,ip,i,c,r1,r2,w)
 #define	XFS_BMAP_TRACE_POST_UPDATE(d,ip,i,w)	\
-	xfs_bmap_trace_post_update(__FUNCTION__,d,ip,i,w)
+	xfs_bmap_trace_post_update(__func__,d,ip,i,w)
 #define	XFS_BMAP_TRACE_PRE_UPDATE(d,ip,i,w)	\
-	xfs_bmap_trace_pre_update(__FUNCTION__,d,ip,i,w)
+	xfs_bmap_trace_pre_update(__func__,d,ip,i,w)
 #else
 #define	XFS_BMAP_TRACE_DELETE(d,ip,i,c,w)
 #define	XFS_BMAP_TRACE_INSERT(d,ip,i,c,r1,r2,w)
@@ -6162,10 +6162,10 @@ xfs_check_block(
 			}
 			if (*thispa == *pp) {
 				cmn_err(CE_WARN, "%s: thispa(%d) == pp(%d) %Ld",
-					__FUNCTION__, j, i,
+					__func__, j, i,
 					(unsigned long long)be64_to_cpu(*thispa));
 				panic("%s: ptrs are equal in node\n",
-					__FUNCTION__);
+					__func__);
 			}
 		}
 	}
@@ -6325,13 +6325,13 @@ xfs_bmap_check_leaf_extents(
 	return;
 
 error0:
-	cmn_err(CE_WARN, "%s: at error0", __FUNCTION__);
+	cmn_err(CE_WARN, "%s: at error0", __func__);
 	if (bp_release)
 		xfs_trans_brelse(NULL, bp);
 error_norelse:
 	cmn_err(CE_WARN, "%s: BAD after btree leaves for %d extents",
-		__FUNCTION__, i);
-	panic("%s: CORRUPTED BTREE OR SOMETHING", __FUNCTION__);
+		__func__, i);
+	panic("%s: CORRUPTED BTREE OR SOMETHING", __func__);
 	return;
 }
 #endif
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 87224b7..6ff70cd 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -151,7 +151,7 @@ xfs_bmap_trace_exlist(
 	xfs_extnum_t		cnt,		/* count of entries in list */
 	int			whichfork);	/* data or attr fork */
 #define	XFS_BMAP_TRACE_EXLIST(ip,c,w)	\
-	xfs_bmap_trace_exlist(__FUNCTION__,ip,c,w)
+	xfs_bmap_trace_exlist(__func__,ip,c,w)
 #else
 #define	XFS_BMAP_TRACE_EXLIST(ip,c,w)
 #endif
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index bd18987..f155c21 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -275,21 +275,21 @@ xfs_bmbt_trace_cursor(
 }
 
 #define	XFS_BMBT_TRACE_ARGBI(c,b,i)	\
-	xfs_bmbt_trace_argbi(__FUNCTION__, c, b, i, __LINE__)
+	xfs_bmbt_trace_argbi(__func__, c, b, i, __LINE__)
 #define	XFS_BMBT_TRACE_ARGBII(c,b,i,j)	\
-	xfs_bmbt_trace_argbii(__FUNCTION__, c, b, i, j, __LINE__)
+	xfs_bmbt_trace_argbii(__func__, c, b, i, j, __LINE__)
 #define	XFS_BMBT_TRACE_ARGFFFI(c,o,b,i,j)	\
-	xfs_bmbt_trace_argfffi(__FUNCTION__, c, o, b, i, j, __LINE__)
+	xfs_bmbt_trace_argfffi(__func__, c, o, b, i, j, __LINE__)
 #define	XFS_BMBT_TRACE_ARGI(c,i)	\
-	xfs_bmbt_trace_argi(__FUNCTION__, c, i, __LINE__)
+	xfs_bmbt_trace_argi(__func__, c, i, __LINE__)
 #define	XFS_BMBT_TRACE_ARGIFK(c,i,f,s)	\
-	xfs_bmbt_trace_argifk(__FUNCTION__, c, i, f, s, __LINE__)
+	xfs_bmbt_trace_argifk(__func__, c, i, f, s, __LINE__)
 #define	XFS_BMBT_TRACE_ARGIFR(c,i,f,r)	\
-	xfs_bmbt_trace_argifr(__FUNCTION__, c, i, f, r, __LINE__)
+	xfs_bmbt_trace_argifr(__func__, c, i, f, r, __LINE__)
 #define	XFS_BMBT_TRACE_ARGIK(c,i,k)	\
-	xfs_bmbt_trace_argik(__FUNCTION__, c, i, k, __LINE__)
+	xfs_bmbt_trace_argik(__func__, c, i, k, __LINE__)
 #define	XFS_BMBT_TRACE_CURSOR(c,s)	\
-	xfs_bmbt_trace_cursor(__FUNCTION__, c, s, __LINE__)
+	xfs_bmbt_trace_cursor(__func__, c, s, __LINE__)
 #else
 #define	XFS_BMBT_TRACE_ARGBI(c,b,i)
 #define	XFS_BMBT_TRACE_ARGBII(c,b,i,j)
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index eb03eab..3f3785b 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -73,7 +73,7 @@ xfs_filestreams_trace(
 #define TRACE4(mp,t,a0,a1,a2,a3)	TRACE6(mp,t,a0,a1,a2,a3,0,0)
 #define TRACE5(mp,t,a0,a1,a2,a3,a4)	TRACE6(mp,t,a0,a1,a2,a3,a4,0)
 #define TRACE6(mp,t,a0,a1,a2,a3,a4,a5) \
-	xfs_filestreams_trace(mp, t, __FUNCTION__, __LINE__, \
+	xfs_filestreams_trace(mp, t, __func__, __LINE__, \
 				(__psunsigned_t)a0, (__psunsigned_t)a1, \
 				(__psunsigned_t)a2, (__psunsigned_t)a3, \
 				(__psunsigned_t)a4, (__psunsigned_t)a5)
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a75edca..a2f2928 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2241,7 +2241,7 @@ xlog_state_do_callback(
 			repeats = 0;
 			xfs_fs_cmn_err(CE_WARN, log->l_mp,
 				"%s: possible infinite loop (%d iterations)",
-				__FUNCTION__, flushcnt);
+				__func__, flushcnt);
 		}
 	} while (!ioerrors && loopdidcallbacks);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b82d5d4..003785d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -191,7 +191,7 @@ xlog_header_check_dump(
 {
 	int			b;
 
-	cmn_err(CE_DEBUG, "%s:  SB : uuid = ", __FUNCTION__);
+	cmn_err(CE_DEBUG, "%s:  SB : uuid = ", __func__);
 	for (b = 0; b < 16; b++)
 		cmn_err(CE_DEBUG, "%02x", ((uchar_t *)&mp->m_sb.sb_uuid)[b]);
 	cmn_err(CE_DEBUG, ", fmt = %d\n", XLOG_FMT);
@@ -3445,7 +3445,7 @@ xlog_valid_rec_header(
 	    (!rhead->h_version ||
 	    (be32_to_cpu(rhead->h_version) & (~XLOG_VERSION_OKBITS))))) {
 		xlog_warn("XFS: %s: unrecognised log version (%d).",
-			__FUNCTION__, be32_to_cpu(rhead->h_version));
+			__func__, be32_to_cpu(rhead->h_version));
 		return XFS_ERROR(EIO);
 	}
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 4d6330e..9982d1a 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -437,7 +437,7 @@ xfs_trans_delete_ail(
 		else {
 			xfs_cmn_err(XFS_PTAG_AILDELETE, CE_ALERT, mp,
 		"%s: attempting to delete a log item that is not in the AIL",
-					__FUNCTION__);
+					__func__);
 			spin_unlock(&mp->m_ail_lock);
 			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		}
-- 
1.5.4.3.500.g83a2c


