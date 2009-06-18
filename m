Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbZFRGYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbZFRGYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbZFRGYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:24:36 -0400
Received: from mail-fx0-f212.google.com ([209.85.220.212]:42323 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbZFRGYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:24:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=VJlahp0RtXcjzOL0Z5nxS6mI8+0Kx1739kb3cT3LqFqN9Hq/jeyKTrcLaV0YLDMAT1
         +7OZpKcnnXh2dmJDUpIooGzAKMSqAbGHuzCJ0/3r6dKqMS6J4BNsJ0ZS+OiAq4DhTJBx
         lGlEcEAgJ1WKXqSjufs0cvPybIISUoHmZClGU=
MIME-Version: 1.0
In-Reply-To: <20090618025736.GB26531@linux-sh.org>
References: <4A392098.9060205@gmail.com> <20090618025736.GB26531@linux-sh.org>
Date: Thu, 18 Jun 2009 08:24:35 +0200
Message-ID: <2ea1731b0906172324g4654966eq22cf0bdbd3eafabf@mail.gmail.com>
Subject: Re: [PATCH 13/14] Pramfs: Write Protection
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, Marco <marco.stornelli@gmail.com>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux@arm.linux.org.uk,
       linux-m68k@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/18 Paul Mundt <lethal@linux-sh.org>:
> On Wed, Jun 17, 2009 at 06:58:00PM +0200, Marco wrote:
>> Jared Hulbert wrote:
>> > > Why not just fix flush_tlb_range()?
>> > >
>> > > If an arch has a flush_tlb_kernel_page() that works then it stands to
>> > > reason that the flush_tlb_kernel_range() shouldn't work with minimal
>> > > effort, no?
>> >
>> > flush_tlb_kernel_page() is a new one to me, it doesn't have any mention
>> > in Documentation/cachetlb.txt anyways.
>> >
>> > Many of the flush_tlb_kernel_range() implementations do ranged checks
>> > with tunables to determine whether it is more expensive to selectively
>> > flush vs just blowing the entire TLB away.
>> >
>> > Likewise, there is no reason why those 4 architectures can not just shove
>> > that if (end <= start + PAGE_SIZE) check in the beginning of their
>> > flush_tlb_kernel_range() and fall back on flush_tlb_kernel_page() for
>> > those cases. Hiding this in generic code is definitely not the way to go.
>>
>> Ok I'll change that function at arch level and I'll remove the ifdef,
>> I'll call only flush_tlb_kernel_page(), but I'd like to know what is
>> the opinion of the arch maintainers to do that.  (Who is the maintainer
>> of H8300 arch?)
>>
> No, you should call flush_tlb_kernel_range() and just fix up the
> flush_tlb_kernel_range() calls to wrap in to flush_tlb_kernel_page(). As
> far as the kernel is concerned, flush_tlb_kernel_page() is not a standard
> interface, as it has no mention in Documentation/cachetlb.txt.
> flush_tlb_page() and flush_tlb_kernel_range() on the other hand are both
> standard interfaces.

Oops, my fault. I meant flush_tlb_kernel_range not the page version,
sorry. I agree with you.

>
> H8300 is a nommu platform, so it has no TLB to flush. Yoshinori Sato is
> the maintainer. Consult the MAINTAINERS file, that's what it is there for.
>

I know the MAINTAINERS file but for h8300 there isn't an exactly
indication (/arch/h8300 as for the other archs).

Marco
