Return-Path: <linux-kernel-owner+w=401wt.eu-S1764436AbXE2Kor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764436AbXE2Kor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 06:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbXE2Kok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 06:44:40 -0400
Received: from cz-prg09a-av06.karneval.cz ([81.27.192.14]:58694 "EHLO
	av6.karneval.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbXE2Koj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 06:44:39 -0400
Message-id: <253477319205412858@wsc.cz>
Subject: [PATCH 1/2] Char: vt, use kzalloc
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Tue, 29 May 2007 12:43:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vt, use kzalloc

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit daa738839b831a78b895ad9cec1da0157e4b1be7
tree 039d7b54429bd8256f59e493f17e43947a2f173e
parent 1a5e44385253ef9a193badf768f40543af6996ca
author Jiri Slaby <jirislaby@gmail.com> Sun, 27 May 2007 09:49:53 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 29 May 2007 12:41:08 +0200

 drivers/char/vt.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index bbd9fc4..1cc960a 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -729,10 +729,9 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 	    /* although the numbers above are not valid since long ago, the
 	       point is still up-to-date and the comment still has its value
 	       even if only as a historical artifact.  --mj, July 1998 */
-	    vc = kmalloc(sizeof(struct vc_data), GFP_KERNEL);
+	    vc = kzalloc(sizeof(struct vc_data), GFP_KERNEL);
 	    if (!vc)
 		return -ENOMEM;
-	    memset(vc, 0, sizeof(*vc));
 	    vc_cons[currcons].d = vc;
 	    INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 	    visual_init(vc, currcons, 1);
