Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613Ab0ATUg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab0ATUg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600Ab0ATUg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:36:26 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48312 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab0ATUgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:36:04 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Eric Paris <eparis@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       "Serge E. Hallyn" <serue@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: [RFC PATCH 2/2] Fix 2 untangling ima mess, part 2 with counters
Date: Wed, 20 Jan 2010 15:35:41 -0500
Message-Id: <6671b3cf65d96375a40ee4e2cd9a0898b12a55c9.1264018123.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cover.1264018123.git.zohar@linux.vnet.ibm.com>
References: <cover.1264018123.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1264018123.git.zohar@linux.vnet.ibm.com>
References: <cover.1264018123.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "Untangling ima mess, part 2 with counters" patch did
not measure all files, which should have been measured.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 fs/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a89ebc3..e1f15e8 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1730,7 +1730,7 @@ do_last:
 		if (nd.root.mnt)
 			path_put(&nd.root);
 		if (!IS_ERR(filp)) {
-			error = ima_path_check(filp, filp->f_mode &
+			error = ima_path_check(filp, acc_mode &
 				       (MAY_READ | MAY_WRITE | MAY_EXEC));
 			if (error) {
 				fput(filp);
@@ -1791,7 +1791,7 @@ ok:
 	}
 	filp = nameidata_to_filp(&nd, open_flag);
 	if (!IS_ERR(filp)) {
-		error = ima_path_check(filp, filp->f_mode &
+		error = ima_path_check(filp, acc_mode &
 			       (MAY_READ | MAY_WRITE | MAY_EXEC));
 		if (error) {
 			fput(filp);
-- 
1.6.0.6

