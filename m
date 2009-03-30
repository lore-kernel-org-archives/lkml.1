Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbZC3Sp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbZC3Sp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759047AbZC3Spb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:45:31 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60651 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953AbZC3Sp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:45:28 -0400
To: user-mode-linux-devel@lists.sourceforge.net
CC: jdike@addtoit.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <E1LoMQ2-0007bB-By@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Mon, 30 Mar 2009 20:41:10 +0200)
Subject: [patch 3/3] uml: fix warnings in kernel_execve
References: <E1LoMQ2-0007bB-By@pomaz-ex.szeredi.hu>
Message-Id: <E1LoMTw-0007d2-AI@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 30 Mar 2009 20:45:12 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Fix the following warnings:

arch/um/kernel/syscall.c: In function 'kernel_execve':
arch/um/kernel/syscall.c:130: warning: passing argument 1 of 'um_execve' discards qualifiers from pointer target type
arch/um/kernel/syscall.c:130: warning: passing argument 2 of 'um_execve' discards qualifiers from pointer target type
arch/um/kernel/syscall.c:130: warning: passing argument 3 of 'um_execve' discards qualifiers from pointer target type

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 arch/um/kernel/syscall.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/um/kernel/syscall.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/syscall.c	2009-03-30 20:25:17.000000000 +0200
+++ linux-2.6/arch/um/kernel/syscall.c	2009-03-30 20:36:20.000000000 +0200
@@ -127,7 +127,8 @@ int kernel_execve(const char *filename,
 
 	fs = get_fs();
 	set_fs(KERNEL_DS);
-	ret = um_execve(filename, argv, envp);
+	ret = um_execve((char *)filename, (char __user *__user *)argv,
+			(char __user *__user *) envp);
 	set_fs(fs);
 
 	return ret;
