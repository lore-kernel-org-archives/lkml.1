Return-Path: <linux-kernel-owner+w=401wt.eu-S936165AbXJSSCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936165AbXJSSCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757607AbXJSSCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:02:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757563AbXJSSCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:02:14 -0400
Date: Fri, 19 Oct 2007 11:00:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org, Paul Sokolovsky <pmiscml@gmail.com>,
       Ben Dooks <ben@trinity.fluff.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] [PATCH -mm] ASIC3 driver
Message-Id: <20071019110034.1534bb86.akpm@linux-foundation.org>
In-Reply-To: <20071019105258.GA15170@caravaggio>
References: <20071018091239.GA11360@caravaggio>
	<20071018150544.6852d5c9.akpm@linux-foundation.org>
	<20071019105258.GA15170@caravaggio>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 12:53:00 +0200 Samuel Ortiz <sameo@openedhand.com> wrote:

> On Thu, Oct 18, 2007 at 03:05:44PM -0700, Andrew Morton wrote:
> > On Thu, 18 Oct 2007 11:12:41 +0200
> > Samuel Ortiz <sameo@openedhand.com> wrote:
> 
> > > +#include <linux/module.h>
> > > +#include <linux/version.h>
> > > +#include <linux/irq.h>
> > 
> > Please see the large comment at the top of linux/irq.h.  I believe this
> > driver will fial to compile on at least arm.
> It doesn't build as a module, since we need the irq.h symbols.
> I changed MFD_ASIC3 to bool. I somehow feel that this is not the cleanest
> solution, but OTOH I think that dynamically adding IRQs and GPIOs to an
> embedded board doesn't make much sense.

We seem to have miscommunicated here.  <linux/irq.h> contains references to
things which only some architectures actually implement.  I don't know
which architectures those are, but it includes common ones like x86, so
it's a real trap.  I recall it does not include arm, so your code might
break on arm.

At least, that's what's _supposed_ to happen: I just compiled and linked
this driver into an ARM kernel with no problems so now I'm all confused as
to what the problem was.

Oh well, we'll see...
