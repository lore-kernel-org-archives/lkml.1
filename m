Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZGAOzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZGAOzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZGAOz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:55:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:35530 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbZGAOz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:55:27 -0400
Date: Wed, 1 Jul 2009 14:54:48 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinder@kernel.org, jaswinderrajput@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, jaswinderrajput@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246458263.6940.22.camel@hpdv5.satnam>
References: <1246458263.6940.22.camel@hpdv5.satnam>
Subject: [tip:x86/urgent] x86: Declare check_efer() before it gets used
Message-ID: <tip-76c06927f2a78143763dcff9b4c362d15eb29cc2@git.kernel.org>
Git-Commit-ID: 76c06927f2a78143763dcff9b4c362d15eb29cc2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 14:54:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  76c06927f2a78143763dcff9b4c362d15eb29cc2
Gitweb:     http://git.kernel.org/tip/76c06927f2a78143763dcff9b4c362d15eb29cc2
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Wed, 1 Jul 2009 19:54:23 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 16:52:54 +0200

x86: Declare check_efer() before it gets used

This sparse warning:

  arch/x86/mm/init.c:83:16: warning: symbol 'check_efer' was not declared. Should it be static?

triggers because check_efer() is not decalared before using it.
asm/proto.h includes the declaration of check_efer(), so
including asm/proto.h to fix that - this also addresses the
sparse warning.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1246458263.6940.22.camel@hpdv5.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 47ce9a2..0607119 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -12,6 +12,7 @@
 #include <asm/system.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
+#include <asm/proto.h>
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
