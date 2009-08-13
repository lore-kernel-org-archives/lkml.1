Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbZHMUBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbZHMUBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932321AbZHMUAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:00:13 -0400
Received: from kroah.org ([198.145.64.141]:41955 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303AbZHMUAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:00:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:34 2009
Message-Id: <20090813195134.338486356@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alok N Kataria <akataria@vmware.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 66/74] x86: Fix VMI && stack protector
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=x86-fix-vmi-stack-protector.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alok Kataria <akataria@vmware.com>

commit 7d5b005652bc5ae3e1e0efc53fd0e25a643ec506 upstream.

With CONFIG_STACK_PROTECTOR turned on, VMI doesn't boot with
more than one processor. The problem is with the gs value not
being initialized correctly when registering the secondary
processor for VMI's case.

The patch below initializes the gs value for the AP to
__KERNEL_STACK_CANARY. Without this the secondary processor
keeps on taking a GP on every gs access.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
LKML-Reference: <1249425262.18955.40.camel@ank32.eng.vmware.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/vmi_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -441,7 +441,7 @@ vmi_startup_ipi_hook(int phys_apicid, un
 	ap.ds = __USER_DS;
 	ap.es = __USER_DS;
 	ap.fs = __KERNEL_PERCPU;
-	ap.gs = 0;
+	ap.gs = __KERNEL_STACK_CANARY;
 
 	ap.eflags = 0;
 


