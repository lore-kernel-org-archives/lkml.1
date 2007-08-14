Return-Path: <linux-kernel-owner+w=401wt.eu-S939707AbXHNEr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939707AbXHNEr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 00:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761956AbXHNErT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 00:47:19 -0400
Received: from n5.bullet.mail.re4.yahoo.com ([206.190.56.24]:42371 "HELO
	n5.bullet.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755464AbXHNErS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 00:47:18 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 102735.17522.bm@rrr4.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=J3rrj9/bwHazVCeMEFoplL4TXzmmJi1wAoDvlYk9/MOmfGB0ZBouaZa5RFxJl9ftSYQ7z9PRxI0XPRsIhK93DiUwP0k985oCZa1pAKAmmQuzpeG1qZX54a5gxGcM4NnYVGbP2Exh7WogWIj5LPAgrhOC4VOGaTWvBpEz8BLoYG0=;
Date: Mon, 13 Aug 2007 21:47:16 -0700 (PDT)
From: Scott Thompson <postfailathushmaildotcom@yahoo.com>
Reply-To: postfail@hushmail.com
Subject: [PATCH 3/3] /drivers/net ucc_geth ioremap balancing/returncode check (resend)
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org, postfail@hushmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <246708.59171.qm@web44916.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

resending patchset against 2.6.23-rc3 for /drivers/net ioremap balancing / return check,
previous patchset contained wordwrap errors:

  corrects:
  --sbus_ioremap return unchecked.
  --ioremap function unchecked
  --function failure cases did not clean up ioremap'd values.
  lne390.c  -- believe had incorrect/not ideal variable check on if for iounmap

this audit was only for files directly in drivers/net directory, not the full tree.

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------
diff --git a/drivers/net/ucc_geth.c b/drivers/net/ucc_geth.c
index 12e01b2..30acbe2 100644
--- a/drivers/net/ucc_geth.c
+++ b/drivers/net/ucc_geth.c
@@ -2430,6 +2430,11 @@ static int ucc_struct_init(struct ucc_geth_private *ugeth)
 
 	ugeth->ug_regs = (struct ucc_geth *) ioremap(uf_info->regs, sizeof(struct ucc_geth));
 
+	if (!ugeth->ug_regs){
+		ugeth_err("%s: Failed to ioremap.", __FUNCTION__);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 



       
____________________________________________________________________________________
Choose the right car based on your needs.  Check out Yahoo! Autos new Car Finder tool.
http://autos.yahoo.com/carfinder/


       
____________________________________________________________________________________
Need a vacation? Get great deals
to amazing places on Yahoo! Travel.
http://travel.yahoo.com/

