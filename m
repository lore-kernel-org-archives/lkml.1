Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbXJ2FDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbXJ2FDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 01:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbXJ2FD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 01:03:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39868 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbXJ2FD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 01:03:26 -0400
Date: Mon, 29 Oct 2007 05:03:23 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [SCTP] endianness annotations regression
Message-ID: <20071029050323.GC8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/net/sctp/auth.h |    2 +-
 net/sctp/auth.c         |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/sctp/auth.h b/include/net/sctp/auth.h
index 9e8f13b..5db261a 100644
--- a/include/net/sctp/auth.h
+++ b/include/net/sctp/auth.h
@@ -103,7 +103,7 @@ struct sctp_hmac *sctp_auth_asoc_get_hmac(const struct sctp_association *asoc);
 void sctp_auth_asoc_set_default_hmac(struct sctp_association *asoc,
 				     struct sctp_hmac_algo_param *hmacs);
 int sctp_auth_asoc_verify_hmac_id(const struct sctp_association *asoc,
-				    __u16 hmac_id);
+				    __be16 hmac_id);
 int sctp_auth_send_cid(sctp_cid_t chunk, const struct sctp_association *asoc);
 int sctp_auth_recv_cid(sctp_cid_t chunk, const struct sctp_association *asoc);
 void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 8af1004..6d5fa6b 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -556,7 +556,7 @@ struct sctp_hmac *sctp_auth_asoc_get_hmac(const struct sctp_association *asoc)
 	return &sctp_hmac_list[id];
 }
 
-static int __sctp_auth_find_hmacid(__u16 *hmacs, int n_elts, __u16 hmac_id)
+static int __sctp_auth_find_hmacid(__be16 *hmacs, int n_elts, __be16 hmac_id)
 {
 	int  found = 0;
 	int  i;
@@ -573,7 +573,7 @@ static int __sctp_auth_find_hmacid(__u16 *hmacs, int n_elts, __u16 hmac_id)
 
 /* See if the HMAC_ID is one that we claim as supported */
 int sctp_auth_asoc_verify_hmac_id(const struct sctp_association *asoc,
-				    __u16 hmac_id)
+				    __be16 hmac_id)
 {
 	struct sctp_hmac_algo_param *hmacs;
 	__u16 n_elt;
-- 
1.5.3.GIT

