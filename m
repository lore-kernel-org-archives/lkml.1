Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZCFQqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZCFQqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZCFQqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:46:14 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:47621 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZCFQqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:46:13 -0500
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090306162337.GA3040@us.ibm.com>
References: <20090305163857.0C18F3FD@kernel>
	 <20090305174037.GA2274@x200.localdomain> <1236280567.22399.99.camel@nimitz>
	 <20090305210840.GA2499@x200.localdomain>
	 <1236288427.22399.122.camel@nimitz>
	 <20090305220044.GA2819@x200.localdomain>
	 <1236291865.22399.139.camel@nimitz> <20090306143425.GA31250@us.ibm.com>
	 <1236354509.10626.29.camel@nimitz>  <20090306162337.GA3040@us.ibm.com>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 08:46:05 -0800
Message-Id: <1236357965.10626.51.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 10:23 -0600, Serge E. Hallyn wrote:
> Which imo is fine, but my question is whether that leaves any actual
> value in the persistent per-resource uncheckpointable flag.

OK, let's take a look back at this discussion a little bit and how we
got here.

Ingo quotes:
> Yeah, per resource it should be. That's per task in the normal 
> case - except for threaded workloads where it's shared by 
> threads.

> Uncheckpointable should be a one-way flag anyway. We want this 
> to become usable, so uncheckpointable functionality should be as 
> painful as possible, to make sure it's getting fixed ...

> Is there any automated test that could discover C/R breakage via 
> brute force? All that matters in such cases is to get the "you 
> broke stuff" information as soon as possible. If it comes at an 
> early stage developers can generally just fix stuff.

You add these things together and you get what I posted.  My patch is:
1. per resource
2. has a one way flag
3. Gives messages to developers at an early stage (dmesg) and lets them
   explore it more thoroughly (/proc)

But, these "early stage" messages are completely opposed to an approach
that uses sys_checkpoint() in some form (like with a -1 fd as an
argument).

Think of it like lockdep.  We *could* have designed lockdep to simply
give us a nice message whenever we do an a/b b/a deadlock.  That would
be helpful.  Or, we could design it to record all lock acquisitions that
didn't deadlock to see if they ever possibly deadlock.  (We did the
second one, btw).  That gave an early, useful, warning that developers
could fix before we encounter an actual problem.  I'm advocating such a
mechanism for c/r.  

-- Dave

