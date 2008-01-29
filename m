Return-Path: <linux-kernel-owner+w=401wt.eu-S1764041AbYA2OCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764041AbYA2OCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 09:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933006AbYA2OCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 09:02:09 -0500
Received: from sacred.ru ([62.205.161.221]:43122 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932966AbYA2OCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:02:07 -0500
Message-ID: <479F31DB.5000809@openvz.org>
Date: Tue, 29 Jan 2008 17:02:03 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 9/12] ia64: make pfm_get_task work with virtual pids
References: <479F2C5C.1050303@openvz.org>
In-Reply-To: <479F2C5C.1050303@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 29 Jan 2008 17:01:43 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pid comes from user space, so treat it accordingly.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 arch/ia64/kernel/perfmon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 73e7c2e..da1cff0 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2654,11 +2654,11 @@ pfm_get_task(pfm_context_t *ctx, pid_t pid, struct task_struct **task)
 	/* XXX: need to add more checks here */
 	if (pid < 2) return -EPERM;
 
-	if (pid != current->pid) {
+	if (pid != task_pid_vnr(current)) {
 
 		read_lock(&tasklist_lock);
 
-		p = find_task_by_pid(pid);
+		p = find_task_by_vpid(pid);
 
 		/* make sure task cannot go away while we operate on it */
 		if (p) get_task_struct(p);
-- 
1.5.3.4

