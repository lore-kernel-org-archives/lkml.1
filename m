Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbXDPHZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbXDPHZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 03:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbXDPHZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 03:25:43 -0400
Received: from [212.12.190.243] ([212.12.190.243]:32863 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754041AbXDPHZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 03:25:43 -0400
From: Al Boldi <a1426z@gawab.com>
Subject: IOsched: AS improvements (was: [Announce] [patch] Modular Scheduler Core and Completely Fair)
Date: Mon, 16 Apr 2007 10:29:17 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200704161029.18023.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Actually, I would still like to be able to deprecate deadline for
> AS, because AS has a tunable that you can switch to turn off read
> anticipation and revert to deadline behaviour (or very close to).

You mean antic_expire?  I tried it, and it does have an enormous effect on 
performance.  Smaller values do mimic deadline behavior in a way, as 
deadline has some strange behaviour on sync, so it's closer to noop, which 
is good for single user/proc access, while larger values are good for multi 
user/proc access.  But I always have to set it to 0, or else it starves sync 
with others reading.

I wonder if these tunables couldn't be autotuned by some form of 
history-based access pattern detection?

> It would have been nice if CFQ were then a layer on top of AS that
> implemented priorities (or vice versa). And then AS could be
> deprecated and we'd be back to 1 primary scheduler.
>
> Well CFQ seems to be going in the right direction with that, however
> some large users still find AS faster for some reason...

AS is faster no-contest.  CFQ has some deep block-io/queue problem that slows 
it down up to 25%.  It's related to max_sectors_kb and read_ahead_kb , and I 
mentioned this to Jens before, and AS show this problem sometimes too, but 
with CFQ it's much more prevalent.


Thanks!

--
Al

