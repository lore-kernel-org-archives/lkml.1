Return-Path: <linux-kernel-owner+w=401wt.eu-S1030598AbXBFXo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030598AbXBFXo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030599AbXBFXo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:44:28 -0500
Received: from www.osadl.org ([213.239.205.134]:38215 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030598AbXBFXo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:44:27 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Thomas Gleixner <tglx@linutronix.de>
To: dwalker@mvista.com
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1170804903.3455.121.camel@dwalker1>
References: <20070206210959.GC25430@elte.hu>
	 <1170796999.3455.43.camel@dwalker1> <20070206214131.GA1176@elte.hu>
	 <1170798879.3455.58.camel@dwalker1> <20070206220855.GB5109@elte.hu>
	 <1170801742.3455.87.camel@dwalker1> <20070206225650.GA14853@elte.hu>
	 <1170803070.3455.93.camel@dwalker1> <20070206231421.GA18654@elte.hu>
	 <1170804177.3455.109.camel@dwalker1>  <20070206232828.GA21969@elte.hu>
	 <1170804903.3455.121.camel@dwalker1>
Content-Type: text/plain
Date: Wed, 07 Feb 2007 00:44:37 +0100
Message-Id: <1170805477.3785.63.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 15:35 -0800, Daniel Walker wrote:
> Last and final correction. I'm saying drop the timer entry, which means
> drop the call to request_irq() for irq0.

Right, that's a real good suggestion. Here's the patch especially for
you. Apply it and figure out yourself, why your computer won't boot
anymore.

	tglx


Index: linux-2.6.20/arch/i386/mach-default/setup.c
===================================================================
--- linux-2.6.20.orig/arch/i386/mach-default/setup.c
+++ linux-2.6.20/arch/i386/mach-default/setup.c
@@ -95,8 +95,10 @@ static struct irqaction irq0  = {
  **/
 void __init time_init_hook(void)
 {
+#ifdef CONFIG_THIS_IS_NOT_DWALKERS_COMPUTER
 	irq0.mask = cpumask_of_cpu(0);
 	setup_irq(0, &irq0);
+#endif
 }
 
 #ifdef CONFIG_MCA


