Return-Path: <linux-kernel-owner+w=401wt.eu-S964815AbXBLJaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964815AbXBLJaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964820AbXBLJaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:30:24 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:51461 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815AbXBLJaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:30:22 -0500
Date: Mon, 12 Feb 2007 14:59:45 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Srinivasa Ds <srinivasa@in.ibm.com>, Frederik Deweerdt <deweerdt@free.fr>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jkenisto@us.ibm.com,
       anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com,
       davem@davemloft.net
Subject: Re: [RFC] [PATCH] To list all active probes in the system---Take-2
Message-ID: <20070212092945.GA7109@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <45C85097.1000106@in.ibm.com> <20070206100607.GA10296@infradead.org> <45C856F1.7060403@in.ibm.com> <45C894EA.4060305@in.ibm.com> <20070206145609.GA11249@slug> <45C962C3.2020904@in.ibm.com> <20070207142717.5da4d8d4.akpm@linux-foundation.org> <45CB0D87.8070808@in.ibm.com> <20070212004515.b66ec836.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212004515.b66ec836.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 12:45:15AM -0800, Andrew Morton wrote:
> On Thu, 08 Feb 2007 17:16:15 +0530 Srinivasa Ds <srinivasa@in.ibm.com> wrote:
> 
> > +	if (p->pre_handler == pre_handler_kretprobe)
> 
> This breaks on sparc64:
> 
> kernel/kprobes.c: In function `report_probe':
> kernel/kprobes.c:826: error: `pre_handler_kretprobe' undeclared (first use in this function)

Andrew,

Here is a patch to fix the issue, compile tested with crosstools. Sorry for
the trouble.

Do you want a comprehensive patch that folds all the related changes
into one?

Ananth
--

Fix kprobes compilation breakage on sparc64 caused due to
kprobes-list-all-active-probes-in-the-system.patch

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

---
 kernel/kprobes.c |    6 ++++++
 1 files changed, 6 insertions(+)

Index: linux-2.6.20/kernel/kprobes.c
===================================================================
--- linux-2.6.20.orig/kernel/kprobes.c
+++ linux-2.6.20/kernel/kprobes.c
@@ -780,6 +780,12 @@ int __kprobes register_kretprobe(struct 
 	return -ENOSYS;
 }
 
+static int __kprobes pre_handler_kretprobe(struct kprobe *p,
+					   struct pt_regs *regs)
+{
+	return 0;
+}
+
 #endif /* ARCH_SUPPORTS_KRETPROBES */
 
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
