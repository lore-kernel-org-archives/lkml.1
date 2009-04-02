Return-Path: <linux-kernel-owner+w=401wt.eu-S1751267AbZDBEK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbZDBEK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbZDBEKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:10:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:52973 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZDBEKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:10:45 -0400
Date: Thu, 2 Apr 2009 04:09:32 GMT
From: Tejun Heo <tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, davem@davemloft.net, tj@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, davem@davemloft.net, tj@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49D30469.8020006@kernel.org>
References: <49D30469.8020006@kernel.org>
Subject: [tip:x86/urgent] x86,percpu: fix inverted NUMA test in setup_pcpu_remap()
Message-ID: <tip-eb12ce60c81826a99eadbc56401e08ceb37a0cc2@git.kernel.org>
Git-Commit-ID: eb12ce60c81826a99eadbc56401e08ceb37a0cc2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 04:09:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb12ce60c81826a99eadbc56401e08ceb37a0cc2
Gitweb:     http://git.kernel.org/tip/eb12ce60c81826a99eadbc56401e08ceb37a0cc2
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Wed, 1 Apr 2009 15:06:33 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Apr 2009 06:08:05 +0200

x86,percpu: fix inverted NUMA test in setup_pcpu_remap()

setup_percpu_remap() is for NUMA machines yet it bailed out with
-EINVAL if pcpu_need_numa().  Fix the inverted condition.

This problem was reported by David Miller and verified by Yinhai Lu.

Reported-by: David Miller <davem@davemloft.net>
Reported-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <49D30469.8020006@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/setup_percpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 400331b..876b127 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -162,7 +162,7 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
 	 * If large page isn't supported, there's no benefit in doing
 	 * this.  Also, on non-NUMA, embedding is better.
 	 */
-	if (!cpu_has_pse || pcpu_need_numa())
+	if (!cpu_has_pse || !pcpu_need_numa())
 		return -EINVAL;
 
 	last = NULL;
