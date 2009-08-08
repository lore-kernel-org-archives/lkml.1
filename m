Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbZHHC1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbZHHC1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 22:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757699AbZHHC1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 22:27:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:26774 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847AbZHHC0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 22:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Trv8cqVSC/1juEbr4Ihu69GbaR+8EV5JMR13ID3dSDzpOVYcZNraxn80VQ2Khbk3HJ
         dIG4W0WNeW8JPEhh5peWR6jH+PLcrQjBfrFc9vqm3Fy0ttppNBGn+XfECFWIDCsgi3Fg
         J4d0MyB9hd+dHK2qUHLkjGllGg03jrS+N4CB4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/3] perfcounter: Align ftrace events raw samples to 8 bytes
Date: Sat,  8 Aug 2009 04:26:39 +0200
Message-Id: <1249698400-5441-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
References: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align the ftrace events raw samples to 8 bytes so that they meet the
perf output event alignements requirements.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
---
 include/trace/ftrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 80e5f6c..7b0834c 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -687,7 +687,7 @@ static void ftrace_profile_##call(proto)				\
 	pc = preempt_count();						\
 									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
-	__entry_size = __data_size + sizeof(*entry);			\
+	__entry_size = ALIGN(__data_size + sizeof(*entry), sizeof(u64));\
 									\
 	do {								\
 		char raw_data[__entry_size];				\
-- 
1.6.2.3

