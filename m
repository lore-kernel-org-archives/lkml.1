Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbYFAX1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbYFAX1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYFAX1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:27:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:24300 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbYFAX1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=C8VjhBcZUV23q+ZdNxI3ukTt6yiVf6Dy+LRGf70w+x2C5XpoG42bUn0HmKXQ1ObuP1uZJlPDuEhh/GbSVeloxAsDAIm47tM3D6u1djWhcljZ/HB2ZPLrO62e25+QaeAOQaHt8G+4JXmJcSVQD8azW/YHzxUYqLiQaUJe+hqhWXI=
Message-Id: <20080601231451.529328123@gmail.com>
References: <20080601231329.223608711@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 08:13:30 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [patch -v2 01/23] sunrpc: use simple_read_from_buffer
Content-Disposition: inline; filename=sunrpc-simple-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 net/sunrpc/cache.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

Index: 2.6-git/net/sunrpc/cache.c
===================================================================
--- 2.6-git.orig/net/sunrpc/cache.c
+++ 2.6-git/net/sunrpc/cache.c
@@ -1271,20 +1271,11 @@ static ssize_t read_flush(struct file *f
 {
 	struct cache_detail *cd = PDE(file->f_path.dentry->d_inode)->data;
 	char tbuf[20];
-	unsigned long p = *ppos;
 	size_t len;
 
-	sprintf(tbuf, "%lu\n", cd->flush_time);
-	len = strlen(tbuf);
-	if (p >= len)
-		return 0;
-	len -= p;
-	if (len > count)
-		len = count;
-	if (copy_to_user(buf, (void*)(tbuf+p), len))
-		return -EFAULT;
-	*ppos += len;
-	return len;
+	len = sprintf(tbuf, "%lu\n", cd->flush_time);
+
+	return simple_read_from_buffer(buf, count, ppos, tbuf, len);
 }
 
 static ssize_t write_flush(struct file * file, const char __user * buf,

-- 
