Return-Path: <linux-kernel-owner+w=401wt.eu-S1763745AbYBZRey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763745AbYBZRey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760196AbYBZReq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:34:46 -0500
Received: from relay1.sgi.com ([192.48.171.29]:59311 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759631AbYBZRep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:34:45 -0500
Date: Tue, 26 Feb 2008 11:34:41 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] mempolicy: update NUMA memory policy documentation
Message-Id: <20080226113441.934c8c90.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802250016380.12368@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250014410.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250016120.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250016380.12368@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+	MPOL_F_RELATIVE_NODES:  This flag specifies that the nodemask passed
+	by the user should remain in the same context as it is for the
+	current task or VMA's set of accessible nodes after the memory
+	policy has been defined.
+
+	    Without this flag (and without MPOL_F_STATIC_NODES), anytime a
+	    mempolicy is rebound because of a change in the set of
+	    accessible nodes, the node (Preferred) or nodemask (Bind,
+	    Interleave) is remapped to the new set of accessible nodes.
+	    With this flag, the remap is done to ensure the context of the
+	    previous nodemask with its set of allowed mems is preserved.

Hmmm ... I've read this several times now ... still can't figure out
what it's saying ;).  And it doesn't really explain key aspects of
MPOL_F_RELATIVE_NODES, such as that it provides cpuset relative
numbering (use nodes 0..N-1, regardless of your current cpuset, to
refer to the first N nodes in whatever is your current cpuset.)

Perhaps we'd be further ahead of the game if you started with the
documentation changes to Documentation/vm/numa_memory_policy.txt,
in my patch:
	Date: Sun, 23 Dec 2007 22:24:02 -0600
	From: Paul Jackson <pj@sgi.com>
	To: David Rientjes <rientjes@google.com>
	Cc: Lee.Schermerhorn@hp.com, clameter@sgi.com
	Subject: Re: [RFC] cpuset relative memory policies - second choice
	Message-Id: <20071223222402.5486bf0a.pj@sgi.com>

Change MPOL_MASK_REL to MPOL_F_RELATIVE_NODES and similar changes.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
