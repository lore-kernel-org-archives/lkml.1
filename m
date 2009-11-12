Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbZKLIWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbZKLIWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 03:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbZKLIWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 03:22:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:58520 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbZKLIWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 03:22:06 -0500
Date: Thu, 12 Nov 2009 08:21:50 GMT
From: tip-bot for Roel Kluin <roel.kluin@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, roel.kluin@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, roel.kluin@gmail.com, tglx@linutronix.de
In-Reply-To: <4AFB2C0B.50605@gmail.com>
References: <4AFB2C0B.50605@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Fix return value of tracing_stats_read()
Message-ID: <tip-a646365cc330b5aaf4452c91f61b1e0d1acf68d0@git.kernel.org>
Git-Commit-ID: a646365cc330b5aaf4452c91f61b1e0d1acf68d0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a646365cc330b5aaf4452c91f61b1e0d1acf68d0
Gitweb:     http://git.kernel.org/tip/a646365cc330b5aaf4452c91f61b1e0d1acf68d0
Author:     Roel Kluin <roel.kluin@gmail.com>
AuthorDate: Wed, 11 Nov 2009 22:26:35 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 11 Nov 2009 21:26:55 -0500

tracing: Fix return value of tracing_stats_read()

The function tracing_stats_read() mistakenly returns ENOMEM instead
of the negative value -ENOMEM.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
LKML-Reference: <4AFB2C0B.50605@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b20d3ec..03c7fd5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3730,7 +3730,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
-		return ENOMEM;
+		return -ENOMEM;
 
 	trace_seq_init(s);
 
