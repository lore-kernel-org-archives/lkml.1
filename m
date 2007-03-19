Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbXCSVww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbXCSVww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbXCSVwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:52:50 -0400
Received: from ns2.suse.de ([195.135.220.15]:59226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965042AbXCSVkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:40:32 -0400
Date: Mon, 19 Mar 2007 14:38:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, mingo@elte.hu,
       zilvinas@wilibox.com
Subject: [patch 11/31] initialise pi_lock if CONFIG_RT_MUTEXES=N
Message-ID: <20070319213835.GM9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="initialise-pi_lock-if-config_rt_mutexes-n.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Zilvinas Valinskas <zilvinas@wilibox.com>

Fixes a bogus lockdep warning which causes lockdep to disable itself.

Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -933,8 +933,8 @@ asmlinkage long sys_set_tid_address(int 
 
 static inline void rt_mutex_init_task(struct task_struct *p)
 {
-#ifdef CONFIG_RT_MUTEXES
 	spin_lock_init(&p->pi_lock);
+#ifdef CONFIG_RT_MUTEXES
 	plist_head_init(&p->pi_waiters, &p->pi_lock);
 	p->pi_blocked_on = NULL;
 #endif

-- 
