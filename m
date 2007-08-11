Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbXHKJqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbXHKJqd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 05:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbXHKJqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 05:46:25 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:44894 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbXHKJqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 05:46:24 -0400
Subject: Re: 2.6.23-rc2-mm2 build error on MIPS and ARM
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070811025802.GA15885@Krystal>
References: <20070811025802.GA15885@Krystal>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sat, 11 Aug 2007 11:50:00 +0200
Message-Id: <1186825800.32314.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-10 at 22:58 -0400, Mathieu Desnoyers wrote:
> I got the following errors when building 2.6.23-rc2-mm2 on both mips and
> arm. Both errors are very much alike.

That attached patch should fix it for arm and mips. I'll try a few more
architectures until I'm fed up with compiling cross-compilers..

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.
---
Subject: [PATCH] move mm_struct and vm_area_struct, compile fix.

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Include <asm/page.h> in <linux/mm_types.h> to make mips and arm
compile again after mm_struct and vm_area_struct have been moved.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/linux/mm_types.h |    1 +
 1 file changed, 1 insertion(+)

diff -urpN linux-2.6/include/linux/mm_types.h
linux-2.6-patched/include/linux/mm_types.h
--- linux-2.6/include/linux/mm_types.h	2007-08-11 11:30:10.000000000
+0200
+++ linux-2.6-patched/include/linux/mm_types.h	2007-08-11
11:32:42.000000000 +0200
@@ -11,6 +11,7 @@
 #include <linux/rwsem.h>
 #include <linux/completion.h>
 #include <asm/mmu.h>
+#include <asm/page.h>
 
 struct address_space;
 


