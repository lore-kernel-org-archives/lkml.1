Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbXLKGKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbXLKGKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 01:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXLKGJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 01:09:58 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:50184 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbXLKGJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 01:09:58 -0500
Date: Tue, 11 Dec 2007 11:39:29 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
       lkml <linux-kernel@vger.kernel.org>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       davem@davemloft.net, hskinnemoen@atmel.com
Subject: Re: [PATCH 1/2] Kprobes: Indicate kretprobe support in arch/<arch>/Kconfig - updated
Message-ID: <20071211060929.GA9938@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20071210095221.GA19425@in.ibm.com> <20071210101307.GA14359@uranus.ravnborg.org> <20071210113249.GC8437@in.ibm.com> <20071210151001.GD2082@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210151001.GD2082@Krystal>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 10:10:01AM -0500, Mathieu Desnoyers wrote:
> * Ananth N Mavinakayanahalli (ananth@in.ibm.com) wrote:
> > On Mon, Dec 10, 2007 at 11:13:07AM +0100, Sam Ravnborg wrote:
> > > On Mon, Dec 10, 2007 at 03:22:22PM +0530, Ananth N Mavinakayanahalli wrote:
> > > > From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > > > 

<snip>

> > Index: linux-2.6.24-rc4/include/linux/kprobes.h
> > ===================================================================
> > --- linux-2.6.24-rc4.orig/include/linux/kprobes.h
> > +++ linux-2.6.24-rc4/include/linux/kprobes.h
> > @@ -125,11 +125,11 @@ struct jprobe {
> >  DECLARE_PER_CPU(struct kprobe *, current_kprobe);
> >  DECLARE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
> >  
> > -#ifdef ARCH_SUPPORTS_KRETPROBES
> > +#ifdef CONFIG_HAVE_KRETPROBES
> 
> Hi Ananth,
> 
> I just want to point out a detail: if someone sets CONFIG_KPROBES to n,
> the CONFIG_HAVE_KPROBES is still y, and so is CONFIG_HAVE_KRETPROBES.
> However, I doubt that you want to activate this code in this case ?
> The code paths are OK because they are nested into CONFIG_KPROBES
> ifdefs (or not built due to dependency on CONFIG_KPROBES in the
> Makfile), but if one wants to use CONFIG_HAVE_KRETPROBE for something
> else (Makefile), then it could become a problem.
> 
> Could we add a menu entry CONFIG_KRETPROBES that depends on
> CONFIG_HAVE_KRETPROBES and CONFIG_KPROBES, and also remove the
> CONFIG_HAVE_KPROBES dependency for the CONFIG_HAVE_KRETPROBE option ?
> This way, we would have much more flexibility (like specifiying if we
> want CONFIG_KRETPROBES to be default y or default n...)

Done... Updated patch coming up.

Ananth
