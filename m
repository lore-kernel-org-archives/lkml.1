Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbYCNK3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbYCNK3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 06:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYCNK2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 06:28:52 -0400
Received: from www.tglx.de ([62.245.132.106]:35723 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbYCNK2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 06:28:52 -0400
Date: Fri, 14 Mar 2008 11:28:36 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Greg KH <greg@kroah.com>
Cc: Hans J Koch <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       Juergen Beisert <juergen127@kreuzholzen.de>,
       Jean-Samuel Chenard <jsamch@gmail.com>
Subject: [PATCH] Add pgprot_noncached() to UIO mmap code
Message-ID: <20080314112836.30f39afb@bluebox.local>
Organization: Linutronix GmbH
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Samuel Chenard <jsamch@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Hans J Koch <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
 Juergen Beisert <juergen127@kreuzholzen.de>
Date: Fri, 14 Mar 2008 11:19:49 +0100
Subject: Add pgprot_noncached() to UIO mmap code

Mapping of physical memory in UIO needs pgprot_noncached() to ensure
that IO memory is not cached. Without pgprot_noncached(), it (accidentally)
works on x86 and arm, but fails on PPC.

Signed-off-by: Jean-Samuel Chenard <jsamch@gmail.com>
Signed-off-by: Hans J Koch <hjk@linutronix.de>

---
 drivers/uio/uio.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.25-rc/drivers/uio/uio.c
===================================================================
--- linux-2.6.25-rc.orig/drivers/uio/uio.c	2008-03-14 11:00:59.000000000 +0100
+++ linux-2.6.25-rc/drivers/uio/uio.c	2008-03-14 11:03:13.000000000 +0100
@@ -470,6 +470,8 @@
 
 	vma->vm_flags |= VM_IO | VM_RESERVED;
 
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
 	return remap_pfn_range(vma,
 			       vma->vm_start,
 			       idev->info->mem[mi].addr >> PAGE_SHIFT,
