Return-Path: <linux-kernel-owner+w=401wt.eu-S933503AbYA2OA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503AbYA2OA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 09:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760976AbYA2OAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 09:00:14 -0500
Received: from sacred.ru ([62.205.161.221]:45166 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757756AbYA2OAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:00:12 -0500
Message-ID: <479F3155.9060504@openvz.org>
Date: Tue, 29 Jan 2008 16:59:49 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Oleg Nesterov <oleg@tv-sign.ru>, David Howells <dhowells@redhat.com>
Subject: [PATCH 8/12] frv: use find_task_by_vpid in cxn_pin_by_pid
References: <479F2C5C.1050303@openvz.org>
In-Reply-To: <479F2C5C.1050303@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 29 Jan 2008 16:59:28 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is question gets the pid from sysctl table,
so this one is a virtual pid, i.e. the pid of a task as it
is seen from inside a namespace.

So the find_task_by_vpid() must be used here.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 arch/frv/mm/mmu-context.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/frv/mm/mmu-context.c b/arch/frv/mm/mmu-context.c
index 1530a41..81757d5 100644
--- a/arch/frv/mm/mmu-context.c
+++ b/arch/frv/mm/mmu-context.c
@@ -181,7 +181,7 @@ int cxn_pin_by_pid(pid_t pid)
 
 	/* get a handle on the mm_struct */
 	read_lock(&tasklist_lock);
-	tsk = find_task_by_pid(pid);
+	tsk = find_task_by_vpid(pid);
 	if (tsk) {
 		ret = -EINVAL;
 
-- 
1.5.3.4

