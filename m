Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbZK3IYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbZK3IYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbZK3IYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:24:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:37883 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbZK3IYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:24:20 -0500
Date: Mon, 30 Nov 2009 08:23:43 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1259565529-6407-2-git-send-email-tzanussi@gmail.com>
References: <1259565529-6407-2-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/scripting] perf trace/scripting: Silence PERL_EMBED_* backtick errors
Message-ID: <tip-f8be4231f82ab56a87ce74906671afbe1aa9ec75@git.kernel.org>
Git-Commit-ID: f8be4231f82ab56a87ce74906671afbe1aa9ec75
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f8be4231f82ab56a87ce74906671afbe1aa9ec75
Gitweb:     http://git.kernel.org/tip/f8be4231f82ab56a87ce74906671afbe1aa9ec75
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Mon, 30 Nov 2009 01:18:46 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 30 Nov 2009 09:03:59 +0100

perf trace/scripting: Silence PERL_EMBED_* backtick errors

The backtick shell substitutions for PERL_EMBED_LDOPT/CCOPT make
a lot of noise on stderr if Embed.pm isn't installed - this
silences them.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
Cc: anton@samba.org
Cc: hch@infradead.org
LKML-Reference: <1259565529-6407-2-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
