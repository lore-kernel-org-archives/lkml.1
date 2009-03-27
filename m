Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZC0NWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZC0NWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 09:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbZC0NW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 09:22:27 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:35094 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbZC0NW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 09:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=olpSELjMxNZm5NgyzpF1Gp+QMZh0gGwC0sMGCMYhirqHYJxGTsH3itbpNhQZoW1B4T
         w4e2F9Qc4opdcDv92XnS9FRx94ZdkCwFnbRGodXx+aPo0xbZIKR4mKvIHwM/l+DBlZr0
         Rdyk4WaPpPqw5/x2ENEYs+Rs7JwBMLs5bCGGk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2] tracing/ftrace: fix missing include string.h
Date: Fri, 27 Mar 2009 14:22:10 +0100
Message-Id: <1238160130-7437-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1238159920-7411-1-git-send-email-fweisbec@gmail.com>
References: <1238159920-7411-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building a kernel with tracing can raise the following warning on
tip/master:

kernel/trace/trace.c:1249: error: implicit declaration of function 'vbin_printf'

We are missing an include to string.h

[v2: add reported-by]

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2a81dec..704cd7f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -30,6 +30,7 @@
 #include <linux/percpu.h>
 #include <linux/splice.h>
 #include <linux/kdebug.h>
+#include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/poll.h>
-- 
1.6.1

