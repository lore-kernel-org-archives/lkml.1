Return-Path: <linux-kernel-owner+w=401wt.eu-S1765447AbXH0V3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765447AbXH0V3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764603AbXH0V1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:27:25 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58796 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762014AbXH0V1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:27:23 -0400
Date: Mon, 27 Aug 2007 23:27:23 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, perex@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] unexport sys_{open,read}
Message-ID: <20070827212723.GM4121@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc2-mm2:
>...
>  git-alsa.patch
>...
>  git trees
>...

sys_{open,read} can finally be unexported.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/open.c       |    1 -
 fs/read_write.c |    1 -
 2 files changed, 2 deletions(-)

6f6884f9ee675f2e804c6c58ca46337f9765dd0d 
diff --git a/fs/open.c b/fs/open.c
index 23f334d..c0814de 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1057,7 +1057,6 @@ asmlinkage long sys_open(const char __user *filename, int flags, int mode)
 	prevent_tail_call(ret);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(sys_open);
 
 asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
 			   int mode)
diff --git a/fs/read_write.c b/fs/read_write.c
index 507ddff..d913d1e 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -370,7 +370,6 @@ asmlinkage ssize_t sys_read(unsigned int fd, char __user * buf, size_t count)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(sys_read);
 
 asmlinkage ssize_t sys_write(unsigned int fd, const char __user * buf, size_t count)
 {

