Return-Path: <linux-kernel-owner+w=401wt.eu-S1763159AbYD0Slo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763159AbYD0Slo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 14:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757720AbYD0Slg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 14:41:36 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:57284 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758107AbYD0Slf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 14:41:35 -0400
Date: Sun, 27 Apr 2008 21:41:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] prepare kconfig inline optimization for all
	architectures
Message-ID: <20080427184106.GD2252@cs181133002.pp.htv.fi>
References: <20080427105100.GA14795@uranus.ravnborg.org> <20080427113158.GY2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org> <20080427172235.GA2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271029130.2896@woody.linux-foundation.org> <20080427174714.GB2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271053300.2896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804271053300.2896@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 11:11:27AM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 27 Apr 2008, Adrian Bunk wrote:
> >
> > What I want instead:
> > - we continue to force the compiler to always inline with "inline"
> > - we remove the inline's in .c files and make too big functions in 
> >   headers out-of-line
> 
> Sure, I can agree with that as a mostly good goal, but you're still 
> ignoring the fact that nobody should really expect the compiler to always 
> do a good job at deciding high-level issues.
> 
> For example, what's wrong with having "inline" on functions in .c files if 
> the author thinks they are small enough? He's likely right. Considering 
> past behaviour, he's quite often more right than the compiler.
>...

Ingo's commit in your tree just broke this assumption.

And he justified breaking it with a 2.3% size decrease.

And after
- grep'ing for "inline" through drivers/
- remembering how driver authors use likely/unlikely
- remembering the practically non-existing quality criteria you set
  for new drivers [1]
"He's likely right." is likely not right for the average driver author.

You might be smarter than gcc, but most kernel developers (including me) 
are not.

> 		Linus

cu
Adrian

[1] you said you really wanted this driver merged in this state in 2.6.25:

      grep -C4 volatile drivers/infiniband/hw/nes/nes_nic.c


-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

