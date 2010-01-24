Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945Ab0AXQLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab0AXQLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 11:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907Ab0AXQL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 11:11:28 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:43142 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab0AXQL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 11:11:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=E3OAQrRI2Mz8bXsypI/kdclvv6utHhi8kRtQWUn5PD+ULhdIiMvE5XhLg4IkIAxEYO
         qM0G49qtG41oIyAvjYqklJDA7FpfZopkpmM7mmsh2HbMnd42ygPV+OQYEsaAt5aAMBRF
         of6lxzG7NjsmxXC9Ggl8juW++t7oZyw2pkyWk=
From: Thiago Farina <tfransosi@gmail.com>
To: tfransosi@gmail.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] trace/trace_output.c: fix "integer as NULL pointer" warning.
Date: Sun, 24 Jan 2010 11:03:50 -0500
Message-Id: <1264349038-1766-3-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.6.1.383.g5a9f
In-Reply-To: <1264349038-1766-1-git-send-email-tfransosi@gmail.com>
References: <1264349038-1766-1-git-send-email-tfransosi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/trace/trace_output.c:256:24: warning: Using plain integer as NULL pointer

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 kernel/trace/trace_output.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 8e46b33..2404c12 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -253,7 +253,7 @@ void *trace_seq_reserve(struct trace_seq *s, size_t len)
 	void *ret;
 
 	if (s->full)
-		return 0;
+		return NULL;
 
 	if (len > ((PAGE_SIZE - 1) - s->len)) {
 		s->full = 1;
-- 
1.6.6.1.383.g5a9f

