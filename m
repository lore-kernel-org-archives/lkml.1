Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbXGYEfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbXGYEfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 00:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbXGYEfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 00:35:12 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:47233 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212AbXGYEfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 00:35:10 -0400
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Fengguang Wu <fengguang.wu@gmail.com>, Dave Jones <davej@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>
In-Reply-To: <46A46E4B.7050007@yahoo.com.au>
References: <20070721210005.000228000@chello.nl>
	 <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com>
	 <20070722081010.GA6317@mail.ustc.edu.cn>
	 <1185093236.6344.87.camel@localhost.localdomain>
	 <46A46E4B.7050007@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 00:35:06 -0400
Message-Id: <1185338106.7105.44.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-23-07 at 19:00 +1000, Nick Piggin wrote:

> I don't like this kind of conditional information going from something
> like readahead into page reclaim. Unless it is for readahead _specific_
> data such as "I got these all wrong, so you can reclaim them" (which
> this isn't).
> 
> But I don't like it as a use-once thing. The VM should be able to get
> that right.
> 


Question: How work the use-once code in the current kernel? Is there
any? I doesn't quite work for me...

See my previous email today, I've done a small test case to demonstrate 
the problem and the effectiveness of Peter's patch.  The only piece
missing is the copy case (read once + write once).

Regardless of how it's implemented, I think a similar mechanism must be
added. This is a long standing issue.

In the end, I think it's a pagecache resources allocation problem. the
VM lacks fair-share limits between processes. The kernel doesn't have
enough information to make the right decisions.

You can refine or use more advanced page reclaim, but some fair-share
splitting (like the CPU scheduler) between the processes must be
present.  Of course some process should have large or unlimited VM
limits, like databases.

Maybe the "containers" patchset and memory controller can help.  With
some specific configuration and/or a userspace daemon to adjust the
limits on the fly.

Independently, the basic large file streaming read (or copy) once cases
should not trash the pagecache. Can we agree on that?

I say, let's add some code to fix the problem.  If we hear about any
regression in some workloads, we can add a tunable to limit or disable
its effects, _if_ a better compromised solution cannot be found.

Surely it's possible to have a acceptable solution.

Best regards,

- Eric


