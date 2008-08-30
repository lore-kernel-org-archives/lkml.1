Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbYH3C3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbYH3C3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 22:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbYH3C3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 22:29:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:41231 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbYH3C3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 22:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=X0G4JKmwr+9bj636ARmzvdU2EH9fpccLo0FACtt1Ws74BMUw53IUAmSSYlOuemJk/1
         mgcwhUaviE3X9TcnKSOJDiw3ZJT98qMgpKDGZI/8tjQ+V9CKaTWwPRGQLC0tLLyewHze
         h6mE/EdvupR4ce+x8N8gvYlAYEn5HdC32N7bE=
Message-ID: <86802c440808291929r64c4dd15td5214a9199618815@mail.gmail.com>
Date: Fri, 29 Aug 2008 19:29:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Jordan Crouse" <jordan.crouse@amd.com>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808291912360.3300@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808292157.24179.rjw@sisk.pl>
	 <86802c440808291413t4f31993fmba59a65aefd906ca@mail.gmail.com>
	 <200808300031.16708.rjw@sisk.pl>
	 <86802c440808291624t2bd0229w2da36dfc6c794b18@mail.gmail.com>
	 <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org>
	 <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>
	 <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>
	 <86802c440808291814v4037f83eu943b9ad23297309b@mail.gmail.com>
	 <alpine.LFD.1.10.0808291912360.3300@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 7:16 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 29 Aug 2008, Yinghai Lu wrote:
>> > Ok, can we please
>> >
>> >  - *do* get a quirk for known-broken chipsets (at a *PCI* level, this is
>> >   not an x86 issue)
>>
>> the quirk work at the first point for David' system.
>
> That was not what I meant - meant the known-broken MMIO bar.
>
>> [PATCH] x86: protect hpet in BAR for one ATI chipset v3
>
> Now, this is probably fine too in theory, but
>
>  - you didn't check if the BAR is even enabled, afaik
>
>  - the other patch - to move the reserved e820 range later - should make
>   this pointless, no?

yes.

>
>> >  - *not* get any more random PCI work-arounds that go through the x86 tree
>> >   and aren't even looked at by the (very few) people who actually
>> >   understand the PCI resource handling?
>>
>> stop working on following path?
>> [PATCH] x86: split e820 reserved entries record to late v4
>> [PATCH] x86: split e820 reserved entries record to late v4 - fix v2
>
> No, I think this is worth doing, BUT IT MUST NOT BE MERGED BY JUST SENDING
> IT TO INGO.
>
> It's not an "x86 patch". It's about the PCI resources.
>
> And those kinds of patches need to be acked by people who know and
> understand the PCI resource issues and have some memory of just how
> broken machines can exist.

i see.

YH
