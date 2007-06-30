Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbXF3DWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbXF3DWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbXF3DWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:22:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:13979 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbXF3DW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:22:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Y2viJNEzbhx80eW+dDRvxjj9rJ61I+18HSv7o9Mbjk/WYfELfyudEEX1vNNYZ3Rf5QBSU9qi4HSS4ZDy5s5FI1bqTAiKWUyHHduJ48TVEqmyTtsnvd1ycJ76EzEIl5qWL9FWeEGFkHE05VTTj9C1KfdOKCkTN8v9ZY/pNJval9I=
Date: Sat, 30 Jun 2007 12:13:22 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/4 -mm] void unregister_blkdev - delete redundant message
Message-ID: <20070630031322.GE4045@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org,
	Grant Likely <grant.likely@secretlab.ca>
References: <20070630031013.GC4045@APFDCB5C> <20070630031212.GD4045@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070630031212.GD4045@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No need to warn unregister_blkdev() failure by caller.
(The previous patch makes unregister_blkdev() print error message in
error case)

Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/block/xsysace.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: 2.6-mm/drivers/block/xsysace.c
===================================================================
--- 2.6-mm.orig/drivers/block/xsysace.c
+++ 2.6-mm/drivers/block/xsysace.c
@@ -1157,9 +1157,7 @@ static void __exit ace_exit(void)
 {
 	pr_debug("Unregistering Xilinx SystemACE driver\n");
 	driver_unregister(&ace_driver);
-	if (unregister_blkdev(ace_major, "xsysace"))
-		printk(KERN_WARNING "systemace unregister_blkdev(%i) failed\n",
-		       ace_major);
+	unregister_blkdev(ace_major, "xsysace");
 }
 
 module_init(ace_init);
