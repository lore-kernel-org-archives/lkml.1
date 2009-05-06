Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZEFEYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZEFEYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 00:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZEFEXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 00:23:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZEFEXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 00:23:34 -0400
Message-Id: <20090506042332.892821272@goodmis.org>
References: <20090506042101.231470089@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 00:21:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 01/11] ring-buffer: export symbols
Content-Disposition: inline; filename=0001-ring-buffer-export-symbols.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

I'm adding a module to do a series of tests on the ring buffer as well
as benchmarks. This module needs to have more of the ring buffer API
exported. There's nothing wrong with reading the ring buffer from a
module.

[ Impact: allow modules to read pages from the ring buffer ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f4cc590..3e86da9 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2802,6 +2802,7 @@ void *ring_buffer_alloc_read_page(struct ring_buffer *buffer)
 
 	return bpage;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_alloc_read_page);
 
 /**
  * ring_buffer_free_read_page - free an allocated read page
@@ -2814,6 +2815,7 @@ void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data)
 {
 	free_page((unsigned long)data);
 }
+EXPORT_SYMBOL_GPL(ring_buffer_free_read_page);
 
 /**
  * ring_buffer_read_page - extract a page from the ring buffer
@@ -2959,6 +2961,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
  out:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_read_page);
 
 static ssize_t
 rb_simple_read(struct file *filp, char __user *ubuf,
-- 
1.6.2.4

-- 
