Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab0CKOmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:42:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:35528 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab0CKOm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:42:28 -0500
Date: Thu, 11 Mar 2010 14:39:57 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, kyle@redhat.com, fweisbec@gmail.com,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, kyle@redhat.com, fweisbec@gmail.com,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1268312220-12880-1-git-send-email-jkacur@redhat.com>
References: <1268312220-12880-1-git-send-email-jkacur@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Make the install relative to DESTDIR if specified
Message-ID: <tip-7ae5f21361fea11f58c398701da635f778635d13@git.kernel.org>
Git-Commit-ID: 7ae5f21361fea11f58c398701da635f778635d13
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:39:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ae5f21361fea11f58c398701da635f778635d13
Gitweb:     http://git.kernel.org/tip/7ae5f21361fea11f58c398701da635f778635d13
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Thu, 11 Mar 2010 13:57:00 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 14:08:11 +0100

perf: Make the install relative to DESTDIR if specified

Without this change, the install path is relative to
prefix/DESTDIR where prefix is automatically set to $HOME.

This can produce unexpected results. For example:

  make -C tools/perf DESTDIR=/home/jkacur/tmp install-man

creates the directory:		/home/jkacur/home/jkacur/tmp/share/...
instead of the expected:	/home/jkacur/tmp/share/...

Signed-off-by: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Kyle McMartin <kyle@redhat.com>
Cc: <stable@kernel.org>
LKML-Reference: <1268312220-12880-1-git-send-email-jkacur@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/Makefile |    4 +++-
 tools/perf/Makefile               |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index bdd3b7e..bd498d4 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -24,7 +24,10 @@ DOC_MAN1=$(patsubst %.txt,%.1,$(MAN1_TXT))
 DOC_MAN5=$(patsubst %.txt,%.5,$(MAN5_TXT))
 DOC_MAN7=$(patsubst %.txt,%.7,$(MAN7_TXT))
 
+# Make the path relative to DESTDIR, not prefix
+ifndef DESTDIR
 prefix?=$(HOME)
+endif
 bindir?=$(prefix)/bin
 htmldir?=$(prefix)/share/doc/perf-doc
 pdfdir?=$(prefix)/share/doc/perf-doc
@@ -32,7 +35,6 @@ mandir?=$(prefix)/share/man
 man1dir=$(mandir)/man1
 man5dir=$(mandir)/man5
 man7dir=$(mandir)/man7
-# DESTDIR=
 
 ASCIIDOC=asciidoc
 ASCIIDOC_EXTRA = --unsafe
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5840499..8a8f52d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -216,7 +216,10 @@ STRIP ?= strip
 # runtime figures out where they are based on the path to the executable.
 # This can help installing the suite in a relocatable way.
 
+# Make the path relative to DESTDIR, not to prefix
+ifndef DESTDIR
 prefix = $(HOME)
+endif
 bindir_relative = bin
 bindir = $(prefix)/$(bindir_relative)
 mandir = share/man
@@ -233,7 +236,6 @@ sysconfdir = $(prefix)/etc
 ETC_PERFCONFIG = etc/perfconfig
 endif
 lib = lib
-# DESTDIR=
 
 export prefix bindir sharedir sysconfdir
 
