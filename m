Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbZFIQiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbZFIQiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757162AbZFIQhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:37:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176AbZFIQhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:37:53 -0400
Message-Id: <20090609163754.392651394@goodmis.org>
References: <20090609163657.557589106@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 09 Jun 2009 12:36:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] ring-buffer: fix ret in rb_add_time_stamp
Content-Disposition: inline; filename=0001-ring-buffer-fix-ret-in-rb_add_time_stamp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The update of ret got mistakenly added to the if statement of
rb_try_to_discard. The variable ret should be 1 on commit and zero
otherwise.

[ Impact: fix compiler warning and real bug ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 22878b0..2e642b2 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1433,8 +1433,8 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 			/* Darn, this is just wasted space */
 			event->time_delta = 0;
 			event->array[0] = 0;
-			ret = 0;
 		}
+		ret = 0;
 	}
 
 	*delta = 0;
-- 
1.6.3.1

-- 
