Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887Ab0ALAIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0ALAIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340Ab0ALAIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:08:10 -0500
Received: from mga14.intel.com ([143.182.124.37]:62800 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab0ALAIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:08:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="231609596"
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR
 instead of 0x1f
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B4BB0B7.3000106@zytor.com>
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>
	 <4B47E7A9.6090904@zytor.com>
	 <1263250418.2859.681.camel@sbs-t61.sc.intel.com>
	 <4B4BACCA.2040805@zytor.com> <m1tyus8chc.fsf@fess.ebiederm.org>
	 <4B4BB0B7.3000106@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 11 Jan 2010 16:06:47 -0800
Message-Id: <1263254812.2859.890.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 15:13 -0800, H. Peter Anvin wrote:
> On 01/11/2010 03:10 PM, Eric W. Biederman wrote:
> > "H. Peter Anvin" <hpa@zytor.com> writes:
> > 
> >> On 01/11/2010 02:53 PM, Suresh Siddha wrote:
> >>>
> >>>> However, my most serious concern with this patch is that there is a
> >>>> fairly significant change due to this patch, which is that the legacy
> >>>> IRQ vectors now fall *inside* the FIRST_DEVICE_VECTOR range.  This isn't
> >>>> a bad thing -- in fact, it is fundamentally the right thing to do
> >>>> especially once we consider platforms which *don't* have the legacy IRQs
> >>>> -- but it makes me scared of unexpected behavior changes as a result.
> >>>> If you feel confident that that is not the case, could you outline why
> >>>> it shouldn't be a problem?
> >>>
> >>> In irqinit.c, we statically pre-assign the per-cpu vector to irq
> >>> mappings (vector_irq) for all the legacy IRQ vectors. Similarly irq_cfg
> >>> is statically initialized for legacy IRQ's in io_apic.c. So we won't be
> >>> able to use this space for anything else.
> >>>
> >>
> >> What enforces that, though?  The used_vector bitmap?  In the past it was
> >> enforced simply by being < FIRST_DEVICE_VECTOR.
> > 
> > I believe historically it was simply that we did not loop over that set of vectors,
> > in assign_irq_vector.
> > 
> 
> Yes, that's what I said.  My question was to Suresh what enforces that
> in the case of his patch, which moves the legacy range into the middle
> of the device vectors.

It's not the used_vector bitmap. That range will appear as used on all
the cpu's and hence we won't be allocating it for anything else.

Now the question is: for non-legacy (io-apic) case, instead of reserving
this range for all the cpu's, does it make sense to generalize like any
other vector?

thanks,
suresh

