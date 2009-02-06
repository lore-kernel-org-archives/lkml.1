Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbZBFRBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbZBFRBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758646AbZBFRBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:01:00 -0500
Received: from gw.goop.org ([64.81.55.164]:59211 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbZBFRA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:00:59 -0500
Message-ID: <498C6CC9.5050302@goop.org>
Date: Fri, 06 Feb 2009 09:00:57 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: akataria@vmware.com, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Zach Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Rohit Jain <rjain@vmware.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PARAVIRT/x86] BUGFIX: Put a missing paravirt_release_pmd in
 pgd_dtor
References: <1233885731.29693.26.camel@alok-dev1> <498BA0CA.2040603@goop.org> <1233901043.8943.6.camel@alok-dev1> <498BDE1D.8030101@goop.org> <20090206145324.GF18368@elte.hu>
In-Reply-To: <20090206145324.GF18368@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Alok Kataria wrote:
>>     
>>> As it affects only VMI, instead of adding another callback, i have
>>> hooked on the paravirt_pgd_free call for vmi to release the pgd page.
>>> Below is the patch. I will run some overnight tests with this patch and
>>> get back if there are any errors.
>>>   
>>>       
>> I'd forgotten that I'd already added pgd_alloc/pgd_free.  So, yes, just  
>> use pgd_free.
>>     
>
> Can i take that as an Acked-by?
>   

Yeah.  Though:
>  /*
> + * We hack the pgd_free hook for releasing the pgd page.
>   
Its hardly a hack to use a hook for exactly its intended purpose...
> + */
> +static void vmi_pgd_free(struct mm_struct *mm, pgd_t *pgd)
> +{
> +	unsigned long pfn = __pa(pgd) >> PAGE_SHIFT;
> +
> +	vmi_ops.release_page(pfn, VMI_PAGE_L2);
> +}
> +

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J
