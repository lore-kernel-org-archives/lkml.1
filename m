Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYJWCpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYJWCpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYJWCpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:45:17 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:26276
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504AbYJWCpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:45:15 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 22:45:14 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPp//0h8qQJT/2dsb2JhbADAQINO
X-IronPort-AV: E=Sophos;i="4.33,468,1220198400"; 
   d="scan'208";a="267105511"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 2/6] autofs4 - remove string terminator check
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>
Date: Thu, 23 Oct 2008 10:35:22 +0800
Message-ID: <20081023023522.4508.27987.stgit@raven.themaw.net>
In-Reply-To: <20081023023513.4508.54940.stgit@raven.themaw.net>
References: <20081023023513.4508.54940.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary string terminator check.

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

