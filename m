Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbYIZSHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbYIZSHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 14:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYIZSGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 14:06:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:37213 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbYIZSGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 14:06:08 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 1/5] kgdb: could not write to the last of valid memory with kgdb
Date: Fri, 26 Sep 2008 13:05:16 -0500
Message-Id: <1222452320-16281-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.90.g436ed.dirty
In-Reply-To: <1222452320-16281-1-git-send-email-jason.wessel@windriver.com>
References: <1222452320-16281-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 26 Sep 2008 18:05:35.0456 (UTC) FILETIME=[79575600:01C92002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Atsuo Igarashi <atsuo_igarashi@tripeaks.co.jp>

On the ARM architecture, kgdb will crash the kernel if the last byte
of valid memory is written due to a flush_icache_range flushing
beyond the memory boundary.

Signed-off-by: Atsuo Igarashi <atsuo_igarashi@tripeaks.co.jp>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/kgdb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index eaa21fc..949806a 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -488,7 +488,7 @@ static int write_mem_msg(int binary)
 		if (err)
 			return err;
 		if (CACHE_FLUSH_IS_SAFE)
-			flush_icache_range(addr, addr + length + 1);
+			flush_icache_range(addr, addr + length);
 		return 0;
 	}
 
-- 
1.6.0.90.g436ed.dirty

