Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbZJ0AdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbZJ0AdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbZJ0AdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:33:21 -0400
Received: from smtp-out.neti.ee ([194.126.126.34]:48345 "EHLO smtp-out.neti.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575AbZJ0AdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:33:20 -0400
X-SMTP-Auth-NETI-Businesmail: no
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 2] perf tools: notify user when unrecognized event is
	specified
X-Mercurial-Node: 03ec9ee96f17cef054241630a941bf94db7e1ad2
Message-Id: <03ec9ee96f17cef05424.1256603584@localhost>
In-Reply-To: <patchbomb.1256603583@localhost>
References: <patchbomb.1256603583@localhost>
User-Agent: Mercurial-patchbomb/1.3.1
Date: Tue, 27 Oct 2009 00:33:04 -0000
From: Marti Raudsepp <marti@juffo.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marti Raudsepp <marti@juffo.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously no indication was given about what went wrong.

Signed-off-by: Marti Raudsepp <marti@juffo.org>

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -677,6 +677,8 @@
 	if (ret != EVT_FAILED)
 		goto modifier;
 
+	fprintf(stderr, "invalid or unsupported event: '%s'\n", *str);
+	fprintf(stderr, "Run 'perf list' for a list of valid events\n");
 	return EVT_FAILED;
 
 modifier:
