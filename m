Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbZLRAjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbZLRAjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZLRAjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:39:46 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:39479 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbZLRAjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:39:43 -0500
MIME-Version: 1.0
Message-ID: <6160c200-144c-4cc0-b095-6fe27e9ee3a1@default>
Date: Thu, 17 Dec 2009 16:38:28 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: dan.magenheimer@oracle.com, npiggin@suse.de, akpm@osdl.org,
       jeremy@goop.org, xen-devel@lists.xensource.com,
       tmem-devel@oss.oracle.com, kurt.hackel@oracle.com,
       Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
       dave.mccracken@oracle.com, linux-mm@kvack.org,
       Rusty@rcsinet15.oracle.com, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, alan@lxorguk.ukuu.org.uk,
       chris.mason@oracle.com, Pavel Machek <pavel@ucw.cz>
Subject: Tmem [PATCH 4/5] (Take 3): Add mm buildfiles
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4B2ACF1B.0142:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tmem [PATCH 4/5] (Take 3): Add mm buildfiles

Add necessary Kconfig and Makefile changes to mm directory

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

 Kconfig                                  |   26 +++++++++++++++++++++
 Makefile                                 |    3 ++
 2 files changed, 29 insertions(+)

--- linux-2.6.32/mm/Kconfig	2009-12-02 20:51:21.000000000 -0700
+++ linux-2.6.32-tmem/mm/Kconfig	2009-12-17 13:56:46.000000000 -0700
@@ -287,3 +287,29 @@ config NOMMU_INITIAL_TRIM_EXCESS
 	  of 1 says that all excess pages should be trimmed.
 
 	  See Documentation/nommu-mmap.txt for more information.
+
+#
+# support for transcendent memory
+#
+config TMEM
+	bool "Transcendent memory support"
+	help
+	  In a virtualized environment, allows unused and underutilized
+	  system physical memory to be made accessible through a narrow
+	  well-defined page-copy-based API.
+
+config CLEANCACHE
+	bool "Cache clean pages in transcendent memory"
+	depends on TMEM
+	help
+	  Allows the transcendent memory pool to be used to store clean
+	  page-cache pages which, under some circumstances, will greatly
+	  reduce paging and thus improve performance.
+
+config FRONTSWAP
+	bool "Swap pages to transcendent memory"
+	depends on TMEM
+	help
+	  Allows the transcendent memory pool to be used as a pseudo-swap
+	  device which, under some circumstances, will greatly reduce
+	  swapping and thus improve performance.
--- linux-2.6.32/mm/Makefile	2009-12-02 20:51:21.000000000 -0700
+++ linux-2.6.32-tmem/mm/Makefile	2009-12-17 14:23:40.000000000 -0700
@@ -17,6 +17,9 @@ obj-y += init-mm.o
 
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
+obj-$(CONFIG_TMEM)	+= tmem.o
+obj-$(CONFIG_FRONTSWAP)	+= frontswap.o
+obj-$(CONFIG_CLEANCACHE) += cleancache.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
 obj-$(CONFIG_NUMA) 	+= mempolicy.o
