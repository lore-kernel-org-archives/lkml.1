Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbZHMTtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbZHMTtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbZHMTtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:49:10 -0400
Received: from kroah.org ([198.145.64.141]:36814 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099AbZHMTsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:48:04 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:39 2009
Message-Id: <20090813194339.670649676@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>, Julien TINNES <julien@cr0.org>,
       Tavis Ormandy <taviso@sdf.lonestar.org>
Subject: [patch 26/28] Make sock_sendpage() use kernel_sendpage()
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=make-sock_sendpage-use-kernel_sendpage.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit e694958388c50148389b0e9b9e9e8945cf0f1b98 upstream.

kernel_sendpage() does the proper default case handling for when the
socket doesn't have a native sendpage implementation.

Now, arguably this might be something that we could instead solve by
just specifying that all protocols should do it themselves at the
protocol level, but we really only care about the common protocols.
Does anybody really care about sendpage on something like Appletalk? Not
likely.

Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Julien TINNES <julien@cr0.org>
Acked-by: Tavis Ormandy <taviso@sdf.lonestar.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -695,7 +695,7 @@ static ssize_t sock_sendpage(struct file
 	if (more)
 		flags |= MSG_MORE;
 
-	return sock->ops->sendpage(sock, page, offset, size, flags);
+	return kernel_sendpage(sock, page, offset, size, flags);
 }
 
 static ssize_t sock_splice_read(struct file *file, loff_t *ppos,


