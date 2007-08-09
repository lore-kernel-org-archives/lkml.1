Return-Path: <linux-kernel-owner+w=401wt.eu-S940059AbXHIRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940059AbXHIRTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934873AbXHIRTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:19:05 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4093 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935276AbXHIRTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:19:04 -0400
Date: Thu, 9 Aug 2007 18:18:34 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       drfickle@us.ibm.com, mel@csn.ul.ie
Subject: Re: 2.6.23-rc2-mm1 -- PPC G5 kernel compile failure (patch)
Message-ID: <20070809171834.GB7060@shadowen.org>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org> <20070809130449.GB3091@shadowen.org> <20070809162006.00197118.krzysztof.h1@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809162006.00197118.krzysztof.h1@wp.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 04:20:06PM +0200, Krzysztof Helt wrote:
> On Thu, 9 Aug 2007 14:04:49 +0100
> Andy Whitcroft <apw@shadowen.org> wrote:
> 
> > Seeing the following compile error on a G5 mac:
> > 
> >   drivers/video/tdfxfb.c: In function 'tdfxfb_setup':
> >   drivers/video/tdfxfb.c:1341: error: 'opt' undeclared (first use in this
> >                                                                  function)
> >   drivers/video/tdfxfb.c:1341: error: (Each undeclared identifier is
> >                                                         reported only once
> >   drivers/video/tdfxfb.c:1341: error: for each function it appears in.)
> > 
> > This seems to be the following fragment from tdfxfb-hardware-cursor:
> > 
> > +               } else if (!strcmp(this_opt, "hwcursor")) {
> > +                       hwcursor = simple_strtoul(opt + 9, NULL, 0);
> > 
> > I guess the nieve fix would be s/opt/this_opt, but I am also
> > suspicious of the +9 here as hwcursor is only 8 long?  Now this
> > seems to take a numeric value and I assume that is via hwcursor=N,
> > if so then the +9 would make sense _if_ the strcmp was against
> > "hwcursor=".
> > 
> 
> The patch below fixes all issues you have pointed out. It also fixes
> the description of the nomtrr option.

Will push this through our tests and let you know.

-apw
