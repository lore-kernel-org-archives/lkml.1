Return-Path: <linux-kernel-owner+w=401wt.eu-S1757688AbYCYGR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688AbYCYGR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 02:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbYCYGRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 02:17:03 -0400
Received: from mx1.suse.de ([195.135.220.2]:37327 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009AbYCYGRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 02:17:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jean-Samuel Chenard <jsamch@gmail.com>, Hans J Koch <hjk@linutronix.de>,
       stable <stable@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/2] UIO: add pgprot_noncached() to UIO mmap code
Date: Mon, 24 Mar 2008 23:16:53 -0700
Message-Id: <1206425814-20831-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080325060503.GB20741@suse.de>
References: <20080325060503.GB20741@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Samuel Chenard <jsamch@gmail.com>

Mapping of physical memory in UIO needs pgprot_noncached() to ensure
that IO memory is not cached. Without pgprot_noncached(), it (accidentally)
works on x86 and arm, but fails on PPC.

Signed-off-by: Jean-Samuel Chenard <jsamch@gmail.com>
Signed-off-by: Hans J Koch <hjk@linutronix.de>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index e8a01f2..1175908 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -470,6 +470,8 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 
 	vma->vm_flags |= VM_IO | VM_RESERVED;
 
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
 	return remap_pfn_range(vma,
 			       vma->vm_start,
 			       idev->info->mem[mi].addr >> PAGE_SHIFT,
-- 
1.5.4.3

