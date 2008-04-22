Return-Path: <linux-kernel-owner+w=401wt.eu-S1762143AbYDVPPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762143AbYDVPPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYDVPP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:15:27 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15676 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbYDVPP0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:15:26 -0400
Message-Id: <480E1D3A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 16:15:38 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] adjust size calculation for get_vm_area() in ioremap()
	context
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Short of getting a reply on the query why the argument of fls() here is
missing the decrement, here's a patch to add it (reducing the resulting
size when the incoming size is an exact power of two).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

---
 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.25/mm/vmalloc.c	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-vm-ioremap-size/mm/vmalloc.c	2008-04-15 10:49:20.000000000 +0200
@@ -214,7 +214,7 @@ static struct vm_struct *__get_vm_area_n
 
 	BUG_ON(in_interrupt());
 	if (flags & VM_IOREMAP) {
-		int bit = fls(size);
+		int bit = fls(size - 1);
 
 		if (bit > IOREMAP_MAX_ORDER)
 			bit = IOREMAP_MAX_ORDER;



