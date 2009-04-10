Return-Path: <linux-kernel-owner+w=401wt.eu-S935775AbZDJTgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935775AbZDJTgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 15:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932522AbZDJTgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 15:36:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47831 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759222AbZDJTgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 15:36:01 -0400
Date: Fri, 10 Apr 2009 21:34:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Al Viro <viro@ZenIV.linux.org.uk>, Mike Travis <travis@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unbreak alpha percpu
Message-ID: <20090410193444.GA18039@elte.hu>
References: <20090410151224.GM26366@ZenIV.linux.org.uk> <20090410154704.GN26366@ZenIV.linux.org.uk> <alpine.LFD.2.00.0904100915010.4583@localhost.localdomain> <20090410165030.GQ26366@ZenIV.linux.org.uk> <20090410170507.GR26366@ZenIV.linux.org.uk> <20090410171415.GA6033@ZenIV.linux.org.uk> <20090410180532.GA4419@jurassic.park.msu.ru> <alpine.LFD.2.00.0904101118470.4583@localhost.localdomain> <49DF935E.8030607@kernel.org> <49DF97D0.9090506@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DF97D0.9090506@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Long term, I think what Ivan proposed with a bit of addition so 
> that combination of DECLARE_PER_CPU() and static DEFINE_PER_CPU() 
> triggers compile error but I think it's better to do it when 
> converting non-x86 archs to dynamic percpu allocator which is 
> scheduled for the next merge window.  For the time being, how 
> about just moving the generic percpu_*() accessors to 
> linux/percpu.h?  asm-generic/percpu.h is meant to carry generic 
> stuff for low level stuff - declarations, definitions and pointer 
> offset calculation and so on but not for generic interface.
> 
> I currently can't build or test stuff so the patch is not tested 
> at all.  Ingo, can you please test whether this would work?

Yes - but i'm somewhat confused - i frequently cross-built Alpha and 
other architectures as well.

So exactly what problem do we have here - has some devel tree grown 
new use of these APIs in generic code, without waiting for all 
arches to be properly converted?

(sounds of rummaging around)

Oh drat:

| commit 4e69489a0ac11a9b62a25923975bfc370a30eae5
| Author: Eric Dumazet <dada1@cosmosbay.com>
| Date:   Sat Apr 4 16:41:09 2009 -0700
|
|     socket: use percpu_add() while updating sockets_in_use

Now i understand the rush ...

Yes, moving the APIs to the generic header should properly expose 
the wrapped default implementations. I'll test your patch in a 
minute.

	Ingo
