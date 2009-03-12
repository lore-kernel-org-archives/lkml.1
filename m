Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZCLHzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZCLHzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZCLHzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:55:35 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49127 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbZCLHzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:55:35 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 0/6] Futex fixes and cleanups
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 12 Mar 2009 00:55:29 -0700
Message-ID: <20090312075349.9856.83687.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are some assorted futex fixes that I was hoping to get upstream in
preparation for my requeue_pi patchset in the near future.  They can found at
the following git repository:

git://git.kernel.org/pub/scm/linux/kernel/git/dvhart/linux-2.6-tip-hacks.git futex-fixes

Note that prior to applying these patches to tip/core/futexes I did a "git
merge master" to make sure I was patching the latest futex.c, including Peter's
latest futex_key fix and the older syscall patches that core/futexes hadn't
been synced yet with.  Since this is my first attempt at a git pull request,
and I would still really appreciate some review on the following patches, I
have also included them in reply to this mail.

---

Darren Hart (6):
      futex: cleanup fault logic
      futex: unlock before returning -EFAULT
      futex: Use current->time_slack_ns for rt tasks too
      futex: add double_unlock_hb()
      Additional (get|put)_futex_key() fixes
      Update futex commentary


 kernel/futex.c |  206 ++++++++++++++++++++++----------------------------------
 1 files changed, 81 insertions(+), 125 deletions(-)

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
