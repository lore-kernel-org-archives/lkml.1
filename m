Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbZABR4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbZABR4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 12:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757749AbZABR4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 12:56:06 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:60560 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757757AbZABR4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:56:05 -0500
X-Greylist: delayed 171960 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jan 2009 12:56:05 EST
Date: Fri, 2 Jan 2009 18:57:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, rdreier@cisco.com, ian.campbell@citrix.com,
       jeremy.fitzhardinge@citrix.com, deller@gmx.de, rusty@rustcorp.com.au,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca, randolph@tausq.org, dave@hiauly1.hia.nrc.ca,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kbuild: Disallow GCC 4.1.0 / 4.1.1
Message-ID: <20090102175737.GA5818@uranus.ravnborg.org>
References: <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain> <20081231105425.9ccac21d.akpm@linux-foundation.org> <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain> <20081231.141408.60544902.davem@davemloft.net> <20090102115547.GB3027@elte.hu> <alpine.LFD.2.00.0901020844070.5086@localhost.localdomain> <alpine.LFD.2.00.0901020933370.5086@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901020933370.5086@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 09:38:14AM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 2 Jan 2009, Linus Torvalds wrote:
> > 
> > I think this is wrong.
> > 
> > Just move the check into <linux/compiler-gcc4.h>
> 
> In fact, looking at that whole mess, I redid it all. It was disgusting how 
> conditionals in gcc4.h needed to double-check that __GNUC__ really was 4 
> (rather than something bigger), which largely negated the whole nice clean 
> compiler version separation.
> 
> I pushed out my preferred version, which fixes up the whole thing. The 
> gcc4 header file now only gets included for __GNUC__ == 4, and when we 
> ever see a __GNUC__ of 5, it will automatically DTRT and try to include 
> <linux/compiler-gcc5.h> instead of #4.
> 
> And then the check in gcc4.h for 4.1.0 and 4.1.1 is much simplified.  The 
> two patches I pushed out add functionality, but don't actually add any new 
> lines (the first simplification patch removes more lines than it adds, and 
> the second one that adds the __weak bug test adds as mahy lines as the 
> cleanup removed).
> 
> And it all looks more logical too, imho.

Bugger....
Now I cannot do cross compile for: alpha, arm, m68k and sparc.

Not that I actually try to run these beasts but just being able
to do cross compile has served me well.

Last I looked (only few days ago) crosstool-ng did not support sparc :-(

	Sam
