Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbYDXPEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbYDXPEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYDXPEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:04:40 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10621 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbYDXPEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:04:40 -0400
Date: Thu, 24 Apr 2008 17:04:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
Message-ID: <20080424150425.GD12774@kernel.dk>
References: <480F8936.5030406@hp.com> <87ve27gz4u.fsf@basil.nowhere.org> <67E36C56-E149-4C87-8788-05BA43C1C2AD@kernel.dk> <4810961A.4000104@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4810961A.4000104@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24 2008, Andi Kleen wrote:
> 
> > Not a good idea IMHO, it's much better with an explicit setting. That
> > way you don't introduce indeterministic behavior.
> 
> So you would be deterministically slower.

Yes, absolutely. Think about the case for a second - the potential gain is in
fractions of a percent basically, the potential loss however is HUGE.
There's absolutely no way on earth I'd ever make this dynamic.

> Another way to avoid this problem would be to keep the statistics per
> IO context, then the same run of a program would always get the same
> behaviour. Drawback is that if your non mergeable workload consists of
> lots of short running processes (like a shell script) the optimization
> wouldn't work. Not sure if it's really practical, but it would be an option.

Complexity for basically zero gain, no thanks.

> I think in modern systems with caches etc. you typically have enough
> non quite deterministic and other surprising and hard to analyze
> behaviour anyways, so a little more doesn't make much difference.

Sorry Andi, but that is nonsense. Not merging IOs when you should can
cut your performance to a 5th or something of that order, it's an
entirely different ballgame.

-- 
Jens Axboe

