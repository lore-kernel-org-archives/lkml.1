Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbYKKTVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbYKKTVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 14:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYKKTVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 14:21:13 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:56777 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbYKKTVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 14:21:12 -0500
Date: Tue, 11 Nov 2008 20:19:36 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Problems with the block-layer timeouts
Message-ID: <20081111191936.GK26778@kernel.dk>
References: <20081111155458M.fujita.tomonori@lab.ntt.co.jp> <Pine.LNX.4.44L0.0811111205390.29125-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0811111205390.29125-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11 2008, Alan Stern wrote:
> On Tue, 11 Nov 2008, FUJITA Tomonori wrote:
> 
> > I don't worry about anything. I just think that these round_jiffies_up
> > are pointless because they were added for the block-layer users that
> > care about exact timeouts, however the block-layer doesn't export
> > blk_add_timer() so the block-layer users can't control the exact time
> > when the timer starts. So doing round_jiffies_up calculation per every
> > request doesn't make sense for me.
> 
> In fact the round_jiffies_up() routines were added for other users as
> well as the block layer.  However none of the others could be changed
> until the routines were merged.  Now that the routines are in the 
> mainline, you should see them start to be called in multiple places.
> 
> Also, the users of the block layer _don't_ care about exact timeouts.  
> That's an important aspect of round_jiffies() and round_jiffies_up() --
> you don't use them if you want an exact timeout.
> 
> The reason for using round_jiffies() is to insure that the timeout
> will occur at a 1-second boundary.  If several timeouts are set for
> about the same time and they all use round_jiffies() or
> round_jiffies_up(), then they will all occur at the same tick instead
> of spread out among several different ticks during the course of that
> 1-second interval.  As a result, the system will need to wake up only
> once to service all those timeouts, instead of waking up several
> different times.  It is a power-saving scheme.

I can't add anything else, can't say it any better either. The main
point of using round_jiffies_up() is to align with other timers. I don't
understand why you (Tomo) think that timeouts are exact? They really are
not, and within the same second is quite adequate here.

-- 
Jens Axboe

