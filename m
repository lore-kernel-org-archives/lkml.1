Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbXKWUQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbXKWUQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 15:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337AbXKWUQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 15:16:39 -0500
Received: from waste.org ([66.93.16.53]:34945 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086AbXKWUQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 15:16:38 -0500
Date: Fri, 23 Nov 2007 14:09:13 -0600
From: Matt Mackall <mpm@selenic.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: 2.6.23 WARNING: at kernel/softirq.c:139 local_bh_enable()
Message-ID: <20071123200913.GE19691@waste.org>
References: <20071123105518.GA22062@2ka.mipt.ru> <20071123170756.GV19691@waste.org> <20071123175757.GA23991@2ka.mipt.ru> <20071123184851.GA14415@2ka.mipt.ru> <20071123185101.GA17582@2ka.mipt.ru> <20071123185906.GA23710@2ka.mipt.ru> <20071123191120.GA19691@waste.org> <20071123193222.GA22168@2ka.mipt.ru> <20071123194139.GC19691@waste.org> <20071123195410.GA11401@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071123195410.GA11401@2ka.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2007 at 10:54:11PM +0300, Evgeniy Polyakov wrote:
> On Fri, Nov 23, 2007 at 01:41:39PM -0600, Matt Mackall (mpm@selenic.com) wrote:
> > Here's another thought: move all this logic into the networking core,
> > unify it with current softirq zapper, then allow it to be called from
> > various other places (like atomic allocators). Then it'll all be in
> > central maintained place with more users.
> 
> This can be done quite easily - put a check into __kfree_skb() if
> netpoll is compiled-in and we are in hardirq context, then put skb
> into softirq freeing queue. Then zap_completion_queue() can free
> anything without ever knowing about nature of the packet, since this
> will be checked in __kfree_skb() anyway.

What I had in mind was moving the whole zap_completion_queue concept
into net/core/skbuff. So that netpoll (and, say, atomic kmalloc) can
simply call something like "clean_completion_queue".

-- 
Mathematics is the supreme nostalgia of our time.
