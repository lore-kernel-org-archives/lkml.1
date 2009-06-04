Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbZFDUQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbZFDUQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbZFDUQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:16:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:65530 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbZFDUQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:16:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=fVCkoTVwcTUd635miCYuEHFO7kxXA39Obp7QOnPeqpTO4mlhVet6KAhzrG5bb1WB8V
         SjKcfQkGrma8osJXaefuBR6yKY4VZ7xClSxtNpK2I+Y6yJvbOOGPVtmTXbtsSHDJsvk2
         FbNsG8xZqjb7n8r7fYSD1C+T2fwlRyZtMaOE8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perfcounter: fix warn_unused_result warnings in perfcounter utils
Date: Thu,  4 Jun 2009 22:15:58 +0200
Message-Id: <1244146558-8635-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warnings for return values that we don't care.

util/quote.c:222: attention : ignoring return value of ‘fwrite’, declared with attribute warn_unused_result
util/quote.c:235: attention : ignoring return value of ‘fwrite’, declared with attribute warn_unused_result
util/quote.c: In function ‘write_name_quotedpfx’:
util/quote.c:290: attention : ignoring return value of ‘fwrite’, declared with attribute warn_unused_result

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Documentation/perf_counter/util/quote.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/util/quote.c b/Documentation/perf_counter/util/quote.c
index 7a49fcf..f18c521 100644
--- a/Documentation/perf_counter/util/quote.c
+++ b/Documentation/perf_counter/util/quote.c
@@ -201,8 +201,9 @@ static size_t quote_c_style_counted(const char *name, ssize_t maxlen,
 	} while (0)
 #define EMITBUF(s, l)                           \
 	do {                                        \
+		int __ret;				\
 		if (sb) strbuf_add(sb, (s), (l));       \
-		if (fp) fwrite((s), (l), 1, fp);        \
+		if (fp) __ret = fwrite((s), (l), 1, fp);        \
 		count += (l);                           \
 	} while (0)
 
@@ -287,7 +288,9 @@ extern void write_name_quotedpfx(const char *pfx, size_t pfxlen,
 		quote_c_style(name, NULL, fp, 1);
 		fputc('"', fp);
 	} else {
-		fwrite(pfx, pfxlen, 1, fp);
+		int ret;
+
+		ret = fwrite(pfx, pfxlen, 1, fp);
 		fputs(name, fp);
 	}
 	fputc(terminator, fp);
-- 
1.6.2.3

