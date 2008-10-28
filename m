Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYJ1BOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYJ1BOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 21:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYJ1BOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 21:14:34 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:5511
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568AbYJ1BOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 21:14:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAHQEBkl8qQJT/2dsb2JhbADGcINP
X-IronPort-AV: E=Sophos;i="4.33,495,1220198400"; 
   d="scan'208";a="393611169"
From: Ian Kent <raven@themaw.net>
Subject: [RESEND PATCH] autofs4 - remove string terminator check
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Tue, 28 Oct 2008 10:14:30 +0900
Message-ID: <20081028011430.4976.320.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a previous patch a comment was made that checking for the existence of
a NULL terminator in strings copied from userspace wasn't needed as this
is done in many places in the kernel without problem. This patch removes
this string terminator check.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---

 fs/autofs4/dev-ioctl.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 625abf5..304c1ff 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -51,18 +51,6 @@ static int check_name(const char *name)
 }
 
 /*
- * Check a string doesn't overrun the chunk of
- * memory we copied from user land.
- */
-static int invalid_str(char *str, void *end)
-{
-	while ((void *) str <= end)
-		if (!*str++)
-			return 0;
-	return -EINVAL;
-}
-
-/*
  * Check that the user compiled against correct version of autofs
  * misc device code.
  *
@@ -143,14 +131,6 @@ static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
 				    cmd);
 			goto out;
 		}
-
-		err = invalid_str(param->path,
-				 (void *) ((size_t) param + param->size));
-		if (err) {
-			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
-				    cmd);
-			goto out;
-		}
 	}
 
 	err = 0;

