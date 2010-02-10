Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab0BJVct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 16:32:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:52744 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701Ab0BJVcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 16:32:47 -0500
Date: Wed, 10 Feb 2010 21:30:39 GMT
From: tip-bot for Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stable@kernel.org, aaw@google.com, tglx@linutronix.de, jslaby@suse.cz,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, tglx@linutronix.de, aaw@google.com, jslaby@suse.cz,
       mingo@elte.hu
In-Reply-To: <1265831716-7668-1-git-send-email-jslaby@suse.cz>
References: <1265831716-7668-1-git-send-email-jslaby@suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, ia32_aout: do not kill argument mapping
Message-ID: <tip-318f6b228ba88a394ef560efc1bfe028ad5ae6b6@git.kernel.org>
Git-Commit-ID: 318f6b228ba88a394ef560efc1bfe028ad5ae6b6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Feb 2010 21:30:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  318f6b228ba88a394ef560efc1bfe028ad5ae6b6
Gitweb:     http://git.kernel.org/tip/318f6b228ba88a394ef560efc1bfe028ad5ae6b6
Author:     Jiri Slaby <jslaby@suse.cz>
AuthorDate: Wed, 10 Feb 2010 20:55:16 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 10 Feb 2010 12:03:34 -0800

x86, ia32_aout: do not kill argument mapping

Do not set current->mm->mmap to NULL in 32-bit emulation on 64-bit
load_aout_binary after flush_old_exec as it would destroy already
set brpm mapping with arguments.

Introduced by b6a2fea39318e43fee84fa7b0b90d68bed92d2ba
mm: variable length argument support
where the argument mapping in bprm was added.

[ hpa: this is a regression from 2.6.22... time to kill a.out? ]

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
LKML-Reference: <1265831716-7668-1-git-send-email-jslaby@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ollie Wild <aaw@google.com>
Cc: x86@kernel.org
Cc: <stable@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/ia32/ia32_aout.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index f9f4724..14531ab 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -327,7 +327,6 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	current->mm->free_area_cache = TASK_UNMAPPED_BASE;
 	current->mm->cached_hole_size = 0;
 
-	current->mm->mmap = NULL;
 	install_exec_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 
