Return-Path: <linux-kernel-owner+w=401wt.eu-S1760227AbZKFWZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbZKFWZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758691AbZKFWZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:25:00 -0500
Received: from kroah.org ([198.145.64.141]:57216 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932729AbZKFWXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:44 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:52 2009
Message-Id: <20091106221552.018297553@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [94/99] powerpc/pmac: Fix PowerSurge SMP IPI allocation
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-pmac-fix-powersurge-smp-ipi-allocation.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 527b3639616b21c257518ee7c26fbf05232db0c0 upstream.

The code for setting up the IPIs for SMP PowerSurge marchines bitrot,
it needs to properly map the HW interrupt number

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/powermac/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -408,7 +408,7 @@ static void __init smp_psurge_setup_cpu(
 	/* reset the entry point so if we get another intr we won't
 	 * try to startup again */
 	out_be32(psurge_start, 0x100);
-	if (setup_irq(30, &psurge_irqaction))
+	if (setup_irq(irq_create_mapping(NULL, 30), &psurge_irqaction))
 		printk(KERN_ERR "Couldn't get primary IPI interrupt");
 }
 


