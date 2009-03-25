Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbZCYXia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbZCYXia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZCYXiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:38:21 -0400
Received: from www.tglx.de ([62.245.132.106]:40511 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbZCYXiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:38:20 -0400
Date: Thu, 26 Mar 2009 00:36:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
In-Reply-To: <20090325232921.GL7278@localdomain>
Message-ID: <alpine.LFD.2.00.0903260034200.3397@localhost.localdomain>
References: <20090227001757.GE27240@localdomain> <20090228094430.GH12095@elte.hu> <20090302235120.GF27240@localdomain> <20090322124818.GA31466@elte.hu> <20090324061429.GH7278@localdomain> <20090324091035.GA6605@elte.hu> <20090325185138.GI7278@localdomain>
 <49CAAD2E.3060904@goop.org> <20090325223642.GK7278@localdomain> <49CABB25.8040106@goop.org> <20090325232921.GL7278@localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009, Ravikiran G Thirumalai wrote:
> > Sure, but it would be cleaner if the whole file were controlled by 
> > CONFIG_X86_VSMP.  is_vsmp_box() is already defined as const inline 
> > returning 0 if !CONFIG_X86_VSMP.
> >
> 
> The point in this thread was, is_vsmp_box() needs to be meaningful even when
> CONFIG_X86_VSMP is not on.  This is needed because is_vsmp_box() is used to
> determine if the platform has reliable tscs.

Did you even read what Jeremy wrote or bother to look at the code in
arch/x86/include/asm/apic.h ?

#ifdef CONFIG_X86_VSMP
extern int is_vsmp_box(void);
#else
static inline int is_vsmp_box(void)
{
        return 0;
}
#endif

So the .c file is completely useless if CONFIG_X86_VSMP=n.

Thanks,

	tglx
