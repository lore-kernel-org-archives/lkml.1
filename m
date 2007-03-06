Return-Path: <linux-kernel-owner+w=401wt.eu-S932908AbXCFH1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbXCFH1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 02:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932913AbXCFH1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 02:27:42 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:49001 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbXCFH1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 02:27:41 -0500
X-IronPort-AV: i="4.14,253,1170651600"; 
   d="scan'208"; a="30080082:sNHT28400778"
Subject: [PATCH -mm] utrace: nommu fixup support utrace
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: roland@redhat.com, David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Tue, 06 Mar 2007 15:25:27 +0800
Message-Id: <1173165927.17134.5.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

When adding utrace support to blackfin architecture, I found a compiling
error in nommu related utrace stuff. Then this little patch will fix
this for nommu arch utrace.

Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
---
 mm/nommu.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/mm/nommu.c
===================================================================
--- linux-2.6.orig/mm/nommu.c	2007-03-06 15:14:22.000000000 +0800
+++ linux-2.6/mm/nommu.c	2007-03-06 15:16:01.000000000 +0800
@@ -673,7 +673,11 @@
 	 * it's being traced - otherwise breakpoints set in it may interfere
 	 * with another untraced process
 	 */
+#ifdef CONFIG_UTRACE
+	if (flags & MAP_PRIVATE) 
+#else
 	if ((flags & MAP_PRIVATE) && (current->ptrace & PT_PTRACED))
+#endif
 		vm_flags &= ~VM_MAYSHARE;
 
 	return vm_flags;
_

Thanks
-Bryan Wu
