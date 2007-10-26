Return-Path: <linux-kernel-owner+w=401wt.eu-S1762351AbXJZPbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762351AbXJZPbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbXJZPbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:31:08 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:49631 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbXJZPbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:31:06 -0400
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	 <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	 <20071025185506.8c373aa8.pj@sgi.com>
	 <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 26 Oct 2007 11:30:44 -0400
Message-Id: <1193412644.5032.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 19:11 -0700, David Rientjes wrote:
> On Thu, 25 Oct 2007, Paul Jackson wrote:
> 
> > David - could you describe the real world situation in which you
> > are finding that this new 'interleave_over_allowed' option, aka
> > 'memory_spread_user', is useful?  I'm not always opposed to special
> > case solutions; but they do usually require special case needs to
> > justify them ;).
> > 
> 
> Yes, when a task with MPOL_INTERLEAVE has its cpuset mems_allowed expanded 
> to include more memory.  The task itself can't access all that memory with 
> the memory policy of its choice.
> 
> Since the cpuset has changed the mems_allowed of the task without its 
> knowledge, it would require a constant get_mempolicy() and set_mempolicy() 
> loop in the application to catch these changes.  That's obviously not in 
> the best interest of anyone.
> 
> So my change allows those tasks that have already expressed the desire to 
> interleave their memory with MPOL_INTERLEAVE to always use the full range 
> of memory available that is dynamically changing beneath them as a result 
> of cpusets.  Keep in mind that it is still possible to request an 
> interleave only over a subset of allowed mems: but you must do it when you 
> create the interleaved mempolicy after it has been attached to the cpuset.
> set_mempolicy() changes are always honored.
> 
> The only other way to support such a feature is through a modification to 
> mempolicies themselves, which Lee has already proposed.  The problem with 
> that is it requires mempolicy support for cpuset cases and modification to 
> the set_mempolicy() API.  My solution presents a cpuset fix for a cpuset 
> problem.

Actually, my patch doesn't change the set_mempolicy() API at all, it
just co-opts a currently unused/illegal value for the nodemask to
indicate "all allowed nodes".  Again, I need to provide a libnuma API to
request this.   Soon come, mon...

Here's a link the last posting of my patch, as Paul requested:

http://marc.info/?l=linux-mm&m=118849999128086&w=4

A bit out of date, but I'll fix that maybe next week.

Lee
<snip>

