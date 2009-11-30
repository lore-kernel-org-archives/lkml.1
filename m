Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZK3HTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZK3HTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 02:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbZK3HSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 02:18:54 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:60958 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbZK3HSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 02:18:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uVP+6VKjIGgaVkkvm9+BQWHPpYZYWSFU/NcaF3ABRra8iLaRW86NSkRP1lbDNgnkIU
         Vf7jNuJpgC1oulsYC7iEVR1KM9xh06ca7ciW3kJMSKrTtMDtLwX0umGxbYdTuAdTmpn1
         QGgQfYshT1+mR4M3roVDtdk7PYjVkck1JiSTs=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org, anton@samba.org,
       hch@infradead.org
Subject: [PATCH 2/4] perf trace/scripting: ignore shadowed variable warning for perf-trace-perl.c
Date: Mon, 30 Nov 2009 01:18:47 -0600
Message-Id: <1259565529-6407-3-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1259565529-6407-1-git-send-email-tzanussi@gmail.com>
References: <1259565529-6407-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debugging versions of the ENTER and LEAVE internal perl macros,
used when embedding perl, define a local block with a my_perl perl
variable that shadows a global variable of the same name, which is
also the name expected by the embedding API for the embedded
interpreter.  Since we don't have control over the code generated in
this case and can't get rid of the warning, ignore it.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d62a2d7..20cd663 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -872,7 +872,7 @@ util/find_next_bit.o: ../../lib/find_next_bit.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o util/find_next_bit.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
 util/trace-event-perl.o: util/trace-event-perl.c PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o util/trace-event-perl.o -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes  -Wno-unused-parameter $<
+	$(QUIET_CC)$(CC) -o util/trace-event-perl.o -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
 
 scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-Util/Context.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o scripts/perl/Perf-Trace-Util/Context.o -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
-- 
1.6.4.GIT

