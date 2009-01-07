Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbZAGXsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbZAGXsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbZAGXsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:48:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755423AbZAGXsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:48:31 -0500
Date: Wed, 7 Jan 2009 15:47:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git pull] scheduler fix
In-Reply-To: <20090107222641.GA27541@elte.hu>
Message-ID: <alpine.LFD.2.00.0901071543550.3057@localhost.localdomain>
References: <20090107222641.GA27541@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Jan 2009, Ingo Molnar wrote:
> +		/*
> +		 * Should not call ttwu while holding a rq->lock
> +		 */
> +		spin_unlock(&this_rq->lock);
>  		if (active_balance)
>  			wake_up_process(busiest->migration_thread);
> +		spin_lock(&this_rq->lock);

Btw, this isn't the first time we've wanted to do a wakeup while 
potentially locked.

Is there any way to perhaps go a "wake_up_gentle()" that doesn't need the 
lock, and just basically does a potentially delayed wakeup by just 
scheduling it asynchronously.

That would have solved all those nasty printk issues too. These kinds of 
things don't need the strict "wake up NOW" behaviour - they are more of a 
"kick the dang thing and make sure it wakes up in some timely manner".

		Linus
