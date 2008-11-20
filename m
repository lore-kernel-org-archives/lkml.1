Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbYKTWAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbYKTWAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 17:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbYKTWAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 17:00:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:57572 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbYKTWAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 17:00:19 -0500
Message-ID: <154e089b0811201400w6b5d249eyc21ebb9a76133d08@mail.gmail.com>
Date: Thu, 20 Nov 2008 23:00:17 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "David Howells" <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] CRED: fix compilation warning in function 'get_cred'
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to following warning by introducing a temporary variable:

include/linux/cred.h: In function 'get_cred':
include/linux/cred.h:187: warning: passing argument 1 of
'get_new_cred' discards qualifiers from pointer target type

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
With -O2 the same code as for the original function is generated.

 include/linux/cred.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 26c1ab1..2ab8cf7 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -184,7 +184,8 @@ static inline struct cred *get_new_cred(struct cred *cred)
  */
 static inline const struct cred *get_cred(const struct cred *cred)
 {
-	return get_new_cred((struct cred *) cred);
+	struct cred *non_const_cred = (struct cred *) cred;
+	return get_new_cred(non_const_cred);
 }

 /**
