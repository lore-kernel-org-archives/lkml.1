Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab0BBLQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 06:16:01 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49932 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab0BBLP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 06:15:59 -0500
Date: Tue, 2 Feb 2010 20:15:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100202111552.GA9325@linux-sh.org>
References: <20100202063904.GK13428@linux-sh.org> <1265108739.12634.38.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265108739.12634.38.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 11:05:39AM +0000, Catalin Marinas wrote:
> On Tue, 2010-02-02 at 06:39 +0000, Paul Mundt wrote:
> > On Mon, Feb 01, 2010 at 05:29:14PM +0000, Catalin Marinas wrote:
> > > diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
> > > index 27b8f7c..4d3eeee 100644
> > > --- a/drivers/usb/host/isp1760-hcd.c
> > > +++ b/drivers/usb/host/isp1760-hcd.c
> > > @@ -18,6 +18,8 @@
> > >  #include <linux/uaccess.h>
> > >  #include <linux/io.h>
> > >  #include <asm/unaligned.h>
> > > +#include <asm/cacheflush.h>
> > > +#include <asm/memory.h>
> > 
> > asm/memory.h isn't a portable header. If you are including it for
> > virt_to_page(), linux/io.h should already bring that in via asm/io.h.
> > If arm doesn't bring in virt_to_page() through its asm/io.h, then fix the
> > headers there please.
> 
> In the ARM case, yes, it brings virt_to_page() but I'm not sure that's
> the case for the other architectures. I think a better header is
> linux/mm.h which already uses this function in virt_to_head_page().
> 
For some reason I was thinking virt_to_phys() instead of virt_to_page()
when I wrote that, so just ignore me. linux/mm.h is obviously fine.
