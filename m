Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbZLFHfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbZLFHfb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932268AbZLFHfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:35:22 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35687 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbZLFHez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:34:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oVKwoeo+TLUQVnIblmubw2jHHhCzPexyw7k2T8wIwotz+d1lDPVTbtO1LpusMYy/nm
         LXqYRj2kgZ8LH/rxk97MhiJ0I4sT0y1AFTHk3s/zaJTEUVB9KLs80aM+7YKmObeWJjSO
         32M5+NBSg0UdcarDGJxmQ7TmaOV1no/fBvPEo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 2/9] perf: Remove pointless union that wraps the hw breakpoint fields
Date: Sun,  6 Dec 2009 08:34:51 +0100
Message-Id: <1260084898-11686-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
References: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It stands to anonymize a structure, but structures can already
anonymize by themselves.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>
---
 include/linux/perf_event.h |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index a61e4de..53230e9 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -215,14 +215,12 @@ struct perf_event_attr {
 		__u32		wakeup_watermark; /* bytes before wakeup   */
 	};
 
-	union {
-		struct { /* Hardware breakpoint info */
-			__u64		bp_addr;
-			__u32		bp_type;
-			__u32		bp_len;
-			__u64		__bp_reserved_1;
-			__u64		__bp_reserved_2;
-		};
+	struct { /* Hardware breakpoint info */
+		__u64		bp_addr;
+		__u32		bp_type;
+		__u32		bp_len;
+		__u64		__bp_reserved_1;
+		__u64		__bp_reserved_2;
 	};
 
 	__u32			__reserved_2;
-- 
1.6.2.3

