Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbYJUGMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbYJUGMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 02:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbYJUGLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 02:11:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51757 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbYJUGLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 02:11:34 -0400
Date: Tue, 21 Oct 2008 15:11:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nishimura@mxp.nes.nec.co.jp
Subject: Re: memcg: Fix init/Kconfig documentation
Message-Id: <20081021151105.f13ec6d2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081021055118.GA11429@balbir.in.ibm.com>
References: <20081021055118.GA11429@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 11:21:18 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> From: Balbir Singh <balbir@linux.vnet.ibm.com>
> Date: Tue, 21 Oct 2008 11:12:45 +0530
> Subject: [PATCH] memcg: Update Kconfig to remove the struct page overhead statement.
> 
> The memory resource controller no longer has a struct page overhead
> associated with it. The init/Kconfig help has been replaced with
> something more suitable based on the current implementation.
> 
Oh, this is my version..could you merge if this includes something good ?

==
Fixes menu help text for memcg-allocate-page-cgroup-at-boot.patch.


Signed-off-by: KAMEZAWA hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 init/Kconfig |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

Index: mmotm-2.6.27+/init/Kconfig
===================================================================
--- mmotm-2.6.27+.orig/init/Kconfig
+++ mmotm-2.6.27+/init/Kconfig
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
+	  disable memory resource controller and you can avoid almost all bads.
+	  (and lost benefits of memory resource contoller)
 
 	  This config option also selects MM_OWNER config option, which
 	  could in turn add some fork/exit overhead.

