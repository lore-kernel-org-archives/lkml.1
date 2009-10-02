Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbZJBBdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbZJBBdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756680AbZJBBdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:38 -0400
Received: from kroah.org ([198.145.64.141]:33298 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358AbZJBBdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:37 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:19 2009
Message-Id: <20091002012419.154037296@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pierre Habouzit <pierre.habouzit@intersec.com>
Subject: [080/136] perf tools: do not complain if root is owning perf.data
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=perf-tools-do-not-complain-if-root-is-owning-perf.data.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Pierre Habouzit <pierre.habouzit@intersec.com>

commit 119e7a22bb70d84849384e5113792cd45afa4f85 upstream.

This improves patch fa6963b24 so that perf.data stuff that has
been dumped as root can be read (annotate/report) by a user
without the use of the --force.

Rationale is that root has plenty of ways to screw us (usually)
that do not require twisted schemes involving specially
crafting a perf.data.

Signed-off-by: Pierre Habouzit <pierre.habouzit@intersec.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090827075902.GF19653@laphroaig.corp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 tools/perf/builtin-annotate.c |    4 ++--
 tools/perf/builtin-report.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -1335,8 +1335,8 @@ static int __cmd_annotate(void)
 		exit(-1);
 	}
 
-	if (!force && (stat.st_uid != geteuid())) {
-		fprintf(stderr, "file: %s not owned by current user\n", input_name);
+	if (!force && stat.st_uid && (stat.st_uid != geteuid())) {
+		fprintf(stderr, "file: %s not owned by current user or root\n", input_name);
 		exit(-1);
 	}
 
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1857,8 +1857,8 @@ static int __cmd_report(void)
 		exit(-1);
 	}
 
-	if (!force && (stat.st_uid != geteuid())) {
-		fprintf(stderr, "file: %s not owned by current user\n", input_name);
+	if (!force && stat.st_uid && (stat.st_uid != geteuid())) {
+		fprintf(stderr, "file: %s not owned by current user or root\n", input_name);
 		exit(-1);
 	}
 


