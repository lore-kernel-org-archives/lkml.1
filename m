Return-Path: <linux-kernel-owner+w=401wt.eu-S1762014AbYCAA6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762014AbYCAA6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 19:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYCAA5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 19:57:54 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:13489 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbYCAA5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 19:57:53 -0500
Message-ID: <47C8A982.4080302@oracle.com>
Date: Fri, 29 Feb 2008 16:55:30 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] mempolicy: update NUMA memory policy documentation
References: <alpine.DEB.1.00.0802291640570.30883@chino.kir.corp.google.com> <alpine.DEB.1.00.0802291641500.30883@chino.kir.corp.google.com> <alpine.DEB.1.00.0802291642110.30883@chino.kir.corp.google.com> <alpine.DEB.1.00.0802291642290.30883@chino.kir.corp.google.com> <alpine.DEB.1.00.0802291644060.30883@chino.kir.corp.google.com> <alpine.DEB.1.00.0802291644290.30883@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0802291644290.30883@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> Updates Documentation/vm/numa_memory_policy.txt and
> Documentation/filesystems/tmpfs.txt to describe optional mempolicy mode
> flags.
> 
> Cc: Christoph Lameter <clameter@sgi.com>
> Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Paul Jackson <pj@sgi.com>
> ---
>  Documentation/filesystems/tmpfs.txt     |   12 +++
>  Documentation/vm/numa_memory_policy.txt |  131 +++++++++++++++++++++++-------
>  2 files changed, 112 insertions(+), 31 deletions(-)
> 
> diff --git a/Documentation/vm/numa_memory_policy.txt b/Documentation/vm/numa_memory_policy.txt
> --- a/Documentation/vm/numa_memory_policy.txt
> +++ b/Documentation/vm/numa_memory_policy.txt

> @@ -231,6 +234,80 @@ Components of Memory Policies
>  	    the temporary interleaved system default policy works in this
>  	    mode.
>  
> +   Linux memory policy supports the following optional mode flag:

                                                               flags:

> +
> +	MPOL_F_STATIC_NODES:  This flag specifies that the nodemask passed by
> +	the user should not be remapped if the task or VMA's set of allowed
> +	nodes changes after the memory policy has been defined.
> +
> +	    Without this flag, anytime a mempolicy is rebound because of a
> +	    change in the set of allowed nodes, the node (Preferred) or
> +	    nodemask (Bind, Interleave) is remapped to the new set of
> +	    allowed nodes.  This may result in nodes being used that were
> +	    previously undesired.
> +
> +	    With this flag, if the user specified nodes overlap with the

                                   user-specified

> +	    nodes allowed by the task's cpuset, then the memory policy is
> +	    applied to their intersection.  If the two sets of nodes do not
> +	    overlap, the Default policy is used.
> +
> +	    For example, consider a task that is attached to a cpuset with
> +	    mems 1-3 that sets an Interleave policy over the same set.  If
> +	    the cpuset's mems change to 3-5, the Interleave will now occur
> +	    over nodes 3, 4, and 5.  With this flag, however, since only node
> +	    3 is allowed from the user's nodemask, the "interleave" only
> +	    occurs over that node.  If no nodes from the user's nodemask are
> +	    now allowed, the Default behavior is used.
> +
> +	    MPOL_F_STATIC_NODES cannot be used with MPOL_F_RELATIVE_NODES.
> +


-- 
~Randy
