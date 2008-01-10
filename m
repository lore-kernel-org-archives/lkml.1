Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbYAJQjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbYAJQjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 11:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756500AbYAJQji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 11:39:38 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:1225
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754027AbYAJQjh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:39:37 -0500
Message-Id: <4786586B.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 10 Jan 2008 16:39:55 +0000
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

--- linux-2.6.24-rc7/mm/vmalloc.c	2008-01-10 16:50:54.000000000 +0100
+++ 2.6.24-rc7-vm-ioremap-size/mm/vmalloc.c	2008-01-08 12:35:11.000000000 +0100
@@ -176,7 +176,7 @@ static struct vm_struct *__get_vm_area_n
 
 	BUG_ON(in_interrupt());
 	if (flags & VM_IOREMAP) {
-		int bit = fls(size);
+		int bit = fls(size - 1);
 
 		if (bit > IOREMAP_MAX_ORDER)
 			bit = IOREMAP_MAX_ORDER;



