Return-Path: <linux-kernel-owner+w=401wt.eu-S1762801AbXJMOss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762801AbXJMOss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759991AbXJMOmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:36 -0400
Received: from 1wt.eu ([62.212.114.60]:2991 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761940AbXJMOme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:34 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143501.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:43 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Steven Toth <stoth@hauppauge.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 21/35] V4L: cx88: Avoid a NULL pointer dereference during mpeg_open()
Content-Disposition: inline; filename=0068-V4L-cx88-Avoid-a-NULL-pointer-dereference-during-m.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(cherry picked from commit 48200baeab95fd39a7f4c4f3536c7142a64ac335)

[PATCH] V4L: cx88: Avoid a NULL pointer dereference during mpeg_open()

Bug: With a hardware encoder board installed as cx88[1] and a
non-encoder boards installed as cx88[0], an OOPS is generated
during cx8802_get_device() called from mpeg_open().

Signed-off-by: Steven Toth <stoth@hauppauge.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/media/video/cx88/cx88-mpeg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: 2.6/drivers/media/video/cx88/cx88-mpeg.c
===================================================================
--- 2.6.orig/drivers/media/video/cx88/cx88-mpeg.c
+++ 2.6/drivers/media/video/cx88/cx88-mpeg.c
@@ -556,7 +556,7 @@ struct cx8802_dev * cx8802_get_device(st
 
 	list_for_each(list,&cx8802_devlist) {
 		h = list_entry(list, struct cx8802_dev, devlist);
-		if (h->mpeg_dev->minor == minor)
+		if (h->mpeg_dev && h->mpeg_dev->minor == minor)
 			return h;
 	}
 

-- 
