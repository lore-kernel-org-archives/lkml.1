Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbYGRFFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbYGRFFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 01:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYGRFEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 01:04:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:23129 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbYGRFEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 01:04:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=w4oPRDffHPE7hYeG001mGfYh15rADa7luh08cbEVwnbOnwL16LsqZoT/NKJfPA4Snc
         MXlzm5rQH2Ax/w9aJhI5s8Gd13Rlo7SHwzZ4kEpM/OOoJZx9Ehxim6fRHLK7voeS4w9P
         3a6sJucwSATe5pb8xOTkM1zNPAoIGiQgRDlOw=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, hjk@linutronix.de, gregkh@suse.de,
       akpm@linux-foundation.org
Date: Fri, 18 Jul 2008 14:04:43 +0900
Message-Id: <20080718050443.16250.24714.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080718050402.16250.25213.sendpatchset@rx1.opensource.se>
References: <20080718050402.16250.25213.sendpatchset@rx1.opensource.se>
Subject: [PATCH 05/06] uio: Remove redundant vma->vm_flags setup code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

Remove redundant VM_IO | VM_RESERVED setup code since remap_pfn_range()
already sets them for us.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/uio/uio.c |    1 -
 1 file changed, 1 deletion(-)

--- 0005/drivers/uio/uio.c
+++ work/drivers/uio/uio.c	2008-07-18 12:44:42.000000000 +0900
@@ -474,7 +474,6 @@ static struct vm_operations_struct uio_v
 
 static int uio_mmap_physical(struct vm_area_struct *vma, struct uio_mem *imem)
 {
-	vma->vm_flags |= VM_IO | VM_RESERVED;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	return remap_pfn_range(vma,
 			       vma->vm_start,
