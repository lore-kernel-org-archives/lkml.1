Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbZBMVgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbZBMVgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZBMVgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:36:24 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40794 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546AbZBMVgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:36:23 -0500
Subject: Re: [tip:x86/headers] x86: fix "__udivdi3"
	[drivers/scsi/aha1542.ko] undefined
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
In-Reply-To: <4995D4A9.5060400@zytor.com>
References: <tip-bf33a70a73876b163d62612e9567cbac6604ba7e@kernel.org>
	 <4995D4A9.5060400@zytor.com>
Content-Type: text/plain
Date: Fri, 13 Feb 2009 15:36:19 -0600
Message-Id: <1234560979.3252.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-13 at 12:14 -0800, H. Peter Anvin wrote:
> James Bottomley wrote:
> >  arch/x86/include/asm/io.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
> > index e5a2ab4..4f8e820 100644
> > --- a/arch/x86/include/asm/io.h
> > +++ b/arch/x86/include/asm/io.h
> > @@ -125,7 +125,7 @@ static inline void *phys_to_virt(phys_addr_t address)
> >  /*
> >   * ISA I/O bus memory addresses are 1:1 with the physical address.
> >   */
> > -#define isa_virt_to_bus virt_to_phys
> > +#define isa_virt_to_bus (unsigned long)virt_to_phys
> >  #define isa_page_to_bus page_to_phys
> >  #define isa_bus_to_virt phys_to_virt
> >  
> 
> This changes one token to multiple, and not even with the highest
> precedence.

Yes, well, it was just a verifying patch, really.

> It needs to be something like:
> 
> #define isa_virt_to_bus(x) ((unsigned int)virt_to_phys(x))
> 
> ... if we're going to do that.

Actually, it probably wants to become a static inline ... that way the
compiler can always verify the promotion and truncation is legal
regardless of whether an actual user is compiled or not.

James


