Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbYEFMjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbYEFMjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYEFMiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:38:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:55910 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbYEFMiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:38:50 -0400
Date: Tue, 6 May 2008 14:39:36 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: w35und: fixed nasty stack overflow, I can actually ssh over
	this
Message-ID: <20080506123936.GA4777@elf.ucw.cz>
References: <20080505205617.GD7273@elf.ucw.cz> <20080506123536.GM32591@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506123536.GM32591@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > Removed nasty stack overflow, and got transmit of big packets to work. 
> > I can now actually do ssh over softmac-based driver.
> > 
> > Unindent code to make it more readable.
> 
> > --- a/arch/x86/kernel/traps_32.c
> > +++ b/arch/x86/kernel/traps_32.c
> > @@ -146,11 +146,16 @@ static inline unsigned long print_contex
> >  				unsigned long *stack, unsigned long bp,
> >  				const struct stacktrace_ops *ops, void *data)
> >  {
> > +	int max = 5;
> >  	struct stack_frame *frame = (struct stack_frame *)bp;
> >  
> >  	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
> >  		unsigned long addr;
> >  
> > +		if (!max)
> > +			return;
> > +		max--;
> > +
> 
> hm, you got into an infinite loop here, right? Could you please send 
> this bit as a separate patch - and i guess it should use 
> kstack_depth_to_print instead of '5'?

No, sorry, this should not have been in this patch. (And no, this is
not the overflow I was talking about).

What happened to me is that current oops is too long even for vga=1,
and I was trying to see where it dies.

I was trying to only print first few lines of the backtrace, but then
I fix the nasty bug...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
