Return-Path: <linux-kernel-owner+w=401wt.eu-S936279AbZDIUFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936279AbZDIUFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932364AbZDIUFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:05:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:28460 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763588AbZDIUFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:05:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GVc6h9fVLM6nAnZVS2yBLDD9xRCAybhVBLUhutuJJ9TzjV6qVg/Mq9V3uvouwWFTBL
         jSojXrtijYZcJqvnRSxZcveQ2QEHgqjIzk8KePbELrf4TMyrSlN0MdmpaLK/fCGrVx3k
         op/A2JB4BX3aRScx9nSqAcDjkVnc75tppxbl0=
Date: Thu, 9 Apr 2009 22:05:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] reiserfs: kill-the-BKL
Message-ID: <20090409200530.GB6033@nowhere>
References: <1239070789-13354-1-git-send-email-fweisbec@gmail.com> <87tz4x97uq.fsf@basil.nowhere.org> <alpine.LFD.2.00.0904090831000.4583@localhost.localdomain> <20090409184022.GA2665@elte.hu> <20090409193635.GO14687@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409193635.GO14687@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 09:36:35PM +0200, Andi Kleen wrote:
> > Using a mutex seems like the sane choice here. I'd advocate spinlocks 
> > for a new filesystem any day (but even there it's a fine choice to have 
> > a mutex, if top of the line scalability is not an issue).
> > 
> > But for a legacy filesystem like reiser3, which depended on the BKL 
> 
> reiser3 is much more widely used in the user base than a lot of "non 
> legacy" file systems. It's very likely it has significantly
> more users than ext4 for example. Remember that it was the default file system
> for a major distribution until very recently. I also got a few
> reiser3 fs still around, it tended to perform very well
> on kernel hacker workloads.
> 
> Given all that I think the current performance penalties Frederic reports
> are not acceptable. Dropping BKL is not a cause in itself, but should
> just improve performance.


It's not only about performances, latency is also a fair goal here.
Moreover, reiserfs is not the only one concerned while dropping its
Bkl, this is one big source of contention less for the rest of the system.

And concerning performance, I'm working on it :-)

Frederic.


> > auto-dropping on schedule() it would be rather fragile to use spinlocks, 
> > and it would take forever to validate the result. 
> 
> Not convinced it would be that hard. It could be probably done with some 
> straight forward static code analysis. And after that since there's
> not much development going anymore it's unlikely to break again.
> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.

