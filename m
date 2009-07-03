Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbZGCAlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbZGCAlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbZGCAkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:40:55 -0400
Received: from smtp-out.google.com ([216.239.45.13]:4520 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbZGCAkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:40:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=F7um5hhijetdo1GDBdveZArXnQrdUV7CyTQnUgFiawvXeOUiEf3rUeCzi0/CQnIE4
	2PIAKkAad0prMqZYL5M0w==
From: Paul Menage <menage@google.com>
Subject: [PATCH] Fix warning in get_cred()
To: jmorris@namei.org, dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org
Date: Thu, 02 Jul 2009 17:40:39 -0700
Message-ID: <20090703004039.22350.27996.stgit@menage.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warning in get_cred()

With gcc 4.2.4 (building UML) I get the warning

include/linux/cred.h: In function 'get_cred':
include/linux/cred.h:189: warning: passing argument 1 of
'get_new_cred' discards qualifiers from pointer target type

Inserting an additional local variable appears to keep the compiler
happy, although it's not clear to me why this should be needed.

Signed-off-by: Paul Menage <menage@google.com>

---

 include/linux/cred.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 4fa9996..b3c76e8 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -186,7 +186,8 @@ static inline struct cred *get_new_cred(struct cred *cred)
  */
 static inline const struct cred *get_cred(const struct cred *cred)
 {
-	return get_new_cred((struct cred *) cred);
+	struct cred *nonconst_cred = (struct cred *) cred;
+	return get_new_cred(nonconst_cred);
 }
 
 /**

