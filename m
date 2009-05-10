Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbZEJGN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbZEJGN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 02:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZEJGNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 02:13:20 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61824 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZEJGNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 02:13:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ryYjJvjhKxOWuRB7Sna+RWnNUVT+eYVEln4kTl6UAMqI11tB22xWP7zcPAJRTAtXJ0
         cG7St0AjZa0hVs+RSic54z3aAmxMfhMmFt2mIzuB8yqrVus7ZmXdHe6SkIknV+jYD8mA
         jNPVBAHf7WGw1P78ZrLVnOQyAmlqjCUSoIEkU=
MIME-Version: 1.0
Date: Sun, 10 May 2009 02:13:19 -0400
Message-ID: <3fee128b0905092313x608e65e0l7b1116d86914114f@mail.gmail.com>
Subject: perf_counter: buffer overwrite problem for perf top command
From: Erdem Aktas <eaktas1@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;
There is a buffer overwrite problem in builtin-top.c line 526, When I
tried to use ./perf top command, it was giving memory corruption
problem. should not we use malloc(strlen(str)+1) ?

Regards
-erdem


=======================
diff --git a/Documentation/perf_counter/builtin-top.c
b/Documentation/perf_counter/builtin-top.c
index cd6f61d..b1549dd 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -523,7 +523,7 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 	if (strstr(sym, "_text_start") || strstr(sym, "_text_end"))
 		return 1;

-	s->sym = malloc(strlen(str));
+	s->sym = malloc(strlen(str)+1);
 	assert(s->sym);

 	strcpy((char *)s->sym, str);
