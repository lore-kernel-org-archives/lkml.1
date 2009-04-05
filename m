Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbZDEPHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbZDEPHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 11:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbZDEPH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 11:07:28 -0400
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:53055 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754146AbZDEPH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 11:07:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=elastic.org;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
	b=Iux51Z6G6+gb1Zt1siuRY6p9m672Yr8MO77fqn3eX92vOtGXyU8sDllYrCj1BxWgbXFqEQgtxuIfoxKpZIkNI2IGH6DUWVCeTMoi9CSpBo4NMZmcPKY7CPQRmjzhevAA;
From: "Frank Ch. Eigler" <fche@elastic.org>
To: linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Cc: systemtap@sources.redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
       mingo@elte.hu, "Frank Ch. Eigler" <fche@elastic.org>
Subject: [PATCH 1/2] make arch_init_ftrace_syscalls multiply callable
Date: Sun,  5 Apr 2009 10:17:53 -0400
Message-Id: <1238941074-27424-2-git-send-email-fche@elastic.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238941074-27424-1-git-send-email-fche@elastic.org>
References: <1238941074-27424-1-git-send-email-fche@elastic.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since both the utrace-based ftrace engine and the original
syscall-specific ftrace engine use the syscall pretty-printer, this
initialization function needs to be callable from each of them.

Signed-off-by: Frank Ch. Eigler <fche@elastic.org>
---
 arch/x86/kernel/ftrace.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1d0d7f4..1d99d3d 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -498,6 +498,9 @@ void arch_init_ftrace_syscalls(void)
 	if (atomic_inc_return(&refs) != 1)
 		goto end;
 
+        if (syscalls_metadata)
+                return;
+
 	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
 					FTRACE_SYSCALL_MAX, GFP_KERNEL);
 	if (!syscalls_metadata) {
-- 
1.6.0.6

