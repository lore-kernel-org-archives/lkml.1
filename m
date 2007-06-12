Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbXFLVih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbXFLVih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 17:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbXFLVia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 17:38:30 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:44843 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbXFLVia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 17:38:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Wm8WOCPUjjC3BqZHPlweDO1cE3CwvLMrn9IATFMx+NCJc8mmqHty4CuCNKmsx1m6Nx5ET8R+pcpNj0aUXgsbdvqk4xtttkBVsxwYF1jRSTsg2qSXLEIwi+V1qVl2WIsdAgIQ+oUuL+kB77cHhCBK67obENonD070NMnEMH1qIac=
Message-ID: <2c0942db0706121438y6d2d2bb5qbe11269691366d20@mail.gmail.com>
Date: Tue, 12 Jun 2007 14:38:28 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Cc: "Jesse Barnes" <jesse.barnes@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20070612213020.GA13747@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706071530.51552.jesse.barnes@intel.com>
	 <20070612145007.GA5986@ucw.cz>
	 <200706120829.21465.jesse.barnes@intel.com>
	 <20070612213020.GA13747@elf.ucw.cz>
X-Google-Sender-Auth: 03791e044b90e225
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/07, Pavel Machek <pavel@ucw.cz> wrote:
> > > > On some machines, buggy BIOSes don't properly setup WB MTRRs to
> > > > cover all available RAM, meaning the last few megs (or even gigs)
> > > > of memory will be marked uncached.  Since Linux tends to allocate
> > > > from high memory addresses first, this causes the machine to be
> > > > unusably slow as soon as the kernel starts really using memory
> > > > (i.e. right around init time).
> > > >
> > > > + if ((highest_addr >> PAGE_SHIFT) != end_pfn) {
> > > > +         printk(KERN_WARNING "***************\n");
> > > > +         printk(KERN_WARNING "**** WARNING: likely BIOS bug\n");
> > > > +         printk(KERN_WARNING "**** MTRRs don't cover all of "
> > > > +                "memory, trimmed %ld pages\n", end_pfn -
> > > > +                (highest_addr >> PAGE_SHIFT));
> > > > +         printk(KERN_WARNING "***************\n");
> > > > +         end_pfn = highest_addr >> PAGE_SHIFT;
> > >
> > > Missing 4K of memory is not worth 4K of junk in syslog per boot. Can
> > > you drop the stars and stop shouting?
> >
> > How missing about 1G of memory?  We already discussed this, and Andi and
> > Venki felt that either a panic or a really obnoxious message was the
> > way to go...
>
> Just use panic, then.
>                                                                         Pavel,
>         who still thinks anyone missing 1GB of ram will not miss
>         friendly notice in dmesg, even if it goes without 20 stars.

Panicking when it's not necessary is anti-social. If the kernel can
continue, then it should, unless it's a correctness issue that may
cause data corruption. Given that the kernel can even work around the
problem now, throwing a panic is even less warranted.

Ray
