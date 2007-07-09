Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbXGII0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbXGII0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 04:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbXGII0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 04:26:05 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4778 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbXGII0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 04:26:04 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: ericvh@gmail.com, rminnich@lanl.gov, lucho@ionkov.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fs: 9p/conv.c error path fix
Date: Mon, 9 Jul 2007 10:24:26 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707091024.26763.m.kozlowski@tuxland.pl>
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	When buf_check_overflow() returns != 0 we will hit kfree(ERR_PTR(err))
and it will not be happy about it.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/9p/conv.c |    1 +
 1 file changed, 1 insertion(+)

diff -U 4 -pr linux-2.6.22-rc6-mm1-a/fs/9p/conv.c linux-2.6.22-rc6-mm1-b/fs/9p/conv.c
--- linux-2.6.22-rc6-mm1-a/fs/9p/conv.c	2007-06-25 01:21:48.000000000 +0200
+++ linux-2.6.22-rc6-mm1-b/fs/9p/conv.c	2007-07-09 09:59:37.000000000 +0200
@@ -741,8 +741,9 @@ struct v9fs_fcall *v9fs_create_twrite(u3
 	err = v9fs_put_user_data(bufp, data, count, &fc->params.twrite.data);
 	if (err) {
 		kfree(fc);
 		fc = ERR_PTR(err);
+		goto error;
 	}
 
 	if (buf_check_overflow(bufp)) {
 		kfree(fc);
