Return-Path: <linux-kernel-owner+w=401wt.eu-S1751212Ab0ABRnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212Ab0ABRnS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 12:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938Ab0ABRnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 12:43:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36495 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab0ABRnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 12:43:17 -0500
Date: Sat, 2 Jan 2010 18:43:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
Message-ID: <20100102174311.GA30016@basil.fritz.box>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com> <87bphc7heo.fsf@basil.nowhere.org> <20100102163644.GA5076@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100102163644.GA5076@nowhere>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I only have reiserfs partitions in my laptop and my testbox,
> nothing else. And that because I'm now maintaining it de facto.

AFAIK it's widely used in SUSE installations. It was the default
for a long time.

And right now as in 2.6.32 it's in a state of
"may randomly explode/deadlock". And no clear path out of it. Not good.

I am very concerned about destabilizing a widely used file system
like this. This has the potential to really hurt users.

> - that would require a notifier in schedule(), one notifier
>   per sub-bkl. That's horrible for performances. And for
>   the scheduler. I will be the first to NAK.

I thought the original idea was to find everything that 
can sleep in reiserfs and simply wrap it with lock dropping?

That should be roughly equivalent to the old BKL semantics.

Where did it go wrong?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
