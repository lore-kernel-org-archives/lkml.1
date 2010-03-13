Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934885Ab0CMB3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:29:47 -0500
Received: from kroah.org ([198.145.64.141]:60687 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934881Ab0CMAT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:57 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:08 2010
Message-Id: <20100313001508.226284440@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 035/123] perf_event: Fix preempt warning in perf_clock()
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Peter Zijlstra <peterz@infradead.org>

commit 24691ea964cc0123e386b661e03a86a481c6ee79 upstream.

A recent commit introduced a preemption warning for
perf_clock(), use raw_smp_processor_id() to avoid this, it
really doesn't matter which cpu we use here.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1267198583.22519.684.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -248,7 +248,7 @@ static void perf_unpin_context(struct pe
 
 static inline u64 perf_clock(void)
 {
-	return cpu_clock(smp_processor_id());
+	return cpu_clock(raw_smp_processor_id());
 }
 
 /*


