Return-Path: <linux-kernel-owner+w=401wt.eu-S966339AbXDGUaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966339AbXDGUaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 16:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966340AbXDGUaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 16:30:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:47920 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966339AbXDGUax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 16:30:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=GyMqBCoOxS9UARIGedQ8m5HdYcgxE9FoQhTi+rakFl7HuwLYo1PUX/auLZVz3IzLsNQ/JZF8NXHBK2Mtekfn4TBtazMkiPWubC/kAHji1mRnq1UupdBTr+jG6XdU6g9tCVtDCgn4cmJxcHiAvUXw0ZSX0Gx949Lo5b2yxEv6Pr8=
Date: Sun, 8 Apr 2007 00:31:21 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH] iucv: fix compilation on s390-up
Message-ID: <20070407203120.GA11326@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  CC [M]  net/iucv/iucv.o
net/iucv/iucv.c: In function 'iucv_init':
net/iucv/iucv.c:1556: error: 'iucv_cpu_notifier' undeclared (first use in this function)

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/iucv/iucv.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -519,7 +519,6 @@ static void iucv_disable(void)
 	kfree(iucv_path_table);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static int __cpuinit iucv_cpu_notify(struct notifier_block *self,
 				     unsigned long action, void *hcpu)
 {
@@ -565,7 +564,6 @@ static int __cpuinit iucv_cpu_notify(struct notifier_block *self,
 static struct notifier_block iucv_cpu_notifier = {
 	.notifier_call = iucv_cpu_notify,
 };
-#endif
 
 /**
  * iucv_sever_pathid

