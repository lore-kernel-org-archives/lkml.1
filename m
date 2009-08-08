Return-Path: <linux-kernel-owner+w=401wt.eu-S1751376AbZHHO6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbZHHO6G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 10:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZHHO6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 10:58:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:47106 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbZHHO6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 10:58:03 -0400
Date: Sat, 8 Aug 2009 14:57:37 GMT
From: tip-bot for Eric Dumazet <eric.dumazet@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eric.dumazet@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4A7C06B9.2090302@gmail.com>
References: <4A7C06B9.2090302@gmail.com>
Subject: [tip:tracing/urgent] ring-buffer: Fix memleak in ring_buffer_free()
Message-ID: <tip-bd3f02212d6a457267e0c9c02c426151c436d9d4@git.kernel.org>
Git-Commit-ID: bd3f02212d6a457267e0c9c02c426151c436d9d4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 08 Aug 2009 14:57:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd3f02212d6a457267e0c9c02c426151c436d9d4
Gitweb:     http://git.kernel.org/tip/bd3f02212d6a457267e0c9c02c426151c436d9d4
Author:     Eric Dumazet <eric.dumazet@gmail.com>
AuthorDate: Fri, 7 Aug 2009 12:49:29 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 7 Aug 2009 12:46:39 -0400

ring-buffer: Fix memleak in ring_buffer_free()

I noticed oprofile memleaked in linux-2.6 current tree,
and tracked this ring-buffer leak.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
LKML-Reference: <4A7C06B9.2090302@gmail.com>
Cc: stable@kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 kernel/trace/ring_buffer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d4d3580..a330513 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -735,6 +735,7 @@ ring_buffer_free(struct ring_buffer *buffer)
 
 	put_online_cpus();
 
+	kfree(buffer->buffers);
 	free_cpumask_var(buffer->cpumask);
 
 	kfree(buffer);
