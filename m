Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbYGAUU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbYGAUU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbYGAUUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:20:17 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:56176 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbYGAUUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:20:15 -0400
Date: Tue, 1 Jul 2008 20:20:14 +0000
From: Sean Young <sean@mess.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
Message-ID: <20080701202014.GA77013@atlantis.8hz.com>
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org> <48695871.8000805@zytor.com> <48695F88.9080905@goop.org> <48696167.6050000@zytor.com> <20080701195942.GA76608@atlantis.8hz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701195942.GA76608@atlantis.8hz.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 07:59:42PM +0000, Sean Young wrote:
> On Mon, Jun 30, 2008 at 03:42:47PM -0700, H. Peter Anvin wrote:
> > diff --git a/arch/x86/boot/pmjump.S b/arch/x86/boot/pmjump.S
> > index ab049d4..141b6e2 100644
> > --- a/arch/x86/boot/pmjump.S
> > +++ b/arch/x86/boot/pmjump.S
> > @@ -33,6 +33,8 @@ protected_mode_jump:
> >  	movw	%cs, %bx
> >  	shll	$4, %ebx
> >  	addl	%ebx, 2f
> > +	jmp	1f			# Short jump to serialize on 386/486
> > +1:
> >  
> >  	movw	$__BOOT_DS, %cx
> >  	movw	$__BOOT_TSS, %di
> > @@ -40,8 +42,6 @@ protected_mode_jump:
> >  	movl	%cr0, %edx
> >  	orb	$X86_CR0_PE, %dl	# Protected mode
> >  	movl	%edx, %cr0
> > -	jmp	1f			# Short jump to serialize on 386/486
> > -1:
> >  
> >  	# Transition to 32-bit mode
> >  	.byte	0x66, 0xea		# ljmpl opcode
> 
> I'm afraid it doesn't work. Maybe I can find something in the AMD Elan
> documentation. Would a fence make sense?

I was just trying to confirm this with postive and negative tests which 
is failing. I'm probably being an idiot, please let systematically test
this.

This does not seem like the heisenbug category, or is it?


Sean
