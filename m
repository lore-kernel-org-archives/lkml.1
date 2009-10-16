Return-Path: <linux-kernel-owner+w=401wt.eu-S1758191AbZJPR1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbZJPR1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZJPRSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:16 -0400
Received: from kroah.org ([198.145.64.141]:48440 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbZJPRSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:14 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:49 2009
Message-Id: <20091016171148.889563227@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:09:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [05/46] tracing/filters: Fix memory leak when setting a filter
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=tracing-filters-fix-memory-leak-when-setting-a-filter.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Li Zefan <lizf@cn.fujitsu.com>

commit 8ad807318fcd62aba0e18c7c7fbfcc1af3fcdbab upstream.

Every time we set a filter, we leak memory allocated by
postfix_append_operand() and postfix_append_op().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <4AD3D7D9.4070400@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/trace_events_filter.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -844,8 +844,9 @@ static void postfix_clear(struct filter_
 
 	while (!list_empty(&ps->postfix)) {
 		elt = list_first_entry(&ps->postfix, struct postfix_elt, list);
-		kfree(elt->operand);
 		list_del(&elt->list);
+		kfree(elt->operand);
+		kfree(elt);
 	}
 }
 


