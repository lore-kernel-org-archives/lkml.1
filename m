Return-Path: <linux-kernel-owner+w=401wt.eu-S2993291AbXEBOzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993291AbXEBOzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 10:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993292AbXEBOzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 10:55:52 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35685 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993291AbXEBOzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 10:55:51 -0400
Date: Wed, 2 May 2007 16:55:50 +0200
From: Adrian Bunk <bunk@stusta.de>
To: David Rientjes <rientjes@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
Message-ID: <20070502145550.GE3531@stusta.de>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com> <1178084403.28659.222.camel@localhost.localdomain> <Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com> <1178087393.28659.238.camel@localhost.localdomain> <Pine.LNX.4.64.0705012336430.22339@chino.kir.corp.google.com> <1178089444.28659.246.camel@localhost.localdomain> <Pine.LNX.4.64.0705020020420.22717@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705020020420.22717@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 12:22:24AM -0700, David Rientjes wrote:
> On Wed, 2 May 2007, Rusty Russell wrote:
> 
> > 	That sounds exactly right to me!  If the author says it's optional, it
> > might be discarded.  If they say it's needed, it won't be.  At least,
> > when I'm coding and gcc warns me something is unused, this is the
> > decision I have to make ("is this really needed or not?").
> > 
> 
> Hi Rusty,
> 
> There are many instances in the tree of functions that have no callers 
> whatsoever because they've been commented out temporarily, disabled 
> through configuration, etc.  These are marked __attribute__ ((unused)) 
> right now so that the compiler doesn't emit a warning (and with gcc >=3.4 
> it doesn't even emit code for them).  What's __optional about these 
> functions if they have no callers?  They're unused.  So we cover all our 
> bases with __maybe_unused.

"many ... are marked __attribute__ ((unused))" is not true:
$ grep -r __attribute_used__ * | wc -l
60
$ 

static inline functions don't result in warnings.

And for global functions, it is technically impossible for gcc to figure
out whether a function has any users.

Unused static non-inline functions are the only functions resulting in 
warnings when being unused.
If we don't want gcc to emit warnings for such, we could disable them 
globally.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

