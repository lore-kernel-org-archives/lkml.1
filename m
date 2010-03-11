Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab0CKM5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 07:57:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:55220 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667Ab0CKM5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 07:57:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=bACitdFbTeeVey/I39AW7/iq6hoA/OXSN4USrwQEDCfVzJoPjX/ltF5R4bJmR4g3WM
         D2oV0hBREWvQqVdlgbQoT3vRHe5QiUG9k2x/a9nh//UrlklSkegeVXihnKA1cwhhwa3h
         kiVCrIZeKQff6EC5oNwRJsautBVR58Xp8rzpM=
From: John Kacur <jkacur@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Kyle McMartin <kyle@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH] perf: Make the install relative to DESTDIR if specified
Date: Thu, 11 Mar 2010 13:57:00 +0100
Message-Id: <1268312220-12880-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this change, the install path is relative to
prefix/DESTDIR
where prefix is automatically set to $HOME

This can produce unexpected results. For example

make -C tools/perf DESTDIR=/home/jkacur/tmp install-man

creates the directory:		/home/jkacur/home/jkacur/tmp/share/...
instead of  the expected:	/home/jkacur/tmp/share/...

Signed-off-by: John Kacur <jkacur@redhat.com>
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
index 2d53738..5da0cd0 100644
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
 
-- 
1.6.6.1

