Return-Path: <linux-kernel-owner+w=401wt.eu-S1764337AbYA2OEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764337AbYA2OEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 09:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763622AbYA2OE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 09:04:26 -0500
Received: from sacred.ru ([62.205.161.221]:43720 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763240AbYA2OEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:04:25 -0500
Message-ID: <479F3264.4070703@openvz.org>
Date: Tue, 29 Jan 2008 17:04:20 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 10/12] ia64: fix ptrace inside a namespace
References: <479F2C5C.1050303@openvz.org>
In-Reply-To: <479F2C5C.1050303@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 29 Jan 2008 17:03:59 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ia64 has its own sys_ptrace implementation and it was 
overlooked when the pid namespaces patches were sent.

Use find_task_by_vpid() in it.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 arch/ia64/kernel/ptrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/ptrace.c b/arch/ia64/kernel/ptrace.c
index 2e96f17..a671ef8 100644
--- a/arch/ia64/kernel/ptrace.c
+++ b/arch/ia64/kernel/ptrace.c
@@ -1437,7 +1437,7 @@ sys_ptrace (long request, pid_t pid, unsigned long addr, unsigned long data)
 	ret = -ESRCH;
 	read_lock(&tasklist_lock);
 	{
-		child = find_task_by_pid(pid);
+		child = find_task_by_vpid(pid);
 		if (child) {
 			if (peek_or_poke)
 				child = find_thread_for_addr(child, addr);
-- 
1.5.3.4

