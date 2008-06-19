Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbYFSOx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbYFSOx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 10:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbYFSOxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 10:53:11 -0400
Received: from gate.critical-links.com ([62.28.57.164]:57544 "EHLO
	gate.critical-links.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092AbYFSOwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 10:52:55 -0400
X-Greylist: delayed 765 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2008 10:52:55 EDT
Date: Thu, 19 Jun 2008 15:37:14 +0100
From: WANG Cong <wcong@critical-links.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: [Patch] net/sched/sch_generic.c: fix an error pointer
Message-ID: <20080619153714.5614d5be@hack>
Organization: critical-links.com
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-edgeBOX-MailScanner-Information: Please contact the ISP for more information
X-edgeBOX-MailScanner: Found to be clean
X-edgeBOX-MailScanner-From: wcong@critical-links.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ERR_PTR() ususally encodes an negative errno, not positive.

Note, in the following patch, 'err' is initialized as:

int err = -ENOBUFS;

Signed-off-by: WANG Cong <wcong@critical-links.com>
Cc: David Miller <davem@davemloft.net>
Cc:  Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

---
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index d355e5e..13afa72 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -468,7 +468,7 @@ struct Qdisc *qdisc_alloc(struct net_device *dev,
struct Qdisc_ops *ops) 
 	return sch;
 errout:
-	return ERR_PTR(-err);
+	return ERR_PTR(err);
 }
 
 struct Qdisc * qdisc_create_dflt(struct net_device *dev, struct
Qdisc_ops *ops,
