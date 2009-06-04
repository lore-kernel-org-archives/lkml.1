Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbZFDRO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbZFDRO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbZFDROw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:14:52 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:39350 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZFDROw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:14:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=YogjIGLPbKeznLhSujUSx5G/SEVvnBJvnN+FSeoaQGUbCC8iw5xrKyiNgLyu7Wif0C
         V+Mjj0nMtSkwBGdRlhoV01zEpVcUbE4gxm+ffPAlEMBQJ5QA+b+KImUdfaLKWEs5TfN4
         /gdI+tzUT6ufjqbctEOEN6oMTM39Q4x4QyWPM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perfcounter: don't keep warnings treated as errors as default
Date: Thu,  4 Jun 2009 19:14:48 +0200
Message-Id: <1244135688-5542-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building userspace perfcounter tools gives such warning:

cc1: warnings being treated as errors
builtin-top.c: In function ‘print_sym_table’:
builtin-top.c:207: erreur: ignoring return value of ‘write’, declared with attribute warn_unused_result
make: *** [builtin-top.o] Erreur 1

It's about checking if a write was successful on stdout.
The real point here is that treating each warning as errors by default
can be avoided, especially for such harmless warning.

This patch drop -Werror from perfcounter tools makefile.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/perf_counter/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index c9ec458..9b42897 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -159,7 +159,7 @@ uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
-CFLAGS = -ggdb3 -Wall -Werror -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -O6 -march=native
+CFLAGS = -ggdb3 -Wall -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -O6 -march=native
 LDFLAGS = -lpthread -lrt -lelf
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
-- 
1.6.2.3

