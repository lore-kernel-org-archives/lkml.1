Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbZECMXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbZECMXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 08:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbZECMXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 08:23:16 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:51500 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbZECMXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 08:23:15 -0400
Date: Sun, 3 May 2009 08:22:01 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: npiggin@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SLQB: Use _RET_IP_ instead of
 __builtin_return_address(0)
In-Reply-To: <alpine.LFD.2.00.0905030816050.7072@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0905030821290.7144@localhost.localdomain>
References: <Pine.LNX.4.64.0905031513410.32397@melkki.cs.Helsinki.FI> <alpine.LFD.2.00.0905030816050.7072@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 May 2009, Robert P. J. Day wrote:

> On Sun, 3 May 2009, Pekka J Enberg wrote:
>
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> >
> > This patch changes SLQB to use the shorter _RET_IP_ form for consistency
> > with SLUB and to prepare SQLB for eventual kmemtrace hooks.
>
> ... big snip ...
>
> >  void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
> >  {
> > -	return __kmem_cache_alloc(s, gfpflags, __builtin_return_address(0));
> > +	return __kmem_cache_alloc(s, gfpflags, _RET_IP_);
> >  }
>
>   since i originally pointed out this possible simplification, i might
> as well also point out that the above is not necessarily correct.  in
> include/linux/kernel.h:
>
> #define _RET_IP_   (unsigned long)__builtin_return_address(0)
>
> as in, _RET_IP_ represents the **(unsigned long)** cast of that
> (void*) value.  so, technically, that's not merely an aesthetic
> replacement.  is that still what you wanted?

  whoops, never mind, i didn't read far enough to notice you were
making that change throughout the code.  carry on.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
