Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbYDXPF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbYDXPF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYDXPFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:05:48 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10625 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbYDXPFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:05:47 -0400
Date: Thu, 24 Apr 2008 17:05:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
Message-ID: <20080424150533.GE12774@kernel.dk>
References: <480F8936.5030406@hp.com> <87ve27gz4u.fsf@basil.nowhere.org> <67E36C56-E149-4C87-8788-05BA43C1C2AD@kernel.dk> <48109571.70905@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48109571.70905@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24 2008, Alan D. Brunelle wrote:
> Jens Axboe wrote:
> > On 24/04/2008, at 15.29, Andi Kleen <andi@firstfloor.org> wrote:
> > 
> >> "Alan D. Brunelle" <Alan.Brunelle@hp.com> writes:
> >>
> >>> The block I/O + elevator + I/O scheduler code spends a lot of time
> >>> trying to merge I/Os -- rightfully so under "normal" circumstances.
> >>> However, if one were to know that the incoming I/O stream was /very/
> >>> random in nature, the cycles are wasted. (This can be the case, for
> >>> example, during OLTP-type runs.)
> >>>
> >>> This patch stream adds a per-request_queue tunable that (when set)
> >>> disables merge attempts, thus freeing up a non-trivial amount of CPU
> >>> cycles.
> >>
> >> It sounds interesting. But explicit tunables are always bad because
> >> they will be only used by a elite few. Do you think it would be
> >> possible instead to keep some statistics on how successfull merging is
> >> and
> >> when the success rate is very low disable it automatically for some
> >> time until a time out?
> >>
> >> This way nearly everybody could get most of the benefit from this
> >> change.
> > 
> > Not a good idea IMHO, it's much better with an explicit setting. That
> > way you don't introduce indeterministic behavior.
> 
> Another way to attack this would be to have a user level daemon "watch
> things" -
> 
> o  We could leave 'nomerges' alone: if someone set that, they "know"
> what they are doing, and we just don't attempt merges. [This tunable
> would really be for the "elite few" - those that no which devices are
> used in which ways - people that administer Enterprise load environments
> tend to need to know this.]
> 
> o  The kernel already exports stats on merges, so the daemon could watch
> those stats in comparison to the number of I/Os submitted. If it
> determined that merge attempts were not being very successful, it could
> turn off merges for a period of time. Later it could turn them back on,
> watch for a while, and repeat.
> 
> Does this sound better/worthwhile?

That's is true, you could toggle this from a user daemon if you wish. I
still think it's a really bad idea, but at least then it's entirely up
to the user. I'm not a big fan of such schemes, to say the least.

-- 
Jens Axboe

