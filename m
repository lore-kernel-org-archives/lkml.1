Return-Path: <linux-kernel-owner+w=401wt.eu-S1761968AbYCABPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761968AbYCABPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 20:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbYCABOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 20:14:53 -0500
Received: from smtp-out.google.com ([216.239.33.17]:53164 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbYCABOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 20:14:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=ye3+/Vm4dRqy/aeFfo/tqtrtnsfthg8QSXKB4DNML1zVBKGblXMUzToK397Ihly3K
	ckaa/Ys/i6VeW4i3s626A==
Date: Fri, 29 Feb 2008 17:14:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] mempolicy: update NUMA memory policy documentation
In-Reply-To: <47C8A982.4080302@oracle.com>
Message-ID: <alpine.DEB.1.00.0802291713280.4164@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802291640570.30883@chino.kir.corp.google.com> <alpine.DEB.1.00.0802291641500.30883@chino.kir.corp.google.com> <alpine.DEB.1.00.0802291642110.30883@chino.kir.corp.google.com> <alpine.DEB.1.00.0802291642290.30883@chino.kir.corp.google.com>
 <alpine.DEB.1.00.0802291644060.30883@chino.kir.corp.google.com> <alpine.DEB.1.00.0802291644290.30883@chino.kir.corp.google.com> <47C8A982.4080302@oracle.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008, Randy Dunlap wrote:

> David Rientjes wrote:
> > Updates Documentation/vm/numa_memory_policy.txt and
> > Documentation/filesystems/tmpfs.txt to describe optional mempolicy mode
> > flags.
> > 
> > Cc: Christoph Lameter <clameter@sgi.com>
> > Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> > Cc: Andi Kleen <ak@suse.de>
> > Cc: Randy Dunlap <randy.dunlap@oracle.com>
> > Signed-off-by: David Rientjes <rientjes@google.com>
> > Signed-off-by: Paul Jackson <pj@sgi.com>
> > ---
> >  Documentation/filesystems/tmpfs.txt     |   12 +++
> >  Documentation/vm/numa_memory_policy.txt |  131
> > +++++++++++++++++++++++-------
> >  2 files changed, 112 insertions(+), 31 deletions(-)
> > 
> > diff --git a/Documentation/vm/numa_memory_policy.txt
> > b/Documentation/vm/numa_memory_policy.txt
> > --- a/Documentation/vm/numa_memory_policy.txt
> > +++ b/Documentation/vm/numa_memory_policy.txt
> 
> > @@ -231,6 +234,80 @@ Components of Memory Policies
> >  	    the temporary interleaved system default policy works in this
> >  	    mode.
> >  +   Linux memory policy supports the following optional mode flag:
> 
>                                                               flags:
> 
> > +
> > +	MPOL_F_STATIC_NODES:  This flag specifies that the nodemask passed by
> > +	the user should not be remapped if the task or VMA's set of allowed
> > +	nodes changes after the memory policy has been defined.
> > +
> > +	    Without this flag, anytime a mempolicy is rebound because of a
> > +	    change in the set of allowed nodes, the node (Preferred) or
> > +	    nodemask (Bind, Interleave) is remapped to the new set of
> > +	    allowed nodes.  This may result in nodes being used that were
> > +	    previously undesired.
> > +
> > +	    With this flag, if the user specified nodes overlap with the
> 
>                                   user-specified
> 
> > +	    nodes allowed by the task's cpuset, then the memory policy is
> > +	    applied to their intersection.  If the two sets of nodes do not
> > +	    overlap, the Default policy is used.
> > +
> > +	    For example, consider a task that is attached to a cpuset with
> > +	    mems 1-3 that sets an Interleave policy over the same set.  If
> > +	    the cpuset's mems change to 3-5, the Interleave will now occur
> > +	    over nodes 3, 4, and 5.  With this flag, however, since only node
> > +	    3 is allowed from the user's nodemask, the "interleave" only
> > +	    occurs over that node.  If no nodes from the user's nodemask are
> > +	    now allowed, the Default behavior is used.
> > +
> > +	    MPOL_F_STATIC_NODES cannot be used with MPOL_F_RELATIVE_NODES.
> > +
> 

Andrew, please fold this into 
mempolicy-update-numa-memory-policy-documentation.patch if this patchset is 
added to -mm.

Corrects two errors in Documentation/vm/numa_memory_policy.txt as identified by 
Randy Dunlap <randy.dunlap@oracle.com>.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/vm/numa_memory_policy.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/vm/numa_memory_policy.txt b/Documentation/vm/numa_memory_policy.txt
--- a/Documentation/vm/numa_memory_policy.txt
+++ b/Documentation/vm/numa_memory_policy.txt
@@ -234,7 +234,7 @@ Components of Memory Policies
 	    the temporary interleaved system default policy works in this
 	    mode.
 
-   Linux memory policy supports the following optional mode flag:
+   Linux memory policy supports the following optional mode flags:
 
 	MPOL_F_STATIC_NODES:  This flag specifies that the nodemask passed by
 	the user should not be remapped if the task or VMA's set of allowed
@@ -246,7 +246,7 @@ Components of Memory Policies
 	    allowed nodes.  This may result in nodes being used that were
 	    previously undesired.
 
-	    With this flag, if the user specified nodes overlap with the
+	    With this flag, if the user-specified nodes overlap with the
 	    nodes allowed by the task's cpuset, then the memory policy is
 	    applied to their intersection.  If the two sets of nodes do not
 	    overlap, the Default policy is used.
