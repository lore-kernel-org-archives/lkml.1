Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZDNPaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZDNPaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZDNPaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:30:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:41711 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbZDNPaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:30:05 -0400
Date: Tue, 14 Apr 2009 10:29:51 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       dave@linux.vnet.ibm.com, mingo@elte.hu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/30] cr: core stuff
Message-ID: <20090414152951.GA7703@us.ibm.com>
References: <20090410023539.GK27788@x200.localdomain> <20090413214701.GA24509@us.ibm.com> <49E424A3.60606@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E424A3.60606@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> 
> Hi,
> 
> Serge E. Hallyn wrote:
> > Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > 
> > Hi Alexey,
> > 
> > as far as I can see, the main differences between this patch and the
> > equivalent in Oren's tree are:
> > 
> > 1. kernel auto-selects container init to freeze
> 
> Actually, this eliminates the possibility to checkpoint a subtree of
> tasks, which (under some obvious constraints) can be a handy feature.

Yes, I agree.  As Dave pointed out on irc yesterday, this patch shows a
very definate whole-container-only point of view which is worth
discussing.

> > 2. kernel freezes tasks
> 
> IMHO better to do it in userspace - that way userspace can accomplish
> other tasks while tasks are frozen, such as snapshot the filesystem,
> or block/unblock the network.

That's a good point.

> Is there a good argument to do it kernel ?

Convenience?  I guess you don't have to worry about getting your
checkpoint job into a cgroup by itself ahead of time.

> > 3. no objhash taking references
> > 4. no hbuf
> > 5. always require CAP_SYS_ADMIN
> 
> I'm now convinced (thanks, Serge!) that it's better not to require
> this unless we strictly have to.

:)  Cool.

I think the perceived need for it comes, as above, from the pure
checkpoint-a-whole-container-only view.  So long as you will
checkpoint/restore a whole container, then you'll end up doing
something requiring privilege anyway.  But that is not all of
the use cases.

-serge
