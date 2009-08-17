Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbZHQJxC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbZHQJxC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:53:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbZHQJxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:53:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:43058 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757410AbZHQJxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:53:00 -0400
Date: Mon, 17 Aug 2009 09:51:36 GMT
From: tip-bot for Amerigo Wang <amwang@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       arjan@linux.intel.com, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       mpm@selenic.com, eduard.munteanu@linux360.ro, amwang@redhat.com,
       tglx@linutronix.de, rientjes@google.com, mingo@elte.hu,
       cl@linux-foundation.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, arjan@linux.intel.com, vegard.nossum@gmail.com,
       eduard.munteanu@linux360.ro, mpm@selenic.com, amwang@redhat.com,
       tglx@linutronix.de, rientjes@google.com, cl@linux-foundation.org,
       mingo@elte.hu
In-Reply-To: <20090817094525.6355.88682.sendpatchset@localhost.localdomain>
References: <20090817094525.6355.88682.sendpatchset@localhost.localdomain>
Subject: [tip:timers/urgent] timers: Drop write permission on /proc/timer_list
Message-ID: <tip-de809347aeef0a68c04576c464414d0e4dce59fc@git.kernel.org>
Git-Commit-ID: de809347aeef0a68c04576c464414d0e4dce59fc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 09:51:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de809347aeef0a68c04576c464414d0e4dce59fc
Gitweb:     http://git.kernel.org/tip/de809347aeef0a68c04576c464414d0e4dce59fc
Author:     Amerigo Wang <amwang@redhat.com>
AuthorDate: Mon, 17 Aug 2009 05:43:01 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 17 Aug 2009 11:47:31 +0200

timers: Drop write permission on /proc/timer_list

/proc/timer_list and /proc/slabinfo are not supposed to be
written, so there should be no write permissions on it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: linux-mm@kvack.org
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <20090817094525.6355.88682.sendpatchset@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/time/timer_list.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index a999b92..fddd69d 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -286,7 +286,7 @@ static int __init init_timer_list_procfs(void)
 {
 	struct proc_dir_entry *pe;
 
-	pe = proc_create("timer_list", 0644, NULL, &timer_list_fops);
+	pe = proc_create("timer_list", 0444, NULL, &timer_list_fops);
 	if (!pe)
 		return -ENOMEM;
 	return 0;
