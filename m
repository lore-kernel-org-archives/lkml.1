Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYJVBzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYJVBzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 21:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYJVBz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 21:55:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56232 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYJVBz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 21:55:28 -0400
Date: Wed, 22 Oct 2008 10:54:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH] memcg: uptodate menuconfig help text
Message-Id: <20081022105459.3f7f2485.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, page_cgroup is allocated at boot and memmap doesn't includes pointer for
page_cgroup.
Fixes menu help text for memcg-allocate-page-cgroup-at-boot.patch.

Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 init/Kconfig |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -401,16 +401,20 @@ config CGROUP_MEM_RES_CTLR
 	depends on CGROUPS && RESOURCE_COUNTERS
 	select MM_OWNER
 	help
-	  Provides a memory resource controller that manages both page cache and
-	  RSS memory.
+	  Provides a memory resource controller that manages both anonymous
+	  memory and page cache. (See Documentation/controllers/memory.txt)
 
 	  Note that setting this option increases fixed memory overhead
-	  associated with each page of memory in the system by 4/8 bytes
-	  and also increases cache misses because struct page on many 64bit
-	  systems will not fit into a single cache line anymore.
+	  associated with each page of memory in the system. By this,
+	  20(40)bytes/PAGE_SIZE on 32(64)bit system will be occupied by memory
+	  usage tracking struct at boot. Total amount of this is printed out
+	  at boot.
 
 	  Only enable when you're ok with these trade offs and really
-	  sure you need the memory resource controller.
+	  sure you need the memory resource controller. Even when you enable
+	  this, you can set "cgroup_disable=memory" at your boot option to
+	  disable memory resource controller and you can avoid overheads.
+	  (and lose benefits of memory resource contoller)
 
 	  This config option also selects MM_OWNER config option, which
 	  could in turn add some fork/exit overhead.

