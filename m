Return-Path: <linux-kernel-owner+w=401wt.eu-S1764103AbYEFBHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764103AbYEFBHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 21:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757691AbYEFBHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 21:07:30 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:56033 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707AbYEFBH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 21:07:28 -0400
Message-ID: <481FAF7F.3020406@keyaccess.nl>
Date: Tue, 06 May 2008 03:08:15 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Uwe Bugla <uwe.bugla@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Len Brown <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] PNP: add pnp_build_option() to the API
References: <481FAC37.6090703@keyaccess.nl>
In-Reply-To: <481FAC37.6090703@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------020004050603070400080007"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020004050603070400080007
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Bjorn.

The subsequent AD181x quirk patch would like this as part of the API.
pnp_register_dependent_option() adds to the same dependent chain the
quirk is walking which is fairly unclean. This enables a private
option chain build which it can then just add onto the end when done.

Signed-off-by: Rene Herman <rene.herman@gmail.com>


--------------020004050603070400080007
Content-Type: text/plain;
 name="pnp-add-pnp_build_option-to-the-api.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pnp-add-pnp_build_option-to-the-api.diff"

commit 1e16678158431ad9260acbd9ff3e43468b67ab6d
Author: Rene Herman <rene.herman@gmail.com>
Date:   Tue May 6 01:54:43 2008 +0200

    PNP: add pnp_build_option() to the API
    
    The subsequent AD181x quirk patch would like this as part of the API.
    pnp_register_dependent_option() adds to the same dependent chain the
    quirk is walking which is fairly unclean. This enables a private
    option chain build which it can then just add onto the end when done.
    
    Signed-off-by: Rene Herman <rene.herman@gmail.com>

diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
index 4fe7c58..886dac8 100644
--- a/drivers/pnp/base.h
+++ b/drivers/pnp/base.h
@@ -19,6 +19,7 @@ void pnp_remove_card(struct pnp_card *card);
 int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev);
 void pnp_remove_card_device(struct pnp_dev *dev);
 
+struct pnp_option *pnp_build_option(int priority);
 struct pnp_option *pnp_register_independent_option(struct pnp_dev *dev);
 struct pnp_option *pnp_register_dependent_option(struct pnp_dev *dev,
 						 int priority);
diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index 2041620..390b500 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -28,7 +28,7 @@ static int pnp_reserve_mem[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some
  * option registration
  */
 
-static struct pnp_option *pnp_build_option(int priority)
+struct pnp_option *pnp_build_option(int priority)
 {
 	struct pnp_option *option = pnp_alloc(sizeof(struct pnp_option));
 



--------------020004050603070400080007--
