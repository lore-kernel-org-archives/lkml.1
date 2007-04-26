Return-Path: <linux-kernel-owner+w=401wt.eu-S933041AbXDZGfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbXDZGfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXDZGfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:35:43 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:41262
	"EHLO gwia-smtp.id2.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933041AbXDZGfj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:35:39 -0400
Message-Id: <46306494.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Thu, 26 Apr 2007 07:36:36 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Haruo Tomita" <haruo.tomita@toshiba.co.jp>
Cc: <prarit@redhat.com>, "lkml" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2]  Fixed typo Intel RNG driver for
	2.6.21-rc7-mm1
References: <BF571719A4041A478005EF3F08EA6DF004332397@pcsmail03.pcs.pc.ome.toshiba.co.jp>
In-Reply-To: <BF571719A4041A478005EF3F08EA6DF004332397@pcsmail03.pcs.pc.ome.toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

But why do you remove the printk()?

>>> "Tomita, Haruo" <haruo.tomita@toshiba.co.jp> 26.04.07 08:27 >>>
This patch fixes a typo in mod_init().
fwh_done is performed when Intel fwh is found.

 intel-rng.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.21-rc7-mm1/drivers/char/hw_random/intel-rng.c~	2007-04-26 13:41:53.000000000 +0900
+++ linux-2.6.21-rc7-mm1/drivers/char/hw_random/intel-rng.c	2007-04-26 13:43:35.000000000 +0900
@@ -264,7 +264,6 @@ static int __init intel_rng_hw_init(void
 	if (mfc != INTEL_FWH_MANUFACTURER_CODE ||
 	    (dvc != INTEL_FWH_DEVICE_CODE_8M &&
 	     dvc != INTEL_FWH_DEVICE_CODE_4M)) {
-		printk(KERN_ERR PFX "FWH not detected\n");
 		return -ENODEV;
 	}
 
@@ -365,7 +364,8 @@ static int __init mod_init(void)
 	pci_dev_put(dev);
 	iounmap(intel_rng_hw->mem);
 	kfree(intel_rng_hw);
-	goto out;
+	if (err)
+		goto out;
 
 fwh_done:
 	err = -ENOMEM;

