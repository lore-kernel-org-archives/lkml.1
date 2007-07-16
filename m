Return-Path: <linux-kernel-owner+w=401wt.eu-S1762203AbXGPL5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203AbXGPL5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 07:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbXGPL5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 07:57:16 -0400
Received: from ns.suse.de ([195.135.220.2]:41389 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540AbXGPL5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 07:57:15 -0400
Date: Mon, 16 Jul 2007 13:57:07 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070716115707.GA29923@suse.de>
Mail-Followup-To: Vivek Goyal <vgoyal@in.ibm.com>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20070710120243.GA10121@hmsendeavour.rdu.redhat.com> <20070713200533oomichi@mail.jp.nec.com> <20070713131550.GB10985@suse.de> <20070716041918.GA11390@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716041918.GA11390@in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@in.ibm.com> [2007-07-16 06:19]:
> On Fri, Jul 13, 2007 at 03:15:50PM +0200, Bernhard Walle wrote:
> > * Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp> [2007-07-13 13:05]:
> > > 
> > > BTW, I'd like to remove PAGESIZE from a mkdfinfo file.
> > > While 2nd-kernel is running, new makedumpfile comes to consider
> > > 2nd-kernel PAGESIZE as 1st-kernel PAGESIZE without getting PAGESIZE
> > > from a mkdfinfo file.
> > 
> > I don't think that's a good idea. IMO the kernel should be modified to
> > export the page size in a variable for that purpose. That would solve
> > all problems and dependencies, doesn't it?
> > 
> 
> Agreed. We need to export PAGESIZE from kernel instead of assuming that
> second kernel as got same page size as first kernel.

So what about this? Do you think it has a chance to get included?
Should the variable not be inside mm/ but otherwhere?


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 mm/mmap.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -35,6 +35,16 @@
 #define arch_mmap_check(addr, len, flags)	(0)
 #endif
 
+#ifdef CONFIG_KEXEC
+
+/*
+ * Although that variable is not needed for the kernel, initialise it here
+ * to have the page size available in the vmlinux binary.
+ */
+int page_size = PAGE_SIZE;
+
+#endif
+
 static void unmap_region(struct mm_struct *mm,
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end);
