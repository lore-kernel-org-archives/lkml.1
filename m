Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbZHRQzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbZHRQzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759459AbZHRQzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:55:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:42389 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759452AbZHRQzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:55:00 -0400
Date: Tue, 18 Aug 2009 16:54:19 GMT
From: tip-bot for Kyle McMartin <kyle@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       kyle@redhat.com, fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       kyle@redhat.com, fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090818164125.GM25206@bombadil.infradead.org>
References: <20090818164125.GM25206@bombadil.infradead.org>
Subject: [tip:perfcounters/urgent] perf tools: Make 'make html' work
Message-ID: <tip-b395cd8a74b4a8d943dd4b5585e676f62f7350b3@git.kernel.org>
Git-Commit-ID: b395cd8a74b4a8d943dd4b5585e676f62f7350b3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 16:54:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b395cd8a74b4a8d943dd4b5585e676f62f7350b3
Gitweb:     http://git.kernel.org/tip/b395cd8a74b4a8d943dd4b5585e676f62f7350b3
Author:     Kyle McMartin <kyle@redhat.com>
AuthorDate: Tue, 18 Aug 2009 12:41:25 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 18:43:13 +0200

perf tools: Make 'make html' work

pushd tools/perf/Documentation
make html
popd

is failing for me...

    ASCIIDOC perf-annotate.html
ERROR: unsafe: include file: /etc/asciidoc/./stylesheets/xhtml11.css
ERROR: unsafe: include file:
/etc/asciidoc/./stylesheets/xhtml11-manpage.css
ERROR: unsafe: include file:
/etc/asciidoc/./stylesheets/xhtml11-quirks.css
make: *** [perf-annotate.html] Error 1

Apparently asciidoc "unsafe" is the default mode of operation
in practice.

https://bugzilla.redhat.com/show_bug.cgi?id=506953

Works tidily now.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20090818164125.GM25206@bombadil.infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Documentation/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index 5457192..bdd3b7e 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -35,7 +35,7 @@ man7dir=$(mandir)/man7
 # DESTDIR=
 
 ASCIIDOC=asciidoc
-ASCIIDOC_EXTRA =
+ASCIIDOC_EXTRA = --unsafe
 MANPAGE_XSL = manpage-normal.xsl
 XMLTO_EXTRA =
 INSTALL?=install
