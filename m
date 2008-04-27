Return-Path: <linux-kernel-owner+w=401wt.eu-S1762508AbYD0Rrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762508AbYD0Rrw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 13:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbYD0Rrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 13:47:43 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37636 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056AbYD0Rrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 13:47:42 -0400
Date: Sun, 27 Apr 2008 20:47:14 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] prepare kconfig inline optimization for all
	architectures
Message-ID: <20080427174714.GB2252@cs181133002.pp.htv.fi>
References: <20080427105100.GA14795@uranus.ravnborg.org> <20080427113158.GY2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org> <20080427172235.GA2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271029130.2896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804271029130.2896@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 10:32:28AM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 27 Apr 2008, Adrian Bunk wrote:
> > 
> > I'm looking at it from a different angle, all code in the kernel should 
> > follow the following rules [1]:
> > - no functions in .c files should be marked inline
> > - all functions in headers should be static inline
> > - all functions in headers should either be very small or collapse
> >   to become very small after inlining
> > 
> > I can simply not see any usecase for a non-forced inline in the kernel,
> > and fixing the kernel should give a superset of the space savings of 
> > this "inline optimization".
> 
> Your whole argument is premised on the assumption that the compiler does 
> the right thing.
>...

No, you seem to be misunderstanding what I am saying.

Status Quo as of 2.6.25:
- we force the compiler to always inline with "inline"
- we have inline's in .c files and too big functions in headers, and
  both of them are wrong

"inline optimization":
- we leave the compiler the choice whether or not to inline with "inline"
- we still have inline's in .c files and too big functions in headers, 
  and both of them are wrong, but this "inline optimization" works 
  around these in some of the cases

What I want instead:
- we continue to force the compiler to always inline with "inline"
- we remove the inline's in .c files and make too big functions in 
  headers out-of-line

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

