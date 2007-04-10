Return-Path: <linux-kernel-owner+w=401wt.eu-S1030634AbXDJUwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030634AbXDJUwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 16:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030636AbXDJUwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 16:52:08 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:37256 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030634AbXDJUwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 16:52:07 -0400
Date: Tue, 10 Apr 2007 22:50:28 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
cc: kernel-janitors@lists.osdl.org, kernelnewbies@nl.linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [KJ]remove SPIN_LOCK_UNLOCKED
In-Reply-To: <20070410181654.GA10525@arun.site>
Message-ID: <Pine.LNX.4.61.0704102249290.32056@yvahk01.tjqt.qr>
References: <20070410181654.GA10525@arun.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 10 2007 23:46, Milind Arun Choudhary wrote:

>"use spin_lock_init instead of SPIN_LOCK_UNLOCKED"

Fact is, we cannot remove SPIN_LOCK_UNLOCKED. It's needed for
variables outside functions:

static spinlock_t foobar = SPIN_LOCK_UNLOCKED;




>let me know if this is fine ..

not for me to comment :)


> aerdrv.c |    2 +-
> 1 files changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/pci/pcie/aer/aerdrv.c b/drivers/pci/pcie/aer/aerdrv.c
>index db6ad8e..6846fb4 100644
>--- a/drivers/pci/pcie/aer/aerdrv.c
>+++ b/drivers/pci/pcie/aer/aerdrv.c
>@@ -157,7 +157,7 @@ static struct aer_rpc* aer_alloc_rpc(struct pcie_device *dev)
> 	 * Initialize Root lock access, e_lock, to Root Error Status Reg,
> 	 * Root Error ID Reg, and Root error producer/consumer index.
> 	 */
>-	rpc->e_lock = SPIN_LOCK_UNLOCKED;
>+	spin_lock_init(&rpc->e_lock);
> 
> 	rpc->rpd = dev;
> 	INIT_WORK(&rpc->dpc_handler, aer_isr);
>
>
>-- 
>Milind Arun Choudhary
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>

Jan
-- 
