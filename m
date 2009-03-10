Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbZCJOj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbZCJOj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbZCJOjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:39:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:5169 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbZCJOjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:39:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XTHSpUwkDGBlx+QBa2v7NTuInj3qRpPYVKxlWoITgFMB6XVSeBwdgzOfli++Klil5/
         FXXr44RoP/4bsQXXbgt57M+HF4NttJzcm7NqC70wOuOsgycFdfOfnoIaeaUswbj5+E7x
         hDOBSqrpglxvZ6Fc04T5YahzFpPuj5jD0zt9A=
Date: Tue, 10 Mar 2009 23:38:57 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/2 -mmotm] debug-pagealloc: cannot depend on hibernation
Message-ID: <20090310143857.GB3151@localhost.localdomain>
References: <20090310143701.GA3151@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20090310143701.GA3151@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic debug-pagealloc generates wrong messages for the page corruption
after hibernation. Because the free pages are not saved to the suspend image.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-arch@vger.kernel.org>
---
 mm/Kconfig.debug |    5 +++++
 1 file changed, 5 insertions(+)

Index: 2.6-mmotm/mm/Kconfig.debug
===================================================================
--- 2.6-mmotm.orig/mm/Kconfig.debug
+++ 2.6-mmotm/mm/Kconfig.debug
@@ -4,9 +4,14 @@ config WANT_PAGE_DEBUG_FLAGS
 config PAGE_POISONING
 	bool "Debug page memory allocations"
 	depends on DEBUG_KERNEL && !ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	depends on !HIBERNATION
 	select DEBUG_PAGEALLOC
 	select WANT_PAGE_DEBUG_FLAGS
 	help
 	   Fill the pages with poison patterns after free_pages() and verify
 	   the patterns before alloc_pages(). This results in a large slowdown,
 	   but helps to find certain types of memory corruptions.
+
+	   This option cannot enalbe with hibernation. Otherwise, it will get
+	   wrong messages for memory corruption because the free pages are not
+	   saved to the suspend image.
