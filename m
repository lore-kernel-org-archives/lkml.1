Return-Path: <linux-kernel-owner+w=401wt.eu-S1757804AbZDNQ5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804AbZDNQ5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbZDNQ5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:57:09 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52029 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757086AbZDNQ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:57:08 -0400
Subject: Re: [PATCH 01/14] [VOYAGER] x86: add {safe,hard}_smp_processor_id
	to smp_ops
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <49E4BB61.1090008@goop.org>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
	 <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
	 <49E4BB61.1090008@goop.org>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 16:57:08 +0000
Message-Id: <1239728228.3357.58.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 09:35 -0700, Jeremy Fitzhardinge wrote:
> James Bottomley wrote:
> > Not having apics, Voyager can't use the default apic implementation of
> > these, it has to read from a special port in the VIC to get the
> > processor ID, so abstract these functions in smp_ops to allow voyager
> > to live simultaneously with the apic code.
> >   
> 
> I thnk we should just drop safe_smp_processor_id().  It doesn't seem to 
> do anything useful.

OK ... I don't think it does anything either.  It was introduced by
VMware a long time ago if I remember correctly ... something to do with
the way we get the ID in the boot sequence, but I've forgotten the
details.

I can eliminate it as a separate precursor patch to this.

> > diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> > index 429834e..eb795bf 100644
> > --- a/arch/x86/xen/smp.c
> > +++ b/arch/x86/xen/smp.c
> > @@ -454,6 +454,11 @@ static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
> >  	return IRQ_HANDLED;
> >  }
> >  
> > +static int xen_hard_smp_processor_id(void)
> > +{
> > +	return read_apic_id();
> > +}
> >   
> 
> This should just be "return smp_processor_id()".  There are no 
> meaningful APICs under Xen.

OK, will reroll.

James


