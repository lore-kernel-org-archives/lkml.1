Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbXJ0VXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbXJ0VXK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 17:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbXJ0VWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 17:22:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51757 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750749AbXJ0VWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 17:22:42 -0400
Date: Sat, 27 Oct 2007 14:22:39 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071027142239.0ded1e42.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710262134180.24687@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	<alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	<20071025185506.8c373aa8.pj@sgi.com>
	<alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	<1193412644.5032.13.camel@localhost>
	<alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
	<20071026120037.7b95a136.pj@sgi.com>
	<alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
	<1193433239.5032.95.camel@localhost>
	<alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
	<1193434278.5032.106.camel@localhost>
	<alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
	<20071026180713.aeedfac2.pj@sgi.com>
	<alpine.DEB.0.9999.0710262134180.24687@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> I prefer Choice B because it does not force mempolicies to have any 
> dependence on cpusets with regard to what nodemask is passed.

Yes, well said.

> It would be very good to store the passed nodemask to set_mempolicy in 
> struct mempolicy, 

Yes - that's what I'm intending to do.

> If the cpuset has fewer than four nodes, the behavior 
> should be undefined (probably implemented to just cycle the set of 
> mems_allowed until you reach the fourth entry).

I do intend to implement it as you suggest.  See the lib/bitmap.c
routines bitmap_remap() and bitmap_bitremap(), and the nodemask
wrappers for these, nodes_remap() and node_remap().  They will
define the cycling, or I sometimes call it folding.

I would have tended to make this folding a defined part of the API,
though I will grant that the possibility of being lazy and forgetting
to document it seems attractive (less to document ;).

> That [running in a cpuset with fewer nodes than used in a memory policy
> mask] is the result of constraining a task to a cpuset that obviously
> wants access to more nodes -- it's a userspace mistake and abusing
> cpusets so that the task does not get what it expects.

Nah - I wouldn't put it that way.  It's no mistake or abuse.  It's just
one more example of a kernel making too few resources look sufficient
by sharing, multiplexing and virtualizing them.  That's what kernels do.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
