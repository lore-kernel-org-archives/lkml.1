Return-Path: <linux-kernel-owner+w=401wt.eu-S1764138AbXHHNaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764138AbXHHNaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765452AbXHHN3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:29:53 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:44767 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432AbXHHN3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:29:51 -0400
Date: Wed, 8 Aug 2007 17:28:53 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Daniel Phillips <phillips@phunq.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [1/1] Block device throttling [Re: Distributed storage.]
Message-ID: <20070808132853.GA19488@2ka.mipt.ru>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708051423.45484.phillips@phunq.net> <20070807120523.GX5245@kernel.dk> <200708071124.56859.phillips@phunq.net> <20070807205538.GB5245@kernel.dk> <20070808095448.GA3440@2ka.mipt.ru> <20070808101708.GA23815@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808101708.GA23815@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 02:17:09PM +0400, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> This throttling mechanism allows to limit maximum amount of queued bios 
> per physical device. By default it is turned off and old block layer 
> behaviour with unlimited number of bios is used. When turned on (queue
> limit is set to something different than -1U via blk_set_queue_limit()),
> generic_make_request() will sleep until there is room in the queue.
> number of bios is increased in generic_make_request() and reduced either
> in bio_endio(), when bio is completely processed (bi_size is zero), and
> recharged from original queue when new device is assigned to bio via
> blk_set_bdev(). All oerations are not atomic, since we do not care about
> precise number of bios, but a fact, that we are close or close enough to
> the limit.
> 
> Tested on distributed storage device - with limit of 2 bios it works
> slow :)

As addon I can cook up a patch to configure this via sysfs if needed.
Thoughts?

-- 
	Evgeniy Polyakov
