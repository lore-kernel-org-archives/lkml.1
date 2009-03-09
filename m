Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbZCIKTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbZCIKTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 06:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZCIKTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 06:19:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37013 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbZCIKTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 06:19:24 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0903090206010.24605@chino.kir.corp.google.com>
References: <20090309123011.A228.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0903090206010.24605@chino.kir.corp.google.com>
Message-Id: <20090309181756.CF66.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon,  9 Mar 2009 19:19:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 9 Mar 2009, KOSAKI Motohiro wrote:
> 
> > Hmmm,
> > this description only explay how to implement this.
> > but no explain why this patch is useful.
> > 
> > Could you please who and why need it?
> > 
> 
> The change to Documentation/cgroups/cpusets.txt should have explained it.
> 
> This is for two cases: true memory isolation (now including slab 
> allocations at the object level) and NUMA optimizations.
> 
> Prior to this change, it was possible for slabs to be allocated in a 
> cpuset while its objects were largely consumed by disjoint cpusets.  We 
> can fix that by only allocating objects from slabs that are found on 
> current->mems_allowed.  While this incurs a performance penalty, some 
> users may find that true isolation outweighs the cache optimizations.
> 
> It is also helpful for long-lived objects that require NUMA affinity to a 
> certain cpu or group of cpus.  That is, after all, the reasoning behind 
> cpusets in the first place.  If slab objects were all allocated from a 
> node with remote affinity to the cpus that will be addressing it, it 
> negates a significant advantage that cpusets provides to the user.

My question mean, Why anyone need isolation?
your patch insert new branch into hotpath.
then, it makes slower hotpath a abit although a user don't use this feature.

typically, slab cache don't need strict node binding because
inode/dentry touched from multiple cpus.

In addition, on large numa systems, slab cache is relatively small
than page cache. then this feature's improvement seems relatively small too.

if you have strongly reason, I don't oppose this proposal.
but I don't think your explanation is enough reasonable reason.


btw, have you seen "immediate values" patch series? I think it
can become make the patch zero cost for non-cpuset user.
after that patch merging, I don't oppose this patch although
your reason isn't so much.



