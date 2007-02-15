Return-Path: <linux-kernel-owner+w=401wt.eu-S964888AbXBODnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888AbXBODnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 22:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964893AbXBODnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 22:43:46 -0500
Received: from smtp005.mail.ukl.yahoo.com ([217.12.11.36]:35899 "HELO
	smtp005.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964888AbXBODnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 22:43:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TaLvNvNY+LZ2Fe/DW8lz/mgBtC0tzpreqCpHBaZJ6YQ8zg+Cb54cYZXNbFkEPpTz2VBWlLhLqZ4WVCNyadS7jWQWF9rsKEfyafJti1cn0Q8Fci8/M6gVI3MrnHubnIJk5s/jYB9lkLCL5lbQBO9M3PgfLtxb7lcCJQZdNeveNmk=  ;
X-YMail-OSG: tTNmiSAVM1k8jUamZk.3Qc5EKOqXaemkL0CC6eygzJjuPyoCE5AR4Hkz6ew4iMhFEQAe6q59qrSaJEGVNJQ_k2s.HYi7qf113fZpaSTHQ6Z.EnQpL4Z06LNHLAxPjmrIqqnv.TxrLzSQSzvuvtAW0VBs_uKJgo0-
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should be accepted
Date: Thu, 15 Feb 2007 04:43:41 +0100
User-Agent: KMail/1.9.5
Cc: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       stable@kernel.org
References: <11715068631914-git-send-email-blaisorblade@yahoo.it> <20070215025423.GA9300@ccure.user-mode-linux.org>
In-Reply-To: <20070215025423.GA9300@ccure.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702150443.42287.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007 03:54, Jeff Dike wrote:
> On Thu, Feb 15, 2007 at 03:34:23AM +0100, Paolo 'Blaisorblade' Giarrusso 
wrote:
> > Index: linux-2.6.git/arch/x86_64/ia32/ptrace32.c
> > ===================================================================
> > --- linux-2.6.git.orig/arch/x86_64/ia32/ptrace32.c
> > +++ linux-2.6.git/arch/x86_64/ia32/ptrace32.c
> > @@ -246,6 +246,7 @@ asmlinkage long sys32_ptrace(long reques
> >  	case PTRACE_SINGLESTEP:
> >  	case PTRACE_DETACH:
> >  	case PTRACE_SYSCALL:
> > +	case PTRACE_OLDSETOPTIONS:
> >  	case PTRACE_SETOPTIONS:
> >  	case PTRACE_SET_THREAD_AREA:
> >  	case PTRACE_GET_THREAD_AREA:
>
> I sent an equivalent patch in earlier today:
Doh! Interesting this timing...

> Index: linux-2.6/arch/x86_64/ia32/ptrace32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86_64/ia32/ptrace32.c
> +++ linux-2.6/arch/x86_64/ia32/ptrace32.c
> @@ -239,6 +239,8 @@ asmlinkage long sys32_ptrace(long reques
>  	__u32 val;
>
>  	switch (request) {
> +	case PTRACE_OLDSETOPTIONS:
> +		request = PTRACE_SETOPTIONS;
>  	case PTRACE_TRACEME:
>  	case PTRACE_ATTACH:
>  	case PTRACE_KILL:
>
> I change the request so that PTRACE_OLDSETOPTIONS doesn't need to
> propogate any further.  However, it is present in include/asm-x86_64,
> so I guess that counts as being part of the x86_64 ABI.  That being
> the case, I guess my patch can be dropped in favor of this one.

It is handled in ptrace_request, unless there are include problems. I'm going 
to reboot and test mine for any remaining problem.
-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
