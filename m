Return-Path: <linux-kernel-owner+w=401wt.eu-S937186AbXG2X0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937186AbXG2X0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 19:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935438AbXG2X0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 19:26:36 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:57541 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935375AbXG2X0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 19:26:35 -0400
Date: Mon, 30 Jul 2007 08:25:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net
Subject: Re: Fwd: [PATCH] Reboot Dreamcast under software control
Message-ID: <20070729232554.GA21913@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
References: <8b67d60707291104k64ba6e0dpf86a7604ce63ae8e@mail.gmail.com> <8b67d60707291125o5c78d87dq59c842a9dac3e521@mail.gmail.com> <20070729225024.GA8039@linux-sh.org> <1185750331.23949.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185750331.23949.16.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 12:05:31AM +0100, Adrian McMenamin wrote:
> On Mon, 2007-07-30 at 07:50 +0900, Paul Mundt wrote:
> > On Sun, Jul 29, 2007 at 07:25:21PM +0100, Adrian McMenamin wrote:
> > > diff --git a/arch/sh/kernel/process.c b/arch/sh/kernel/process.c
> > > index 6334a4c..6f5e9e4 100644
> > > --- a/arch/sh/kernel/process.c
> > > +++ b/arch/sh/kernel/process.c
> > > @@ -97,6 +97,11 @@ void cpu_idle(void)
> > > 
> > >  void machine_restart(char * __unused)
> > >  {
> > > +
> > > +#ifdef CONFIG_SH_DREAMCAST
> > > +       /*reboot the Dreamcast under software control*/
> > > +       writel(0x00007611, 0xA05F6890);
> > > +#endif
> > >         /* SR.BL=1 and invoke address error to let CPU reset (manual reset) */
> > >         asm volatile("ldc %0, sr\n\t"
> > >                      "mov.l @%1, %0" : : "r" (0x10000000), "r" (0x80000001));
> > 
> > No, if you want to do this, at least use a function pointer and leave
> > this as the default implementation. The dreamcast presumably only needs
> > this magic write anyways, rather than the SR.BL trick.
> > 
> 
> Well, when I tested it, it did have a "return" in after the call and it
> worked - but I took that out as it looked like code bloat to me :)
> 
> Explain what you mean by using a function pointer and I'll do that.
> 
Look at the other implementations that are overloaded by the boards.
machine_power_off, the idle loop, etc.
