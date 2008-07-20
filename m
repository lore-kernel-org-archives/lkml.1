Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYGTMIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYGTMIv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 08:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbYGTMIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 08:08:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60890 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755955AbYGTMIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 08:08:42 -0400
Date: Sun, 20 Jul 2008 14:08:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Zachary Amsden <zach@vmware.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Message-ID: <20080720120811.GA16138@elte.hu>
References: <86802c440807181413n7e79e821l90afaae86b322de9@mail.gmail.com> <Pine.LNX.4.55.0807182254270.12125@cliff.in.clinika.pl> <1216420937.30348.30.camel@bodhitayantram.eng.vmware.com> <20080718224922.GB4507@linux-os.sc.intel.com> <86802c440807181551l7e6e143dy7cea8ab59f1830ed@mail.gmail.com> <20080718230012.GD4507@linux-os.sc.intel.com> <86802c440807181604y502e7deal98abfeb1ceee769d@mail.gmail.com> <20080718231828.GE4507@linux-os.sc.intel.com> <20080719214944.GC836@elte.hu> <20080719215325.GA12737@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080719215325.GA12737@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i've merged tip/x86/x2apic into tip/master, and it seems to be working 
fine. One UP build fix was needed for Xen, see below.

	Ingo

-------------------------->
commit caf43bf7c6a55e89b6df5179df434d67e24aa32e
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sun Jul 20 14:06:50 2008 +0200

    x86, xen: fix apic_ops build on UP
    
    fix:
    
     arch/x86/xen/enlighten.c:615: error: variable ‘xen_basic_apic_ops’ has initializer but incomplete type
     arch/x86/xen/enlighten.c:616: error: unknown field ‘read’ specified in initializer
     [...]
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/xen/enlighten.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 008b7b6..e4d1459 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -35,6 +35,7 @@
 #include <xen/page.h>
 
 #include <asm/paravirt.h>
+#include <asm/apic.h>
 #include <asm/page.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
