Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbYAXWQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbYAXWQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYAXWP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:15:57 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:51967 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753395AbYAXWP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:15:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAO+cmEdMQWYq/2dsb2JhbACBV61Y
Date: Thu, 24 Jan 2008 17:10:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/26] Add INIT_ARRAY() to kernel.h (update 2)
Message-ID: <20080124221054.GA5384@Krystal>
References: <20080124202706.250598537@polymtl.ca> <20080124203335.082459062@polymtl.ca> <20080124125845.bf5767b8.randy.dunlap@oracle.com> <20080124210431.GA1647@Krystal> <tkrat.234abd01d9726428@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <tkrat.234abd01d9726428@s5r6.in-berlin.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:09:27 up 82 days,  3:14,  6 users,  load average: 0.03, 0.88,
	1.09
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Array initializers in the body of a function causes unbalanced brackets which
syntax highlighting editors such as vim have problems with. Fix this by creating
the INIT_ARRAY() macro.

It is used to declare arguments passed as function parameters such as:
text_poke(addr, INIT_ARRAY(unsigned char, 0xf0, len), len);

Changelog :
- [len] -> []
- Remove whitespaces.
- Fixed Jan's suggestion which was not checkpatch.pl-safe.
- More informative patch header.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jan Engelhardt <jengelh@computergmbh.de>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>
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
