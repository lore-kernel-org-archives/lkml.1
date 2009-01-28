Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZA1VE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZA1VE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZA1VEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:04:47 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:58495 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbZA1VEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:04:47 -0500
Date: Wed, 28 Jan 2009 22:06:33 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
Message-ID: <20090128210633.GA29123@uranus.ravnborg.org>
References: <20090127222825.GA27097@elte.hu> <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 02:57:23PM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 27 Jan 2009, Ingo Molnar wrote:
> > 
> > Should i perhaps not bother with the stuff below? Cannot turn off 
> > CONFIG_HEADERS_CHECK in my builds because it can cause build failures.
> 
> I really hate the patch. I think it's fundamentally flawed. I hate scripts 
> that test for things that are readable, and encourage people to then write 
> crap instead.
> 
> The thing is, the headers_check stuff is just wrong if it causes these 
> things, and I'd rather just turn it off.
> 
> If those 
> 
> 	#ifdef CONFIG_XYZ
> 
> things result in problems, then we should just make the rule be that we 
> turn that kind of string into
> 
> 	#if 0
> 
> automatically when exporting the kernel headers. IOW, just about 
> _anything_ that headers_check complains about automatically is something 
> that should just be _fixed_ automatically at header install time rather 
> than make the code harder to read.

Almost every single patch that makes code harder to read while removing
CONFIG_ references from the exported headers just take the wrong approach.

I read later in this thread that Ingo is planning to filter out these patches
so we can get the other ones in - good.

What we should try to do is to look at the bigger picture.
Sometimes the right answer is that this whole file should not
be exported or maybe only half should be exported.
But due to the fact that we have no established way to seperate
what is internal and what is exported *on the file level* people
keep sprinkling #ifdef __KERNEL__ all over the header files.

I checked include/linux - we have 494 places where we reference __KERNEL__
And that is in 237 files.
We export 354 files from this dir - so we already have > 100 files that is
exported to userspace without modifications.

So rather than start sprinkling the exported headers with "if 0" then
we should encourage to clean them and when accetable move them to
a dedicated abi directory.

This may need some cooperation with external parties such as glibc
and other libc variants. And we could improve here.

	Sam
