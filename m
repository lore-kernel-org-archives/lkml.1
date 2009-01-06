Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbZAFQ1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbZAFQ1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbZAFQ1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:27:44 -0500
Received: from relay3.sgi.com ([192.48.171.31]:48082 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750846AbZAFQ1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:27:43 -0500
Date: Tue, 6 Jan 2009 10:27:41 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-ia64@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
       Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>,
       Tony Luck <tony.luck@gmail.com>, Robin Holt <holt@sgi.com>
Subject: [PATCH] configure HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN systems
Message-ID: <20090106162741.GA7991@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn on CONFIG_HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN.

SGI Altix has unsynchronized itc clocks.  This results in rq->clock
occasionally being set to a time in the past by a remote cpu.

Note that it is possible that this problem may exist for other ia64
machines as well, based on the following comment for sched_clock() in
arch/ia64/kernel/head.S:

 * Return a CPU-local timestamp in nano-seconds.  This timestamp is
 * NOT synchronized across CPUs its return value must never be
 * compared against the values returned on another CPU.  The usage in
 * kernel/sched.c ensures that.


Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

Greg, if everyone is OK with this patch, this should also be applied
to all stable trees starting with 2.6.26.

 arch/ia64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/arch/ia64/Kconfig
===================================================================
--- linux-2.6.orig/arch/ia64/Kconfig	2009-01-06 10:13:13.051918923 -0600
+++ linux-2.6/arch/ia64/Kconfig	2009-01-06 10:13:44.547856328 -0600
@@ -536,6 +536,7 @@ config IA64_MC_ERR_INJECT
 
 config SGI_SN
 	def_bool y if (IA64_SGI_SN2 || IA64_GENERIC)
+	select HAVE_UNSTABLE_SCHED_CLOCK
 
 config IA64_ESI
 	bool "ESI (Extensible SAL Interface) support"
