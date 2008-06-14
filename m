Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbYFNXR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbYFNXR7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 19:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755632AbYFNXRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 19:17:52 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:54905 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbYFNXRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 19:17:51 -0400
Date: Sat, 14 Jun 2008 16:13:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, chrisw@sous-sol.org,
       virtualization@lists.osdl.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 13 (XEN)
Message-Id: <20080614161301.83c276e6.randy.dunlap@oracle.com>
In-Reply-To: <20080614203109.GH20851@kernel.dk>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au>
	<20080613101316.1c228fe7.randy.dunlap@oracle.com>
	<4852F1C8.7060904@goop.org>
	<20080614203109.GH20851@kernel.dk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jun 2008 22:31:10 +0200 Jens Axboe wrote:

> On Fri, Jun 13 2008, Jeremy Fitzhardinge wrote:
> > Randy Dunlap wrote:
> > >next-20080613 on x86_32 has lots of xen build errors like this:
> > >
> > >linux-next-20080613/arch/x86/xen/mmu.c: In function 'drop_mm_ref':
> > >linux-next-20080613/arch/x86/xen/mmu.c:759: error: implicit declaration of 
> > >function 'xen_smp_call_function_mask'
> > >make[2]: *** [arch/x86/xen/mmu.o] Error 1
> > >
> > >  
> > 
> > Ooh, first time I've seen that.  Sounds like Jens' patches are missing 
> > the appropriate update there (though it's certainly had it in the past).
> 
> Hmm, will this work or do we need to force xen smp_ops for this one? I
> wonder if this is new code and was missed, or what happened in this
> case.

Builds cleanly.  Thanks.

> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 3525ef5..8baef77 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -569,7 +569,7 @@ static void drop_mm_ref(struct mm_struct *mm)
>  	}
>  
>  	if (!cpus_empty(mask))
> -		xen_smp_call_function_mask(mask, drop_other_mm_ref, mm, 1);
> +		smp_call_function_mask(mask, drop_other_mm_ref, mm, 1);
>  }
>  #else
>  static void drop_mm_ref(struct mm_struct *mm)


---
~Randy
'"Daemon' is an old piece of jargon from the UNIX operating system,
where it referred to a piece of low-level utility software, a
fundamental part of the operating system."
