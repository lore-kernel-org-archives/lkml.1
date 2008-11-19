Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbYKSHFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbYKSHFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 02:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYKSHF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 02:05:26 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:40525 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751395AbYKSHFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 02:05:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aiEAU/3X3/F0MvQjeuE32yYOQ+iVHmEZuHiaBBxQitugzI2l5ltdkMjlOOmI0zLrfk5076nWhKgIsxHbwVjsYnkEqeu8LD9q/+2XhpChckelQDA0sSpLa03rt6TcXM4QzoP8QzJ2BLQWzMxqcWDPeRvq0JiQ+Go9R6lLMhBpX6E=  ;
X-YMail-OSG: aKAb.x0VM1kCvnRLR5vuviONCHsGsUvzKdN2fdSXX9rG88QC2k1dkBBUnkXkFBxWrKXLXb2q_iNoQyCUoqgKigb9VOqh_DzbiqZ9KufkhIyeLloY7CdK5g_al3IVEcrT3ovwRXUNF2uGKU7oc1TaWoSoXumSNwZfMGmvUU2AseW7x1Z2fMMF64KP4_JA
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] Blackfin arch: SMP supporting patchset: Blackfin header files and machine common code
Date: Wed, 19 Nov 2008 18:05:07 +1100
User-Agent: KMail/1.9.5
Cc: Bryan Wu <cooloney@kernel.org>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       Graf Yang <graf.yang@analog.com>
References: <1226999108-13839-1-git-send-email-cooloney@kernel.org> <1226999108-13839-3-git-send-email-cooloney@kernel.org> <20081118225629.eddd23ae.akpm@linux-foundation.org>
In-Reply-To: <20081118225629.eddd23ae.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811191805.07656.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2008 17:56, Andrew Morton wrote:
> On Tue, 18 Nov 2008 17:05:05 +0800 Bryan Wu <cooloney@kernel.org> wrote:

> > +#define smp_mb__before_clear_bit()	barrier()
> > +#define smp_mb__after_clear_bit()	barrier()
> > +
> > +static inline void __set_bit(int nr, volatile unsigned long *addr)
> > +{
> > +	int *a = (int *)addr;
> > +	int mask;
> > +
> > +	a += nr >> 5;
> > +	mask = 1 << (nr & 0x1f);
> > +	*a |= mask;
> > +}
> > +
> > +static inline void __clear_bit(int nr, volatile unsigned long *addr)
> > +{
> > +	int *a = (int *)addr;
> > +	int mask;
> > +
> > +	a += nr >> 5;
> > +	mask = 1 << (nr & 0x1f);
> > +	*a &= ~mask;
> > +}
> > +
> > +static inline void __change_bit(int nr, volatile unsigned long *addr)
> > +{
> > +	int mask;
> > +	unsigned long *ADDR = (unsigned long *)addr;
> > +
> > +	ADDR += nr >> 5;
> > +	mask = 1 << (nr & 31);
> > +	*ADDR ^= mask;
> > +}
>
> I'm surprised there isn't any generic code which can be used for the above.

include/asm-generic/bitops/non-atomic.h


> > ...
>
> Gad what a lot of code.  I don't think I have time to read it all, sorry.

:) I don't know who is expected to. Cc'ing linux-arch for something
like this might attract some helpful comments.
