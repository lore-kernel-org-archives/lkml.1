Return-Path: <linux-kernel-owner+w=401wt.eu-S1031353AbXDJSPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031353AbXDJSPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 14:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031366AbXDJSPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 14:15:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:40354 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031353AbXDJSPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 14:15:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=poYQLZX2W9OdpFsBMeWMqE2XWh8TC1HGfdyQ2Ef6xFaH+dHjT+52jhcGy6yFgKRBTsxHXzgKqgWno82snxvA+eL+4D3OxIG1FvwqVyYkCm2xDSmu8cUh/iaE6MLlqTgfn1XcYGf3rvH5klmedXo/cN9rhLC0+ghGchhrUMGf8NI=
Date: Tue, 10 Apr 2007 23:46:54 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org
Cc: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
Subject: [KJ]remove SPIN_LOCK_UNLOCKED
Message-ID: <20070410181654.GA10525@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"use spin_lock_init instead of SPIN_LOCK_UNLOCKED"


i'm a bit confused with SPIN_LOCK_UNLOCKED removal
 I just did the below mentioned change
but then came to know that  spin_lock_init is defined as

# define spin_lock_init(lock)                                   \
        do { *(lock) = SPIN_LOCK_UNLOCKED; } while (0)

so what difference does it make..
eventually replacing SPIN_LOCK_UNLOCKED with itself

or is it just that this one [SPIN_LOCK_UNLOCKED] also needs 
to be replaced with __SPIN_LOCK_UNLOCKED?

after thought with CONFIG_DEBUG_SPINLOCK does make a diff


let me know if this is fine ..


 aerdrv.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/aer/aerdrv.c b/drivers/pci/pcie/aer/aerdrv.c
index db6ad8e..6846fb4 100644
--- a/drivers/pci/pcie/aer/aerdrv.c
+++ b/drivers/pci/pcie/aer/aerdrv.c
@@ -157,7 +157,7 @@ static struct aer_rpc* aer_alloc_rpc(struct pcie_device *dev)
 	 * Initialize Root lock access, e_lock, to Root Error Status Reg,
 	 * Root Error ID Reg, and Root error producer/consumer index.
 	 */
-	rpc->e_lock = SPIN_LOCK_UNLOCKED;
+	spin_lock_init(&rpc->e_lock);
 
 	rpc->rpd = dev;
 	INIT_WORK(&rpc->dpc_handler, aer_isr);


-- 
Milind Arun Choudhary
