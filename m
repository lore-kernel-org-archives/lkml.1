Return-Path: <linux-kernel-owner+w=401wt.eu-S1760824AbYEMPbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760824AbYEMPbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760682AbYEMPbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:31:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760670AbYEMPbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:31:19 -0400
Date: Tue, 13 May 2008 08:31:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nickolay Vinogradov <nickolay@protei.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic/bitops/fls64.h
Message-Id: <20080513083101.96c92bd6.akpm@linux-foundation.org>
In-Reply-To: <482970DF.8020206@protei.ru>
References: <481E076A.8060302@protei.ru>
	<20080512144507.8d770723.akpm@linux-foundation.org>
	<482970DF.8020206@protei.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 14:43:43 +0400 Nickolay Vinogradov <nickolay@protei.ru> wrote:

> Andrew Morton __________:
> > On Sun, 04 May 2008 22:58:50 +0400
> > ____________________ ______________ ____________________ <nickolay@protei.ru> wrote:
> > 
> >> bugfix in fls64 on a big endian systems(against 2.6.25).
> >>
> >> Signed-off-by: Nickolay Vinogradov <nickolay@protei.ru>
> >>
> >> --
> >>
> >> diff --git a/include/asm-generic/bitops/fls64.h 
> >> b/include/asm-generic/bitops/fls64.h
> >> index 1b6b17c..2eedb6f 100644
> >> --- a/include/asm-generic/bitops/fls64.h
> >> +++ b/include/asm-generic/bitops/fls64.h
> >> @@ -8,7 +8,7 @@ static inline int fls64(__u64 x)
> >>          __u32 h = x >> 32;
> >>          if (h)
> >>                  return fls(h) + 32;
> >> -       return fls(x);
> >> +       return fls((__u32)x);
> >>   }
> >>
> >>   #endif /* _ASM_GENERIC_BITOPS_FLS64_H_ */
> > 
> > Please describe the bug which you are fixing?
> > 
> > Perhaps a more robust fix to <whatever the bug is> would be to
> > repair fls() so that it works correctly when passed a u64.  Perhaps.
> 
> Repair fls64() so that it works correctly when passed a u64.
> 

Yes, but what's wrong with it now?

The fls() in include/asm-generic/bitops/fls.h takes an int.

The fls() in include/asm-x86/bitops.h takes an int.

So both of these will already trucate the incoming argument to 32-bits.

It seems that you are using a version of fls() which doesn't do this. 
Why?  Which architecture are you using?  Would it not be more robust to
fix fls()?
