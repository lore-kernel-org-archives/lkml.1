Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbYC3XOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbYC3XOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbYC3XNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:13:01 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58716 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756752AbYC3XNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:13:00 -0400
Date: Mon, 31 Mar 2008 02:12:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: minyard@acm.org
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix return from atca_oem_poweroff_hook()
Message-ID: <20080330231247.GE28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A void returning function returned the return value of another void 
returning function...

Spotted by sparse.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
6c4cdaeed88de5e2a6949e63526bd2db59060fa1 diff --git a/drivers/char/ipmi/ipmi_poweroff.c b/drivers/char/ipmi/ipmi_poweroff.c
index b86186d..21e2e2d 100644
--- a/drivers/char/ipmi/ipmi_poweroff.c
+++ b/drivers/char/ipmi/ipmi_poweroff.c
@@ -289,7 +289,7 @@ static void ipmi_poweroff_atca (ipmi_user_t user)
 	}
 
 	if(atca_oem_poweroff_hook)
-		return atca_oem_poweroff_hook(user);
+		atca_oem_poweroff_hook(user);
  out:
 	return;
 }

