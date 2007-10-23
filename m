Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbXJWUUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbXJWUUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbXJWUUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:20:23 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27147 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbXJWUUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:20:22 -0400
Date: Tue, 23 Oct 2007 22:20:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071023202017.GI14671@kernel.dk>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <471E2A96.7050304@panasas.com> <20071023183321.GA14671@kernel.dk> <p738x5t4nbn.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p738x5t4nbn.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Andi Kleen wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> >> You might want to put a BUG_ON(page & 0x3); Make sure
> >> you're not loosing information. (The m68k problem)
> >
> > That's a really good idea, thanks Boaz! I'll add that.
> 
> It would be even better if you replaced all the magic numbers with defines
> or better accessors.

All? There are two numbers, and all are confined to scatterlist.h
privately. Except the one in blk_rq_map_sg(), which was done on purpose
since I don't want to export that knowledge to others. So we definitely
don't want accessors, I can name the two bit values but don't see much
point in doing it.

-- 
Jens Axboe

