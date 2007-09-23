Return-Path: <linux-kernel-owner+w=401wt.eu-S1756476AbXIWDSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbXIWDSt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 23:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbXIWDSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 23:18:40 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:61940 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbXIWDSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 23:18:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=T8ob4QkqYs9qWaQTZOLxfEThv8gvmPJgRkAlVGwm6UWa4aO1M6wfUlJCGMsgd399FHN15ljD+v76ZHoebUSPiAGnvB8PA/uTE97EL6kYguFhmGXF2bwCQf19f9MD2QrE6BoyA5LDoUUM0L5U14ARnfinBGyefI1nateYaVHqoLE=
Date: Sun, 23 Sep 2007 11:14:30 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Gerhard Mack <gmack@innerfire.net>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Dave Haywood <tla@oak.selfip.net>,
       linux-kernel@vger.kernel.org
Subject: Re: linux 2.6.23-rc7 - 14 compile warnings
Message-ID: <20070923031430.GJ2475@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <46F39004.4050106@oak.selfip.net> <20070922022932.GC2480@hacking> <alpine.DEB.0.999.0709222212050.27608@mtl.rackplans.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.999.0709222212050.27608@mtl.rackplans.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 10:23:59PM -0400, Gerhard Mack wrote:
>On Sat, 22 Sep 2007, WANG Cong wrote:
>
>> >Summary:
>> >  CC      mm/slub.o
>> >mm/slub.c: In function 'kfree':
>> >mm/slub.c:2491: warning: passing argument 3 of 'slab_free' discards
>> >qualifiers from pointer target type
>
>static void __slab_free(struct kmem_cache *s, struct page *page,
>                                        void *x, void *addr)
>but ..
>
>void kfree(const void *x)
>
>void is not the same as const void.
>					
>> >  CC      fs/autofs4/symlink.o
>> >fs/autofs4/symlink.c: In function 'autofs4_follow_link':
>> >fs/autofs4/symlink.c:18: warning: passing argument 2 of 'nd_set_link'
>> >discards qualifiers from pointer target type
>
>Once again ino->u.symlink is a const char and it's dropping the const.
>

slab_free(s, page, (void *)x, __builtin_return_address(0));
                   ^^^^^^^^^
I knew these things. But the explicit casts, such as the above one, mean
that we are intended to discard to qualifiers and I think gcc shouldn't
warn about this.

Regards.


WANG Cong

