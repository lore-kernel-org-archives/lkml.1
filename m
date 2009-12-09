Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZLILuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZLILuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 06:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbZLILua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 06:50:30 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:48503 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250AbZLILua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 06:50:30 -0500
From: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] crypto/testmgr: fix uninitialized warning from gcc
Date: Wed,  9 Dec 2009 06:50:34 -0500
Message-Id: <1260359434-15358-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since err is not set to a value if tcount is 0, gcc issues a warning:
crypto/testmgr.c: In function ‘test_cprng’:
crypto/testmgr.c:1204: warning: ‘err’ may be used uninitialized in this function

Since this is test code, forcing initialized sanity should be fine.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 crypto/testmgr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 7620bfc..90c4254 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1214,6 +1214,7 @@ static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
 		return -ENOMEM;
 	}
 
+	err = 0; /* sanity in case tcount is 0 */
 	for (i = 0; i < tcount; i++) {
 		memset(result, 0, 32);
 
-- 
1.6.5.5

