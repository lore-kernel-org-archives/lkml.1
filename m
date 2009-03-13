Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbZCMIJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbZCMIJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZCMIJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:09:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:43089 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbZCMIJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:09:09 -0400
Subject: Re: [git-pull -tip V2] x86: cpu architecture debug code
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49BA0C8C.4050302@goop.org>
References: <1236684201.3301.11.camel@localhost.localdomain>
	 <20090310122806.GE5794@elte.hu>
	 <1236697752.3387.2.camel@localhost.localdomain>
	 <20090310152029.GN3850@elte.hu>
	 <1236701373.3387.4.camel@localhost.localdomain>
	 <20090310174535.GA2963@elte.hu>
	 <1236729310.7004.2.camel@localhost.localdomain>
	 <20090311105333.GC2282@elte.hu> <1236770749.2836.10.camel@ht.satnam>
	 <49BA0C8C.4050302@goop.org>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 13:37:48 +0530
Message-Id: <1236931668.7865.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 00:34 -0700, Jeremy Fitzhardinge wrote:
> Jaswinder Singh Rajput wrote:
> >>> Complete diff:
> >>> diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
> >>> index 0bdf4da..08c365a 100755
> >>> --- a/arch/x86/kernel/cpu/cpu_debug.c
> >>> +++ b/arch/x86/kernel/cpu/cpu_debug.c
> >>> @@ -464,19 +464,19 @@ static void print_dt(void *seq)
> >>>  	unsigned long ldt;
> >>>  
> >>>  	/* IDT */
> >>> -	store_idt((struct desc_ptr *)&dt);
> >>> +	native_store_idt((struct desc_ptr *)&dt);
> >>>       
> >> hm, this wont work on Xen then.
> >>
> >>     
> >
> > Strange it should work for Xen, Are you getting any error.
> >
> > Xen also uses native_store_idt:
> > arch/x86/xen/enlighten.c:	.store_idt = native_store_idt,
> >   
> 
> store_idt (and the others) are not used very much, and never in any code 
> path under Xen.  They're not really meaningful in Xen, and this code 
> will probably oops if you ran it.
> 
> I guess we could do more meaningful implementations of these ops for 
> Xen, now that there's a user.
> 

cpu_debug is availabe in -tip.

Can you test it:

[jaswinder@ht linux-2.6-tip]$ cat /sys/kernel/debug/x86/cpu/cpu*/dt/dt
 IDT	: 00000000c05617ff
 GDT	: 00000000c17040ff
 LDT	: 0000000000000000
 TR	: 0000000000000080

 IDT	: 00000000c05617ff
 GDT	: 00000000c17140ff
 LDT	: 00000000fce90000
 TR	: 0000000000000080

[jaswinder@ht linux-2.6-tip]$ 


--
JSR

