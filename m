Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbYI0C2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbYI0C2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 22:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbYI0C2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 22:28:12 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:54598 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYI0C2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 22:28:08 -0400
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH 3/6] file capabilities: uninline cap_safe_nice
Date: Fri, 26 Sep 2008 22:27:47 -0400
Message-Id: <178a4b5984b7559cb5cdb93b242484386ec3e3ab.1222451103.git.serue@us.ibm.com>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <89d3843fc1aaf91ded89d741b2e6d425508e0146.1222451103.git.serue@us.ibm.com>
References: <1222482472-12847-1-git-send-email-serue@us.ibm.com>
 <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com>
 <89d3843fc1aaf91ded89d741b2e6d425508e0146.1222451103.git.serue@us.ibm.com>
In-Reply-To: <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com>
References: <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reduces the kernel size by 289 bytes.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/commoncap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 9bfef94..d48fdd8 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -512,7 +512,7 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
  * yet with increased caps.
  * So we check for increased caps on the target process.
  */
-static inline int cap_safe_nice(struct task_struct *p)
+static int cap_safe_nice(struct task_struct *p)
 {
 	if (!cap_issubset(p->cap_permitted, current->cap_permitted) &&
 	    !capable(CAP_SYS_NICE))
-- 
1.5.1.1.GIT

