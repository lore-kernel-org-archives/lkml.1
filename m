Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936036Ab0BZM4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:56:06 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:50638 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935925Ab0BZM4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:56:04 -0500
Subject: [PATCH] io: remove padding from io_context on 64bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nikanth Karthikesan <knikanth@suse.de>, Jeff Moyer <jmoyer@redhat.com>,
       Vivek Goyal <vgoyal@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Feb 2010 12:56:00 +0000
Message-ID: <1267188960.2077.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64 bit builds when CONFIG_BLK_CGROUP=n (the default) this removes 8
bytes of padding from structure io_context and drops its size from 72 to
64 bytes, so needing one fewer cachelines and allowing more objects per
slab in it's kmem_cache.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

----
patch against 2.6.33
compiled & test on x86_64 AMDX2
regards
Richard


diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 78ef023..1195a80 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -49,8 +49,8 @@ struct io_context {
 	/*
 	 * For request batching
 	 */
-	unsigned long last_waited; /* Time last woken after wait for request */
 	int nr_batch_requests;     /* Number of requests left in the batch */
+	unsigned long last_waited; /* Time last woken after wait for request */
 
 	struct radix_tree_root radix_root;
 	struct hlist_head cic_list;


