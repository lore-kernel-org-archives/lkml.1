Return-Path: <linux-kernel-owner+w=401wt.eu-S1764130AbXGYUxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764130AbXGYUxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbXGYUwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:52:51 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59707 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757828AbXGYUwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:52:49 -0400
Date: Wed, 25 Jul 2007 15:52:38 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, toml@us.ibm.com
Subject: [PATCH 6/7] eCryptfs: Remove unnecessary variable initializations
Message-ID: <20070725205238.GW14091@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070725204855.GQ14091@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725204855.GQ14091@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> >       struct mutex *tfm_mutex = NULL;
>
> This initialisation looks like it's here to kill bogus gcc warning
> (if it is, it should have been commented).  Please investigate
> uninitialized_var() and __maybe_unused sometime.

Remove some unnecessary variable initializations. There may be a few
more such intializations remaining in the code base; a future patch
will take care of those.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/keystore.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index a718136..d9739bc 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1009,7 +1009,7 @@ decrypt_passphrase_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 {
 	struct scatterlist dst_sg;
 	struct scatterlist src_sg;
-	struct mutex *tfm_mutex = NULL;
+	struct mutex *tfm_mutex;
 	struct blkcipher_desc desc = {
 		.flags = CRYPTO_TFM_REQ_MAY_SLEEP
 	};
@@ -1123,8 +1123,8 @@ int ecryptfs_parse_packet_set(struct ecryptfs_crypt_stat *crypt_stat,
 	size_t found_auth_tok;
 	size_t next_packet_is_auth_tok_packet;
 	struct list_head auth_tok_list;
-	struct ecryptfs_auth_tok *matching_auth_tok = NULL;
-	struct ecryptfs_auth_tok *candidate_auth_tok = NULL;
+	struct ecryptfs_auth_tok *matching_auth_tok;
+	struct ecryptfs_auth_tok *candidate_auth_tok;
 	char *candidate_auth_tok_sig;
 	size_t packet_size;
 	struct ecryptfs_auth_tok *new_auth_tok;
-- 
1.5.1.6

