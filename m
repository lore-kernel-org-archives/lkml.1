Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbZJGT5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbZJGT5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 15:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759941AbZJGT5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 15:57:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:56874 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759938AbZJGT5X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 15:57:23 -0400
Date: Wed, 7 Oct 2009 12:56:01 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH] perf timechart: Work around commit 42e59d7d19dc4b4
Message-ID: <20091007125601.415e7898@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 07c039ee370f49a0c5fc690ba473d42d27ccb022 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 7 Oct 2009 12:27:07 -0700
Subject: [PATCH] perf timechart: Work around commit 42e59d7d19dc4b4

Commit 42e59d7d19dc4b4 introduced a sample frequency framework..
.. however it unfortunately changed how perf events get recorded,
and caused timechart to miss events to the point that timechart
became useless.

This patch causes the timechart code to use -F 0 to not use the
new framework when recording timechart data.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 tools/perf/builtin-timechart.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 702d8fe..e5bda76 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1105,6 +1105,7 @@ static const char *record_args[] = {
 	"-M",
 	"-f",
 	"-c", "1",
+	"-F", "0",
 	"-e", "power:power_start",
 	"-e", "power:power_end",
 	"-e", "power:power_frequency",
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
