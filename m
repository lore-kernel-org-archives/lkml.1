Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbZDYWKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbZDYWKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 18:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZDYWKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 18:10:17 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:38422 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbZDYWKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 18:10:16 -0400
Date: Sat, 25 Apr 2009 18:09:11 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Introduce a boolean "single_bit_set" function.
In-Reply-To: <20090424104651.7c751735.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0904251808320.4803@localhost.localdomain>
References: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain> <49F0C817.8050407@caviumnetworks.com> <20090423165723.16c9f566.akpm@linux-foundation.org> <alpine.LFD.2.00.0904240632240.16107@localhost.localdomain>
 <20090424104651.7c751735.akpm@linux-foundation.org>
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

On Fri, 24 Apr 2009, Andrew Morton wrote:

> On Fri, 24 Apr 2009 06:40:39 -0400 (EDT) "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
>
> >   so it would be a simple matter to define the bit set boolean in
> > terms of hweight_long(), yes?  so what about, in bitops.h:
> >
> >   static inline bool
> >   exactly_one_bit_set(unsigned long w)
> >   {
> > 	return hweight_long(w) == 1;
> >   }
> >
> >   static inline bool
> >   more_than_one_bit_set(unsigned long w)
> >   {
> > 	return hweight_long(w) > 1;
> >   }
> >
> > or something to that effect, *if* people think it's worth it.
> > obviously, none of the above is strictly necessary, but it would make
> > a lot of code semantically cleaner.
> >
>
> Doing plain old
>
> 	if (hweight32(foo) == 1)
>
> (say) at the call sites quite clearly expresses what the code is trying
> to do.

  yes, that seems reasonable.  but would you really prefer "hweight32"
over "hweight_long"?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
