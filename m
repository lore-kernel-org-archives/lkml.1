Return-Path: <linux-kernel-owner+w=401wt.eu-S933537AbXBXTMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbXBXTMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 14:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933541AbXBXTMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 14:12:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933537AbXBXTMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 14:12:47 -0500
Message-ID: <45E08E1D.5010307@redhat.com>
Date: Sat, 24 Feb 2007 14:12:29 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
Subject: Re: [PATCH] Print error code in page faults
References: <20070224053125.GA20487@redhat.com>
In-Reply-To: <20070224053125.GA20487@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> When a page faults comes from a kernel space, the printed summary
> leaves us clueless about what kind of access was being tried (which
> is encoded in the error_code variable).
> 
> Having it promply available may ease debugging in a bunch of
> situations.
> 
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> 
> 
> 
> ------------------------------------------------------------------------
> 
> diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
> index 6ada723..e65522e 100644
> --- a/arch/x86_64/mm/fault.c
> +++ b/arch/x86_64/mm/fault.c
> @@ -539,7 +539,7 @@ no_context:
>  		printk(KERN_ALERT "Unable to handle kernel NULL pointer dereference");
>  	else
>  		printk(KERN_ALERT "Unable to handle kernel paging request");
> -	printk(" at %016lx RIP: \n" KERN_ALERT,address);
> +	printk(" at %016lx (error=0x%02lx) RIP: \n" KERN_ALERT, error_code, address);
>  	printk_address(regs->rip);
>  	dump_pagetable(address);
>  	tsk->thread.cr2 = address;

Umm, it's already there, right after the word "Oops".


Oops: 0002 [1] SMP
      ^^^^


