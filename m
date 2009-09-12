Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbZILLEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbZILLEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 07:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbZILLEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 07:04:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:43143 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZILLEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 07:04:07 -0400
Date: Sat, 12 Sep 2009 13:05:11 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu, fweisbec@gmail.com,
       peterz@infradead.org
Subject: [PATCH 4/8] perf: Add a sample_event type to the event_union
Message-ID: <20090912130511.411434b5@infradead.org>
In-Reply-To: <20090912130306.5d0086ea@infradead.org>
References: <20090912130306.5d0086ea@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4837fa586ab440d6a79f542b90994c1dde9be8ef Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 12 Sep 2009 07:53:00 +0200
Subject: [PATCH] perf: Add a sample_event type to the event_union

Add a sample_event type to the event_union so that raw samples
can be processed easily.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 tools/perf/util/event.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1545349..33ced5a 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -60,6 +60,12 @@ struct read_event {
 	u64 id;
 };
 
+struct sample_event{
+	struct perf_event_header        header;
+	u64 array[];
+};
+
+
 typedef union event_union {
 	struct perf_event_header	header;
 	struct ip_event			ip;
@@ -68,6 +74,7 @@ typedef union event_union {
 	struct fork_event		fork;
 	struct lost_event		lost;
 	struct read_event		read;
+	struct sample_event		sample;
 } event_t;
 
 struct map {
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
