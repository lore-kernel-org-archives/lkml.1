Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbYEWUvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbYEWUvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 16:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbYEWUvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 16:51:40 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49030 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395AbYEWUvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 16:51:39 -0400
Date: Fri, 23 May 2008 23:49:12 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Steve French <smfrench@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
Message-ID: <20080523204912.GB4886@cs181133002.pp.htv.fi>
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com> <20080523204228.GC6749@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080523204228.GC6749@1wt.eu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 10:42:28PM +0200, Willy Tarreau wrote:
> On Fri, May 23, 2008 at 02:11:43PM -0500, Steve French wrote:
> > A question splitting "else" and "if" on distinct lines vs. using an
> > extra line and extra #else came up as I was reviewing a proposed cifs
> > patch.   Which is the preferred style?
> >
> > #ifdef CONFIG_SOMETHING
> >    if (foo)
> >       something ...
> >    else
> > #endif
> >    if ((mode & S_IWUGO) == 0)
> > 
> > or alternatively
> > 
> > #ifdef CONFIG_SOMETHING
> >    if (foo)
> >       something ...
> >    else if ((mode & S_IWUGO) == 0)
> > #else
> >    if ((mode & S_IWUGO) == 0)
> > #endif
> 
> The second one is dangerous because if code evolves, chances are that
> only one of the two identical lines will be updated.
> 
> At least the first one is clearly readable.

I would consider the first one much harder to read since you can _very_ 
easily miss that the "if" is in an "else" clause and completely misread 
the code.

> But if you have tons of
> places with the same construct, it's better to create a macro which
> will inhibit the if branch, which gcc will happily optimize away.
> For instance :
> 
> #ifdef CONFIG_FOO
> #define FOO_ENABLED 1
> #else
> #define FOO_ENABLED 0
> #endif
> 
> if (FOO_ENABLED && foo)
>     something
> else if ((mode & S_IWUGO) == 0)
>    ...
>...

I'd also say that's the best solution.

> Regards,
> Willy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

