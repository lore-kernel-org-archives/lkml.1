Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYBJPj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYBJPj6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 10:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYBJPjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 10:39:48 -0500
Received: from mars.karoo.kcom.com ([212.50.160.54]:40687 "EHLO
	mars.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYBJPjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 10:39:47 -0500
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2008 10:39:47 EST
X-IronPort-AV: E=Sophos;i="4.25,330,1199664000"; 
   d="scan'208";a="255942570"
Date: Sun, 10 Feb 2008 15:33:55 +0000
From: Martin Habets <errandir_news@mph.eclipse.co.uk>
To: David Rientjes <rientjes@google.com>
Cc: Adrian Bunk <bunk@kernel.org>, wli@holomorphy.com,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: sparc compile error
Message-ID: <20080210153355.GA6737@palantir8>
Mail-Followup-To: David Rientjes <rientjes@google.com>,
	Adrian Bunk <bunk@kernel.org>, wli@holomorphy.com,
	linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
References: <20080207231230.GE7198@cs181133002.pp.htv.fi> <alpine.DEB.1.00.0802071538440.15050@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0802071538440.15050@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This still gives build errors with CGROUP_MEM_CONT off.
Some ifdef-ing will fix that.

 Martin

	 Signed-off-by: Martin Habets <errandir_news@mph.eclipse.co.uk>

Index: sparc-2.6.git/mm/rmap.c
===================================================================
--- sparc-2.6.git.orig/mm/rmap.c	2008-02-10 13:01:37.000000000 +0000
+++ sparc-2.6.git/mm/rmap.c	2008-02-10 14:16:34.000000000 +0000
@@ -321,8 +321,11 @@
 		 * counting on behalf of references from different
 		 * cgroups
 		 */
-		if (mem_cont && (mm_cgroup(vma->vm_mm) != mem_cont))
+#ifdef CONFIG_CGROUP_MEM_CONT
+		if (mem_cont && mem_cont !=
+		    rcu_dereference(vma->vm_mm->mem_cgroup))
 			continue;
+#endif
 		referenced += page_referenced_one(page, vma, &mapcount);
 		if (!mapcount)
 			break;
@@ -382,8 +385,11 @@
 		 * counting on behalf of references from different
 		 * cgroups
 		 */
-		if (mem_cont && (mm_cgroup(vma->vm_mm) != mem_cont))
+#ifdef CONFIG_CGROUP_MEM_CONT
+		if (mem_cont && mem_cont !=
+		    rcu_dereference(vma->vm_mm->mem_cgroup))
 			continue;
+#endif
 		if ((vma->vm_flags & (VM_LOCKED|VM_MAYSHARE))
 				  == (VM_LOCKED|VM_MAYSHARE)) {
 			referenced++;
