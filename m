Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbYKRSVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbYKRSVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 13:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbYKRSVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 13:21:04 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:23576 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbYKRSVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 13:21:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=Uaw/Wqe4Zy+vAg+dYMjPRplqTuUH7TmUJ3xLVhFcQBZf1R4bN+Tv/oNH79MbbvPwjj
         scRurMqMGWXlKQbl3cJrFl3CT27KWjY0ed4KIOMIU/FQg5AKE8kb+NOo+TJGlSDADUmB
         QHgDk0rqmfsvx/jZcLssu6VXgFWGt5x93xvwQ=
Date: Tue, 18 Nov 2008 19:22:13 +0100
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] trace: introduce missing mutex_unlock()
Message-ID: <20081118182213.GA5436@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8a98729e7b3af032b798c36788095d955f0d7e79 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 18 Nov 2008 19:15:02 +0100
Subject: [PATCH] trace: introduce missing mutex_unlock()

This error was spotted by this semantic patch:

http://www.emn.fr/x-info/coccinelle/mut.html

It looks correct as far as I can tell. Please review.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 kernel/trace/ring_buffer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 036456c..f780e95 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -617,6 +617,7 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 		list_del_init(&page->list);
 		free_buffer_page(page);
 	}
+	mutex_unlock(&buffer->mutex);
 	return -ENOMEM;
 }
 
-- 
1.5.6.5

