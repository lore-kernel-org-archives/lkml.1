Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736Ab0AYDmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0AYDmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 22:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883Ab0AYDmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 22:42:32 -0500
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:44813 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751404Ab0AYDmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 22:42:32 -0500
Date: Mon, 25 Jan 2010 14:41:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Don Mullis <don.mullis@gmail.com>, linux-kernel@vger.kernel.org,
       airlied@redhat.com, dedekind@infradead.org
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
Message-ID: <20100125034151.GL25842@discord.disaster>
References: <87fx609i29.fsf@gmail.com> <20100121175914.GA8910@basil.fritz.box> <87vdeu96bo.fsf@gmail.com> <87k4vah12u.fsf@basil.nowhere.org> <20100123082839.GB25842@discord.disaster> <20100123113551.GB29555@one.firstfloor.org> <20100123160537.GG25842@discord.disaster> <20100124205906.GC29555@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100124205906.GC29555@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 09:59:06PM +0100, Andi Kleen wrote:
> > Similarly, adding cond_resched() to list_sort means you can stop
> > worrying about the scheduling latency impact of sorting long lists.
> > I fail to see why you're making such a big deal out of this.....
> 
> It's not easy to add it to a low level library function like list_sort()
> because you would need to ensure that all callers are allowed to sleep.

might_sleep() annotations are typically used in this case....

> Or even if all callers currently allow it future ones might not.

You're trying to make this way more complex than the current
requirements need it to be.  Just declaring a simple rule -
"list_sort() can sleep" - and all these problems go away until
someone really needs list sorting in atomic context.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
