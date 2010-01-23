Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943Ab0AWQGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab0AWQGN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 11:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852Ab0AWQGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 11:06:13 -0500
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:41589 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755667Ab0AWQGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 11:06:12 -0500
Date: Sun, 24 Jan 2010 03:05:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Don Mullis <don.mullis@gmail.com>, linux-kernel@vger.kernel.org,
       airlied@redhat.com, dedekind@infradead.org
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
Message-ID: <20100123160537.GG25842@discord.disaster>
References: <87fx609i29.fsf@gmail.com> <20100121175914.GA8910@basil.fritz.box> <87vdeu96bo.fsf@gmail.com> <87k4vah12u.fsf@basil.nowhere.org> <20100123082839.GB25842@discord.disaster> <20100123113551.GB29555@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100123113551.GB29555@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 12:35:51PM +0100, Andi Kleen wrote:
> > Burning CPU time to save on IO is a very valid tradeoff in
> > filesystem design - burning a few hundred millieseconds of CPU
> > time can result in savcwinge tens of seconds of IO time. Hence
> > passing big long lists to be sorted is not an indication of broken
> > design, it's an indication of understanding CPU time vs IO time
> > tradeoffs during design...
> 
> Burning long CPU time in kernel code without latency breaker code is always
> a sign of broken design.

It's a characteristic of a sub-optimal implementation, not bad
design. Plenty of code has been fixed over the years simply by
adding cond_resched() to loops that have triggered latency
warnings.

Similarly, adding cond_resched() to list_sort means you can stop
worrying about the scheduling latency impact of sorting long lists.
I fail to see why you're making such a big deal out of this.....

Cheers

Dave.
-- 
Dave Chinner
david@fromorbit.com
