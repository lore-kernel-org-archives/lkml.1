Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbZFPQBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbZFPQBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZFPQBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:01:11 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:49917 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZFPQBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:01:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=KKDFJwZU+Y7ogyQS8DsbRJeVMGaF5ML1q2rxCwdyyPqSbbSXEPAaag1iZRNQNYrydj
         cZXGM/KnZ4P7X5IOsJ3mzCx6WBNYHneaq/NdtQdzP2TYaccKodCtz2RX25NEzz6UaBCT
         3He32a9wylj4YQvioVi2RmZy6/nV6LycFnX38=
Message-ID: <4A37DDEA.3080003@gmail.com>
Date: Tue, 16 Jun 2009 20:01:14 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] tracing: Keep index within map_pid_to_cmdline[]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that index `pid' remains within array map_pid_to_cmdline[]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8acd9b8..f359e9e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -803,7 +803,7 @@ void trace_find_cmdline(int pid, char comm[])
 		return;
 	}
 
-	if (pid > PID_MAX_DEFAULT) {
+	if (pid > PID_MAX_DEFAULT || pid < 0) {
 		strcpy(comm, "<...>");
 		return;
 	}
