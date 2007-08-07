Return-Path: <linux-kernel-owner+w=401wt.eu-S934628AbXHGUpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934628AbXHGUpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbXHGUo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:44:59 -0400
Received: from brick.kernel.dk ([87.55.233.238]:3851 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871AbXHGUo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:44:58 -0400
Date: Tue, 7 Aug 2007 22:44:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: dragoran <drago01@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: allow non root users to set io priority "idle" ?
Message-ID: <20070807204449.GA5245@kernel.dk>
References: <46B6EDCB.6030806@gmail.com> <p73zm14lxyy.fsf@bingen.suse.de> <46B6F75D.1070808@gmail.com> <20070806103553.GA16133@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806103553.GA16133@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06 2007, Andi Kleen wrote:
> > couldn't this be fixed by bumping idle tasks to middle while they hold a 
> 
> Usually to high.
> 
> But it's all complicated and hasn't been done consistently
> (there are real time mutexes in the -rt kernel for example, 
> but there are lots of other locks and they have higher overhead too) 
> and it's unclear we really want to do all this complexity anyways.
> 
> Also as I said the problem could then still happen in user space
> which then would all need to be fixed to handle PI too.
> 
> In some cases the relationship is also not as simple as a single 
> lock. And for IO handling it would be likely quite hard.
> 
> I personally always found idle priorities quite dubious because
> even if they worked reliable for the CPU they will clear your cache/
> load your memory controller and impact all other programs because
> of this. And for the disk they will cause additional seeks which are 
> also very costly.

But that is why the idle priority implementation in CFQ adds a grace
period before idle prio tasks are run. So that concern should not be an
issue, if so the grace period needs to be enlarged. That at least covers
the seek side of things. If idle io tasks run, then the IO load on the
system must be very low to zero. Hence other IO relevant resource
contention isn't an iissue.

-- 
Jens Axboe

