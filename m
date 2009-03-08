Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbZCHRCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbZCHRCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 13:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZCHRCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 13:02:13 -0400
Received: from waste.org ([66.93.16.53]:59854 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbZCHRCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 13:02:12 -0400
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
From: Matt Mackall <mpm@selenic.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Sun, 08 Mar 2009 12:01:04 -0500
Message-Id: <1236531664.4192.389.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 09:27 -0700, David Rientjes wrote:
> Adds a per-cpuset `memory_slab_hardwall' flag.
> 
> The slab allocator interface for determining whether an object is allowed
> is
> 
> 	int current_cpuset_object_allowed(int node, gfp_t flags)
> 
> This returns non-zero when the object is allowed, either because
> current's cpuset does not have memory_slab_hardwall enabled or because
> it allows allocation on the node.  Otherwise, it returns zero.
> 
> This interface is lockless because a task's cpuset can always be safely
> dereferenced atomically.
> 
> For slab, if the physical node id of the cpu cache is not from an
> allowable node, the allocation will fail.  If an allocation is targeted
> for a node that is not allowed, we allocate from an appropriate one
> instead of failing.
> 
> For slob, if the page from the slob list is not from an allowable node,
> we continue to scan for an appropriate slab.  If none can be used, a new
> slab is allocated.

Looks fine to me, if a little expensive. We'll be needing SLQB support
though.

-- 
http://selenic.com : development and support for Mercurial and Linux


