Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbZHQUgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbZHQUgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZHQUgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:36:50 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:16802 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbZHQUgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:36:49 -0400
Message-ID: <4A89BF90.5070202@oracle.com>
Date: Mon, 17 Aug 2009 13:37:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH -next] trace_skb: fix build when CONFIG_NET is not enabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt012.oracle.com [141.146.116.21]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4A89BF32.0051:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix trace_skb_sources build when CONFIG_NET is not enabled:

kernel/built-in.o: In function `probe_skb_dequeue':
trace_skb_sources.c:(.text+0xd9152): undefined reference to `init_net'
trace_skb_sources.c:(.text+0xd9188): undefined reference to `dev_get_by_index'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
---
 kernel/trace/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090817.orig/kernel/trace/Kconfig
+++ linux-next-20090817/kernel/trace/Kconfig
@@ -236,6 +236,7 @@ config BOOT_TRACER
 
 config SKB_SOURCES_TRACER
 	bool "Trace skb source information"
+	depends on NET
 	select GENERIC_TRACER
 	help
 	   This tracer helps developers/sysadmins correlate skb allocation and



-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
