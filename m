Return-Path: <linux-kernel-owner+w=401wt.eu-S965089AbXCOEjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965089AbXCOEjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 00:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965149AbXCOEjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 00:39:44 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42696 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965089AbXCOEjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 00:39:42 -0400
Date: Thu, 15 Mar 2007 10:05:47 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, hch@infradead.org,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: [PATCH] Kprobes: Make kprobe.symbol_name const
Message-ID: <20070315043547.GA14236@in.ibm.com>
Reply-To: ananth@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Kprobes doesn't scribble the kprobe.symbol_name field. Its only set by
the module when registering the probe. Modules that exercise good
hygiene using the "const" qualifier will see warnings...

	warning: assignment discards qualifiers from pointer target type

Make struct kprobe.symbol_name const char *

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>

---
 include/linux/kprobes.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc3/include/linux/kprobes.h
===================================================================
--- linux-2.6.21-rc3.orig/include/linux/kprobes.h
+++ linux-2.6.21-rc3/include/linux/kprobes.h
@@ -78,7 +78,7 @@ struct kprobe {
 	kprobe_opcode_t *addr;
 
 	/* Allow user to indicate symbol name of the probe point */
-	char *symbol_name;
+	const char *symbol_name;
 
 	/* Offset into the symbol */
 	unsigned int offset;
