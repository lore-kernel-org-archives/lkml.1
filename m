Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbZCYPzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbZCYPzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729AbZCYPzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:55:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:48426 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979AbZCYPzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:55:08 -0400
Date: Wed, 25 Mar 2009 15:54:27 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237898630.25315.83.camel@penberg-laptop>
References: <1237898630.25315.83.camel@penberg-laptop>
Subject: [tip:tracing/kmemtrace] fs, kmemtrace: fix fs.h's PAGE_SIZE dependency
Message-ID: <tip-55553d2b7c253a1d676596fee680412727d84bc4@git.kernel.org>
Git-Commit-ID: 55553d2b7c253a1d676596fee680412727d84bc4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 15:54:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55553d2b7c253a1d676596fee680412727d84bc4
Gitweb:     http://git.kernel.org/tip/55553d2b7c253a1d676596fee680412727d84bc4
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 25 Mar 2009 16:48:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 16:50:47 +0100

fs, kmemtrace: fix fs.h's PAGE_SIZE dependency

Impact: build fix

ARM does not build due to fs.h using PAGE_SIZE but not including
asm/page.h.

(This was masked before by rcupreempt.h including percpu.h which
brought in asm/page.h indirectly.)

( A future enhancement would be to split out the simple_transaction
  facility (only two usage sites) from fs.h, into a separate
  linux/simple_transaction.h header. )

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: paulmck@linux.vnet.ibm.com
LKML-Reference: <1237898630.25315.83.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/fs.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 159f7b8..79be937 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -9,6 +9,8 @@
 #include <linux/limits.h>
 #include <linux/ioctl.h>
 
+#include <asm/page.h> /* for PAGE_SIZE */
+
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
  * the file limit at runtime and only root can increase the per-process
