Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153AbXINHAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbXINHAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 03:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbXINHAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 03:00:38 -0400
Received: from brick.kernel.dk ([87.55.233.238]:24313 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbXINHAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 03:00:38 -0400
Date: Fri, 14 Sep 2007 09:00:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] shared tag queue barrier comment
Message-ID: <20070914070020.GU25592@kernel.dk>
References: <20070914064112.GA25277@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914064112.GA25277@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14 2007, Nick Piggin wrote:
> 
> Should add some comments for the tag barriers (they won't be so important
> if we can switch over to the explicit _lock bitops, but for now we should
> make it clear).

Thanks!

> Jens' original patch said a barrier after the test_and_clear_bit was also
> required. I can't see why (and it would prevent the use of the _lock bitop).

Yeah, I don't think it's needed either. The important bit was ordering
the ->tag_index[tag] = NULL setting before clearing the bit, and as long
as those two operations are ordered, we are good to go. So the last
memory barrier was not needed.

-- 
Jens Axboe

