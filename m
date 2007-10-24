Return-Path: <linux-kernel-owner+w=401wt.eu-S1762137AbXJXQdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762137AbXJXQdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759469AbXJXQYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:24:01 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33389 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759414AbXJXQX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:23:58 -0400
Date: Wed, 24 Oct 2007 18:24:28 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Vlad Yasevich <vladislav.yasevich@hp.com>, sri@us.ibm.com
Cc: lksctp-developers@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [2.6 patch] net/sctp/auth.c: make 3 functions static
Message-ID: <20071024162428.GJ30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes three needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/net/sctp/auth.h |    1 -
 net/sctp/auth.c         |    6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

102a72ca5278d3c502bee6af4c4d11c9876d5a2d 
diff --git a/include/net/sctp/auth.h b/include/net/sctp/auth.h
index 4945954..9e8f13b 100644
--- a/include/net/sctp/auth.h
+++ b/include/net/sctp/auth.h
@@ -88,7 +88,6 @@ static inline void sctp_auth_key_hold(struct sctp_auth_bytes *key)
 
 void sctp_auth_key_put(struct sctp_auth_bytes *key);
 struct sctp_shared_key *sctp_auth_shkey_create(__u16 key_id, gfp_t gfp);
-void sctp_auth_shkey_free(struct sctp_shared_key *sh_key);
 void sctp_auth_destroy_keys(struct list_head *keys);
 int sctp_auth_asoc_init_active_key(struct sctp_association *asoc, gfp_t gfp);
 struct sctp_shared_key *sctp_auth_get_shkey(
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 7818107..5a2dd38 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -107,7 +107,7 @@ struct sctp_shared_key *sctp_auth_shkey_create(__u16 key_id, gfp_t gfp)
 }
 
 /* Free the shared key stucture */
-void sctp_auth_shkey_free(struct sctp_shared_key *sh_key)
+static void sctp_auth_shkey_free(struct sctp_shared_key *sh_key)
 {
 	BUG_ON(!list_empty(&sh_key->key_list));
 	sctp_auth_key_put(sh_key->key);
@@ -220,7 +220,7 @@ static struct sctp_auth_bytes *sctp_auth_make_key_vector(
 
 
 /* Make a key vector based on our local parameters */
-struct sctp_auth_bytes *sctp_auth_make_local_vector(
+static struct sctp_auth_bytes *sctp_auth_make_local_vector(
 				    const struct sctp_association *asoc,
 				    gfp_t gfp)
 {
@@ -232,7 +232,7 @@ struct sctp_auth_bytes *sctp_auth_make_local_vector(
 }
 
 /* Make a key vector based on peer's parameters */
-struct sctp_auth_bytes *sctp_auth_make_peer_vector(
+static struct sctp_auth_bytes *sctp_auth_make_peer_vector(
 				    const struct sctp_association *asoc,
 				    gfp_t gfp)
 {

