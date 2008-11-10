Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYKJFab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYKJFab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 00:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYKJFaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 00:30:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:46783 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbYKJFaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 00:30:19 -0500
Message-ID: <4917C6DD.4010500@kernel.org>
Date: Mon, 10 Nov 2008 14:30:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: request to revert libata-convert-to-block-tagging patches
References: <4917C449.2080504@kernel.org>
In-Reply-To: <4917C449.2080504@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Nov 2008 05:30:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> #1 is easy to fix but #2 requires either adding a spinlock or two atomic
> variables to struct blk_queue_tag to keep the current behavior while
> guaranteeing that tags are used in order.  Also, there's delay between
> libata marks a request complete and the request actually gets completed
> and the tag is freed.  If another request gets issued inbetween, the tag
> number can't be guaranteed.  This can be worked around by re-mapping tag
> number in libata depending on command type but, well then, it's worse
> than the original implementation.

I think this can be made to work by making tag free synchronous (ie.
doing it when the request is passed over to softirq) but I don't think
things like that should go into 2.6.28 at this point.

Thanks.

-- 
tejun
