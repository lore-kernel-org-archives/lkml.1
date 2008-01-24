Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbYAXU7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbYAXU7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbYAXU7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:59:40 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:47263 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755835AbYAXU7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:59:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAHCLmEdMQWYq/2dsb2JhbACBV61r
Date: Thu, 24 Jan 2008 15:54:34 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 07/26] Add INIT_ARRAY() to kernel.h (updated)
Message-ID: <20080124205434.GC31333@Krystal>
References: <20080124202706.250598537@polymtl.ca> <20080124203335.082459062@polymtl.ca> <Pine.LNX.4.64.0801242137020.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801242137020.12676@fbirervta.pbzchgretzou.qr>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:46:45 up 82 days,  1:52,  6 users,  load average: 0.00, 0.04,
	0.14
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add initialization of an array, which needs brackets that would pollute kernel
code, to kernel.h. It is used to declare arguments passed as function parameters
such as:
text_poke(addr, INIT_ARRAY(unsigned char, 0xf0, len), len);

Changelog :
- [len] -> []
- Remove whitespaces.
- Fixed Jan's suggestion which was not checkpatch.pl-safe.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/kernel.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-lttng.mm/include/linux/kernel.h
===================================================================
--- linux-2.6-lttng.mm.orig/include/linux/kernel.h	2008-01-24 15:53:04.000000000 -0500
+++ linux-2.6-lttng.mm/include/linux/kernel.h	2008-01-24 15:53:25.000000000 -0500
@@ -423,4 +423,6 @@ struct sysinfo {
 #define NUMA_BUILD 0
 #endif
 
+#define INIT_ARRAY(type, val, len) ((type[]) {[0 ... (len)-1] = (val)})
+
 #endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
