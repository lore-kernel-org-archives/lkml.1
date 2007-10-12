Return-Path: <linux-kernel-owner+w=401wt.eu-S1762013AbXJLSP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762013AbXJLSP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 14:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759832AbXJLSPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 14:15:18 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56359 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758096AbXJLSPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 14:15:16 -0400
Date: Fri, 12 Oct 2007 20:15:44 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Franck Bui-Huu <vagabon.xyz@gmail.com>, linux-arch@vger.kernel.org,
       linux-mips@linux-mips.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Discardable strings for init and exit sections
Message-ID: <20071012181544.GC6476@stusta.de>
References: <Pine.LNX.4.64N.0710121711120.21684@blysk.ds.pg.gda.pl> <20071012171938.GB6476@stusta.de> <20071012175209.GA1110@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071012175209.GA1110@linux-mips.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 06:52:10PM +0100, Ralf Baechle wrote:
> On Fri, Oct 12, 2007 at 07:19:38PM +0200, Adrian Bunk wrote:
> 
> > I have an objection against this approach:
> > 
> > Our __*init*/__*exit* annotations are already a constant source of bugs, 
> > and adding more pifalls (e.g. forgotten removal of _i()/_e() when a 
> > function is no longer __*init*/__*exit*) doesn't sound like a good plan.
> > 
> > Shouldn't it be possible to automatically determine where to put the 
> > strings? I don't know enough gcc/ld voodoo for being able to tell 
> > whether it is currently possible, and if yes how, but doing it 
> > automatically sounds like the only solution that wouldn't result in an
> > unmaintainable mess.
> 
> gcc tends to place data such as strings or jump tables generated from
> switches not into a place were it would be easily discardable.  The
> latter is the reason that on MIPS we can't discard __exit functions
> at all - a switch table in .rodata might be referencing discarded code
> in .exit.text which makes ld fail.  When I discussed this with some gcc
> people a while ago nobody really had a good suggestion to solve this.

- Most of the string annotations are (naturally) dev{init,exit}
  annotations, and bugs there are therefore in configurations that have
  only extremely low testing coverage during -rc.
- I'm counting 22 annotations in the driver Maciej converted as an
  example. When estimating the number of possible annotations based
  on the number of C files in the kernel I'm getting a six digit
  number.

No matter how hard it would be to teach gcc about it, when thinking of 
the amount of __*init*/__*exit* bugs we already have I simply can't 
imagine the string annotations as a maintainable solution.

>   Ralf

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

