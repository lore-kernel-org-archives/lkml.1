Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbYGTPFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbYGTPFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 11:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbYGTPFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 11:05:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35132 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbYGTPFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 11:05:12 -0400
Date: Sun, 20 Jul 2008 17:04:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Zachary Amsden <zach@vmware.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Message-ID: <20080720150444.GA4225@elte.hu>
References: <Pine.LNX.4.55.0807182254270.12125@cliff.in.clinika.pl> <1216420937.30348.30.camel@bodhitayantram.eng.vmware.com> <20080718224922.GB4507@linux-os.sc.intel.com> <86802c440807181551l7e6e143dy7cea8ab59f1830ed@mail.gmail.com> <20080718230012.GD4507@linux-os.sc.intel.com> <86802c440807181604y502e7deal98abfeb1ceee769d@mail.gmail.com> <20080718231828.GE4507@linux-os.sc.intel.com> <20080719214944.GC836@elte.hu> <20080719215325.GA12737@elte.hu> <20080720120811.GA16138@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080720120811.GA16138@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> i've merged tip/x86/x2apic into tip/master, and it seems to be working 
> fine. One UP build fix was needed for Xen, see below.

and a similar one for UP lguest.

	Ingo

---------------->
commit 7be42004065ce4df193aeef5befd26805267d0d9
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sun Jul 20 17:04:57 2008 +0200

    x86, lguest: fix apic_ops build on UP
    
    fix:
    
      arch/x86/lguest/boot.c:816: error: variable ‘lguest_basic_apic_ops’ has initializer but incomplete type
      arch/x86/lguest/boot.c:817: error: unknown field ‘read’ specified in initializer
     [...]
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lguest/boot.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 35c4349..756fc48 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -55,6 +55,7 @@
 #include <linux/lguest_launcher.h>
 #include <linux/virtio_console.h>
 #include <linux/pm.h>
+#include <asm/apic.h>
 #include <asm/lguest.h>
 #include <asm/paravirt.h>
 #include <asm/param.h>
