Return-Path: <linux-kernel-owner+w=401wt.eu-S1762254AbYDQBJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762254AbYDQBJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbYDQBHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:07:00 -0400
Received: from sous-sol.org ([216.99.217.87]:58784 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904AbYDQBG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:06:58 -0400
Message-Id: <20080417010312.861195068@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:28 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean-Samuel Chenard <jsamch@gmail.com>, Hans J Koch <hjk@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: UIO: add pgprot_noncached() to UIO mmap code
Content-Disposition: inline; filename=uio-add-pgprot_noncached-to-uio-mmap-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jean-Samuel Chenard <jsamch@gmail.com>

upstream commit: c9698d6b1a90929e427a165bd8283f803f57d9bd

Mapping of physical memory in UIO needs pgprot_noncached() to ensure
that IO memory is not cached. Without pgprot_noncached(), it (accidentally)
works on x86 and arm, but fails on PPC.

Signed-off-by: Jean-Samuel Chenard <jsamch@gmail.com>
Signed-off-by: Hans J Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/uio/uio.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -447,6 +447,8 @@ static int uio_mmap_physical(struct vm_a
 
 	vma->vm_flags |= VM_IO | VM_RESERVED;
 
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
 	return remap_pfn_range(vma,
 			       vma->vm_start,
 			       idev->info->mem[mi].addr >> PAGE_SHIFT,

-- 
