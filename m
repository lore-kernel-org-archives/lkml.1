Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbZIPA2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbZIPA2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 20:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbZIPA2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 20:28:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53262 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZIPA2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 20:28:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Sep 2009 09:26:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: [BUGFIX][mmotm] fix walk system ram range patch (Was Re: mmotm on
 powerpc: walk_memory_resource?
Message-Id: <20090916092644.fb53279a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0909152224400.29857@sister.anvils>
References: <Pine.LNX.4.64.0909152224400.29857@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 22:36:26 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> Recent mmotm builds on powerpc have been failing with
> 
> arch/powerpc/mm/mem.c:169: error: ‘walk_memory_resource’ undeclared here (not in a function)
> cc1: warnings being treated as errors
> arch/powerpc/mm/mem.c:169: error: type defaults to ‘int’ in declaration of ‘walk_memory_resource’
> make[1]: *** [arch/powerpc/mm/mem.o] Error 1
> 
Thank you for pointing out.
-Kame
==


walk-system-ram-range.patch renames walk_memory_resource()
to be walk_system_ram_range().
But powerpc has its own one and it's exported.
(Because ehea driver (IBM's one) uses this, powerpc export this.)

> arch/powerpc/mm/mem.c:169: error: ‘walk_memory_resource’ undeclared here (not in a function)
> cc1: warnings being treated as errors
> arch/powerpc/mm/mem.c:169: error: type defaults to ‘int’ in declaration of ‘walk_memory_resource’
> make[1]: *** [arch/powerpc/mm/mem.o] Error 1
> 
The patch failed to update powerpc's EXPORT_SYMBOL, this patch fixes it.

Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 arch/powerpc/mm/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: mmotm-2.6.31-Sep14/arch/powerpc/mm/mem.c
===================================================================
--- mmotm-2.6.31-Sep14.orig/arch/powerpc/mm/mem.c
+++ mmotm-2.6.31-Sep14/arch/powerpc/mm/mem.c
@@ -166,7 +166,7 @@ walk_system_ram_range(unsigned long star
 	}
 	return ret;
 }
-EXPORT_SYMBOL_GPL(walk_memory_resource);
+EXPORT_SYMBOL_GPL(walk_system_ram_range);
 
 /*
  * Initialize the bootmem system and give it all the memory we

