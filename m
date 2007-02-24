Return-Path: <linux-kernel-owner+w=401wt.eu-S933389AbXBXF24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbXBXF24 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 00:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933390AbXBXF24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 00:28:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933389AbXBXF2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 00:28:55 -0500
Date: Sat, 24 Feb 2007 02:31:25 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
Subject: [PATCH] Print error code in page faults
Message-ID: <20070224053125.GA20487@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When a page faults comes from a kernel space, the printed summary
leaves us clueless about what kind of access was being tried (which
is encoded in the error_code variable).

Having it promply available may ease debugging in a bunch of
situations.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>



--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=patch_err

diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
index 6ada723..e65522e 100644
--- a/arch/x86_64/mm/fault.c
+++ b/arch/x86_64/mm/fault.c
@@ -539,7 +539,7 @@ no_context:
 		printk(KERN_ALERT "Unable to handle kernel NULL pointer dereference");
 	else
 		printk(KERN_ALERT "Unable to handle kernel paging request");
-	printk(" at %016lx RIP: \n" KERN_ALERT,address);
+	printk(" at %016lx (error=0x%02lx) RIP: \n" KERN_ALERT, error_code, address);
 	printk_address(regs->rip);
 	dump_pagetable(address);
 	tsk->thread.cr2 = address;

--T4sUOijqQbZv57TR--
