Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbYH0Nyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbYH0Nyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbYH0NtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:49:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278AbYH0NtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:49:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/59] CRED: Wrap task credential accesses in the PA-RISC arch
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-parisc@vger.kernel.org
Date: Wed, 27 Aug 2008 14:45:57 +0100
Message-ID: <20080827134557.19980.40787.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-parisc@vger.kernel.org
---

 arch/parisc/kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 06213d1..f825442 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -182,7 +182,7 @@ give_sigsegv:
 	si.si_errno = 0;
 	si.si_code = SI_KERNEL;
 	si.si_pid = task_pid_vnr(current);
-	si.si_uid = current->uid;
+	si.si_uid = current_uid();
 	si.si_addr = &frame->uc;
 	force_sig_info(SIGSEGV, &si, current);
 	return;

