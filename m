Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZCDCxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZCDCxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbZCDCwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:52:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39964 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZCDCwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:52:53 -0500
Message-Id: <20090304025250.164970857@goodmis.org>
References: <20090304024921.153061228@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 03 Mar 2009 21:49:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/5] ring-buffer: reset write field for ring_buffer_read_page
Content-Disposition: inline; filename=0001-ring-buffer-reset-write-field-for-ring_buffer_read_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix ring_buffer_read_page

After a page is swapped into the ring buffer, the write field must
also be reset.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a8c275c..9baad7e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2492,6 +2492,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		rb_init_page(bpage);
 		bpage = cpu_buffer->reader_page->page;
 		cpu_buffer->reader_page->page = *data_page;
+		local_set(&cpu_buffer->reader_page->write, 0);
 		cpu_buffer->reader_page->read = 0;
 		*data_page = bpage;
 	}
-- 
1.5.6.5

-- 
