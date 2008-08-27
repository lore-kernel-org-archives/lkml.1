Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbYH0HoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbYH0HoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbYH0HoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:44:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37782 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbYH0HoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:44:16 -0400
X-Greylist: delayed 1491 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2008 03:44:16 EDT
Date: Wed, 27 Aug 2008 09:19:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] block bits
Message-ID: <20080827071921.GY20055@kernel.dk>
References: <20080826070640.GR20055@kernel.dk> <alpine.LFD.1.10.0808261009180.3363@nehalem.linux-foundation.org> <20080826185636.GP20055@kernel.dk> <alpine.LFD.1.10.0808261201420.3363@nehalem.linux-foundation.org> <20080826191031.GQ20055@kernel.dk> <48B471B4.9030202@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B471B4.9030202@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26 2008, Jeremy Fitzhardinge wrote:
> Jens Axboe wrote:
> > On Tue, Aug 26 2008, Linus Torvalds wrote:
> >   
> >> On Tue, 26 Aug 2008, Jens Axboe wrote:
> >>     
> >>> I'll move those 1-2 patches to the 2.6.28 branch and resubmit the rest
> >>> for you.
> >>>       
> >> You will *delete* the absolute crap locking patch, that has no way of 
> >> being even 2.6.28 material.
> >>     
> >
> > Yeah, I thought that was obvious, I'll bounce it back to the Xen folks.
> >   
> 
> Which, what?  Was there an objection to one of the blkfront patches?  (I
> don't remember anything locking related in there anyway.)

I see Linus' initial reply didn't make it to the list, not sure why.
This is what he said:

"it's so _incredibly_ broken that I refuse to pull any of the rest
either, because the queue is obviously utter crap.

In fact, even the "explanation" for that one is shit:

   "It shouldn't matter if an interrupt comes in whilst blkif_io_lock is
    held, as it will block on the lock [...]"

where "as it will block" is apparently shorthand for "as it will
deadlock and kill the machine"."

This is the patch in question:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=b58e9034c5e2424723948a63712eaf1332a76ab8;hp=5814f8d589a1daef3b1a6f3731fd65a858dc8466

and it doesn indeed look like crap. It DOES matter if an interrupt comes
in on the local CPU while you are holding the blkif_io_lock, you'd be
dead on the spot spinning forever in the irq handler.

-- 
Jens Axboe

