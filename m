Return-Path: <linux-kernel-owner+w=401wt.eu-S1751165AbXC1Qmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbXC1Qmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 12:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXC1Qmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 12:42:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:5750 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbXC1Qmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 12:42:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,341,1170662400"; 
   d="scan'208"; a="204367781:sNHT431447345"
Date: Wed, 28 Mar 2007 09:42:00 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       davej@codemonkey.org.uk, johnstul@us.ibm.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] Add support for deferrable timers (respun)
Message-ID: <20070328164200.GA27711@linux-os.sc.intel.com>
References: <200703212353.l2LNrNOj007453@shell0.pdx.osdl.net> <20070322140532.GA120@tv-sign.ru> <20070322151817.GA29840@linux-os.sc.intel.com> <20070322161355.GA160@tv-sign.ru> <20070327204344.GA21529@linux-os.sc.intel.com> <p734po54og4.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p734po54og4.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 01:06:35PM +0200, Andi Kleen wrote:
> Venki Pallipadi <venkatesh.pallipadi@intel.com> writes:
> > +++ new/kernel/timer.c	2007-03-26 15:19:35.000000000 -0800
> > @@ -74,7 +74,7 @@
> >  	tvec_t tv3;
> >  	tvec_t tv4;
> >  	tvec_t tv5;
> > -} ____cacheline_aligned_in_smp;
> > +} ____cacheline_aligned;
> 
> Why this change?  It should be aligned to 2 bytes anyways.

Just wanted to be cautious of all archs and all compilers.
 
> >  static DEFINE_PER_CPU(tvec_base_t *, tvec_bases) = &boot_tvec_bases;
> >  
> > +/*
> > + * The lowest bit of base ptr in timer is used as a flag to indicate
> > + * 'deferrable' nature of the timer. Functions below help us manage that flag.
> > + */
> > +static inline unsigned int tbase_get_deferrable(struct tvec_t_base_s *base)
> > +{
> > +	return ((unsigned int)base & TBASE_DEFERRABLE_FLAG);
> 
> This will warn on 64bit for cast ptr -> int

OK. Will change this to ptr->long->int in the update patch.

Thanks,
Venki
