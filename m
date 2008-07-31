Return-Path: <linux-kernel-owner+w=401wt.eu-S1761624AbYGaBco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761624AbYGaBco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 21:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbYGaBaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 21:30:52 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:47610 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbYGaBap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 21:30:45 -0400
Message-Id: <20080731012927.994229258@vergenet.net>
References: <20080731012208.115225969@vergenet.net>
User-Agent: quilt/0.46-1
Date: Thu, 31 Jul 2008 11:22:14 +1000
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
From: Simon Horman <horms@verge.net.au>
Subject: [patch 6/6] kdump: use is_vmcore_usable() and vmcore_unusable() in reserve_elfcorehdr()
Content-Disposition: inline; filename=use-is_vmcore_usable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After recent changes setting elfcorehdr_addr to ELFCORE_ADDR_MAX
will cause is_kdump_kernel() to return 0 when it should return 1.
Instead use vmcore_unusable(), which has been added for this purpose.

Signed-off-by: Simon Horman <horms@verge.net.au>

--- 

Andrew, this can wait until post 2.6.27 as although the current
state of affairs is confusing, a bug does not manifest at this time
as there are no callers of is_kdump_kernel on ia64 at this time.

is_vmcore_usable() and vmcore_unusable() are provided by a previous
patch in this series

Index: linux-2.6/arch/ia64/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/setup.c	2008-07-31 09:41:15.000000000 +1000
+++ linux-2.6/arch/ia64/kernel/setup.c	2008-07-31 09:41:36.000000000 +1000
@@ -509,11 +509,11 @@ int __init reserve_elfcorehdr(unsigned l
 	 * to work properly.
 	 */
 
-	if (elfcorehdr_addr >= ELFCORE_ADDR_MAX)
+	if (!is_vmcore_usable())
 		return -EINVAL;
 
 	if ((length = vmcore_find_descriptor_size(elfcorehdr_addr)) == 0) {
-		elfcorehdr_addr = ELFCORE_ADDR_MAX;
+		vmcore_unusable();
 		return -EINVAL;
 	}
 

-- 

-- 
Horms

