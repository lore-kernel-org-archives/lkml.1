Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZHMUBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZHMUBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbZHMUAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:00:14 -0400
Received: from kroah.org ([198.145.64.141]:41949 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304AbZHMUAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:00:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:34 2009
Message-Id: <20090813195134.194857291@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [patch 65/74] ring-buffer: Fix memleak in ring_buffer_free()
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=ring-buffer-fix-memleak-in-ring_buffer_free.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit bd3f02212d6a457267e0c9c02c426151c436d9d4 upstream.

I noticed oprofile memleaked in linux-2.6 current tree,
and tracked this ring-buffer leak.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
LKML-Reference: <4A7C06B9.2090302@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/ring_buffer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -695,6 +695,7 @@ ring_buffer_free(struct ring_buffer *buf
 
 	put_online_cpus();
 
+	kfree(buffer->buffers);
 	free_cpumask_var(buffer->cpumask);
 
 	kfree(buffer);


