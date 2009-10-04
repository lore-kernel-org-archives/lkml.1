Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbZJDS5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbZJDS5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 14:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbZJDS5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 14:57:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55832 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbZJDS5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 14:57:19 -0400
Date: Sun, 4 Oct 2009 20:56:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Leonidas ." <leonidas137@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: GFP_NOWAIT and GFP_NOMEMALLOC
Message-ID: <20091004185627.GA1378@ucw.cz>
References: <f22d86810909290425s46406fe5ib00bcfc9673f70df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f22d86810909290425s46406fe5ib00bcfc9673f70df@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-09-29 16:55:24, Leonidas . wrote:
> Hi list,
> 
> I am new here, I have googled/binged enough before posting this message,
> in case of redundancy please point me to appropriate links/resources etc.
> 
> I want to kmalloc memory while holding spinlocks in process context, here I
> can't use GFP_KERNEL flag since it can sleep. Using GFP_ATOMIC guarantees
> that allocation will succeed by allocating from emergency pools if needed.
> But I dont think, I need to use emergency pool and I want to limit my memory
> consumption to ZONE_NORMAL without sleeping, my module is ready to handle
> the allocation failure if any.

Umm. Either preallocate, or use gfp_atomic. It should be ok.

> Something like,
> 
> ptr =  kmalloc(..., GFP_KERNEL | GFP_DONT_SLEEP );
> 
> if( !ptr ) {
> 
>  /*GFP_KERNEL failed, Use GFP_ATOMIC pool*/
>  ptr =  kmalloc(..., GFP_ATOMIC );
> 
> }
> /*Go ahead and do stuff*/

That's pretty stupid, no? Just alloc GFP_ATOMIC directly... oh and
check return values...
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
