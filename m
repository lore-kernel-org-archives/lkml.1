Return-Path: <linux-kernel-owner+w=401wt.eu-S1760233AbYCUROW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbYCUROW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758020AbYCURNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:13:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36760 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824AbYCURNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:13:50 -0400
Date: Fri, 21 Mar 2008 18:16:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, andreas.herrmann3@amd.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/7] Readd rdmsrl_safe
Message-ID: <20080321171636.GE2346@one.firstfloor.org>
References: <20080312353.598285931@firstfloor.org> <20080312025331.B113B1B41D1@basil.firstfloor.org> <alpine.LFD.1.00.0803211756000.3781@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803211756000.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 06:06:13PM +0100, Thomas Gleixner wrote:
> On Wed, 12 Mar 2008, Andi Kleen wrote:
> > RDMSR for 64bit values with exception handling.
> > 
> > Makes it easier to deal with 64bit valued MSRs. The old 64bit code
> > base had that too as checking_rdmsrl(), but it got dropped somehow. 
> 
> Yup, no users.
> 
> > +#define rdmsrl_safe(msr,p) \
> > +	({ int __err; *(p) = native_read_msr_safe(msr, &__err); __err; })
> > +
> 
> static inline please

Well all of paravirt.h uses macros. I did the same for consistency. If you want 
inlines it would be better to just convert it all in one go (but please only
after this patch was applied)

-Andi
