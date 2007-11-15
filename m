Return-Path: <linux-kernel-owner+w=401wt.eu-S1764743AbXKOQPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764743AbXKOQPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758611AbXKOQPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:15:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34829 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012AbXKOQPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:15:15 -0500
Date: Thu, 15 Nov 2007 17:05:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Paul E McKenney <paulmck@us.ibm.com>,
       Richard Gooch <rgooch@atnf.csiro.au>,
       Tigran Aivazian <tigran@aivazian.fs.co.uk>,
       Shoahua Li <shaohua.li@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nathan Lynch <ntl@pobox.com>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC PATCH 1/3] cpu-hotplug: Refcount Based Cpu Hotplug
	implementation
Message-ID: <20071115160520.GA3969@elte.hu>
References: <20071115134924.GA15282@in.ibm.com> <20071115135108.GA15462@in.ibm.com> <20071115141501.GB28857@elte.hu> <20071115152558.GA22599@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115152558.GA22599@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> FYI, i've put these 3 patches into the scheduler git tree and it's 
> looking very good so far. So unless Andrew or Linus objects to put 
> this into v2.6.24, or there's serious questions during review, could 
> we merge it this way?

i've got this trivial build fix for !SMP - otherwise it's still looking 
good.

	Ingo

------------------>
Subject: cpu hotplug: fix build on !CONFIG_SMP
From: Ingo Molnar <mingo@elte.hu>

fix build on !CONFIG_SMP.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/cpu.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux/include/linux/cpu.h
===================================================================
--- linux.orig/include/linux/cpu.h
+++ linux/include/linux/cpu.h
@@ -71,19 +71,25 @@ static inline void unregister_cpu_notifi
 
 int cpu_up(unsigned int cpu);
 
+extern void cpu_hotplug_init(void);
+
 #else
 
 static inline int register_cpu_notifier(struct notifier_block *nb)
 {
 	return 0;
 }
+
 static inline void unregister_cpu_notifier(struct notifier_block *nb)
 {
 }
 
+static inline void cpu_hotplug_init(void)
+{
+}
+
 #endif /* CONFIG_SMP */
 extern struct sysdev_class cpu_sysdev_class;
-extern void cpu_hotplug_init(void);
 extern void cpu_maps_update_begin(void);
 extern void cpu_maps_update_done(void);
 
