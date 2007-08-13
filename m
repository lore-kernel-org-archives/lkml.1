Return-Path: <linux-kernel-owner+w=401wt.eu-S947751AbXHMO6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947751AbXHMO6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970897AbXHMMZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:25:05 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:38852 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S971400AbXHMMZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:25:01 -0400
Date: Mon, 13 Aug 2007 16:24:51 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Daniel Phillips <phillips@phunq.net>
Cc: Jens Axboe <jens.axboe@oracle.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Block device throttling [Re: Distributed storage.]
Message-ID: <20070813122451.GA30059@2ka.mipt.ru>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708130404.26572.phillips@phunq.net> <20070813120417.GA5992@2ka.mipt.ru> <200708130518.14974.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708130518.14974.phillips@phunq.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 05:18:14AM -0700, Daniel Phillips (phillips@phunq.net) wrote:
> > If limit is for 
> > 1gb of pending block io, and system has for example 2gbs of ram (or
> > any other resonable parameters), then there is no way we can deadlock
> > in allocation, since it will not force page reclaim mechanism.
> 
> The problem is that sk_alloc (called from our block driver via 
> socket->write) would recurse into shrink_pages, which recursively 
> submits IO to our block driver and blocks on the throttle.  Subtle 
> indeed, and yet another demonstration of why vm recursion is a Bad 
> Thing.
>
> I will find a traceback for you tomorrow, which makes this deadlock much 
> clearer.

I see how it can happen, but device throttling is a solution we are
trying to complete, which main aim _is_ to remove this problem.

Lower per-device limit, so that the rest of the RAM allowed to
allocate all needed data structures in the network path.
Above example just has 1gb of ram, which should be enough for skbs, if
it is not, decrease limit to 500 mb and so on, until weighted load of
the system allows to always have a forward progress.

-- 
	Evgeniy Polyakov
