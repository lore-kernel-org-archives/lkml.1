Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbYJ0UEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbYJ0UEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYJ0UD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:03:56 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:53481 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbYJ0UDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ISxTz01gwNbZM3pRhYaKbgRfpc5U8O5yiQeHziyc0jj/DGWKTGe8FS/MDap9hcg6zY
         XVPpIa51ByiNTsV8YHm5ylaI1io8gHn6+E4AUgQ0x5CHa1hwQlQBLhVoIdt93ZIPz/WY
         VbiF11FEglzahFn10IbtxY5Yzbws5NkzE6RsU=
Message-ID: <9bd6b5360810271303teb198dejde3116f69cfffd46@mail.gmail.com>
Date: Tue, 28 Oct 2008 04:03:52 +0800
From: sniper <s3c24xx@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Subject: [PATCH] LOCKDEP: minor fix for debug_show_all_locks()
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we failed to get tasklist_lock eventually (count equals 0),
we should only print " ignoring it.\n", and not print
" locked it.\n" needlessly.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index dbda475..12bf812 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3417,10 +3417,12 @@ retry:
 		}
 		printk(" ignoring it.\n");
 		unlock = 0;
+		goto print_locks;
 	}
 	if (count != 10)
 		printk(" locked it.\n");

+print_locks:
 	do_each_thread(g, p) {
 		/*
 		 * It's not reliable to print a task's held locks
