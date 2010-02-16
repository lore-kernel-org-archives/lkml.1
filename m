Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab0BPGwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 01:52:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:44229 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab0BPGwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 01:52:20 -0500
Date: Tue, 16 Feb 2010 06:51:46 GMT
From: tip-bot for Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20100208100239.2568.2940.stgit@localhost.localdomain>
References: <20100208100239.2568.2940.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mtrr] x86, mtrr: Kill over the top warn
Message-ID: <tip-942fa3b63eb525aa0512ba28c42e656d8efc6787@git.kernel.org>
Git-Commit-ID: 942fa3b63eb525aa0512ba28c42e656d8efc6787
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Feb 2010 06:51:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  942fa3b63eb525aa0512ba28c42e656d8efc6787
Gitweb:     http://git.kernel.org/tip/942fa3b63eb525aa0512ba28c42e656d8efc6787
Author:     Alan Cox <alan@linux.intel.com>
AuthorDate: Mon, 8 Feb 2010 10:03:17 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 15 Feb 2010 19:38:52 -0800

x86, mtrr: Kill over the top warn

Fixes bugzilla: http://bugzilla.kernel.org/show_bug.cgi?id=12558
Fixes bugzilla: http://bugzilla.kernel.org/show_bug.cgi?id=12317

(and if this really needed to be a warn you'd be responding to the bugs left
in bugzilla from it...)

Signed-off-by: Alan Cox <alan@linux.intel.com>
LKML-Reference: <20100208100239.2568.2940.stgit@localhost.localdomain>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/mtrr/generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 4d75584..163e59e 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -464,7 +464,7 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 		tmp |= ~((1<<(hi - 1)) - 1);
 
 		if (tmp != mask_lo) {
-			WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
+			printk(KERN_WARNING "mtrr: your BIOS has configured an incorrect mask, fixing it.\n");
 			mask_lo = tmp;
 		}
 	}
