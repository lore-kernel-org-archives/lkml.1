Return-Path: <linux-kernel-owner+w=401wt.eu-S1760649AbXLTL4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760649AbXLTL4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760378AbXLTLzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:55:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760361AbXLTLzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:55:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 07/43] ptrace_request peekdata/pokedata
Message-Id: <20071220115532.7793126F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:55:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes ptrace_request handle {PEEK,POKE}{TEXT,DATA} directly.
Every arch_ptrace that could call generic_ptrace_peekdata already
has a default case calling ptrace_request, so this keeps things
simpler for the arch code.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/ptrace.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 2824726..e521042 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -426,6 +426,13 @@ int ptrace_request(struct task_struct *child, long request,
 	int ret = -EIO;
 
 	switch (request) {
+	case PTRACE_PEEKTEXT:
+	case PTRACE_PEEKDATA:
+		return generic_ptrace_peekdata(child, addr, data);
+	case PTRACE_POKETEXT:
+	case PTRACE_POKEDATA:
+		return generic_ptrace_pokedata(child, addr, data);
+
 #ifdef PTRACE_OLDSETOPTIONS
 	case PTRACE_OLDSETOPTIONS:
 #endif
-- 
1.5.3.6

