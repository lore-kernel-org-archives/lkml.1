Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbZFQRLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbZFQRLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZFQRKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:10:52 -0400
Received: from mail-yx0-f192.google.com ([209.85.210.192]:57259 "EHLO
	mail-yx0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZFQRKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:10:51 -0400
X-Greylist: delayed 119024 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jun 2009 13:10:51 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GuGT2LDMajOf9UAl53SVVRphDOfYeClio3UaYzJ8A2j5gJ2OLSEnCEfpq8NNN3FRhs
         7gDHo/Rlnf0BkIrkTXl6YfrKKMITA15I7/mwjY8rRVbplcK9URtTvwbfZqKuvR0dRPjJ
         jkocCZMyY6I1Sv+T33Kdw2cTxiWE6s+/26aEw=
MIME-Version: 1.0
In-Reply-To: <4A392098.9060205@gmail.com>
References: <4A392098.9060205@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 17 Jun 2009 13:10:33 -0400
Message-ID: <8bd0f97a0906171010l46a0f389kb2145a5be3e4001@mail.gmail.com>
Subject: Re: [PATCH 13/14] Pramfs: Write Protection
To: Marco <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux@arm.linux.org.uk,
       linux-m68k@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 12:58, Marco wrote:
> Jared Hulbert wrote:
>> > > +#if defined(CONFIG_ARM) || defined(CONFIG_M68K) || defined(CONFIG_H8300) || \
>> > > + ? ? ? defined(CONFIG_BLACKFIN)
>> > > + ? ? ? /*
>> > > + ? ? ? ?* FIXME: so far only these archs have flush_tlb_kernel_page(),
>> > > + ? ? ? ?* for the rest just use flush_tlb_kernel_range(). Not ideal
>> > > + ? ? ? ?* to use _range() because many archs just flush the whole TLB.
>> > > + ? ? ? ?*/
>> > > + ? ? ? if (end <= start + PAGE_SIZE)
>> > > + ? ? ? ? ? ? ? flush_tlb_kernel_page(start);
>> > > + ? ? ? else
>> > > +#endif
>> > > + ? ? ? ? ? ? ? flush_tlb_kernel_range(start, end);
>> > > +}
>> >
>> > Why not just fix flush_tlb_range()?
>> >
>> > If an arch has a flush_tlb_kernel_page() that works then it stands to
>> > reason that the flush_tlb_kernel_range() shouldn't work with minimal
>> > effort, no?
>>
>> flush_tlb_kernel_page() is a new one to me, it doesn't have any mention
>> in Documentation/cachetlb.txt anyways.
>>
>> Many of the flush_tlb_kernel_range() implementations do ranged checks
>> with tunables to determine whether it is more expensive to selectively
>> flush vs just blowing the entire TLB away.
>>
>> Likewise, there is no reason why those 4 architectures can not just shove
>> that if (end <= start + PAGE_SIZE) check in the beginning of their
>> flush_tlb_kernel_range() and fall back on flush_tlb_kernel_page() for
>> those cases. Hiding this in generic code is definitely not the way to go.
>
> Ok I'll change that function at arch level and I'll remove the ifdef, I'll call only flush_tlb_kernel_page(), but I'd like to know what is the opinion of the arch maintainers to do that.

considering Blackfin defines flush_tlb_kernel_page() to BUG(), i dont
think we care what happens.  we dont have a MMU, so all tlb funcs ->
BUG().  presumably this code shouldnt have been compiled in the first
place for us.
-mike
