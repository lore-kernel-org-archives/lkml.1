Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146Ab0A0Iak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab0A0Iak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039Ab0A0I2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:28:12 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:51210 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0A0I2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:28:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AumzXNeJCZSSk9Q7AeirfSZ0X4rl4xSZCZlS4G6Cr/5qdNJIHscLSDzLgwcQ5TD5r2
         aqeWruH03MZA3BxKbDVPMR+pvCqMEZN1KcLMQb8r0slbc7wpFe7cZvVxbY26OVSjE28x
         WPWRCK18KLnvTm/VHx0WcAE53SaslxozQ7p+Y=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: [PATCH 02/12] perf trace/scripting: fix bug in Util.pm
Date: Wed, 27 Jan 2010 02:27:53 -0600
Message-Id: <1264580883-15324-3-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bogus calculation.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
index 052f132..f869c48 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
@@ -44,7 +44,7 @@ sub nsecs_secs {
 sub nsecs_nsecs {
     my ($nsecs) = @_;
 
-    return $nsecs - nsecs_secs($nsecs);
+    return $nsecs % $NSECS_PER_SEC;
 }
 
 sub nsecs_str {
-- 
1.6.4.GIT

