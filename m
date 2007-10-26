Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbXJZTAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbXJZTAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbXJZTAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:00:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58844 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751413AbXJZTAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:00:39 -0400
Date: Fri, 26 Oct 2007 12:00:37 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071026120037.7b95a136.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	<alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	<20071025185506.8c373aa8.pj@sgi.com>
	<alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	<1193412644.5032.13.camel@localhost>
	<alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> If something that was previously unaccepted is now allowed with a 
> newly-introduced semantic, that's an API change.

Agreed, as I wrote earlier:
> It should work with libnuma and be
> fully upward compatible with current code (except perhaps code that
> depends on getting an error from requesting MPOL_INTERLEAVE on a node
> not allowed.)

Without at least this sort of change to MPOL_INTERLEAVE nodemasks,
allowing either empty nodemasks (Lee's proposal) or extending them
outside the current cpuset (what I'm cooking up now), there is no way
for a task that is currently confined to a single node cpuset to say
anything about how it wants be interleaved in the event that it is
subsequently moved to a larger cpuset.  Currently, such a task is only
allowed to pass exactly one particular nodemask to set_mempolicy
MPOL_INTERLEAVE calls, with exactly the one bit corresponding to its
current node.  No useful information can be passed via an API that only
allows a single legal value.

But you knew that ...

You were just correcting my erroneously unqualified statement.  Good.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
