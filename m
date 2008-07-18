Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbYGRHRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbYGRHRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 03:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYGRHRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 03:17:39 -0400
Received: from mail.crca.org.au ([67.207.131.56]:50591 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbYGRHRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 03:17:38 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [Bug #11035] System hangs on 2.6.26-rc8
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roman Mindalev <lists@r000n.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <20080718071121.GB6875@elte.hu>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
	 <uBi7uNfg81L.A.xt.SzLcIB@albercik> <4878D259.7050403@r000n.net>
	 <487CA8E5.8020208@r000n.net>  <20080718071121.GB6875@elte.hu>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Fri, 18 Jul 2008 17:17:32 +1000
Message-Id: <1216365452.26544.22.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2008-07-18 at 09:11 +0200, Ingo Molnar wrote:
> * Roman Mindalev <lists@r000n.net> wrote:
> 
> > I done bisection.
> > Result below:
> > 
> > 8f46924600e30b140445f5b84abe9b80d2fff5fb is first bad commit
> > commit 8f46924600e30b140445f5b84abe9b80d2fff5fb
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Wed Jan 30 13:34:09 2008 +0100
> > 
> >     x86: enable CONFIG_DEBUG_PAGEALLOC more widely
> > 
> >     make CONFIG_DEBUG_PAGEALLOC universally available.
> > 
> >     CONFIG_HIBERNATION and CONFIG_HUGETLBFS was disabling it, for no
> >     particular reason.
> 
> as far as i can see you see a lockup under certain circumstances, right?
> 
> this debug option catches use-after-free and other types of invalid 
> memory accesses. When it catches a bug the kernel most likely crashes 
> and produces a backlog. Because you are in graphical mode that is not 
> visible.
> 
> This would possibly be debuggable if you set up netconsole logging to 
> another system on a local LAN - see 
> Documentation/networking/netconsole.txt.
> 
> Vegard - would it be possible to make DEBUG_PAGEALLOC faults single-shot 
> and non-fatal, just like kmemcheck does it? That way people would see a 
> nice kernel message instead of an immediate crash. That means we'd have 
> to find a reliable filter for DEBUG_PAGEALLOC-provoked pagefaults though 
> ...

Not that it matters now, but that original commit message was wrong -
CONFIG_HIBERNATION used to be incompatible with CONFIG_DEBUG_PAGEALLOC
because [u]swsusp didn't (until very recently) handle the fact that
DEBUG_SLAB unmaps empty pages on x86.

Regards,

Nigel

