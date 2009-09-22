Return-Path: <linux-kernel-owner+w=401wt.eu-S1752330AbZIVTi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbZIVTi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZIVTiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:38:54 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:6632 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbZIVTis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:38:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=en0GhkyepT0Vh8XzpsY1IgPZzVQpj5SJZ+7LVPXUAs535OSfHSHG3UmJFrBaauhoqF
         Qhqz0Gw+vACpPy8fp3KsNBh7ILrXuZyJXpzl/Rmqpxjq7FApi+ykpymwgX4B9gG9w4aZ
         QUKrjeyJxyssPDIWFUr6/hjC9EIm6KLaXy1Gw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 11/24] x86/ptrace: Fix regs_get_argument_nth() to add correct offset
Date: Tue, 22 Sep 2009 21:38:09 +0200
Message-Id: <1253648302-5771-12-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Fix regs_get_argument_nth() to add correct offset bytes. Because
offset_of() returns offset in byte, the offset should be added
to char * instead of unsigned long *.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20090910235306.22412.31613.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ptrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index a33a17d..caffb68 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -150,7 +150,7 @@ static const int arg_offs_table[] = {
 unsigned long regs_get_argument_nth(struct pt_regs *regs, unsigned int n)
 {
 	if (n < ARRAY_SIZE(arg_offs_table))
-		return *((unsigned long *)regs + arg_offs_table[n]);
+		return *(unsigned long *)((char *)regs + arg_offs_table[n]);
 	else {
 		/*
 		 * The typical case: arg n is on the stack.
-- 
1.6.2.3

