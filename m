Return-Path: <linux-kernel-owner+w=401wt.eu-S1762018AbZCNAoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762018AbZCNAoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZCNATq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:46 -0400
Received: from kroah.org ([198.145.64.141]:34947 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753845AbZCNATf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:35 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:50 2009
Message-Id: <20090314000750.294401297@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Mark McLoughlin <markmc@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 74/96] xen: disable interrupts early, as start_kernel expects
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=xen-disable-interrupts-early-as-start_kernel-expects.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeremy Fitzhardinge <jeremy@goop.org>

commit 55d8085671863fe4ee6a17b7814bd38180a44e1d upstream.

This avoids a lockdep warning from:
	if (DEBUG_LOCKS_WARN_ON(unlikely(!early_boot_irqs_enabled)))
		return;
in trace_hardirqs_on_caller();

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Mark McLoughlin <markmc@redhat.com>
Cc: Xen-devel <xen-devel@lists.xensource.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/enlighten.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1707,6 +1707,9 @@ asmlinkage void __init xen_start_kernel(
 	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
 
+	local_irq_disable();
+	early_boot_irqs_off();
+
 	xen_raw_console_write("mapping kernel into physical memory\n");
 	pgd = xen_setup_kernel_pagetable(pgd, xen_start_info->nr_pages);
 


