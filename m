Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbYHHSCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbYHHSCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbYHHSB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:01:57 -0400
Received: from gw.goop.org ([64.81.55.164]:45766 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbYHHSB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:01:56 -0400
Message-ID: <489C89FA.5000301@goop.org>
Date: Fri, 08 Aug 2008 11:01:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Mark McLoughlin <markmc@redhat.com>, xen-devel@lists.xensource.com,
       Eduardo Habkost <ehabkost@redhat.com>, Stephen Tweedie <sct@redhat.com>,
       linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Re: Allow compile with CONFIG_DEBUG_INFO=y,	X86_PAE
 not set on gcc 3.4.5
References: <20080808050429.GA8473@verge.net.au> <489BE9C3.2010006@goop.org>	<20080808080155.GA1992@cs181140183.pp.htv.fi>	<489C6485.7050009@goop.org> <20080808161331.GF14495@cs181140183.pp.htv.fi>
In-Reply-To: <20080808161331.GF14495@cs181140183.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Aug 08, 2008 at 08:21:41AM -0700, Jeremy Fitzhardinge wrote:
>   
>> Adrian Bunk wrote:
>>     
>>> CONFIG_DEBUG_INFO=y is why I never hit it before.
>>>
>>> It does not seem to be just one dodgy Redhat compiler (as I assumed in  
>>> the Bugzilla entry) but the whole 3.4 series of gcc which makes our  
>>> resolution of saying that this specific compiler is broken invalid.
>>>
>>> Considering that we officially support all compilers >= 3.2 this is 
>>> just one more case where we have to add to the kernel a workaround for 
>>> a broken compiler.
>>>   
>>>       
>> Yes.  I'm happy to write off a specific rpm package, but a whole series  
>> is a different matter.
>>
>> Adding
>>
>> 	if (PREALLOCATED_PMDS == 0)
>> 		return;
>>
>> in the appropriate places with a small comment seems like the right answer.
>>     
>
> The patch below you suggested fixes it for me with gcc 3.4.6.
>
>   
>>    J
>>     
>
> cu
> Adrian
>   

OK.  Want to submit this as a proper patch?

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Thanks,
    J


>
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -209,6 +209,9 @@ static void pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd, pmd_t *pmds[])
>  
>  	pud = pud_offset(pgd, 0);
>  
> +	if (PREALLOCATED_PMDS == 0)
> +		return;
> +
>   	for (addr = i = 0; i < PREALLOCATED_PMDS;
>  	     i++, pud++, addr += PUD_SIZE) {
>  		pmd_t *pmd = pmds[i];
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
>   

