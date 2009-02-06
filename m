Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbZBFGwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbZBFGwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 01:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbZBFGwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 01:52:16 -0500
Received: from gw.goop.org ([64.81.55.164]:42769 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbZBFGwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 01:52:16 -0500
Message-ID: <498BDE1D.8030101@goop.org>
Date: Thu, 05 Feb 2009 22:52:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Zach Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Rohit Jain <rjain@vmware.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PARAVIRT/x86] BUGFIX: Put a missing paravirt_release_pmd in
 pgd_dtor
References: <1233885731.29693.26.camel@alok-dev1>	 <498BA0CA.2040603@goop.org> <1233901043.8943.6.camel@alok-dev1>
In-Reply-To: <1233901043.8943.6.camel@alok-dev1>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> As it affects only VMI, instead of adding another callback, i have
> hooked on the paravirt_pgd_free call for vmi to release the pgd page.
> Below is the patch. I will run some overnight tests with this patch and
> get back if there are any errors.
>   

I'd forgotten that I'd already added pgd_alloc/pgd_free.  So, yes, just 
use pgd_free.

>> But either way, calling release_pmd here is wrong, since its only meant 
>> to be applied to pmds,
>>     
> Maybe i misunderstand, but that's how it used to work before that
> commit, we had a single call to release_*pd*, no ?
>   

I rearranged things, but I don't remember the details.  I think pd was 
being overloaded for both pgd and pmd, and I split it out so there was a 
specific function for each level.

>>  and it would break the Xen code.
>>     
>
> i see xen doesn't define the alloc_pmd_clone call. 
>   

It defines alloc_pmd, but has no need for alloc_pmd_clone (there's no 
shadow pagetable, so there's nothing to sync).  Zach added specifically 
for vmi's use.

    J
