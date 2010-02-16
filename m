Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534Ab0BPX2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 18:28:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:35169 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933267Ab0BPX2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 18:28:12 -0500
Date: Tue, 16 Feb 2010 23:27:45 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20100216140213.GB16448@redhat.com>
References: <20100216140213.GB16448@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: set_personality_ia32() misses force_personality32
Message-ID: <tip-1dfc76ec37a59018d8ed39152695ff27a434415b@git.kernel.org>
Git-Commit-ID: 1dfc76ec37a59018d8ed39152695ff27a434415b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Feb 2010 23:27:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1dfc76ec37a59018d8ed39152695ff27a434415b
Gitweb:     http://git.kernel.org/tip/1dfc76ec37a59018d8ed39152695ff27a434415b
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 16 Feb 2010 15:02:13 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 16 Feb 2010 09:44:30 -0800

x86: set_personality_ia32() misses force_personality32

05d43ed8a "x86: get rid of the insane TIF_ABI_PENDING bit" forgot
about force_personality32, fix.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
LKML-Reference: <20100216140213.GB16448@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/process_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 41a26a8..126f0b4 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -527,6 +527,7 @@ void set_personality_ia32(void)
 
 	/* Make sure to be in 32bit mode */
 	set_thread_flag(TIF_IA32);
+	current->personality |= force_personality32;
 
 	/* Prepare the first "return" to user space */
 	current_thread_info()->status |= TS_COMPAT;
