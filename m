Return-Path: <linux-kernel-owner+w=401wt.eu-S970524AbXILRGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970524AbXILRGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970457AbXILRGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:06:39 -0400
Received: from www.osadl.org ([213.239.205.134]:36436 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S970451AbXILRGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:06:38 -0400
Subject: Re: Lossy interrupts on x86_64
From: Thomas Gleixner <tglx@linutronix.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200709120929.52217.jbarnes@virtuousgeek.org>
References: <200709120833.15980.jbarnes@virtuousgeek.org>
	 <20070912090151.97c9a78e.randy.dunlap@oracle.com>
	 <200709120929.52217.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Wed, 12 Sep 2007 19:06:35 +0200
Message-Id: <1189616795.4302.1.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-12 at 09:29 -0700, Jesse Barnes wrote:
> On Wednesday, September 12, 2007, Randy Dunlap wrote:
> > On Wed, 12 Sep 2007 08:33:15 -0700 Jesse Barnes wrote:
> > > I just narrowed down a weird problem where I was losing more than
> > > 50% of my vblank interrupts to what seems to be the hires timers
> > > patch.  Stock 2.6.23-rc5 works fine, but the latest (171) kernel
> > > from rawhide drops most of my interrupts unless I also have another
> > > interrupt source running (e.g. if I hold down a key or move the
> > > mouse I get the expected number of vblank interrupts, otherwise I
> > > get between 3 and 30 instead of the expected 60 per second).
> > >
> > > Any ideas?  It seems like it might be bad APIC programming, but I
> > > haven't gone through those mods to look for suspects...
> >
> > Also tickless?  (NO_HZ ?)
> >
> > I think I've seen some emails about tickless and keystrokes being
> > needed to cause interrupts... but I'm not postive about it.

That's a suspend / resume problem which we are hunting.

> > but you said "any ideas"
> 
> Yeah, there's NO_HZ in the rawhide kernel too, but I'm getting timer
> ticks normally afaict, it's just vblank interrupts that get lost...

Jesse,

does it make any difference when you boot the box with:

nohz=off

on the kernel command line ?

	tglx


