Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZK3HSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZK3HSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 02:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZK3HSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 02:18:52 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:60621 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbZK3HSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 02:18:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KLgkriNW2ijyfjOZo9M6P9FqsVXi+/75AavmdbMWikrMcBZv7+UO4u2zOHruiAZ5HL
         XHIPuKFyFFDU9v4Gabb0/curid+K//rUdtWX/PwMqdWGhdCMhK53jhNCDwDVHcRztob2
         kaJYjoo/w7CiQ5dAe1BiZEr2MBbt8sGciELWc=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org, anton@samba.org,
       hch@infradead.org
Subject: [PATCH 1/4] perf trace/scripting: silence PERL_EMBED_* backtick errors
Date: Mon, 30 Nov 2009 01:18:46 -0600
Message-Id: <1259565529-6407-2-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1259565529-6407-1-git-send-email-tzanussi@gmail.com>
References: <1259565529-6407-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The backtick shell substitutions for PERL_EMBED_LDOPT/CCOPT make a lot
of noise on stderr if Embed.pm isn't installed - this silences them.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8ad57b5..d62a2d7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -490,8 +490,8 @@ else
 	LIB_OBJS += util/probe-finder.o
 endif
 
-PERL_EMBED_LDOPTS = `perl -MExtUtils::Embed -e ldopts`
-PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts`
+PERL_EMBED_LDOPTS = `perl -MExtUtils::Embed -e ldopts 2>/dev/null`
+PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
 
 ifneq ($(shell sh -c "(echo '\#include <EXTERN.h>'; echo '\#include <perl.h>'; echo 'int main(void) { perl_alloc(); return 0; }') | $(CC) -x c - $(PERL_EMBED_CCOPTS) -o /dev/null $(PERL_EMBED_LDOPTS) > /dev/null 2>&1 && echo y"), y)
 	BASIC_CFLAGS += -DNO_LIBPERL
-- 
1.6.4.GIT

