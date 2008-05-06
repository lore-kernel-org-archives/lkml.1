Return-Path: <linux-kernel-owner+w=401wt.eu-S1763553AbYEFBHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763553AbYEFBHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 21:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbYEFBH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 21:07:26 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:59525 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbYEFBHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 21:07:25 -0400
Message-ID: <481FAF79.2030407@keyaccess.nl>
Date: Tue, 06 May 2008 03:08:09 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Uwe Bugla <uwe.bugla@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Len Brown <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] PNP: cleanup pnp_fixup_device()
Content-Type: multipart/mixed;
 boundary="------------000508010108070506080805"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000508010108070506080805
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Bjorn.

In response to off-list AD181x thread, small cleanup to quirk handling.

Patch 3/3 does the actual work. Mind if I feed this stuff through you? And,
mind this, period? Not wed to it or anything...

Signed-off-by: Rene Herman <rene.herman@gmail.com>


--------------000508010108070506080805
Content-Type: text/plain;
 name="pnp-cleanup-pnp_fixup_device.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pnp-cleanup-pnp_fixup_device.diff"

commit 4ed0cb4cef2b45a257b6d7d6cdc987e3511ddf58
Author: Rene Herman <rene.herman@gmail.com>
Date:   Tue May 6 01:51:47 2008 +0200

    PNP: cleanup pnp_fixup_device()
    
    Signed-off-by: Rene Herman <rene.herman@gmail.com>

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 3f2d34a..10b1295 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -209,20 +209,12 @@ static struct pnp_fixup pnp_fixups[] = {
 
 void pnp_fixup_device(struct pnp_dev *dev)
 {
-	int i = 0;
-	void (*quirk)(struct pnp_dev *);
-
-	while (*pnp_fixups[i].id) {
-		if (compare_pnp_id(dev->id, pnp_fixups[i].id)) {
-			quirk = pnp_fixups[i].quirk_function;
-
-#ifdef DEBUG
-			dev_dbg(&dev->dev, "calling quirk 0x%p", quirk);
-			print_fn_descriptor_symbol(": %s()\n",
-				(unsigned long) *quirk);
-#endif
-			(*quirk)(dev);
-		}
-		i++;
+	int i;
+
+	for (i = 0; *pnp_fixups[i].id; i++) {
+		if (!compare_pnp_id(dev->id, pnp_fixups[i].id))
+			continue;
+		dev_dbg(&dev->dev, "calling quirk for %s\n", pnp_fixups[i].id);
+		pnp_fixups[i].quirk_function(dev);
 	}
 }



--------------000508010108070506080805--
