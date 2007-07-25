Return-Path: <linux-kernel-owner+w=401wt.eu-S1760761AbXGYVmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761AbXGYVmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbXGYVmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:42:07 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55622 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbXGYVmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:42:05 -0400
Date: Wed, 25 Jul 2007 14:42:03 -0700
From: sukadev@us.ibm.com
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>, takata@linux-m32r.org,
       linux-kernel@vger.kernel.org, linux-m32r@ml.linux-m32r.org
Subject: Re: 2.6.23-rc1-mm1: m32r is_init() compile error
Message-ID: <20070725214203.GA25062@us.ibm.com>
References: <20070725040304.111550f4.akpm@linux-foundation.org> <20070725210157.GH3572@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725210157.GH3572@stusta.de>
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk [bunk@stusta.de] wrote:
| On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
| >...
| > Changes since 2.6.22-rc6-mm1:
| >...
| > +pid-namespaces-define-is_global_init-and-is_container_init.patch
| >...
| >  pid namespaces
| >...
| 
| m32r was forgotten:
| 
| <--  snip  -->
| 
| ...
|   CC      arch/m32r/mm/fault.o
| arch/m32r/mm/fault.c: In function 'do_page_fault':
| arch/m32r/mm/fault.c:274: error: implicit declaration of function 'is_init'
| make[2]: *** [arch/m32r/mm/fault.o] Error 1
| 
| <--  snip  -->

Sorry. Here is a fix for it.
---

From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [PATCH] Use is_global_init() in arch/m32r/mm/fault.c

Use is_global_init() in arch/m32r/mm/fault.c.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: containers@lists.osdl.org
---
 arch/m32r/mm/fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: lx26-23-rc1-mm1/arch/m32r/mm/fault.c
===================================================================
--- lx26-23-rc1-mm1.orig/arch/m32r/mm/fault.c	2007-07-25 14:24:18.000000000 -0700
+++ lx26-23-rc1-mm1/arch/m32r/mm/fault.c	2007-07-25 14:32:23.000000000 -0700
@@ -271,7 +271,7 @@ no_context:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_init(tsk)) {
+	if (is_global_init(tsk)) {
 		yield();
 		down_read(&mm->mmap_sem);
 		goto survive;
