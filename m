Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbZDAKQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbZDAKQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbZDAKOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:14:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:40028 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756832AbZDAKOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:14:37 -0400
Date: Wed, 1 Apr 2009 10:13:56 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090330171023.792822360@chello.nl>
References: <20090330171023.792822360@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: x86: proper error propagation for the x86 hw_perf_counter_init()
Message-ID: <tip-1763e5959b2302761b10e84df38165fac86bd1a5@git.kernel.org>
Git-Commit-ID: 1763e5959b2302761b10e84df38165fac86bd1a5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 10:13:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1763e5959b2302761b10e84df38165fac86bd1a5
Gitweb:     http://git.kernel.org/tip/1763e5959b2302761b10e84df38165fac86bd1a5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 30 Mar 2009 19:07:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Apr 2009 11:33:35 +0200

perf_counter: x86: proper error propagation for the x86 hw_perf_counter_init()

Now that Paul cleaned up the error propagation paths, pass down the
x86 error as well.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090330171023.792822360@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 7aab177..b8885cc 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -954,7 +954,7 @@ hw_perf_counter_init(struct perf_counter *counter)
 
 	err = __hw_perf_counter_init(counter);
 	if (err)
-		return NULL;
+		return ERR_PTR(err);
 
 	return &x86_perf_counter_ops;
 }
