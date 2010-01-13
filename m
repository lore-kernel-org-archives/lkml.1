Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049Ab0AMQkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab0AMQkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026Ab0AMQkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:40:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:33409 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab0AMQkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:40:13 -0500
Date: Wed, 13 Jan 2010 16:39:35 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, brgerst@gmail.com, ian.campbell@citrix.com,
       lists@nerdbynature.de, Jeremy.Fitzhardinge@citrix.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, brgerst@gmail.com, lists@nerdbynature.de,
       ian.campbell@citrix.com, Jeremy.Fitzhardinge@citrix.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1263377768-19600-1-git-send-email-ian.campbell@citrix.com>
References: <1263377768-19600-1-git-send-email-ian.campbell@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: kernel_thread() -- initialize SS to a known state
Message-ID: <tip-864a0922dd128392467611d9857e5138c6a91999@git.kernel.org>
Git-Commit-ID: 864a0922dd128392467611d9857e5138c6a91999
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 16:39:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  864a0922dd128392467611d9857e5138c6a91999
Gitweb:     http://git.kernel.org/tip/864a0922dd128392467611d9857e5138c6a91999
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Wed, 13 Jan 2010 10:16:07 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 11:23:45 +0100

x86: kernel_thread() -- initialize SS to a known state

Before the kernel_thread was converted into "C" we had
pt_regs::ss set to __KERNEL_DS (by SAVE_ALL asm macro).

Though I must admit I didn't find any *explicit* load of
%ss from this structure the better to be on a safe side
and set it to a known value.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Cc: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1263377768-19600-1-git-send-email-ian.campbell@citrix.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c6ee241..02c3ee0 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -288,6 +288,8 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	regs.es = __USER_DS;
 	regs.fs = __KERNEL_PERCPU;
 	regs.gs = __KERNEL_STACK_CANARY;
+#else
+	regs.ss = __KERNEL_DS;
 #endif
 
 	regs.orig_ax = -1;
