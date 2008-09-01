Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYIARnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYIARnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYIARne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:43:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50615 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbYIARnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:43:33 -0400
Date: Tue, 2 Sep 2008 03:43:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@zeniv.linux.org.uk>, Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Kyle McMartin <kyle@mcmartin.ca>,
       <linux-parisc@vger.kernel.org>
Subject: [PATCH] fix typo in arch/parisc/hpux/fs.c
Message-Id: <20080902034327.2c66cda5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A parisc allmodconfig build produces this:

arch/parisc/hpux/fs.c:107: error: 'buffer' undeclared (first use in this function)

Introduced by commit da574983de9f9283ba35662c8723627096e160de ("[PATCH]
fix hpux_getdents()").

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

diff --git a/arch/parisc/hpux/fs.c b/arch/parisc/hpux/fs.c
index 69ff671..12c04c5 100644
--- a/arch/parisc/hpux/fs.c
+++ b/arch/parisc/hpux/fs.c
@@ -104,7 +104,7 @@ static int filldir(void * __buf, const char * name, int namlen, loff_t offset,
 	buf->count -= reclen;
 	return 0;
 Efault:
-	buffer->error = -EFAULT;
+	buf->error = -EFAULT;
 	return -EFAULT;
 }
 

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
