Return-Path: <linux-kernel-owner+w=401wt.eu-S965053AbYDNSrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965053AbYDNSrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934335AbYDNSnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:43:06 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35360 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934328AbYDNSnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:43:04 -0400
Date: Mon, 14 Apr 2008 21:41:10 +0300
From: Adrian Bunk <bunk@kernel.org>
To: minyard@acm.org
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix return from atca_oem_poweroff_hook()
Message-ID: <20080414184110.GO6695@cs181133002.pp.htv.fi>
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

This patch has been sent on:
- 31 Mar 2008

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

