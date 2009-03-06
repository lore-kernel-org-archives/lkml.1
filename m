Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbZCFTmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbZCFTmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZCFTmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:42:12 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59407 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbZCFTmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:42:11 -0500
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090306182451.GA6307@us.ibm.com>
References: <20090305174037.GA2274@x200.localdomain>
	 <1236280567.22399.99.camel@nimitz> <20090305210840.GA2499@x200.localdomain>
	 <1236288427.22399.122.camel@nimitz>
	 <20090305220044.GA2819@x200.localdomain>
	 <1236291865.22399.139.camel@nimitz> <20090306143425.GA31250@us.ibm.com>
	 <1236354509.10626.29.camel@nimitz> <20090306162337.GA3040@us.ibm.com>
	 <1236357965.10626.51.camel@nimitz>  <20090306182451.GA6307@us.ibm.com>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 11:42:04 -0800
Message-Id: <1236368524.10626.96.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 12:24 -0600, Serge E. Hallyn wrote:
> > But, these "early stage" messages are completely opposed to an approach
> > that uses sys_checkpoint() in some form (like with a -1 fd as an
> > argument).
> 
> Well I disagree with that.  The 'early stage' messages could be seen as
> either:
> 
>         1. a short-term way to prioritize resources to support
>         or
>         2. a long-term way to catch new resources introduced
>         without checkpoint/restart support
> 
> I don't believe 2. would work.  I think 1. would work, but that we
> risk imposing permanent code changes to support a temporary goal.

I should be a bit more clear.  My goal (and I think Ingo's) here is to
come up with a mechanism that will make the checkpoint feature less
likely to break once we merge it into the tree.  I'm looking for a tool
that people can utilize, even if they don't necessarily care about
checkpoint/restart.

If we *completely* depend on sys_checkpoint() as the interface for
determining if we are checkpointable, we don't have such a tool.  We
have a tool that the checkpoint/restart developers and probably some
testers can and certainly will use.  This is still very, very useful.
But, it probably won't ever generate a bug report from anyone who
doesn't specifically care about c/r.

As far as detecting *new* resources.  Well, crap.  I don't think our
little ->may_checkpoint flags can do that.  My little f_op trick will
help and is better than nothing.  But, as you noted, it is far from
perfect because we'll probably have people just copying the generic*
functions into new code.

-- Dave

