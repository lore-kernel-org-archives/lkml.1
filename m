Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbZGKOKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbZGKOKW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 10:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZGKOKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 10:10:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45004 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751416AbZGKOKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 10:10:11 -0400
Date: Sat, 11 Jul 2009 15:10:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cleanups] x86/cpu: Clean up various files a bit
Message-ID: <20090711151028.368ffe24@lxorguk.ukuu.org.uk>
In-Reply-To: <1247310026.3032.17.camel@hpdv5.satnam>
References: <new-submission>
	<tip-8bdbd962ecfcbdd96f9dbb02d780b4553afd2543@git.kernel.org>
	<1247310026.3032.17.camel@hpdv5.satnam>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > No code changes except printk levels (although some of the K6
> > mtrr code might be clearer if there were a few as would
> > splitting out some of the intel cache code).
> > -#include <asm/io.h>
> > +#include <linux/io.h>
> 
> linux/io.h should move to linux/XXX.h block

That would be a code change and potentially a behaviour change - it
should be done but as a later patch. It doesn't help that checkpatch is
buggy here and thinks some stuff is the same which is not.


> >  #if !defined(CONFIG_SMP)
> > -	printk("CPU: ");
> > +	printk(KERN_INFO "CPU: ");
> >  	print_cpu_info(&boot_cpu_data);
> >  #endif
> >  	alternative_instructions();
> 
> I think, these was left intentionally otherwise dmesg output looks
> weird.

Curious. If it is meant to be a continuation it should be KERN_CONT but
that doesn't seem to be the case. No KERN_ is wrong, always.

> >  	 * All current models of Pentium and Pentium with MMX technology CPUs
> > -	 * have the F0 0F bug, which lets nonprivileged users lock up the system.
> > +	 * have the F0 0F bug, which lets nonprivileged users lock up the
> > +	 * system.
> 
> It should be non-privileged

Yes - I agree (or better yet unprivileged)

