Return-Path: <linux-kernel-owner+w=401wt.eu-S936224AbZDITe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936224AbZDITe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 15:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933648AbZDITeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 15:34:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60628 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327AbZDITeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 15:34:14 -0400
Date: Thu, 9 Apr 2009 21:36:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] reiserfs: kill-the-BKL
Message-ID: <20090409193635.GO14687@one.firstfloor.org>
References: <1239070789-13354-1-git-send-email-fweisbec@gmail.com> <87tz4x97uq.fsf@basil.nowhere.org> <alpine.LFD.2.00.0904090831000.4583@localhost.localdomain> <20090409184022.GA2665@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409184022.GA2665@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Using a mutex seems like the sane choice here. I'd advocate spinlocks 
> for a new filesystem any day (but even there it's a fine choice to have 
> a mutex, if top of the line scalability is not an issue).
> 
> But for a legacy filesystem like reiser3, which depended on the BKL 

reiser3 is much more widely used in the user base than a lot of "non 
legacy" file systems. It's very likely it has significantly
more users than ext4 for example. Remember that it was the default file system
for a major distribution until very recently. I also got a few
reiser3 fs still around, it tended to perform very well
on kernel hacker workloads.

Given all that I think the current performance penalties Frederic reports
are not acceptable. Dropping BKL is not a cause in itself, but should
just improve performance.

> auto-dropping on schedule() it would be rather fragile to use spinlocks, 
> and it would take forever to validate the result. 

Not convinced it would be that hard. It could be probably done with some 
straight forward static code analysis. And after that since there's
not much development going anymore it's unlikely to break again.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
