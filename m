Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbZCIEtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbZCIEtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 00:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbZCIEtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 00:49:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40211 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZCIEtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 00:49:33 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com>
Message-Id: <20090309123011.A228.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon,  9 Mar 2009 13:49:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> 
> For slub, if the cpu slab is not from an allowable node, the partial list
> is scanned for a replacement.  If none can be used, a new slab is
> allocated.

Hmmm,
this description only explay how to implement this.
but no explain why this patch is useful.

Could you please who and why need it?



