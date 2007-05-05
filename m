Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbXEEPYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbXEEPYs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbXEEPYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:24:48 -0400
Received: from www.osadl.org ([213.239.205.134]:42296 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753191AbXEEPYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:24:46 -0400
Subject: Re: [PATCH] Blacklist Dell Optiplex 320 from using the HPET
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Guilherme M. Schroeder" <guilherme@centralinf.com.br>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1178375214.31213.13.camel@localhost.localdomain>
References: <1178314144.6094.7.camel@localhost.localdomain>
	 <200705050118.34711.ak@suse.de>
	 <1178321228.6094.34.camel@localhost.localdomain>
	 <1178375214.31213.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 05 May 2007 16:30:35 +0200
Message-Id: <1178375435.31213.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guilherme,

please discard the previous patch. I missed to refresh it before sending
it out. Correct version below.

	tglx	

On Sat, 2007-05-05 at 16:26 +0200, Thomas Gleixner wrote:
> can you please undo John's patch and check whether the patch below works
> for you.

Index: linux-2.6.21/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.21.orig/arch/i386/kernel/hpet.c
+++ linux-2.6.21/arch/i386/kernel/hpet.c
@@ -231,6 +231,7 @@ int __init hpet_enable(void)
 {
 	unsigned long id;
 	uint64_t hpet_freq;
+	cycle_t t1;
 	u64 tmp;
 
 	if (!is_hpet_capable())
@@ -278,6 +279,14 @@ int __init hpet_enable(void)
 	/* Start the counter */
 	hpet_start_counter();
 
+	/* Verify whether hpet counter works */
+	t1 = read_hpet();
+	udelay(50);
+	if (t1 == read_hpet()) {
+		printk(KERN_WARNING "HPET counter is defect\n");
+		goto out_nohpet;
+	}
+
 	/* Initialize and register HPET clocksource
 	 *
 	 * hpet period is in femto seconds per cycle


