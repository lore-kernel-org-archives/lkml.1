Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbXJXQaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbXJXQaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758569AbXJXQXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:23:18 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33349 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758536AbXJXQXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:23:17 -0400
Date: Wed, 24 Oct 2007 18:23:47 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make cpu_shares_{show,store}() static
Message-ID: <20071024162347.GW30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_shares_{show,store}() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 kernel/user.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

ccebfda5cfe88df567a8b33f970bd6f2c167e79c 
diff --git a/kernel/user.c b/kernel/user.c
index e91331c..0f3aa02 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -129,7 +129,7 @@ static inline void uids_mutex_unlock(void)
 }
 
 /* return cpu shares held by the user */
-ssize_t cpu_shares_show(struct kset *kset, char *buffer)
+static ssize_t cpu_shares_show(struct kset *kset, char *buffer)
 {
 	struct user_struct *up = container_of(kset, struct user_struct, kset);
 
@@ -137,7 +137,8 @@ ssize_t cpu_shares_show(struct kset *kset, char *buffer)
 }
 
 /* modify cpu shares held by the user */
-ssize_t cpu_shares_store(struct kset *kset, const char *buffer, size_t size)
+static ssize_t cpu_shares_store(struct kset *kset, const char *buffer,
+				size_t size)
 {
 	struct user_struct *up = container_of(kset, struct user_struct, kset);
 	unsigned long shares;

