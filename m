Return-Path: <linux-kernel-owner+w=401wt.eu-S1763682AbYEOR5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763682AbYEOR5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763218AbYEOR4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:56:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763141AbYEOR4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:56:03 -0400
Message-Id: <20080515175431.118650500@redhat.com>
References: <20080515175357.636334082@redhat.com>
User-Agent: quilt/0.46-1
Date: Thu, 15 May 2008 13:54:00 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ajackson@redhat.com, airlied@redhat.com,
       benh@kernel.crashing.org
Subject: [patch 3/5] use generic_access_phys for pci mmap on x86
Content-Disposition: inline; filename=03-x86-pci.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use generic_access_phys for ptrace and /proc/pid/mem access to
PCI device memory on x86.  This makes it possible to debug the
X server.

Signed-off-by: Rik van Riel <riel@redhat.com>

Index: ptrace-2.6.26-rc2-mm1/arch/x86/pci/i386.c
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/arch/x86/pci/i386.c	2008-05-15 12:46:41.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/arch/x86/pci/i386.c	2008-05-15 13:34:36.000000000 -0400
@@ -280,6 +280,7 @@ static void pci_track_mmap_page_range(st
 static struct vm_operations_struct pci_mmap_ops = {
 	.open  = pci_track_mmap_page_range,
 	.close = pci_unmap_page_range,
+	.access = generic_access_phys,
 };
 
 int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,

-- 
All Rights Reversed

