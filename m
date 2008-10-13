Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbYJMOWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbYJMOWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYJMOWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:22:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45063 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbYJMOWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:22:10 -0400
Date: Mon, 13 Oct 2008 10:22:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ring-buffer: fix free page
Message-ID: <alpine.DEB.1.10.0810131021190.4157@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The pages of a buffer was originally pointing to the page struct, it
now points to the page address. The freeing of the page still uses
the page frame free "__free_page" instead of the correct free_page to
the address.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-tip.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ring_buffer.c	2008-10-13 10:15:16.000000000 -0400
+++ linux-tip.git/kernel/trace/ring_buffer.c	2008-10-13 10:17:03.000000000 -0400
@@ -130,7 +130,7 @@ struct buffer_page {
 static inline void free_buffer_page(struct buffer_page *bpage)
 {
 	if (bpage->page)
-		__free_page(bpage->page);
+		free_page((unsigned long)bpage->page);
 	kfree(bpage);
 }
 

