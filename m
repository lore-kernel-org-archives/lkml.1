Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbYGPUQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbYGPUQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 16:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYGPUQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 16:16:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:41173 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbYGPUQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 16:16:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=vCI9K6xlzLLNiWW/XArAXXmX+q+BE7KTTLjNrEs217YgOy708zw+ofB+gkN33X9/6P
         dsO9Lxh5gE5BKSkxrHjqLBU9VSQvU52z6G1ymqDYuYhkQYvEbVCM/l6LVNh/a/Ik7lWi
         2Q9eUQeCvWtet43QwFZ7cuENse7KyTEMCjjm0=
Subject: [PATCH] dlm: sparse endian annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Teigland <teigland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 13:16:07 -0700
Message-Id: <1216239367.28841.22.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/dlm/dir.c:419:14: warning: incorrect type in assignment (different base types)
fs/dlm/dir.c:419:14:    expected unsigned short [unsigned] [addressable] [assigned] [usertype] be_namelen
fs/dlm/dir.c:419:14:    got restricted __be16 [usertype] <noident>

fs/dlm/util.c:27:17: warning: incorrect type in assignment (different base types)
fs/dlm/util.c:27:17:    expected unsigned int [unsigned] [usertype] h_version
fs/dlm/util.c:27:17:    got restricted __le32 [usertype] <noident>
..lots more...

fs/dlm/util.c:149:17: warning: cast to restricted __le32
fs/dlm/util.c:150:19: warning: cast to restricted __le32
fs/dlm/util.c:151:15: warning: cast to restricted __le64
fs/dlm/util.c:152:16: warning: cast to restricted __le64
fs/dlm/util.c:153:21: warning: cast to restricted __le64

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/dlm/dir.c  |   18 ++++----
 fs/dlm/util.c |  148 ++++++++++++++++++++++++++++----------------------------
 2 files changed, 83 insertions(+), 83 deletions(-)

diff --git a/fs/dlm/dir.c b/fs/dlm/dir.c
index 85defeb..92969f8 100644
--- a/fs/dlm/dir.c
+++ b/fs/dlm/dir.c
@@ -374,7 +374,7 @@ void dlm_copy_master_names(struct dlm_ls *ls, char *inbuf, int inlen,
 	struct list_head *list;
 	struct dlm_rsb *r;
 	int offset = 0, dir_nodeid;
-	uint16_t be_namelen;
+	__be16 be_namelen;
 
 	down_read(&ls->ls_root_sem);
 
@@ -410,15 +410,15 @@ void dlm_copy_master_names(struct dlm_ls *ls, char *inbuf, int inlen,
 
 		if (offset + sizeof(uint16_t)*2 + r->res_length > outlen) {
 			/* Write end-of-block record */
-			be_namelen = 0;
-			memcpy(outbuf + offset, &be_namelen, sizeof(uint16_t));
-			offset += sizeof(uint16_t);
+			be_namelen = cpu_to_be16(0);
+			memcpy(outbuf + offset, &be_namelen, sizeof(__be16));
+			offset += sizeof(__be16);
 			goto out;
 		}
 
 		be_namelen = cpu_to_be16(r->res_length);
-		memcpy(outbuf + offset, &be_namelen, sizeof(uint16_t));
-		offset += sizeof(uint16_t);
+		memcpy(outbuf + offset, &be_namelen, sizeof(__be16));
+		offset += sizeof(__be16);
 		memcpy(outbuf + offset, r->res_name, r->res_length);
 		offset += r->res_length;
 	}
@@ -430,9 +430,9 @@ void dlm_copy_master_names(struct dlm_ls *ls, char *inbuf, int inlen,
 
 	if ((list == &ls->ls_root_list) &&
 	    (offset + sizeof(uint16_t) <= outlen)) {
-		be_namelen = 0xFFFF;
-		memcpy(outbuf + offset, &be_namelen, sizeof(uint16_t));
-		offset += sizeof(uint16_t);
+		be_namelen = cpu_to_be16(0xFFFF);
+		memcpy(outbuf + offset, &be_namelen, sizeof(__be16));
+		offset += sizeof(__be16);
 	}
 
  out:
diff --git a/fs/dlm/util.c b/fs/dlm/util.c
index e36520a..2341e16 100644
--- a/fs/dlm/util.c
+++ b/fs/dlm/util.c
@@ -24,131 +24,131 @@
 
 static void header_out(struct dlm_header *hd)
 {
-	hd->h_version		= cpu_to_le32(hd->h_version);
-	hd->h_lockspace		= cpu_to_le32(hd->h_lockspace);
-	hd->h_nodeid		= cpu_to_le32(hd->h_nodeid);
-	hd->h_length		= cpu_to_le16(hd->h_length);
+	cpu_to_le32s(&hd->h_version);
+	cpu_to_le32s(&hd->h_lockspace);
+	cpu_to_le32s(&hd->h_nodeid);
+	cpu_to_le16s(&hd->h_length);
 }
 
 static void header_in(struct dlm_header *hd)
 {
-	hd->h_version		= le32_to_cpu(hd->h_version);
-	hd->h_lockspace		= le32_to_cpu(hd->h_lockspace);
-	hd->h_nodeid		= le32_to_cpu(hd->h_nodeid);
-	hd->h_length		= le16_to_cpu(hd->h_length);
+	le32_to_cpus(&hd->h_version);
+	le32_to_cpus(&hd->h_lockspace);
+	le32_to_cpus(&hd->h_nodeid);
+	le16_to_cpus(&hd->h_length);
 }
 
 /* higher errno values are inconsistent across architectures, so select
    one set of values for on the wire */
 
-static int to_dlm_errno(int err)
+static void to_dlm_errno(int *err)
 {
-	switch (err) {
+	switch (*err) {
 	case -EDEADLK:
-		return -DLM_ERRNO_EDEADLK;
+		*err = -DLM_ERRNO_EDEADLK;
 	case -EBADR:
-		return -DLM_ERRNO_EBADR;
+		*err = -DLM_ERRNO_EBADR;
 	case -EBADSLT:
-		return -DLM_ERRNO_EBADSLT;
+		*err = -DLM_ERRNO_EBADSLT;
 	case -EPROTO:
-		return -DLM_ERRNO_EPROTO;
+		*err = -DLM_ERRNO_EPROTO;
 	case -EOPNOTSUPP:
-		return -DLM_ERRNO_EOPNOTSUPP;
+		*err = -DLM_ERRNO_EOPNOTSUPP;
 	case -ETIMEDOUT:
-		return -DLM_ERRNO_ETIMEDOUT;
+		*err = -DLM_ERRNO_ETIMEDOUT;
 	case -EINPROGRESS:
-		return -DLM_ERRNO_EINPROGRESS;
+		*err = -DLM_ERRNO_EINPROGRESS;
 	}
-	return err;
+	cpu_to_le32s(err);
 }
 
-static int from_dlm_errno(int err)
+static void from_dlm_errno(int *err)
 {
-	switch (err) {
+	le32_to_cpus(err);
+	switch (*err) {
 	case -DLM_ERRNO_EDEADLK:
-		return -EDEADLK;
+		*err = -EDEADLK;
 	case -DLM_ERRNO_EBADR:
-		return -EBADR;
+		*err = -EBADR;
 	case -DLM_ERRNO_EBADSLT:
-		return -EBADSLT;
+		*err = -EBADSLT;
 	case -DLM_ERRNO_EPROTO:
-		return -EPROTO;
+		*err = -EPROTO;
 	case -DLM_ERRNO_EOPNOTSUPP:
-		return -EOPNOTSUPP;
+		*err = -EOPNOTSUPP;
 	case -DLM_ERRNO_ETIMEDOUT:
-		return -ETIMEDOUT;
+		*err = -ETIMEDOUT;
 	case -DLM_ERRNO_EINPROGRESS:
-		return -EINPROGRESS;
+		*err = -EINPROGRESS;
 	}
-	return err;
 }
 
 void dlm_message_out(struct dlm_message *ms)
 {
 	header_out(&ms->m_header);
 
-	ms->m_type		= cpu_to_le32(ms->m_type);
-	ms->m_nodeid		= cpu_to_le32(ms->m_nodeid);
-	ms->m_pid		= cpu_to_le32(ms->m_pid);
-	ms->m_lkid		= cpu_to_le32(ms->m_lkid);
-	ms->m_remid		= cpu_to_le32(ms->m_remid);
-	ms->m_parent_lkid	= cpu_to_le32(ms->m_parent_lkid);
-	ms->m_parent_remid	= cpu_to_le32(ms->m_parent_remid);
-	ms->m_exflags		= cpu_to_le32(ms->m_exflags);
-	ms->m_sbflags		= cpu_to_le32(ms->m_sbflags);
-	ms->m_flags		= cpu_to_le32(ms->m_flags);
-	ms->m_lvbseq		= cpu_to_le32(ms->m_lvbseq);
-	ms->m_hash		= cpu_to_le32(ms->m_hash);
-	ms->m_status		= cpu_to_le32(ms->m_status);
-	ms->m_grmode		= cpu_to_le32(ms->m_grmode);
-	ms->m_rqmode		= cpu_to_le32(ms->m_rqmode);
-	ms->m_bastmode		= cpu_to_le32(ms->m_bastmode);
-	ms->m_asts		= cpu_to_le32(ms->m_asts);
-	ms->m_result		= cpu_to_le32(to_dlm_errno(ms->m_result));
+	cpu_to_le32s(&ms->m_type);
+	cpu_to_le32s(&ms->m_nodeid);
+	cpu_to_le32s(&ms->m_pid);
+	cpu_to_le32s(&ms->m_lkid);
+	cpu_to_le32s(&ms->m_remid);
+	cpu_to_le32s(&ms->m_parent_lkid);
+	cpu_to_le32s(&ms->m_parent_remid);
+	cpu_to_le32s(&ms->m_exflags);
+	cpu_to_le32s(&ms->m_sbflags);
+	cpu_to_le32s(&ms->m_flags);
+	cpu_to_le32s(&ms->m_lvbseq);
+	cpu_to_le32s(&ms->m_hash);
+	cpu_to_le32s(&ms->m_status);
+	cpu_to_le32s(&ms->m_grmode);
+	cpu_to_le32s(&ms->m_rqmode);
+	cpu_to_le32s(&ms->m_bastmode);
+	cpu_to_le32s(&ms->m_asts);
+	to_dlm_errno(&ms->m_result);
 }
 
 void dlm_message_in(struct dlm_message *ms)
 {
 	header_in(&ms->m_header);
 
-	ms->m_type		= le32_to_cpu(ms->m_type);
-	ms->m_nodeid		= le32_to_cpu(ms->m_nodeid);
-	ms->m_pid		= le32_to_cpu(ms->m_pid);
-	ms->m_lkid		= le32_to_cpu(ms->m_lkid);
-	ms->m_remid		= le32_to_cpu(ms->m_remid);
-	ms->m_parent_lkid	= le32_to_cpu(ms->m_parent_lkid);
-	ms->m_parent_remid	= le32_to_cpu(ms->m_parent_remid);
-	ms->m_exflags		= le32_to_cpu(ms->m_exflags);
-	ms->m_sbflags		= le32_to_cpu(ms->m_sbflags);
-	ms->m_flags		= le32_to_cpu(ms->m_flags);
-	ms->m_lvbseq		= le32_to_cpu(ms->m_lvbseq);
-	ms->m_hash		= le32_to_cpu(ms->m_hash);
-	ms->m_status		= le32_to_cpu(ms->m_status);
-	ms->m_grmode		= le32_to_cpu(ms->m_grmode);
-	ms->m_rqmode		= le32_to_cpu(ms->m_rqmode);
-	ms->m_bastmode		= le32_to_cpu(ms->m_bastmode);
-	ms->m_asts		= le32_to_cpu(ms->m_asts);
-	ms->m_result		= from_dlm_errno(le32_to_cpu(ms->m_result));
+	le32_to_cpus(&ms->m_type);
+	le32_to_cpus(&ms->m_nodeid);
+	le32_to_cpus(&ms->m_pid);
+	le32_to_cpus(&ms->m_lkid);
+	le32_to_cpus(&ms->m_remid);
+	le32_to_cpus(&ms->m_parent_lkid);
+	le32_to_cpus(&ms->m_parent_remid);
+	le32_to_cpus(&ms->m_exflags);
+	le32_to_cpus(&ms->m_sbflags);
+	le32_to_cpus(&ms->m_flags);
+	le32_to_cpus(&ms->m_lvbseq);
+	le32_to_cpus(&ms->m_hash);
+	le32_to_cpus(&ms->m_status);
+	le32_to_cpus(&ms->m_grmode);
+	le32_to_cpus(&ms->m_rqmode);
+	le32_to_cpus(&ms->m_bastmode);
+	le32_to_cpus(&ms->m_asts);
+	from_dlm_errno(&ms->m_result);
 }
 
 void dlm_rcom_out(struct dlm_rcom *rc)
 {
 	header_out(&rc->rc_header);
 
-	rc->rc_type		= cpu_to_le32(rc->rc_type);
-	rc->rc_result		= cpu_to_le32(rc->rc_result);
-	rc->rc_id		= cpu_to_le64(rc->rc_id);
-	rc->rc_seq		= cpu_to_le64(rc->rc_seq);
-	rc->rc_seq_reply	= cpu_to_le64(rc->rc_seq_reply);
+	cpu_to_le32s(&rc->rc_type);
+	cpu_to_le32s(&rc->rc_result);
+	cpu_to_le64s(&rc->rc_id);
+	cpu_to_le64s(&rc->rc_seq);
+	cpu_to_le64s(&rc->rc_seq_reply);
 }
 
 void dlm_rcom_in(struct dlm_rcom *rc)
 {
 	header_in(&rc->rc_header);
 
-	rc->rc_type		= le32_to_cpu(rc->rc_type);
-	rc->rc_result		= le32_to_cpu(rc->rc_result);
-	rc->rc_id		= le64_to_cpu(rc->rc_id);
-	rc->rc_seq		= le64_to_cpu(rc->rc_seq);
-	rc->rc_seq_reply	= le64_to_cpu(rc->rc_seq_reply);
+	le32_to_cpus(&rc->rc_type);
+	le32_to_cpus(&rc->rc_result);
+	le64_to_cpus(&rc->rc_id);
+	le64_to_cpus(&rc->rc_seq);
+	le64_to_cpus(&rc->rc_seq_reply);
 }
-- 
1.5.6.3.499.geae9



