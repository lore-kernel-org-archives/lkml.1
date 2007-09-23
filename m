Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbXIWCYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbXIWCYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 22:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbXIWCYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 22:24:08 -0400
Received: from [69.90.0.18] ([69.90.0.18]:45413 "EHLO mtl.rackplans.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbXIWCYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 22:24:07 -0400
Date: Sat, 22 Sep 2007 22:23:59 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: WANG Cong <xiyou.wangcong@gmail.com>
cc: Dave Haywood <tla@oak.selfip.net>, linux-kernel@vger.kernel.org
Subject: Re: linux 2.6.23-rc7 - 14 compile warnings
In-Reply-To: <20070922022932.GC2480@hacking>
Message-ID: <alpine.DEB.0.999.0709222212050.27608@mtl.rackplans.net>
References: <46F39004.4050106@oak.selfip.net>
 <20070922022932.GC2480@hacking>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2007, WANG Cong wrote:

> >Summary:
> >  CC      mm/slub.o
> >mm/slub.c: In function 'kfree':
> >mm/slub.c:2491: warning: passing argument 3 of 'slab_free' discards
> >qualifiers from pointer target type

static void __slab_free(struct kmem_cache *s, struct page *page,
                                        void *x, void *addr)
but ..

void kfree(const void *x)

void is not the same as const void.
					
> >  CC      fs/autofs4/symlink.o
> >fs/autofs4/symlink.c: In function 'autofs4_follow_link':
> >fs/autofs4/symlink.c:18: warning: passing argument 2 of 'nd_set_link'
> >discards qualifiers from pointer target type

Once again ino->u.symlink is a const char and it's dropping the const.

> 
> These two warnings are suspicious. Explicit casts are already there, how
> they come out? Or gcc bugs?
> 

gcc is perfectly justified when warning about dropping const. 

	Gerhard


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
