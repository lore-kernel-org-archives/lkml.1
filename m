Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbXLIEWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbXLIEWa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 23:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXLIEWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 23:22:23 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:28780 "EHLO
	outbound6-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948AbXLIEWW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 23:22:22 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <475B6D77.6070906@am.sony.com>
Date: Sat, 08 Dec 2007 20:22:15 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: sparsemem: Make SPARSEMEM_VMEMMAP selectable
References: <47537F2E.2070204@am.sony.com>
In-Reply-To: <47537F2E.2070204@am.sony.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
X-OriginalArrivalTime: 09 Dec 2007 04:22:19.0209 (UTC) FILETIME=[16433390:01C83A1B]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Geoff Levand <geoffrey.levand@am.sony.com>

SPARSEMEM_VMEMMAP needs to be a selectable config option to
support building the kernel both with and without sparsemem
vmemmap support.  This selection is desirable for platforms
which could be configured one way for platform specific
builds and the other for multi-platform builds.

Signed-off-by: Miguel Botón <mboton@gmail.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---

Andrew, 

Please consider for 2.6.24.

-Geoff


 mm/Kconfig |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -112,18 +112,17 @@ config SPARSEMEM_EXTREME
 	def_bool y
 	depends on SPARSEMEM && !SPARSEMEM_STATIC
 
-#
-# SPARSEMEM_VMEMMAP uses a virtually mapped mem_map to optimise pfn_to_page
-# and page_to_pfn.  The most efficient option where kernel virtual space is
-# not under pressure.
-#
 config SPARSEMEM_VMEMMAP_ENABLE
 	def_bool n
 
 config SPARSEMEM_VMEMMAP
-	bool
-	depends on SPARSEMEM
-	default y if (SPARSEMEM_VMEMMAP_ENABLE)
+	bool "Sparse Memory virtual memmap"
+	depends on SPARSEMEM && SPARSEMEM_VMEMMAP_ENABLE
+	default y
+	help
+	 SPARSEMEM_VMEMMAP uses a virtually mapped memmap to optimise
+	 pfn_to_page and page_to_pfn operations.  This is the most
+	 efficient option when sufficient kernel resources are available.
 
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG


