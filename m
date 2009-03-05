Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbZCEXge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbZCEXge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758690AbZCEXgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:36:11 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:37471 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758602AbZCEXgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:36:09 -0500
Message-Id: <20090305225514.845374986@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:42 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@osdl.org>
Subject: [RFC patch 14/41] Splice and pipe : export pipe buf operations for GPL modules
Content-Disposition: inline; filename=splice-support-modules.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:11 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng splice transport use the generic pipe and splice operations from a GPL
module.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jens Axboe <axboe@kernel.dk>
CC: Linus Torvalds <torvalds@osdl.org>
CC: Ingo Molnar <mingo@elte.hu>
---
 fs/pipe.c   |    5 +++++
 fs/splice.c |    1 +
 2 files changed, 6 insertions(+)

Index: linux-2.6-lttng/fs/pipe.c
===================================================================
--- linux-2.6-lttng.orig/fs/pipe.c	2009-02-06 14:45:33.000000000 -0500
+++ linux-2.6-lttng/fs/pipe.c	2009-02-06 14:57:50.000000000 -0500
@@ -188,6 +188,7 @@ void *generic_pipe_buf_map(struct pipe_i
 
 	return kmap(buf->page);
 }
+EXPORT_SYMBOL_GPL(generic_pipe_buf_map);
 
 /**
  * generic_pipe_buf_unmap - unmap a previously mapped pipe buffer
@@ -207,6 +208,7 @@ void generic_pipe_buf_unmap(struct pipe_
 	} else
 		kunmap(buf->page);
 }
+EXPORT_SYMBOL_GPL(generic_pipe_buf_unmap);
 
 /**
  * generic_pipe_buf_steal - attempt to take ownership of a &pipe_buffer
@@ -237,6 +239,7 @@ int generic_pipe_buf_steal(struct pipe_i
 
 	return 1;
 }
+EXPORT_SYMBOL_GPL(generic_pipe_buf_steal);
 
 /**
  * generic_pipe_buf_get - get a reference to a &struct pipe_buffer
@@ -252,6 +255,7 @@ void generic_pipe_buf_get(struct pipe_in
 {
 	page_cache_get(buf->page);
 }
+EXPORT_SYMBOL_GPL(generic_pipe_buf_get);
 
 /**
  * generic_pipe_buf_confirm - verify contents of the pipe buffer
@@ -267,6 +271,7 @@ int generic_pipe_buf_confirm(struct pipe
 {
 	return 0;
 }
+EXPORT_SYMBOL_GPL(generic_pipe_buf_confirm);
 
 static const struct pipe_buf_operations anon_pipe_buf_ops = {
 	.can_merge = 1,
Index: linux-2.6-lttng/fs/splice.c
===================================================================
--- linux-2.6-lttng.orig/fs/splice.c	2009-02-06 14:45:33.000000000 -0500
+++ linux-2.6-lttng/fs/splice.c	2009-02-06 14:57:50.000000000 -0500
@@ -260,6 +260,7 @@ ssize_t splice_to_pipe(struct pipe_inode
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(splice_to_pipe);
 
 static void spd_release_page(struct splice_pipe_desc *spd, unsigned int i)
 {

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
