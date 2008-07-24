Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbYGXAJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbYGXAJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYGXAJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:09:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40723 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYGXAJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:09:37 -0400
Date: Wed, 23 Jul 2008 17:06:46 -0700
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: usb debug port early console v2
Message-ID: <20080724000646.GA31214@kroah.com>
References: <200807231252.20371.yhlu.kernel@gmail.com> <200807231400.53957.yhlu.kernel@gmail.com> <20080723224533.GA29234@kroah.com> <86802c440807231554g4fc4f981j5f9a8db9ab51fe93@mail.gmail.com> <20080723232142.GD30234@kroah.com> <86802c440807231646t11313612x4107c2c780d2b0f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807231646t11313612x4107c2c780d2b0f9@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 04:46:36PM -0700, Yinghai Lu wrote:
> On Wed, Jul 23, 2008 at 4:21 PM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Jul 23, 2008 at 03:54:09PM -0700, Yinghai Lu wrote:
> >> On Wed, Jul 23, 2008 at 3:45 PM, Greg KH <greg@kroah.com> wrote:
> >> > On Wed, Jul 23, 2008 at 02:00:53PM -0700, Yinghai Lu wrote:
> >> >> --- linux-2.6.orig/drivers/usb/host/ehci.h
> >> >> +++ linux-2.6/drivers/usb/host/ehci.h
> >> >
> >> > I don't understand the issue of any of these #ifdefs here.  Why are they
> >> > needed?
> >>
> >> In file included from arch/x86/kernel/early_printk.c:19:
> >> arch/x86/kernel/../../../drivers/usb/host/ehci.h:109: error: field
> >> 'iaa_watchdog' has incomplete type
> >
> > Ah, so you are papering over the real problem here, right?
> >
> > Why not just include the properly needed #includes either where you are
> > including this header file, or add the dependancies to the ehci.h file
> > itself (which is usually preferred.)
> 
> how about moving
> 
> struct ehci_caps;
> struct ehci_regs;
> struct ehci_dbg_port;
> 
> to one header file in include/usb
> so could use
> #include <linux/usb/ehci_def.h>
> instead of
> #include "../../../drivers/usb/host/ehci.h"

Sure, feel free to do that instead, that makes more sense.

> >> > And shouldn't there be a separate config option for early printk through
> >> > the ehci debug port?
> >>
> >> under usb or processor?
> >
> > Somewhere.
> >
> > Also, usb patches should be cc:ed to the linux-usb mailing list.  I'm
> > sure the EHCI authors would like to comment on this patch...
> 
> oh, i thought you wrote the ehci code.

Heh, no.

thanks,

greg k-h
