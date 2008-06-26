Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYFZFCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYFZFCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 01:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYFZFCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 01:02:08 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:60410 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbYFZFCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 01:02:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pH7HLklBYuH4jQBbWC+ziX/wqibJG/qjXHezGb6mEnT6G2/Y8Uvey9YsYSWyHxzC3m
         THxvCtaLEJtCARl26liRWGQHdtRwuJL4DQjz8DdjRIgKQx4df3Ce6uw29idP3GEh16W9
         9R7n2p9t2pAJxq0FMCcOWSUuV7Z+Sm2bwNvRQ=
Message-ID: <21d7e9970806252202i10de9c82lb4637d9f1064f0b0@mail.gmail.com>
Date: Thu, 26 Jun 2008 15:02:04 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: kmap_atomic_pfn for PCI BAR access?
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Keith Packard" <keithp@keithp.com>, "Dave Airlie" <airlied@linux.ie>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080625213603.0e82805b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214242487.11887.35.camel@koto.keithp.com>
	 <4862EE4C.4060009@goop.org>
	 <21d7e9970806251823q3405e192q13d4944bd0cc3291@mail.gmail.com>
	 <20080625213603.0e82805b@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 2:36 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Thu, 26 Jun 2008 11:23:11 +1000
> "Dave Airlie" <airlied@gmail.com> wrote:
>
>> On Thu, Jun 26, 2008 at 11:18 AM, Jeremy Fitzhardinge
>> <jeremy@goop.org> wrote:
>> > Keith Packard wrote:
>> >>
>> >> The graphics memory BAR is generally fairly good sized; on Intel
>> >> chips, it's between 256M and 1G (and growing). I want to write
>> >> data into this region from kernel space, but it's really too big
>> >> to map the whole thing into kernel address space, especially on
>> >> 32-bit systems. ioremap is not a good option here -- it's way too
>> >> slow.
>> >>
>> >> With CONFIG_HIGHMEM enabled, I can use kmap_atomic_pfn (well,
>> >> actually the kmap_atomic_proc_pfn included in the DRM tree) and
>> >> things work quite well -- performance is good, with barely any
>> >> measurable time spent in the PTE whacking (~1%).
>> >>
>> >> However, with CONFIG_HIGHMEM disabled, there aren't any PTEs
>> >> reserved for this kind of mapping fun. This makes me suspect that
>> >> abusing kmap_atomic for this operation would not be appreciated.
>> >> Should I use kmap_atomic_pfn to reach my PCI BAR like this?
>> >>
>> >> Would it be reasonable to supply a patch that made this work even
>> >> without CONFIG_HIGHMEM?
>> >>
>> >
>> > Usually people use ioremap to map device memory.  Wouldn't that
>> > work in this case?
>> >
>>
>> "but it's really too big to map the whole thing
>> into kernel address space, especially on 32-bit systems. ioremap is
>> not a good option here -- it's way too slow."
>>
>> >From the original mail.
>>
>> doing tlb flush for iounmap is slow as all hell if you do it a lot,
>> and we can't afford to mmap the whole aperture it can 1GB.
>
> well kmap does a tlb flush as well... you can't get away from doing a
> flush if you change cpu mapping.
> What you CAN do is play tricks and flush only once in a while and make
> sure you don't recycle mappings in the mean time (like kmap does).
>
> I can totally see doing an iounmap_lazy() and then have an
> iounmap_flush_lazy() thing or something like that....
>

Thats why keithp wants something like kmap_atomic but for ioremap
instead of kmaps.

This would be for short temporary ioremaps like kmap_atomic is.

Dave.
