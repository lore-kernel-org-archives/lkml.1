Return-Path: <linux-kernel-owner+w=401wt.eu-S1763935AbYD0TjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763935AbYD0TjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYD0TjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:39:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:55749 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbYD0TjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:39:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=Op/vo828StkQhrtcUIWmY/qPMLqoAFtssh86bmG5n5jAdsAQIlH1wi07Tcty4QtTtJVH+23LEXiObZigYt2ydLKrSvr0wsbZI6JlYpkuXCD+YgzviA45nOzuOwPyXpJ9Yi374+FhpmPXbVla9fwgawEqeOBojpYcan4PQJlbTxg=
Date: Sun, 27 Apr 2008 22:39:03 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, akpm@osdl.org,
       Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Pavel Roskin <proski@gnu.org>
Subject: [PATCH 4/5] mmiotrace: Do not print bogus pid for maps either
Message-ID: <20080427223903.097490bd@daedalus.pq.iki.fi>
In-Reply-To: <20080427222925.02b2b27b@daedalus.pq.iki.fi>
References: <20080427222925.02b2b27b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 05689fa9f93c23153a696d18b1bb71286bd2b3d8 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sun, 27 Apr 2008 21:13:52 +0300
Subject: [PATCH] mmiotrace: Do not print bogus pid for maps either

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 kernel/trace/trace_mmiotrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index d0f649a..3c1dacd 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -225,12 +225,12 @@ static int mmio_print_map(struct trace_iterator *iter)
 		ret = trace_seq_printf(s,
 			"MAP %lu.%06lu %d 0x%lx 0x%lx 0x%lx 0x%lx %d\n",
 			secs, usec_rem, m->map_id, m->phys, m->virt, m->len,
-			0UL, entry->pid);
+			0UL, 0);
 		break;
 	case MMIO_UNPROBE:
 		ret = trace_seq_printf(s,
 			"UNMAP %lu.%06lu %d 0x%lx %d\n",
-			secs, usec_rem, m->map_id, 0UL, entry->pid);
+			secs, usec_rem, m->map_id, 0UL, 0);
 		break;
 	default:
 		ret = trace_seq_printf(s, "map what?\n");
-- 
1.5.3.7

