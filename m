Return-Path: <linux-kernel-owner+w=401wt.eu-S1765389AbXH0V2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765389AbXH0V2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbXH0V1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:27:18 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58791 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764249AbXH0V1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:27:15 -0400
Date: Mon, 27 Aug 2007 23:27:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make do_restart_poll() static
Message-ID: <20070827212714.GK4121@stusta.de>
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
> +use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
>...
>  The infamous misc
>...

do_restart_poll() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
59cd2d11f5f0189973bb280c59262eb50984cb88 
diff --git a/fs/select.c b/fs/select.c
index 5a3ab01..3e515aa 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -711,7 +711,7 @@ out_fds:
 	return err;
 }
 
-long do_restart_poll(struct restart_block *restart_block)
+static long do_restart_poll(struct restart_block *restart_block)
 {
 	struct pollfd __user *ufds = (struct pollfd __user*)restart_block->arg0;
 	int nfds = restart_block->arg1;

