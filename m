Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbZLCW23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbZLCW23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZLCW22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:28:28 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:23349 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbZLCW21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:28:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OhaxQugk/20Z5RPhLm1vnfL37BH/VDKfky7sUNsnpdfgiwZg4d7HMN+tPE0KgPj3Ey
         q30Epqfg+1Gkymb2J8HSDib1hfEw6o6AG6bLdLIcXxSgqUdwdxryjrf6rD9L4EPpk5LU
         DLG4l1r53cGDQQl0n1GSNk+vlsLtE3if65nBE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH] perf: Remove pointless union that wraps the hw breakpoint fields
Date: Thu,  3 Dec 2009 23:20:30 +0100
Message-Id: <1259878830-8552-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1259876019.3977.1559.camel@laptop>
References: <1259876019.3977.1559.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It stands to anonymize a structure, but structure can already anonimize
by themselves.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 include/linux/perf_event.h |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 89832cc..d045e6e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -215,15 +215,13 @@ struct perf_event_attr {
 		__u32		wakeup_watermark; /* bytes before wakeup   */
 	};
 
-	union {
-		struct { /* Hardware breakpoint info */
-			__u64		bp_start;
-			__u64		bp_end;
-			__u32		bp_type;
-			__u32		bp_len;
-			__u64		__bp_reserved_1;
-			__u64		__bp_reserved_2;
-		};
+	struct { /* Hardware breakpoint info */
+		__u64		bp_start;
+		__u64		bp_end;
+		__u32		bp_type;
+		__u32		bp_len;
+		__u64		__bp_reserved_1;
+		__u64		__bp_reserved_2;
 	};
 
 	__u32			__reserved_2;
-- 
1.6.2.3

