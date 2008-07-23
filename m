Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbYGWXYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbYGWXYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYGWXY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:24:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:55882 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYGWXY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:24:26 -0400
Date: Wed, 23 Jul 2008 16:21:42 -0700
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: usb debug port early console v2
Message-ID: <20080723232142.GD30234@kroah.com>
References: <200807231252.20371.yhlu.kernel@gmail.com> <200807231400.53957.yhlu.kernel@gmail.com> <20080723224533.GA29234@kroah.com> <86802c440807231554g4fc4f981j5f9a8db9ab51fe93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807231554g4fc4f981j5f9a8db9ab51fe93@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 03:54:09PM -0700, Yinghai Lu wrote:
> On Wed, Jul 23, 2008 at 3:45 PM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Jul 23, 2008 at 02:00:53PM -0700, Yinghai Lu wrote:
> >> --- linux-2.6.orig/drivers/usb/host/ehci.h
> >> +++ linux-2.6/drivers/usb/host/ehci.h
> >
> > I don't understand the issue of any of these #ifdefs here.  Why are they
> > needed?
> 
> In file included from arch/x86/kernel/early_printk.c:19:
> arch/x86/kernel/../../../drivers/usb/host/ehci.h:109: error: field
> 'iaa_watchdog' has incomplete type

Ah, so you are papering over the real problem here, right?

Why not just include the properly needed #includes either where you are
including this header file, or add the dependancies to the ehci.h file
itself (which is usually preferred.)

> > And shouldn't there be a separate config option for early printk through
> > the ehci debug port?
> 
> under usb or processor?

Somewhere.

Also, usb patches should be cc:ed to the linux-usb mailing list.  I'm
sure the EHCI authors would like to comment on this patch...

thanks,

greg k-h
