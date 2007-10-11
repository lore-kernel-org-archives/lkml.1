Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbXJKQua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbXJKQua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 12:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbXJKQuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 12:50:22 -0400
Received: from www.tglx.de ([62.245.132.106]:59535 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbXJKQuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 12:50:21 -0400
Date: Thu, 11 Oct 2007 18:50:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Egger <Christoph.Egger@amd.com>
cc: Joerg Roedel <joerg.roedel@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: mce init optimization and signedness fixup
In-Reply-To: <200710111703.35129.Christoph.Egger@amd.com>
Message-ID: <alpine.LFD.0.9999.0710111844000.15917@localhost.localdomain>
References: <11921050742274-git-send-email-joerg.roedel@amd.com> <200710111601.02630.Christoph.Egger@amd.com> <alpine.LFD.0.9999.0710111651350.15917@localhost.localdomain> <200710111703.35129.Christoph.Egger@amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007, Christoph Egger wrote:
> On Thursday 11 October 2007 16:55:36 Thomas Gleixner wrote:
> > > > > +
> > > > > +	if (!cpu_has(c, X86_FEATURE_MCA) || !cpu_has(c, X86_FEATURE_MCE)) {
> > > > > +		printk(KERN_INFO "CPU%i: No machine check support available\n",
> > > > > +			smp_processor_id());
> > > > > +		return;
> > > >
> > > > This breaks winchip MCE support.
> > >
> > > First, what is a winchip? It sounds to be something windows specific. ;)
> > > Second, can you explain in which way MCE support gets broken, please?
> >
> > First, winchip is the code name of Centaurs early x86 cpus.
> >
> > Second, those beasts do not have FEATURE_MCA, but they have FEATURE_MCE,
> > so they support the fatal exception, but not the non fatal check.
> 
> So when I change the above code snippet to:
> 
> +	if (!cpu_has(c, X86_FEATURE_MCE)) {
> +		printk(KERN_INFO "CPU%i: No machine check support available\n",
> +			smp_processor_id());
> +		return;
> 
> Would this make the whole patch acceptable then?

Yeah, but then we can clean up the extra checks for _MCE in the various 
cpu type init functions as well.

	tglx
