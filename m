Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbXH2NXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbXH2NXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 09:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757196AbXH2NXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 09:23:36 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:20144 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896AbXH2NXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 09:23:36 -0400
Message-ID: <46D57274.3040802@openvz.org>
Date: Wed, 29 Aug 2007 17:19:48 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Use same_thread_group() in signalfd.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a lost hunk of previous patch that isolated the
explicit usage of task->tgid in some places. The signalfd
code uses the tsk->tgid comparison.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/fs/signalfd.c b/fs/signalfd.c
index a8e293d..5bfd2c5 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -64,7 +64,7 @@ static int signalfd_lock(struct signalfd
 		return 0;
 	}
 
-	if (lk->tsk->tgid == current->tgid)
+	if (same_thread_group(lk->tsk, current->tgid))
 		lk->tsk = current;
 
 	return 1;
