Return-Path: <linux-kernel-owner+w=401wt.eu-S932159AbZKXFku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbZKXFku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 00:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbZKXFku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 00:40:50 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3727 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZKXFkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 00:40:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:subject:from:reply-to:in-reply-to:to:cc:x-system-of-record;
	b=E5oxKG8j9baWBBFOrz9xxqZkN+j7j3RHq0/0rEwg4LL/yLXkynI3IW/m6FLIbBLzi
	jYNW0O4GcuLojNxhcpjMQ==
Message-ID: <4b0b71e1.0508d00a.075e.ffff84a3@mx.google.com>
Date: Mon, 23 Nov 2009 21:40:49 -0800 (PST)
Subject: [PATCH] perf_events: fix bogus copy_to_user() in perf_event_read_group()
From: Stephane Eranian <eranian@google.com>
Reply-to: Stephane Eranian <eranian@google.com>
In-Reply-To: <bd4cb8900911230836na261658udd82f5c20630ffba@mail.gmail.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sourceforge.net, eranian@google.com,
       eranian@gmail.com
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	[This is a repost due to a formatting problem with Gmail]

	When using an event group, the value and id for non leaders events were
	wrong due to invalid offset into the outgoing buffer.

	Signed-off-by: Stephane Eranian <eranian@google.com>

---
 perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0b0d5f7..8306127 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1826,7 +1826,7 @@ static int perf_event_read_group(struct perf_event *event,
 
 		size = n * sizeof(u64);
 
-		if (copy_to_user(buf + size, values, size)) {
+		if (copy_to_user(buf + ret, values, size)) {
 			ret = -EFAULT;
 			goto unlock;
 		}
