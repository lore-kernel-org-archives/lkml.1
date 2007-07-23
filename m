Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbXGWPxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbXGWPxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 11:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbXGWPwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 11:52:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41005 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657AbXGWPwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 11:52:54 -0400
Date: Mon, 23 Jul 2007 17:52:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: Linus 2.6.23-rc1, xen fix
Message-ID: <20070723155248.GA6889@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: xen: fix process_msg() use-after-kfree
From: Ingo Molnar <mingo@elte.hu>

fix an obvious use-after-kfree bug in Xen.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/xen/xenbus/xenbus_xs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/xen/xenbus/xenbus_xs.c
===================================================================
--- linux.orig/drivers/xen/xenbus/xenbus_xs.c
+++ linux/drivers/xen/xenbus/xenbus_xs.c
@@ -782,8 +782,8 @@ static int process_msg(void)
 		msg->u.watch.vec = split(body, msg->hdr.len,
 					 &msg->u.watch.vec_size);
 		if (IS_ERR(msg->u.watch.vec)) {
-			kfree(msg);
 			err = PTR_ERR(msg->u.watch.vec);
+			kfree(msg);
 			goto out;
 		}
 
