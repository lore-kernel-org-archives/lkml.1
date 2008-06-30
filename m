Return-Path: <linux-kernel-owner+w=401wt.eu-S1763993AbYF3Trn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763993AbYF3Trn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764172AbYF3TrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:47:24 -0400
Received: from www.tglx.de ([62.245.132.106]:47782 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764139AbYF3TrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:47:23 -0400
Date: Mon, 30 Jun 2008 21:46:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [git pull] core kernel fixes
In-Reply-To: <19f34abd0806301143u2067d593kf162d7419b653a8b@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0806302145140.3297@apollo.tec.linutronix.de>
References: <20080630153200.GA22360@elte.hu>  <19f34abd0806301002o7bdbd3a3y63d4d036ce5c26b0@mail.gmail.com>  <20080630182038.GA32211@elte.hu> <19f34abd0806301143u2067d593kf162d7419b653a8b@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, Vegard Nossum wrote:
> On Mon, Jun 30, 2008 at 8:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > The patch was tested with our standard tests so it's certainly good in
> > practice - but i havent specifically tried your testcase (maybe Thomas
> > has). Can you see any problem with the fix?
> 
> Well, what I can see is that the patch that was committed has some
> missing changes. In Daniel's patch:
> 
> -repeat:
> -	spin_lock(&pool_lock);
> +	spin_lock_irqsave(&pool_lock, flags);
>  	if (obj_pool.first) {
>  		obj	    = hlist_entry(obj_pool.first, typeof(*obj), node);
> 
> The patch that was committed:
> 
> -repeat:
>         spin_lock(&pool_lock);
>         if (obj_pool.first) {
>                 obj         = hlist_entry(obj_pool.first, typeof(*obj), node);
> 
> Was it not necessary to make the pool lock irq-safe in this place?
> 
> For reference:
> 
> Daniel's patch: http://lkml.org/lkml/2008/6/15/27
> Actual commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=70c85057e0bde35eb56352a293ecb5d1641a0334;hp=e6100f23375c0c71ce595d04551fa6553b611918

alloc_object() is called with interrupts disabled from __debug_object_init()

Thanks,
	tglx
 
