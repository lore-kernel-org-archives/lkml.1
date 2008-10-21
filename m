Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbYJUGMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbYJUGMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 02:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYJUGMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 02:12:23 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:45558 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbYJUGMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 02:12:22 -0400
Date: Tue, 21 Oct 2008 08:12:19 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH] Fix page_cgroup build breakage
Message-ID: <20081021061219.GA4980@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Fix page_cgroup build breakage

From: Heiko Carstens <heiko.carstens@de.ibm.com>

On s390 I get this:

  CC      mm/page_cgroup.o
mm/page_cgroup.c: In function 'init_section_page_cgroup':
mm/page_cgroup.c:111: error: implicit declaration of function 'vmalloc_node'
mm/page_cgroup.c:111: warning: assignment makes pointer from integer without a cast
mm/page_cgroup.c: In function '__free_page_cgroup':
mm/page_cgroup.c:140: error: implicit declaration of function 'vfree'
make[1]: *** [mm/page_cgroup.o] Error 1
make: *** [mm] Error 2

caused by 52d4b9ac0b985168009c2a57098324e67bae171f
("memcg: allocate all page_cgroup at boot")

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 mm/page_cgroup.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/mm/page_cgroup.c
===================================================================
--- linux-2.6.orig/mm/page_cgroup.c
+++ linux-2.6/mm/page_cgroup.c
@@ -3,6 +3,7 @@
 #include <linux/bootmem.h>
 #include <linux/bit_spinlock.h>
 #include <linux/page_cgroup.h>
+#include <linux/vmalloc.h>
 #include <linux/hash.h>
 #include <linux/memory.h>
 
