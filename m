Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYGYUTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYGYUTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 16:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYGYUTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 16:19:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:58735 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYGYUTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 16:19:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Xy0YYTlSnXJo3rFjS6sRt3V2+wF1l3MsEkK2Fu+QsTd9moyil2ioqPrf33qkbljl+Q
         Wi0r0n6SQG80oLCiPLmAmpzeqsVniRu4924JGu7B1/43rPTS62KU3dStqzhEU3TYq0TE
         V9mQBeQF8Ccl2Yo+MidkYGGbC21OFO0ycrY2w=
Subject: [PATCH] sys_paccept definition missing __user annotation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 13:19:22 -0700
Message-Id: <1217017162.5971.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced by:
aaca0bdca573f3f51ea03139f9c7289541e7bca3 flag parameters: paccept

net/socket.c:1515:17: error: symbol 'sys_paccept' redeclared with different type (originally declared at include/linux/syscalls.h:413) - incompatible argument 4 (different address spaces)

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/syscalls.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 06f2bf7..d6ff145 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -411,7 +411,7 @@ asmlinkage long sys_bind(int, struct sockaddr __user *, int);
 asmlinkage long sys_connect(int, struct sockaddr __user *, int);
 asmlinkage long sys_accept(int, struct sockaddr __user *, int __user *);
 asmlinkage long sys_paccept(int, struct sockaddr __user *, int __user *,
-			    const sigset_t *, size_t, int);
+			    const __user sigset_t *, size_t, int);
 asmlinkage long sys_getsockname(int, struct sockaddr __user *, int __user *);
 asmlinkage long sys_getpeername(int, struct sockaddr __user *, int __user *);
 asmlinkage long sys_send(int, void __user *, size_t, unsigned);
-- 
1.6.0.rc0.182.gb96c7



