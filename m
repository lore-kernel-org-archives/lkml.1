Return-Path: <linux-kernel-owner+w=401wt.eu-S965646AbXAXEEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965646AbXAXEEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 23:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965647AbXAXEEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 23:04:16 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50184 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965646AbXAXEEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 23:04:15 -0500
Date: Tue, 23 Jan 2007 20:04:03 -0800
From: Andrew Morton <akpm@osdl.org>
To: takada <takada@mbf.nifty.com>
Cc: lsorense@csclub.uwaterloo.ca, linux-kernel@vger.kernel.org
Subject: Re: fix typo in geode_configre()@cyrix.c
Message-Id: <20070123200403.a51a3a17.akpm@osdl.org>
In-Reply-To: <20070117.021242.227424452.takada@mbf.nifty.com>
References: <20070109173348.GF17269@csclub.uwaterloo.ca>
	<20070117.013835.51856830.takada@mbf.nifty.com>
	<20070116165007.GZ17267@csclub.uwaterloo.ca>
	<20070117.021242.227424452.takada@mbf.nifty.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jan 2007 02:12:42 +0900 (JST)
takada <takada@mbf.nifty.com> wrote:

> From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
> Subject: Re: fix typo in geode_configre()@cyrix.c
> Date: Tue, 16 Jan 2007 11:50:07 -0500
> 
> > On Wed, Jan 17, 2007 at 01:38:35AM +0900, takada wrote:
> > > You are right. I agree to your comment. These variables are needless.
> > > I made a patch again.
> > 
> > Of course there are also lots of "magic numbers" around, but I must
> > admit I don't personally really feel like going through the data sheet
> > and naming all of them.
> 
> Me too.
> 
> > 
> > > diff -Narup linux-2.6.19.orig/arch/i386/kernel/cpu/cyrix.c linux-2.6.19/arch/i386/kernel/cpu/cyrix.c
> > > --- linux-2.6.19.orig/arch/i386/kernel/cpu/cyrix.c	2006-11-30 06:57:37.000000000 +0900
> > > +++ linux-2.6.19/arch/i386/kernel/cpu/cyrix.c	2007-01-16 19:55:05.000000000 +0900
> > > @@ -161,19 +161,15 @@ static void __cpuinit set_cx86_inc(void)
> > >  static void __cpuinit geode_configure(void)
> > >  {
> > >  	unsigned long flags;
> > > -	u8 ccr3, ccr4;
> > >  	local_irq_save(flags);
> > >  
> > >  	/* Suspend on halt power saving and enable #SUSP pin */
> > >  	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
> > >  
> > > -	ccr3 = getCx86(CX86_CCR3);
> > > -	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);	/* Enable */
> > > +	setCx86(CX86_CCR3, (getCx86(CX86_CCR3) & 0x0f) | 0x10);	/* Enable */
> > >  	
> > > -	ccr4 = getCx86(CX86_CCR4);
> > > -	ccr4 |= 0x38;		/* FPU fast, DTE cache, Mem bypass */
> > > -	
> > > -	setCx86(CX86_CCR3, ccr3);
> > > +	/* FPU fast, DTE cache, Mem bypass */
> > > +	setCx86(CX86_CCR4, getCx86(CX86_CCR4) | 0x30);
> > 	
> > Why did that change from 0x38 to 0x30?
> 
> ah... I made mistake. My eye is tired.
> Correctry, 0x38.
> 

I'm lost.  Could someone please prepare a complete new patch against the
latest -linus tree?

Thanks.

