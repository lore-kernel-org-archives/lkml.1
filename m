Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbXGXXIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbXGXXIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbXGXXIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:08:16 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:48120 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754490AbXGXXIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:08:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CS+3TKn7y/cnJF1T4Nla1Y8DtqzreLucZvRDgyyGpU37ARMmPCjmJs+lUXSbwnonytpzYKoGYDiQ/pW1UD4e9rMjV6/iY8+UQRB27YSilZH4JfjY3CX7jvuE9ogg5tnWkxtLYTZAKSZZ2UFKXjsTp0mrkffyryx7hWZhInY3P1A=  ;
X-YMail-OSG: imWB7EEVM1kHvWfeLQ3hgzJXdbrbVBW_wzt5.2Bd8ktYWMBMsBAYgLR0iiX9cKnbHVRkH9ZOgQ--
From: David Brownell <david-b@pacbell.net>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [patch 2.6.23-rc1] dma_free_coherent() needs irqs enabled (sigh)
Date: Tue, 24 Jul 2007 16:08:11 -0700
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
References: <200707241429.05615.david-b@pacbell.net> <20070724220738.GD22165@flint.arm.linux.org.uk>
In-Reply-To: <20070724220738.GD22165@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241608.12198.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2007, Russell King wrote:
> On Tue, Jul 24, 2007 at 02:29:05PM -0700, David Brownell wrote:
> > On at least ARM (and I'm told MIPS too) dma_free_coherent() has a newish
> > call context requirement:  unlike its dma_alloc_coherent() sibling, it
> > may not be called with IRQs disabled.  (This was new behavior on ARM as
> > of late 2006, caused by ARM SMP updates.)
> 
> I think you got the year wrong:
> 
> 5edf71ae (Russell King      2005-11-25 15:52:51 +0000 364)      WARN_ON(irqs_disabled());
> 
> which is due to this commit:
> 
> [ARM] Do not call flush_tlb_kernel_range() with IRQs disabled.

This little "to do" list item has been sitting in my mailbox way
too long then.  Certainly since it was fair to say "last year"!  ;)

Of course, 2.6.23-rc1 also merges all the gadget API updates I
included to cope with this annoyance.  So with any luck the issue
will now finally have been properly whupped.


> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks...

 
> > Since it looks like that restriction won't be removed, this patch changes
> > the definition of the API to include that requirement.
> 
> The PCI DMA-mapping API had this restriction.  For some reason, this
> restriction was not carried forward into the DMA-API.  Unfortunately
> the restriction can not be removed without causing the problems
> described in the commit which introduced it.

Right, I noticed that.

- Dave
