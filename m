Return-Path: <linux-kernel-owner+w=401wt.eu-S1759387AbZDRA6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387AbZDRA6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 20:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbZDRA6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 20:58:40 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11261 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752777AbZDRA6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 20:58:39 -0400
Date: Fri, 17 Apr 2009 18:58:38 -0600
From: dougthompson@xmission.com
To: djiang@mvista.com, jharan@Brocade.COM, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/1] edac: ppc mpc85xx fix mc err detect
Message-ID: <49e925be.mjq9Fl6et5TONkn5%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jiang <djiang@mvista.com>

Error found by Jeff Haran <jharan@Brocade.COM>

The error detect register is 0s when no errors are detected.
The check code is incorrect, so reverse check sense.

Cc: Jeff Haran <jharan@Brocade.COM>
Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>

---
commit 1d8cad7d0ecbe9fad3c70b959804e6c6632e236c
tree ed8e099c0c0b775b1c11b94dfc794491a915e144
parent b0cbc861a3c05e634520b049b5cc27ad6febb51f
author Dave Jiang <djiang@mvista.com> Mon, 13 Apr 2009 10:16:53 -0700
committer Dave Jiang <djiang@mvista.com> Mon, 13 Apr 2009 10:16:53 -0700

 drivers/edac/mpc85xx_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 4637a4a..7c8c2d7 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -674,7 +674,7 @@ static void mpc85xx_mc_check(struct mem_ctl_info *mci)
 	int row_index;
 
 	err_detect = in_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT);
-	if (err_detect)
+	if (!err_detect)
 		return;
 
 	mpc85xx_mc_printk(mci, KERN_ERR, "Err Detect Register: %#8.8x\n",
