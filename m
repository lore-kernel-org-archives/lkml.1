Return-Path: <linux-kernel-owner+w=401wt.eu-S933248AbZLRWvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248AbZLRWvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 17:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933222AbZLRWvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 17:51:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52815 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933207AbZLRWvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 17:51:40 -0500
Date: Sat, 19 Dec 2009 09:51:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jslaby@suse.cz>
Subject: linux-next: manual merge of the tip tree with the limits tree
Message-Id: <20091219095136.c0cd3ba5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
include/linux/sched.h between commit
8c2b7235b952281905e001ad04da365279f4c8ec ("resource: add helpers for
fetching rlimits") from the limits tree and commit
733421516b42c44b9e21f1793c430cc801ef8324 ("sched: Move
TASK_STATE_TO_CHAR_STR near the TASK_state bits") from the tip tree.

Just overlapping changes.  I fixed it up (see below) and can carry the fix
as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/sched.h
index fe12211,f2f842d..0000000
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@@ -2594,30 -2601,6 +2601,28 @@@ static inline void mm_init_owner(struc
  }
  #endif /* CONFIG_MM_OWNER */
  
 +static inline unsigned long task_rlimit(const struct task_struct *tsk,
 +		unsigned int limit)
 +{
 +	return ACCESS_ONCE(tsk->signal->rlim[limit].rlim_cur);
 +}
 +
 +static inline unsigned long task_rlimit_max(const struct task_struct *tsk,
 +		unsigned int limit)
 +{
 +	return ACCESS_ONCE(tsk->signal->rlim[limit].rlim_max);
 +}
 +
 +static inline unsigned long rlimit(unsigned int limit)
 +{
 +	return task_rlimit(current, limit);
 +}
 +
 +static inline unsigned long rlimit_max(unsigned int limit)
 +{
 +	return task_rlimit_max(current, limit);
 +}
 +
- #define TASK_STATE_TO_CHAR_STR "RSDTtZX"
- 
  #endif /* __KERNEL__ */
  
  #endif
