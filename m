Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbXDLX5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbXDLX5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbXDLX5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:57:00 -0400
Received: from mail.screens.ru ([213.234.233.54]:57286 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbXDLX4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:56:47 -0400
Date: Fri, 13 Apr 2007 03:56:29 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] nlmclnt_recovery: don't use CLONE_SIGHAND
Message-ID: <20070412235629.GA1047@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

reclaimer() calls allow_signal() which plays with parent process's ->sighand.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 2.6.21-rc5/fs/lockd/clntlock.c~1_lockd	2007-04-05 12:04:07.000000000 +0400
+++ 2.6.21-rc5/fs/lockd/clntlock.c	2007-04-13 03:20:51.000000000 +0400
@@ -153,7 +153,7 @@ nlmclnt_recovery(struct nlm_host *host)
 	if (!host->h_reclaiming++) {
 		nlm_get_host(host);
 		__module_get(THIS_MODULE);
-		if (kernel_thread(reclaimer, host, CLONE_KERNEL) < 0)
+		if (kernel_thread(reclaimer, host, CLONE_FS | CLONE_FILES) < 0)
 			module_put(THIS_MODULE);
 	}
 }

