Return-Path: <linux-kernel-owner+w=401wt.eu-S936807AbXG2XGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936807AbXG2XGB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 19:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764400AbXG2XFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 19:05:53 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:13944 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762199AbXG2XFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 19:05:52 -0400
X-Trace: 10884031-mk-filter-1.mail.uk.tiscali.com-B2C-$THROTTLED-DYNAMIC-CUSTOMER-DYNAMIC-IP
X-SBRS: None
X-RemoteIP: 81.1.82.215
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=_TTNmgpoho0R1BgnMXAA:9 a=ul_MJ5LH-GY_T_MnrOwA:7 a=r_RWg8KAjKmMGY_ClZFKil_UiY0A:4
X-IronPort-AV: E=Sophos;i="4.19,196,1183330800"; 
   d="scan'208";a="10884031"
Subject: Re: Fwd: [PATCH] Reboot Dreamcast under software control
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net
In-Reply-To: <20070729225024.GA8039@linux-sh.org>
References: <8b67d60707291104k64ba6e0dpf86a7604ce63ae8e@mail.gmail.com>
	 <8b67d60707291125o5c78d87dq59c842a9dac3e521@mail.gmail.com>
	 <20070729225024.GA8039@linux-sh.org>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 00:05:31 +0100
Message-Id: <1185750331.23949.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 07:50 +0900, Paul Mundt wrote:
> On Sun, Jul 29, 2007 at 07:25:21PM +0100, Adrian McMenamin wrote:
> > diff --git a/arch/sh/kernel/process.c b/arch/sh/kernel/process.c
> > index 6334a4c..6f5e9e4 100644
> > --- a/arch/sh/kernel/process.c
> > +++ b/arch/sh/kernel/process.c
> > @@ -97,6 +97,11 @@ void cpu_idle(void)
> > 
> >  void machine_restart(char * __unused)
> >  {
> > +
> > +#ifdef CONFIG_SH_DREAMCAST
> > +       /*reboot the Dreamcast under software control*/
> > +       writel(0x00007611, 0xA05F6890);
> > +#endif
> >         /* SR.BL=1 and invoke address error to let CPU reset (manual reset) */
> >         asm volatile("ldc %0, sr\n\t"
> >                      "mov.l @%1, %0" : : "r" (0x10000000), "r" (0x80000001));
> 
> No, if you want to do this, at least use a function pointer and leave
> this as the default implementation. The dreamcast presumably only needs
> this magic write anyways, rather than the SR.BL trick.
> 

Well, when I tested it, it did have a "return" in after the call and it
worked - but I took that out as it looked like code bloat to me :)

Explain what you mean by using a function pointer and I'll do that.

Adrian
