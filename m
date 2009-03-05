Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbZCEXOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbZCEXOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbZCEXO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:14:28 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:5049 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbZCEXO1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:14:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=McP+4OD2pevDuuX8OJJtT7yQkLKU5U7Jf5xzgXhU6jOnNxnUOKZ56zgGI8/s/yN9rR
         gUu37LL+0PBsQfThfBc+ZcuJDUy2w3fy/QPFstuN9T8wfhkSZIpHX5uRyOpdFdgmLWRI
         w9IPw1MTXwB8yziyhEkhbz65BohlwjmMZ2eSE=
MIME-Version: 1.0
In-Reply-To: <20090305225921.GE918@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.00.0903040014140.5511@xanadu.home>
	 <20090304171429.c013013c.minchan.kim@barrios-desktop>
	 <alpine.LFD.2.00.0903041101170.5511@xanadu.home>
	 <20090305080717.f7832c63.minchan.kim@barrios-desktop>
	 <alpine.LFD.2.00.0903042129140.5511@xanadu.home>
	 <20090305132054.888396da.minchan.kim@barrios-desktop>
	 <alpine.LFD.2.00.0903042350210.5511@xanadu.home>
	 <28c262360903051423g1fbf5067i9835099d4bf324ae@mail.gmail.com>
	 <20090305225921.GE918@n2100.arm.linux.org.uk>
Date: Fri, 6 Mar 2009 08:14:25 +0900
Message-ID: <28c262360903051514n53e54df8x935aa398e16795ce@mail.gmail.com>
Subject: Re: [RFC] atomic highmem kmap page pinning
From: Minchan Kim <minchan.kim@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@cam.org>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 6, 2009 at 7:59 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Mar 06, 2009 at 07:23:44AM +0900, Minchan Kim wrote:
>> > +#ifdef ARCH_NEEDS_KMAP_HIGH_GET
>> > +/**
>> > + * kmap_high_get - pin a highmem page into memory
>> > + * @page: &struct page to pin
>> > + *
>> > + * Returns the page's current virtual memory address, or NULL if no mapping
>> > + * exists.  When and only when a non null address is returned then a
>> > + * matching call to kunmap_high() is necessary.
>> > + *
>> > + * This can be called from any context.
>> > + */
>> > +void *kmap_high_get(struct page *page)
>> > +{
>> > +       unsigned long vaddr, flags;
>> > +
>> > +       spin_lock_kmap_any(flags);
>> > +       vaddr = (unsigned long)page_address(page);
>> > +       if (vaddr) {
>> > +               BUG_ON(pkmap_count[PKMAP_NR(vaddr)] < 1);
>> > +               pkmap_count[PKMAP_NR(vaddr)]++;
>> > +       }
>> > +       spin_unlock_kmap_any(flags);
>> > +       return (void*) vaddr;
>> > +}
>> > +#endif
>>
>> Let's add empty function for architecture of no ARCH_NEEDS_KMAP_HIGH_GET,
>
> The reasoning being?

I thought it can be used in common arm function.
so, for VIVT, it can be work but for VIPT, it can be nulled as
preventing compile error.

But, I don't know where we use kmap_high_get since I didn't see any
patch which use it.
If it is only used architecture specific place,  pz, forgot my comment.

-- 
Kinds regards,
Minchan Kim
