Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbYFIRz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbYFIRz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 13:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYFIRzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 13:55:20 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:43547 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753475AbYFIRzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 13:55:20 -0400
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Daniel Hecht <dhecht@vmware.com>, Tim Mann <mann@vmware.com>,
       Zach Amsden <zach@vmware.com>, Sahil Rihan <srihan@vmware.com>
In-Reply-To: <20080609131136.GA27588@elte.hu>
References: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080609131136.GA27588@elte.hu>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 09 Jun 2008 10:55:16 -0700
Message-Id: <1213034116.24546.10.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-09 at 06:11 -0700, Ingo Molnar wrote:
> * Alok Kataria <akataria@vmware.com> wrote:
> 
> > --- linux-2.6.orig/arch/x86/kernel/tsc_32.c   2008-05-27 12:28:16.000000000 -0700
> > +++ linux-2.6/arch/x86/kernel/tsc_32.c        2008-06-03 17:28:46.000000000 -0700
> > @@ -401,6 +401,7 @@
> >  void __init tsc_init(void)
> >  {
> >       int cpu;
> > +     u64 lpj;
> >
> >       if (!cpu_has_tsc || tsc_disabled) {
> >               /* Disable the TSC in case of !cpu_has_tsc */
> > @@ -421,6 +422,10 @@
> >               return;
> >       }
> >
> > +     lpj = ((u64)cpu_khz * 1000);
> > +     do_div(lpj, HZ);
> > +     lpj_tsc = lpj;
> 
> that wont work very well as lpj_tsc is not declared.

lpj_tsc is declared in include/linux/delay.h, and that declaration is
available in tsc_32.c 

I compile tested against current git too and seems fine to me. 

Also this patch is not to be applied to any tree yet, i will make a
different patch which calculates lpj_tsc from tsc_khz instead and use it
only for the boor processor. 
There were some concerns from Arjan and Pavel regarding cpu frequency
being different on different cpus. I was waiting to hear back from them
before sending a new patch.

Let me know your comments on my questions/suggestions from the earlier
post
http://marc.info/?l=linux-kernel&m=121269125317375&w=2


Thanks,
Alok


> 
>         Ingo

