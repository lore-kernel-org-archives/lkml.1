Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbZBLBRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbZBLBRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbZBLBRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:17:05 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:45020 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236AbZBLBRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:17:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=WrSkZ9tq0wxzFNTxbbfkinEcWA8QmhHUE0UpwbjxpjhNNKKnvQINP+feumqGOHGOdz
         fJfweRn0pDyixA2rNyft5ubToGTMrX33EhNoWKHW5PawyKiuI/PfZhbLYVa5uhujK/2c
         CxevCYE30KEeew+zR4Bz+eOm9XfhnSs5i5JnE=
Subject: [PATCH] nfs: replace uses of __constant_{endian}
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 17:16:58 -0800
Message-Id: <1234401418.5566.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The base versions handle constant folding now, none of these headers
are exported to userspace, so the __ prefixed versions are not
necessary.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/lockd/xdr.h  |   12 ++--
 include/linux/lockd/xdr4.h |   10 ++--
 include/linux/nfsd/nfsd.h  |  132 ++++++++++++++++++++++----------------------
 include/linux/sunrpc/xdr.h |   42 +++++++-------
 4 files changed, 98 insertions(+), 98 deletions(-)

diff --git a/include/linux/lockd/xdr.h b/include/linux/lockd/xdr.h
index 7dc5b6c..d39ed1c 100644
--- a/include/linux/lockd/xdr.h
+++ b/include/linux/lockd/xdr.h
@@ -25,13 +25,13 @@ struct svc_rqst;
 #define NLM_MAXCOOKIELEN    	32
 #define NLM_MAXSTRLEN		1024
 
-#define	nlm_granted		__constant_htonl(NLM_LCK_GRANTED)
-#define	nlm_lck_denied		__constant_htonl(NLM_LCK_DENIED)
-#define	nlm_lck_denied_nolocks	__constant_htonl(NLM_LCK_DENIED_NOLOCKS)
-#define	nlm_lck_blocked		__constant_htonl(NLM_LCK_BLOCKED)
-#define	nlm_lck_denied_grace_period	__constant_htonl(NLM_LCK_DENIED_GRACE_PERIOD)
+#define	nlm_granted		cpu_to_be32(NLM_LCK_GRANTED)
+#define	nlm_lck_denied		cpu_to_be32(NLM_LCK_DENIED)
+#define	nlm_lck_denied_nolocks	cpu_to_be32(NLM_LCK_DENIED_NOLOCKS)
+#define	nlm_lck_blocked		cpu_to_be32(NLM_LCK_BLOCKED)
+#define	nlm_lck_denied_grace_period	cpu_to_be32(NLM_LCK_DENIED_GRACE_PERIOD)
 
-#define nlm_drop_reply		__constant_htonl(30000)
+#define nlm_drop_reply		cpu_to_be32(30000)
 
 /* Lock info passed via NLM */
 struct nlm_lock {
diff --git a/include/linux/lockd/xdr4.h b/include/linux/lockd/xdr4.h
index 12bfe09..7353821 100644
--- a/include/linux/lockd/xdr4.h
+++ b/include/linux/lockd/xdr4.h
@@ -15,11 +15,11 @@
 #include <linux/lockd/xdr.h>
 
 /* error codes new to NLMv4 */
-#define	nlm4_deadlock		__constant_htonl(NLM_DEADLCK)
-#define	nlm4_rofs		__constant_htonl(NLM_ROFS)
-#define	nlm4_stale_fh		__constant_htonl(NLM_STALE_FH)
-#define	nlm4_fbig		__constant_htonl(NLM_FBIG)
-#define	nlm4_failed		__constant_htonl(NLM_FAILED)
+#define	nlm4_deadlock		cpu_to_be32(NLM_DEADLCK)
+#define	nlm4_rofs		cpu_to_be32(NLM_ROFS)
+#define	nlm4_stale_fh		cpu_to_be32(NLM_STALE_FH)
+#define	nlm4_fbig		cpu_to_be32(NLM_FBIG)
+#define	nlm4_failed		cpu_to_be32(NLM_FAILED)
 
 
 
diff --git a/include/linux/nfsd/nfsd.h b/include/linux/nfsd/nfsd.h
index e19f459..16f7b40 100644
--- a/include/linux/nfsd/nfsd.h
+++ b/include/linux/nfsd/nfsd.h
@@ -186,78 +186,78 @@ void		nfsd_lockd_shutdown(void);
 /*
  * These macros provide pre-xdr'ed values for faster operation.
  */
-#define	nfs_ok			__constant_htonl(NFS_OK)
-#define	nfserr_perm		__constant_htonl(NFSERR_PERM)
-#define	nfserr_noent		__constant_htonl(NFSERR_NOENT)
-#define	nfserr_io		__constant_htonl(NFSERR_IO)
-#define	nfserr_nxio		__constant_htonl(NFSERR_NXIO)
-#define	nfserr_eagain		__constant_htonl(NFSERR_EAGAIN)
-#define	nfserr_acces		__constant_htonl(NFSERR_ACCES)
-#define	nfserr_exist		__constant_htonl(NFSERR_EXIST)
-#define	nfserr_xdev		__constant_htonl(NFSERR_XDEV)
-#define	nfserr_nodev		__constant_htonl(NFSERR_NODEV)
-#define	nfserr_notdir		__constant_htonl(NFSERR_NOTDIR)
-#define	nfserr_isdir		__constant_htonl(NFSERR_ISDIR)
-#define	nfserr_inval		__constant_htonl(NFSERR_INVAL)
-#define	nfserr_fbig		__constant_htonl(NFSERR_FBIG)
-#define	nfserr_nospc		__constant_htonl(NFSERR_NOSPC)
-#define	nfserr_rofs		__constant_htonl(NFSERR_ROFS)
-#define	nfserr_mlink		__constant_htonl(NFSERR_MLINK)
-#define	nfserr_opnotsupp	__constant_htonl(NFSERR_OPNOTSUPP)
-#define	nfserr_nametoolong	__constant_htonl(NFSERR_NAMETOOLONG)
-#define	nfserr_notempty		__constant_htonl(NFSERR_NOTEMPTY)
-#define	nfserr_dquot		__constant_htonl(NFSERR_DQUOT)
-#define	nfserr_stale		__constant_htonl(NFSERR_STALE)
-#define	nfserr_remote		__constant_htonl(NFSERR_REMOTE)
-#define	nfserr_wflush		__constant_htonl(NFSERR_WFLUSH)
-#define	nfserr_badhandle	__constant_htonl(NFSERR_BADHANDLE)
-#define	nfserr_notsync		__constant_htonl(NFSERR_NOT_SYNC)
-#define	nfserr_badcookie	__constant_htonl(NFSERR_BAD_COOKIE)
-#define	nfserr_notsupp		__constant_htonl(NFSERR_NOTSUPP)
-#define	nfserr_toosmall		__constant_htonl(NFSERR_TOOSMALL)
-#define	nfserr_serverfault	__constant_htonl(NFSERR_SERVERFAULT)
-#define	nfserr_badtype		__constant_htonl(NFSERR_BADTYPE)
-#define	nfserr_jukebox		__constant_htonl(NFSERR_JUKEBOX)
-#define	nfserr_denied		__constant_htonl(NFSERR_DENIED)
-#define	nfserr_deadlock		__constant_htonl(NFSERR_DEADLOCK)
-#define nfserr_expired          __constant_htonl(NFSERR_EXPIRED)
-#define	nfserr_bad_cookie	__constant_htonl(NFSERR_BAD_COOKIE)
-#define	nfserr_same		__constant_htonl(NFSERR_SAME)
-#define	nfserr_clid_inuse	__constant_htonl(NFSERR_CLID_INUSE)
-#define	nfserr_stale_clientid	__constant_htonl(NFSERR_STALE_CLIENTID)
-#define	nfserr_resource		__constant_htonl(NFSERR_RESOURCE)
-#define	nfserr_moved		__constant_htonl(NFSERR_MOVED)
-#define	nfserr_nofilehandle	__constant_htonl(NFSERR_NOFILEHANDLE)
-#define	nfserr_minor_vers_mismatch	__constant_htonl(NFSERR_MINOR_VERS_MISMATCH)
-#define nfserr_share_denied	__constant_htonl(NFSERR_SHARE_DENIED)
-#define nfserr_stale_stateid	__constant_htonl(NFSERR_STALE_STATEID)
-#define nfserr_old_stateid	__constant_htonl(NFSERR_OLD_STATEID)
-#define nfserr_bad_stateid	__constant_htonl(NFSERR_BAD_STATEID)
-#define nfserr_bad_seqid	__constant_htonl(NFSERR_BAD_SEQID)
-#define	nfserr_symlink		__constant_htonl(NFSERR_SYMLINK)
-#define	nfserr_not_same		__constant_htonl(NFSERR_NOT_SAME)
-#define	nfserr_restorefh	__constant_htonl(NFSERR_RESTOREFH)
-#define	nfserr_attrnotsupp	__constant_htonl(NFSERR_ATTRNOTSUPP)
-#define	nfserr_bad_xdr		__constant_htonl(NFSERR_BAD_XDR)
-#define	nfserr_openmode		__constant_htonl(NFSERR_OPENMODE)
-#define	nfserr_locks_held	__constant_htonl(NFSERR_LOCKS_HELD)
-#define	nfserr_op_illegal	__constant_htonl(NFSERR_OP_ILLEGAL)
-#define	nfserr_grace		__constant_htonl(NFSERR_GRACE)
-#define	nfserr_no_grace		__constant_htonl(NFSERR_NO_GRACE)
-#define	nfserr_reclaim_bad	__constant_htonl(NFSERR_RECLAIM_BAD)
-#define	nfserr_badname		__constant_htonl(NFSERR_BADNAME)
-#define	nfserr_cb_path_down	__constant_htonl(NFSERR_CB_PATH_DOWN)
-#define	nfserr_locked		__constant_htonl(NFSERR_LOCKED)
-#define	nfserr_wrongsec		__constant_htonl(NFSERR_WRONGSEC)
-#define	nfserr_replay_me	__constant_htonl(NFSERR_REPLAY_ME)
+#define	nfs_ok			cpu_to_be32(NFS_OK)
+#define	nfserr_perm		cpu_to_be32(NFSERR_PERM)
+#define	nfserr_noent		cpu_to_be32(NFSERR_NOENT)
+#define	nfserr_io		cpu_to_be32(NFSERR_IO)
+#define	nfserr_nxio		cpu_to_be32(NFSERR_NXIO)
+#define	nfserr_eagain		cpu_to_be32(NFSERR_EAGAIN)
+#define	nfserr_acces		cpu_to_be32(NFSERR_ACCES)
+#define	nfserr_exist		cpu_to_be32(NFSERR_EXIST)
+#define	nfserr_xdev		cpu_to_be32(NFSERR_XDEV)
+#define	nfserr_nodev		cpu_to_be32(NFSERR_NODEV)
+#define	nfserr_notdir		cpu_to_be32(NFSERR_NOTDIR)
+#define	nfserr_isdir		cpu_to_be32(NFSERR_ISDIR)
+#define	nfserr_inval		cpu_to_be32(NFSERR_INVAL)
+#define	nfserr_fbig		cpu_to_be32(NFSERR_FBIG)
+#define	nfserr_nospc		cpu_to_be32(NFSERR_NOSPC)
+#define	nfserr_rofs		cpu_to_be32(NFSERR_ROFS)
+#define	nfserr_mlink		cpu_to_be32(NFSERR_MLINK)
+#define	nfserr_opnotsupp	cpu_to_be32(NFSERR_OPNOTSUPP)
+#define	nfserr_nametoolong	cpu_to_be32(NFSERR_NAMETOOLONG)
+#define	nfserr_notempty		cpu_to_be32(NFSERR_NOTEMPTY)
+#define	nfserr_dquot		cpu_to_be32(NFSERR_DQUOT)
+#define	nfserr_stale		cpu_to_be32(NFSERR_STALE)
+#define	nfserr_remote		cpu_to_be32(NFSERR_REMOTE)
+#define	nfserr_wflush		cpu_to_be32(NFSERR_WFLUSH)
+#define	nfserr_badhandle	cpu_to_be32(NFSERR_BADHANDLE)
+#define	nfserr_notsync		cpu_to_be32(NFSERR_NOT_SYNC)
+#define	nfserr_badcookie	cpu_to_be32(NFSERR_BAD_COOKIE)
+#define	nfserr_notsupp		cpu_to_be32(NFSERR_NOTSUPP)
+#define	nfserr_toosmall		cpu_to_be32(NFSERR_TOOSMALL)
+#define	nfserr_serverfault	cpu_to_be32(NFSERR_SERVERFAULT)
+#define	nfserr_badtype		cpu_to_be32(NFSERR_BADTYPE)
+#define	nfserr_jukebox		cpu_to_be32(NFSERR_JUKEBOX)
+#define	nfserr_denied		cpu_to_be32(NFSERR_DENIED)
+#define	nfserr_deadlock		cpu_to_be32(NFSERR_DEADLOCK)
+#define nfserr_expired          cpu_to_be32(NFSERR_EXPIRED)
+#define	nfserr_bad_cookie	cpu_to_be32(NFSERR_BAD_COOKIE)
+#define	nfserr_same		cpu_to_be32(NFSERR_SAME)
+#define	nfserr_clid_inuse	cpu_to_be32(NFSERR_CLID_INUSE)
+#define	nfserr_stale_clientid	cpu_to_be32(NFSERR_STALE_CLIENTID)
+#define	nfserr_resource		cpu_to_be32(NFSERR_RESOURCE)
+#define	nfserr_moved		cpu_to_be32(NFSERR_MOVED)
+#define	nfserr_nofilehandle	cpu_to_be32(NFSERR_NOFILEHANDLE)
+#define	nfserr_minor_vers_mismatch	cpu_to_be32(NFSERR_MINOR_VERS_MISMATCH)
+#define nfserr_share_denied	cpu_to_be32(NFSERR_SHARE_DENIED)
+#define nfserr_stale_stateid	cpu_to_be32(NFSERR_STALE_STATEID)
+#define nfserr_old_stateid	cpu_to_be32(NFSERR_OLD_STATEID)
+#define nfserr_bad_stateid	cpu_to_be32(NFSERR_BAD_STATEID)
+#define nfserr_bad_seqid	cpu_to_be32(NFSERR_BAD_SEQID)
+#define	nfserr_symlink		cpu_to_be32(NFSERR_SYMLINK)
+#define	nfserr_not_same		cpu_to_be32(NFSERR_NOT_SAME)
+#define	nfserr_restorefh	cpu_to_be32(NFSERR_RESTOREFH)
+#define	nfserr_attrnotsupp	cpu_to_be32(NFSERR_ATTRNOTSUPP)
+#define	nfserr_bad_xdr		cpu_to_be32(NFSERR_BAD_XDR)
+#define	nfserr_openmode		cpu_to_be32(NFSERR_OPENMODE)
+#define	nfserr_locks_held	cpu_to_be32(NFSERR_LOCKS_HELD)
+#define	nfserr_op_illegal	cpu_to_be32(NFSERR_OP_ILLEGAL)
+#define	nfserr_grace		cpu_to_be32(NFSERR_GRACE)
+#define	nfserr_no_grace		cpu_to_be32(NFSERR_NO_GRACE)
+#define	nfserr_reclaim_bad	cpu_to_be32(NFSERR_RECLAIM_BAD)
+#define	nfserr_badname		cpu_to_be32(NFSERR_BADNAME)
+#define	nfserr_cb_path_down	cpu_to_be32(NFSERR_CB_PATH_DOWN)
+#define	nfserr_locked		cpu_to_be32(NFSERR_LOCKED)
+#define	nfserr_wrongsec		cpu_to_be32(NFSERR_WRONGSEC)
+#define	nfserr_replay_me	cpu_to_be32(NFSERR_REPLAY_ME)
 
 /* error codes for internal use */
 /* if a request fails due to kmalloc failure, it gets dropped.
  *  Client should resend eventually
  */
-#define	nfserr_dropit		__constant_htonl(30000)
+#define	nfserr_dropit		cpu_to_be32(30000)
 /* end-of-file indicator in readdir */
-#define	nfserr_eof		__constant_htonl(30001)
+#define	nfserr_eof		cpu_to_be32(30001)
 
 /* Check for dir entries '.' and '..' */
 #define isdotent(n, l)	(l < 3 && n[0] == '.' && (l == 1 || n[1] == '.'))
diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index 49e1eb4..d8910b6 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -69,27 +69,27 @@ struct xdr_buf {
  * pre-xdr'ed macros.
  */
 
-#define	xdr_zero	__constant_htonl(0)
-#define	xdr_one		__constant_htonl(1)
-#define	xdr_two		__constant_htonl(2)
-
-#define	rpc_success		__constant_htonl(RPC_SUCCESS)
-#define	rpc_prog_unavail	__constant_htonl(RPC_PROG_UNAVAIL)
-#define	rpc_prog_mismatch	__constant_htonl(RPC_PROG_MISMATCH)
-#define	rpc_proc_unavail	__constant_htonl(RPC_PROC_UNAVAIL)
-#define	rpc_garbage_args	__constant_htonl(RPC_GARBAGE_ARGS)
-#define	rpc_system_err		__constant_htonl(RPC_SYSTEM_ERR)
-#define	rpc_drop_reply		__constant_htonl(RPC_DROP_REPLY)
-
-#define	rpc_auth_ok		__constant_htonl(RPC_AUTH_OK)
-#define	rpc_autherr_badcred	__constant_htonl(RPC_AUTH_BADCRED)
-#define	rpc_autherr_rejectedcred __constant_htonl(RPC_AUTH_REJECTEDCRED)
-#define	rpc_autherr_badverf	__constant_htonl(RPC_AUTH_BADVERF)
-#define	rpc_autherr_rejectedverf __constant_htonl(RPC_AUTH_REJECTEDVERF)
-#define	rpc_autherr_tooweak	__constant_htonl(RPC_AUTH_TOOWEAK)
-#define	rpcsec_gsserr_credproblem	__constant_htonl(RPCSEC_GSS_CREDPROBLEM)
-#define	rpcsec_gsserr_ctxproblem	__constant_htonl(RPCSEC_GSS_CTXPROBLEM)
-#define	rpc_autherr_oldseqnum	__constant_htonl(101)
+#define	xdr_zero	cpu_to_be32(0)
+#define	xdr_one		cpu_to_be32(1)
+#define	xdr_two		cpu_to_be32(2)
+
+#define	rpc_success		cpu_to_be32(RPC_SUCCESS)
+#define	rpc_prog_unavail	cpu_to_be32(RPC_PROG_UNAVAIL)
+#define	rpc_prog_mismatch	cpu_to_be32(RPC_PROG_MISMATCH)
+#define	rpc_proc_unavail	cpu_to_be32(RPC_PROC_UNAVAIL)
+#define	rpc_garbage_args	cpu_to_be32(RPC_GARBAGE_ARGS)
+#define	rpc_system_err		cpu_to_be32(RPC_SYSTEM_ERR)
+#define	rpc_drop_reply		cpu_to_be32(RPC_DROP_REPLY)
+
+#define	rpc_auth_ok		cpu_to_be32(RPC_AUTH_OK)
+#define	rpc_autherr_badcred	cpu_to_be32(RPC_AUTH_BADCRED)
+#define	rpc_autherr_rejectedcred cpu_to_be32(RPC_AUTH_REJECTEDCRED)
+#define	rpc_autherr_badverf	cpu_to_be32(RPC_AUTH_BADVERF)
+#define	rpc_autherr_rejectedverf cpu_to_be32(RPC_AUTH_REJECTEDVERF)
+#define	rpc_autherr_tooweak	cpu_to_be32(RPC_AUTH_TOOWEAK)
+#define	rpcsec_gsserr_credproblem	cpu_to_be32(RPCSEC_GSS_CREDPROBLEM)
+#define	rpcsec_gsserr_ctxproblem	cpu_to_be32(RPCSEC_GSS_CTXPROBLEM)
+#define	rpc_autherr_oldseqnum	cpu_to_be32(101)
 
 /*
  * Miscellaneous XDR helper functions
-- 
1.6.2.rc0.218.gde7c



