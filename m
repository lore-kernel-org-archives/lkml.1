Return-Path: <linux-kernel-owner+w=401wt.eu-S1760572AbYCUR6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572AbYCUR6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbYCUR63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:58:29 -0400
Received: from www.tglx.de ([62.245.132.106]:46693 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760140AbYCUR60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:58:26 -0400
Date: Fri, 21 Mar 2008 18:58:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: andreas.herrmann3@amd.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/7] Readd rdmsrl_safe
In-Reply-To: <20080321171636.GE2346@one.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0803211857030.3781@apollo.tec.linutronix.de>
References: <20080312353.598285931@firstfloor.org> <20080312025331.B113B1B41D1@basil.firstfloor.org> <alpine.LFD.1.00.0803211756000.3781@apollo.tec.linutronix.de> <20080321171636.GE2346@one.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Andi Kleen wrote:

> On Fri, Mar 21, 2008 at 06:06:13PM +0100, Thomas Gleixner wrote:
> > On Wed, 12 Mar 2008, Andi Kleen wrote:
> > > RDMSR for 64bit values with exception handling.
> > > 
> > > Makes it easier to deal with 64bit valued MSRs. The old 64bit code
> > > base had that too as checking_rdmsrl(), but it got dropped somehow. 
> > 
> > Yup, no users.
> > 
> > > +#define rdmsrl_safe(msr,p) \
> > > +	({ int __err; *(p) = native_read_msr_safe(msr, &__err); __err; })
> > > +
> > 
> > static inline please
> 
> Well all of paravirt.h uses macros. I did the same for consistency.

consistency ?

> If you want inlines it would be better to just convert it all in one
> go (but please only after this patch was applied)

Of course. We don't want to burden work on your shoulders.

Thanks

	tglx
