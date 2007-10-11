Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbXJKPIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbXJKPIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbXJKPIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:08:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59819 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753406AbXJKPIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:08:10 -0400
Date: Thu, 11 Oct 2007 16:11:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Egger <Christoph.Egger@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: mce init optimization and signedness fixup
Message-ID: <20071011161157.5a32122e@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.9999.0710111651350.15917@localhost.localdomain>
References: <11921050742274-git-send-email-joerg.roedel@amd.com>
	<1192105075473-git-send-email-joerg.roedel@amd.com>
	<alpine.LFD.0.9999.0710111550400.15917@localhost.localdomain>
	<200710111601.02630.Christoph.Egger@amd.com>
	<alpine.LFD.0.9999.0710111651350.15917@localhost.localdomain>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 16:55:36 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 11 Oct 2007, Christoph Egger wrote:
> 
> > On Thursday 11 October 2007 15:51:49 Thomas Gleixner wrote:
> > > On Thu, 11 Oct 2007, Joerg Roedel wrote:
> > > > MCG_CAP never reports a negative count of available error-reporting
> > > > banks. Therefore, make nr_mce_banks unsigned.
> > > > Check for MCA/MCE feature bits as early as possible.
> > > >
> > > > +
> > > > +	if (!cpu_has(c, X86_FEATURE_MCA) || !cpu_has(c, X86_FEATURE_MCE)) {
> > > > +		printk(KERN_INFO "CPU%i: No machine check support available\n",
> > > > +			smp_processor_id());
> > > > +		return;
> > >
> > > This breaks winchip MCE support.
> > 
> > First, what is a winchip? It sounds to be something windows specific. ;)
> > Second, can you explain in which way MCE support gets broken, please?
> 
> First, winchip is the code name of Centaurs early x86 cpus.
> 
> Second, those beasts do not have FEATURE_MCA, but they have FEATURE_MCE, 
> so they support the fatal exception, but not the non fatal check.

Ditto some of the original Intel Preventium processors which have limited
MC support hidden in the magic 'Appendix H'

Alan
