Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYFZBXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYFZBXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbYFZBXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:23:14 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:62726 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbYFZBXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:23:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rcLshQARVjRDHxvD7RQk3m81oOnHK14ZuB2H6Bb6AesNF/YPSOp/N0ALff2n3VIVew
         GVWuAjytHSKa4dn33vQFqr9kmxb4TMS5jG73mFAINAmwqfc2CeFcxKSt5rI3lNIrNK4e
         4W1uxdIjiP3hJ4YCO/SnT10c8jZ3nImtfnt/8=
Message-ID: <21d7e9970806251823q3405e192q13d4944bd0cc3291@mail.gmail.com>
Date: Thu, 26 Jun 2008 11:23:11 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: kmap_atomic_pfn for PCI BAR access?
Cc: "Keith Packard" <keithp@keithp.com>, "Dave Airlie" <airlied@linux.ie>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4862EE4C.4060009@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214242487.11887.35.camel@koto.keithp.com>
	 <4862EE4C.4060009@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 11:18 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Keith Packard wrote:
>>
>> The graphics memory BAR is generally fairly good sized; on Intel chips,
>> it's between 256M and 1G (and growing). I want to write data into this
>> region from kernel space, but it's really too big to map the whole thing
>> into kernel address space, especially on 32-bit systems. ioremap is not
>> a good option here -- it's way too slow.
>>
>> With CONFIG_HIGHMEM enabled, I can use kmap_atomic_pfn (well, actually
>> the kmap_atomic_proc_pfn included in the DRM tree) and things work quite
>> well -- performance is good, with barely any measurable time spent in
>> the PTE whacking (~1%).
>>
>> However, with CONFIG_HIGHMEM disabled, there aren't any PTEs reserved
>> for this kind of mapping fun. This makes me suspect that abusing
>> kmap_atomic for this operation would not be appreciated.
>> Should I use kmap_atomic_pfn to reach my PCI BAR like this?
>>
>> Would it be reasonable to supply a patch that made this work even
>> without CONFIG_HIGHMEM?
>>
>
> Usually people use ioremap to map device memory.  Wouldn't that work in this
> case?
>

"but it's really too big to map the whole thing
into kernel address space, especially on 32-bit systems. ioremap is not
a good option here -- it's way too slow."

>From the original mail.

doing tlb flush for iounmap is slow as all hell if you do it a lot,
and we can't afford to mmap the whole aperture it can 1GB.

Dave.
