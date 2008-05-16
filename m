Return-Path: <linux-kernel-owner+w=401wt.eu-S1761263AbYEPU2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263AbYEPU2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760838AbYEPU1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:27:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849AbYEPU1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:27:51 -0400
Date: Fri, 16 May 2008 16:27:34 -0400
From: Rik van Riel <riel@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       ajackson@redhat.com, airlied@redhat.com, benh@kernel.crashing.org
Subject: [PATCH 6/5] Add documentation for the vm_ops->access function.
Message-ID: <20080516162734.5e69d336@cuia.bos.redhat.com>
In-Reply-To: <1210926049.7886.21.camel@twins>
References: <20080515175357.636334082@redhat.com>
	<20080515175431.000301639@redhat.com>
	<1210926049.7886.21.camel@twins>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Add documentation for the vm_ops->access function.

Signed-off-by: Rik van Riel <riel@redhat.com>

Index: ptrace-2.6.26-rc2-mm1/Documentation/filesystems/Locking
===================================================================
--- ptrace-2.6.26-rc2-mm1.orig/Documentation/filesystems/Locking	2008-05-15 12:46:37.000000000 -0400
+++ ptrace-2.6.26-rc2-mm1/Documentation/filesystems/Locking	2008-05-16 16:25:10.000000000 -0400
@@ -510,6 +510,7 @@ prototypes:
 	void (*close)(struct vm_area_struct*);
 	int (*fault)(struct vm_area_struct*, struct vm_fault *);
 	int (*page_mkwrite)(struct vm_area_struct *, struct page *);
+	int (*access)(struct vm_area_struct *, unsigned long, void*, int, int);
 
 locking rules:
 		BKL	mmap_sem	PageLocked(page)
@@ -517,6 +518,7 @@ open:		no	yes
 close:		no	yes
 fault:		no	yes
 page_mkwrite:	no	yes		no
+access:		no	yes
 
 	->page_mkwrite() is called when a previously read-only page is
 about to become writeable. The file system is responsible for
@@ -525,6 +527,11 @@ taking to lock out truncate, the page ra
 within i_size. The page mapping should also be checked that it is not
 NULL.
 
+	->access() is called when get_user_pages() fails in
+acces_process_vm(), typically used to debug a process through
+/proc/pid/mem or ptrace.  This function is needed only for
+VM_IO | VM_PFNMAP VMAs.
+
 ================================================================================
 			Dubious stuff
 
