Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbZLAWNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbZLAWNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 17:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZLAWNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 17:13:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZLAWNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 17:13:46 -0500
Date: Tue, 1 Dec 2009 23:12:58 +0100
From: Veaceslav Falico <vfalico@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Miloslav Trmac <mitr@redhat.com>, James Morris <jmorris@namei.org>,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 3/4] copy_signal cleanup: clean thread_group_cputime_init()
Message-ID: <20091201221258.GC10052@darkmag.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unneeded initializations in thread_group_cputime_init().

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
---

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..4778ef7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2419,9 +2419,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
 {
-	sig->cputimer.cputime = INIT_CPUTIME;
 	spin_lock_init(&sig->cputimer.lock);
-	sig->cputimer.running = 0;
 }
 
 static inline void thread_group_cputime_free(struct signal_struct *sig)
