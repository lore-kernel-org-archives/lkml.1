Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbYDJIUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbYDJIUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 04:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbYDJIT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 04:19:59 -0400
Received: from sacred.ru ([62.205.161.221]:36005 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364AbYDJIT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 04:19:58 -0400
Message-ID: <47FDD2BB.2030304@openvz.org>
Date: Thu, 10 Apr 2008 12:41:31 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Alexey Dobriyan <adobriyan@openvz.org>
CC: Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/10] Bsdacct: rename acct_glbl structure
References: <47FDD267.80700@openvz.org>
In-Reply-To: <47FDD267.80700@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 10 Apr 2008 12:16:40 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will be visible in pid_namespace.h file, so fixup its name first.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 kernel/acct.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 91e1cfd..ee3e605 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -82,7 +82,7 @@ static void do_acct_process(struct pid_namespace *ns, struct file *);
  * can be placed in the same cache line as the lock.  This primes
  * the cache line to have the data after getting the lock.
  */
-struct acct_glbs {
+struct bsd_acct_struct {
 	spinlock_t		lock;
 	volatile int		active;
 	volatile int		needcheck;
@@ -91,7 +91,7 @@ struct acct_glbs {
 	struct timer_list	timer;
 };
 
-static struct acct_glbs acct_globals __cacheline_aligned =
+static struct bsd_acct_struct acct_globals __cacheline_aligned =
 	{__SPIN_LOCK_UNLOCKED(acct_globals.lock)};
 
 /*
-- 
1.5.3.4

