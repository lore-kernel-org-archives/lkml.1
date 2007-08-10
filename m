Return-Path: <linux-kernel-owner+w=401wt.eu-S940447AbXHJSmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940447AbXHJSmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 14:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763121AbXHJSlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 14:41:55 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:55323 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762801AbXHJSly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 14:41:54 -0400
Date: Fri, 10 Aug 2007 14:41:52 -0400
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
       <kernel-janitors@vger.kernel.org>
Subject: [PATCH 4/4]  /drivers/net ioremap balancing/returncode check (ucc_geth.c.c)
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070810184153.19F06DA81F@mailserver7.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

patchset against 2.6.23-rc2 for /drivers/net ioremap balancing / 
return check:

  corrects:
  --sbus_ioremap return unchecked.
  --ioremap function unchecked
  --function failure cases did not clean up ioremap'd values.
  lne390.c
   -- believe had incorrect/not ideal variable check on if for 
iounmap

this audit was only for files directly in drivers/net directory, 
not the full tree.

I split patches up by file changed as each file had different 
'owner' to ease accept/reject/revision process.

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------
diff --git a/drivers/net/ucc_geth.c b/drivers/net/ucc_geth.c
index 12e01b2..30acbe2 100644
--- a/drivers/net/ucc_geth.c
+++ b/drivers/net/ucc_geth.c
@@ -2430,6 +2430,11 @@ static int ucc_struct_init(struct 
ucc_geth_private *ugeth)
 
 	ugeth->ug_regs = (struct ucc_geth *) ioremap(uf_info->regs, 
sizeof(struct ucc_geth));
 
+	if (!ugeth->ug_regs){
+		ugeth_err("%s: Failed to ioremap.", __FUNCTION__);
+		return -ENOMEM;
+	}
+
 	return 0;
}

