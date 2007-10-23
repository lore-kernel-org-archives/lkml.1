Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbXJWRLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbXJWRLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbXJWRLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:11:35 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42760 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752913AbXJWRLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:11:33 -0400
Date: Tue, 23 Oct 2007 19:12:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Franck Bui-Huu <vagabon.xyz@gmail.com>,
       linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Discardable strings for init and exit sections
Message-ID: <20071023171201.GW30533@stusta.de>
References: <Pine.LNX.4.64N.0710121711120.21684@blysk.ds.pg.gda.pl> <20071012171938.GB6476@stusta.de> <20071012175209.GA1110@linux-mips.org> <20071012181544.GC6476@stusta.de> <Pine.LNX.4.64N.0710231753250.8693@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64N.0710231753250.8693@blysk.ds.pg.gda.pl>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 05:57:38PM +0100, Maciej W. Rozycki wrote:
> On Fri, 12 Oct 2007, Adrian Bunk wrote:
> 
> > - Most of the string annotations are (naturally) dev{init,exit}
> >   annotations, and bugs there are therefore in configurations that have
> >   only extremely low testing coverage during -rc.
> > - I'm counting 22 annotations in the driver Maciej converted as an
> >   example. When estimating the number of possible annotations based
> >   on the number of C files in the kernel I'm getting a six digit
> >   number.
> > 
> > No matter how hard it would be to teach gcc about it, when thinking of 
> > the amount of __*init*/__*exit* bugs we already have I simply can't 
> > imagine the string annotations as a maintainable solution.
> 
>  Well, it is up to the maintainer of code in question to get it right if 
> interested.  Otherwise having no annotation and leaving the relevant 
> strings resident in the memory throughout the lifespan of the system is a 
> valid and perfectly working option.

If we want to go this route users may want to have this for all code 
they are using. This is not a per-maintainer question, that's a global 
thing: If janitors start annotating all source files in the kernel the 
resulting patches can't be accepted or rejected only based on the 
personal preferences of the maintainers.

>  If you worry about the reverse case, where an annotation should be 
> removed because the containing function is no longer __*init*/__*exit*, 
> then I think `modpost' does a reasonably good job finding such places.

As long as the modpost warnings are just warnings they will often be 
missed at compile time.

And most of the annotations (also in the driver you converted as an 
example) will be dev{init,exit} annotations, and bugs there are in 
configurations virtually noone tests during -rc

>   Maciej

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

