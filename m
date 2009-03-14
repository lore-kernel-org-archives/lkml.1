Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZCNAnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZCNAnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbZCNATp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:45 -0400
Received: from kroah.org ([198.145.64.141]:34925 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753822AbZCNATd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:50 2009
Message-Id: <20090314000749.947133489@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:20 -0700
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
       alan@lxorguk.ukuu.org.uk, Alok N Kataria <akataria@vmware.com>,
       Zachary Amsden <zach@vmware.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 72/96] x86, vmi: TSC going backwards check in vmi clocksource
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=x86-vmi-tsc-going-backwards-check-in-vmi-clocksource.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alok N Kataria <akataria@vmware.com>

commit 48ffc70b675aa7798a52a2e92e20f6cce9140b3d upstream.

Impact: fix time warps under vmware

Similar to the check for TSC going backwards in the TSC clocksource,
we also need this check for VMI clocksource.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: Zachary Amsden <zach@vmware.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/vmiclock_32.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -280,10 +280,13 @@ void __devinit vmi_time_ap_init(void)
 #endif
 
 /** vmi clocksource */
+static struct clocksource clocksource_vmi;
 
 static cycle_t read_real_cycles(void)
 {
-	return vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
+	cycle_t ret = (cycle_t)vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
+	return ret >= clocksource_vmi.cycle_last ?
+		ret : clocksource_vmi.cycle_last;
 }
 
 static struct clocksource clocksource_vmi = {


