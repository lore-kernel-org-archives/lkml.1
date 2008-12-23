Return-Path: <linux-kernel-owner+w=401wt.eu-S1752104AbYLWUe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbYLWUe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 15:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYLWUeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 15:34:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59495 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbYLWUeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 15:34:17 -0500
Date: Tue, 23 Dec 2008 15:32:23 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Jaswinder Singh <jaswinder@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: traps.c replace #if CONFIG_X86_32 with #ifdef
 CONFIG_X86_32
Message-ID: <20081223153223.2802314f@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <49512BF5.2010705@kernel.org>
References: <1230049211.14358.2.camel@jaswinder.satnam>
	<49512BF5.2010705@kernel.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2008 10:20:37 -0800
"H. Peter Anvin" <hpa@kernel.org> wrote:

> > --- a/arch/x86/kernel/traps.c
> > +++ b/arch/x86/kernel/traps.c
> > @@ -692,7 +692,7 @@ void math_error(void __user *ip)
> >  
> >  	err = swd & ~cwd & 0x3f;
> >  
> > -#if CONFIG_X86_32
> > +#ifdef CONFIG_X86_32
> >  	if (!err)
> >  		return;
> >  #endif
> 
> Applied to tip:x86/fpu, thanks.
> 
> Andi: you might have a perspective on this: in math_error() we bail out
> if there is no error on i386, but not on x86-64.  I am rather assuming
> that is because it simply can't happen on x86-64 (no IRQ 13 bullshit) so
> it wasn't necessary?
> 

Some 32-bit x86 clones generate math error interrupts when there is no
actual error.
