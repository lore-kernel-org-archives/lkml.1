Return-Path: <linux-kernel-owner+w=401wt.eu-S1761900AbYC0VJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761900AbYC0VJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 17:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761374AbYC0VJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 17:09:16 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:14674 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760960AbYC0VJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 17:09:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Egm/d3G6ZtxO7F/gM6ABNI7mpoJ2voi+0dSVZ+ReH4djHVWZ6P/uyBRNxiFsWkmKPns8YqTu7jJJIh2C5gbNQWo3lcXPJIAAY9al9jd/EdWlIeJROe2tWXLJQh/frtti9gQNCGk6uRn2gb5Ai2te7DuvOuZiY+RPl5Zq9Weq/Zw=
Subject: Re: [git pull] x86 fixes
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080327210122.GA22823@elte.hu>
References: <20080327200309.GA18550@elte.hu>
	 <alpine.LFD.1.00.0803271325430.14670@woody.linux-foundation.org>
	 <1206650939.24940.43.camel@brick> <20080327205527.GA21912@elte.hu>
	 <20080327210122.GA22823@elte.hu>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 14:08:53 -0700
Message-Id: <1206652133.24940.49.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  arch/x86/mm/fault.c |   11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> Index: linux-x86.q/arch/x86/mm/fault.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/mm/fault.c
> +++ linux-x86.q/arch/x86/mm/fault.c
> @@ -103,13 +103,10 @@ static int is_prefetch(struct pt_regs *r
>  	int prefetch = 0;
>  	unsigned char *max_instr;
>  
> -#ifdef CONFIG_X86_32
> -	/* Catch an obscure case of prefetch inside an NX page: */
> -	if ((__supported_pte_mask & _PAGE_NX) && (error_code & 16))
> -		return 0;
> -#endif
> -
> -	/* If it was a exec fault on NX page, ignore */
> +	/*
> +	 * If it was a exec (instruction fetch) fault on NX page, then
> +	 * do not ignore the fault:
> +	 */

How about:
If it was an exec (instruction fetch) fault, it cannot be a 		prefetch
fault.

>  	if (error_code & PF_INSTR)
>  		return 0;
>  
> 

Cheers,

Harvey

