Return-Path: <linux-kernel-owner+w=401wt.eu-S932239AbYDNSLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbYDNSLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760119AbYDNSLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:11:34 -0400
Received: from rv-out-0708.google.com ([209.85.198.251]:59243 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760087AbYDNSLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TGwpChyx/DwgA/9vGuCFGZAJCPIkl+ekr6jxDV/DfG72kLllIz2RoIAiz4BFkfgEXjTknxPJLWrc9pUc4OAbrK9w9zaBDSuBdBvjh8eAsbQEqVyQsN1Oxp0DLHP9scz0XeQ+sYthU1ifuEaKor5mv1s/V7y7OYNtORUGSZgu1iE=
Message-ID: <86802c440804141111g7a0cad03rf0b46a9fff01fa95@mail.gmail.com>
Date: Mon, 14 Apr 2008 11:11:32 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [rfc] hw resource debugging checks
Cc: "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <20080414071206.2a5ba029@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804102159.14563.rjw@sisk.pl> <200804112126.29455.rjw@sisk.pl>
	 <20080413075845.GJ20332@elte.hu> <87d4ouw0u9.fsf@basil.nowhere.org>
	 <86802c440804131119m1c43497bg1864ce9751438e85@mail.gmail.com>
	 <20080413182910.GB8641@one.firstfloor.org>
	 <86802c440804131229q7d68091bpa18ac32d379f0ef9@mail.gmail.com>
	 <20080413205215.6073a55b@laptopd505.fenrus.org>
	 <86802c440804132201j69ab8776lb331d906726a005c@mail.gmail.com>
	 <20080414071206.2a5ba029@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 7:12 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sun, 13 Apr 2008 22:01:23 -0700
>
>
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>
>  > On Sun, Apr 13, 2008 at 8:52 PM, Arjan van de Ven
>  > <arjan@infradead.org> wrote:
>  > >
>  > > On Sun, 13 Apr 2008 12:29:30 -0700
>  > >  "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>  > >
>  > >  > On Sun, Apr 13, 2008 at 11:29 AM, Andi Kleen
>  > >  > <andi@firstfloor.org> wrote:
>  > >  > > > even I could talk to BIOS
>  > >  > >  > engineers everyday and tell them how to fix the problem in
>  > >  > >  > BIOS,  some still can not be fixed because of the legacy
>  > >  > >  > BIOS framework or big mess.
>  > >  > >
>  > >  > >  ... so you opt to create the big mess in the kernel. Great.
>  > >  > >
>  > >  > >  And it does not even fixes a real problem, but getting
>  > >  > >  mmconfig or the numa bus discovery to work is not really a too
>  > >  > > serious issue anyways. At best it is the icing on the cake to
>  > >  > > enable some relatively obscure functionality and be a little
>  > >  > > more efficient, but nothing really fundamental.
>  > >  > >
>  > >  > >  But for those things just expecting a working modern BIOS is
>  > >  > > quite reasonable.
>  > >  >
>  > >  > it does fix real problem. when big system with several HT links,
>  > >  > and every link some pcie slots.
>  > >  > you fully load pci-e cards (with pci bridge). BIOS will stop
>  > >  > assign io/mmio resource to left device if it run out of io port
>  > >  > range. (though it is supposed to go on to allocate mmio to left
>  > >  > devices) ( modern pcie device only need mmio with drivers)
>  > >  >
>  > >  > With pre set range allocation in NB pci conf, kernel could
>  > >  > allocate the resource in every peer root bus ranges.
>  > >  > (the code for assign resource to device that is not assigned
>  > >  > resource by BIOS --- already in kernel)
>  > >  >
>  > >
>  > >  there is a really big difference between assigning PCI device
>  > > resources and doing a whole thing like MMCFG from scratch.
>  > >
>  > that MCONF patchset for AMD fam10h include
>  > 1. get mmconfig from MSR, MCFG is using that too, if that is right,
>  > and we will get MCONF support when acpi support is off, and MCFG is
>  > broken.
>  > 2. or assign 0xfc00000000 to that MSR, that is safe too.
>
>  using MCONF when the ACPI support isn't there is just a deathtrap.
>  To be honest, if you want to break the AMD machines out there, who am
>  I to care about that, I work for Intel. But I'm worried someone thinks
>  this can be done for Intel based systems too, and then carry over all
>  the bad bugs to those as well ;(

I don't want to break any machine. and just want to workaround some
bios bug, and use MMCONF when acpi is disabled...

YH
