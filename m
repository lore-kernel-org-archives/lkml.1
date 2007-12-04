Return-Path: <linux-kernel-owner+w=401wt.eu-S1751701AbXLDBbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbXLDBbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 20:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbXLDBbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 20:31:05 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:6742 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbXLDBbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 20:31:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=mb9eT5yCD4raEuzB98yHnM1Q8slpPtFRwOlYr516/8Cv4qqDlyUX0TYN4YyPCwDWWo8qCWV77W8HYu+wDHx6smyZnGSkKykmr4jPlEviR9oQMCuWXVVpeuAtlWtWpcWq9AJBd6p4nlETtjQCnTGXBGLZ52CmlxEcIsc00gbSJKU=
Date: Tue, 4 Dec 2007 09:31:44 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: petero2@telia.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pktcdvd : add kobject_put when kobject register fails
Message-ID: <20071204013144.GA2850@darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kobject_put should be called when kobject register functioin fails, so the the kobj ref count touch zero and then the proper cleanup routines will be called.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
drivers/block/pktcdvd.c |    4 +++-
1 file changed, 3 insertions(+), 1 deletion(-)

diff -upr linux/drivers/block/pktcdvd.c linux.new/drivers/block/pktcdvd.c
--- linux/drivers/block/pktcdvd.c	2007-11-30 13:13:44.000000000 +0800
+++ linux.new/drivers/block/pktcdvd.c	2007-11-30 13:24:08.000000000 +0800
@@ -117,8 +117,10 @@ static struct pktcdvd_kobj* pkt_kobj_cre
 	p->kobj.parent = parent;
 	p->kobj.ktype = ktype;
 	p->pd = pd;
-	if (kobject_register(&p->kobj) != 0)
+	if (kobject_register(&p->kobj) != 0) {
+		kobject_put(&p->kobj);
 		return NULL;
+	}
 	return p;
 }
 /*
