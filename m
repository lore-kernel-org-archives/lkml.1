Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbYCUSDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbYCUSDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbYCUSDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:03:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33793 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbYCUSDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:03:23 -0400
Date: Fri, 21 Mar 2008 19:06:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, andreas.herrmann3@amd.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/7] Readd rdmsrl_safe
Message-ID: <20080321180612.GK2346@one.firstfloor.org>
References: <20080312353.598285931@firstfloor.org> <20080312025331.B113B1B41D1@basil.firstfloor.org> <alpine.LFD.1.00.0803211756000.3781@apollo.tec.linutronix.de> <20080321171636.GE2346@one.firstfloor.org> <alpine.LFD.1.00.0803211857030.3781@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803211857030.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 06:58:08PM +0100, Thomas Gleixner wrote:
> On Fri, 21 Mar 2008, Andi Kleen wrote:
> 
> > On Fri, Mar 21, 2008 at 06:06:13PM +0100, Thomas Gleixner wrote:
> > > On Wed, 12 Mar 2008, Andi Kleen wrote:
> > > > RDMSR for 64bit values with exception handling.
> > > > 
> > > > Makes it easier to deal with 64bit valued MSRs. The old 64bit code
> > > > base had that too as checking_rdmsrl(), but it got dropped somehow. 
> > > 
> > > Yup, no users.
> > > 
> > > > +#define rdmsrl_safe(msr,p) \
> > > > +	({ int __err; *(p) = native_read_msr_safe(msr, &__err); __err; })
> > > > +
> > > 
> > > static inline please
> > 
> > Well all of paravirt.h uses macros. I did the same for consistency.
> 
> consistency ?

At least I consider it clean and consistent to use similar
style as the other code in that file for new code I add.

> 
> > If you want inlines it would be better to just convert it all in one
> > go (but please only after this patch was applied)
> 
> Of course. We don't want to burden work on your shoulders.

Well you signed up for the work yourself last year ;-) It was your choice.

-Andi
