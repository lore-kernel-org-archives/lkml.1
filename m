Return-Path: <linux-kernel-owner+w=401wt.eu-S1761909AbXIJWSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761909AbXIJWSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 18:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761394AbXIJWSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 18:18:42 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47846 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761398AbXIJWSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 18:18:41 -0400
Date: Tue, 11 Sep 2007 00:18:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       perex@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070910221848.GJ3563@stusta.de>
References: <20070909202527.GT3563@stusta.de> <20070909203920.GA11764@infradead.org> <20070909145940.0b41c8a5.akpm@linux-foundation.org> <20070910090808.GA31204@infradead.org> <20070910022324.c69e1897.akpm@linux-foundation.org> <20070910124358.GB21089@ftp.linux.org.uk> <20070910102556.de35e825.akpm@linux-foundation.org> <20070910195821.GH3563@stusta.de> <20070910131759.a7b2dce7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070910131759.a7b2dce7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 01:17:59PM -0700, Andrew Morton wrote:
> On Mon, 10 Sep 2007 21:58:21 +0200 Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Mon, Sep 10, 2007 at 10:25:56AM -0700, Andrew Morton wrote:
> > >...
> > > Also, Adrian goes on and on with weird theories about how I'm picking on
> > > him.  But other patches (such as 7d12e780e003f93433d49ce78c) DO OTHER
> > > STUFF.  Like simplify the code, and make it smaller, faster or more
> > > maintainable or more reliable.
> > 
> > The unexport of sys_{open,read} actually makes the kernel smaller...
> > 
> > > So the tradeoff is quite different from a
> > > one-liner which does nothing but kill an export.  And, contrary to his
> > > claims, we _do_ put temporary back-compat wrappers in there when we
> > > change interfaces on those relatively rare occasions when it is possible,
> > > and when we remember to do it.
> > 
> > Your tradeoff misses the impact on external modules.
> > 
> > The unexport of sys_open will not break many modules, while
> > commit 7d12e780e003f93433d49ce78c most likely broke the majority of 
> > external modules.
> > 
> > Do we guarantee some API stability to module authors or do we not 
> > guarantee this?
> 
> Neither.  We look at each change and make sensible decisions based upon a
> number of factors.

In my experience, the only factor is whether a patch has to go through 
you or not...

> > Emphasizing on API stability in the cases that don't matter much while 
> > breaking the API in cases that affect most modules doesn't make any 
> > sense at all.
> > 
> > And your "remember to do it" is an important point. As an example, every 
> > change to a struct that is part of the signature of one or exportted 
> > functions does change the API of all of these functions. If we offer any 
> > API stability for external modules we need to review all patches that 
> > touch include/ because many of them contain changes to the modules API 
> > that might otherwise get missed.
> > 
> > Let's either continue to state that their is no stable API for external 
> > modules or define some API stability rules and do whatever is required 
> > for implementing them.
> 
> There is no benefit in making some rigid set of rules.

Is is considered beneficial to provide API stability for external 
modules or not?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

