Return-Path: <linux-kernel-owner+w=401wt.eu-S1756294AbYECWnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbYECWnu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 18:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYECWnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 18:43:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:10572 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbYECWnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 18:43:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=AOMZpqBPgIh1lbnDr08DuSrAlSL5X3nk8L8xncTpH7weGS5uxi3+JQ/9r6X6dIOnGfgTo8dey2i4BaY7bwViwYiEQlRNa2G3OMnLleZsUKMHzSuc9yswGDabdCBEDdVClYG/Dpy2WNPYOgfKXONhX6POVKBKExZFsHAx5hr4usI=
Date: Sun, 4 May 2008 00:42:46 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: eparis@redhat.com, viro@zeniv.linux.org.uk
Subject: [PATCH] xfrm: convert empty xfrm_audit_* macros to functions
Message-ID: <20080503224130.GA6120@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it removes these warnings when CONFIG_AUDITSYSCALL is unset:

net/xfrm/xfrm_user.c: In function 'xfrm_add_sa':
net/xfrm/xfrm_user.c:412: warning: unused variable 'sid'
net/xfrm/xfrm_user.c:411: warning: unused variable 'sessionid'
net/xfrm/xfrm_user.c:410: warning: unused variable 'loginuid'
net/xfrm/xfrm_user.c: In function 'xfrm_del_sa':
net/xfrm/xfrm_user.c:485: warning: unused variable 'sid'
net/xfrm/xfrm_user.c:484: warning: unused variable 'sessionid'
net/xfrm/xfrm_user.c:483: warning: unused variable 'loginuid'
net/xfrm/xfrm_user.c: In function 'xfrm_add_policy':
net/xfrm/xfrm_user.c:1132: warning: unused variable 'sid'
net/xfrm/xfrm_user.c:1131: warning: unused variable 'sessionid'
net/xfrm/xfrm_user.c:1130: warning: unused variable 'loginuid'
net/xfrm/xfrm_user.c: In function 'xfrm_get_policy':
net/xfrm/xfrm_user.c:1382: warning: unused variable 'sid'
net/xfrm/xfrm_user.c:1381: warning: unused variable 'sessionid'
net/xfrm/xfrm_user.c:1380: warning: unused variable 'loginuid'
net/xfrm/xfrm_user.c: In function 'xfrm_add_pol_expire':
net/xfrm/xfrm_user.c:1620: warning: unused variable 'sid'
net/xfrm/xfrm_user.c:1619: warning: unused variable 'sessionid'
net/xfrm/xfrm_user.c:1618: warning: unused variable 'loginuid'
net/xfrm/xfrm_user.c: In function 'xfrm_add_sa_expire':
net/xfrm/xfrm_user.c:1658: warning: unused variable 'sid'
net/xfrm/xfrm_user.c:1657: warning: unused variable 'sessionid'
net/xfrm/xfrm_user.c:1656: warning: unused variable 'loginuid'

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 xfrm.h |   48 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 8 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index d1350bc..2933d74 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -648,14 +648,46 @@ extern void xfrm_audit_state_notfound(struct sk_buff *skb, u16 family,
 extern void xfrm_audit_state_icvfail(struct xfrm_state *x,
 				     struct sk_buff *skb, u8 proto);
 #else
-#define xfrm_audit_policy_add(x, r, a, se, s)	do { ; } while (0)
-#define xfrm_audit_policy_delete(x, r, a, se, s)	do { ; } while (0)
-#define xfrm_audit_state_add(x, r, a, se, s)	do { ; } while (0)
-#define xfrm_audit_state_delete(x, r, a, se, s)	do { ; } while (0)
-#define xfrm_audit_state_replay_overflow(x, s)	do { ; } while (0)
-#define xfrm_audit_state_notfound_simple(s, f)	do { ; } while (0)
-#define xfrm_audit_state_notfound(s, f, sp, sq)	do { ; } while (0)
-#define xfrm_audit_state_icvfail(x, s, p)	do { ; } while (0)
+
+static inline void xfrm_audit_policy_add(struct xfrm_policy *xp, int result,
+				  u32 auid, u32 ses, u32 secid)
+{
+}
+
+static inline void xfrm_audit_policy_delete(struct xfrm_policy *xp, int result,
+				  u32 auid, u32 ses, u32 secid)
+{
+}
+
+static inline void xfrm_audit_state_add(struct xfrm_state *x, int result,
+				 u32 auid, u32 ses, u32 secid)
+{
+}
+
+static inline void xfrm_audit_state_delete(struct xfrm_state *x, int result,
+				    u32 auid, u32 ses, u32 secid)
+{
+}
+
+static inline void xfrm_audit_state_replay_overflow(struct xfrm_state *x,
+					     struct sk_buff *skb)
+{
+}
+
+static inline void xfrm_audit_state_notfound_simple(struct sk_buff *skb,
+				      u16 family)
+{
+}
+
+static inline void xfrm_audit_state_notfound(struct sk_buff *skb, u16 family,
+				      __be32 net_spi, __be32 net_seq)
+{
+}
+
+static inline void xfrm_audit_state_icvfail(struct xfrm_state *x,
+				     struct sk_buff *skb, u8 proto)
+{
+}
 #endif /* CONFIG_AUDITSYSCALL */
 
 static inline void xfrm_pol_hold(struct xfrm_policy *policy)
