Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZCCVgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZCCVgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 16:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbZCCVfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 16:35:54 -0500
Received: from smtp-out.google.com ([216.239.33.17]:51708 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbZCCVfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 16:35:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Ek2GC4bFwj6L7ff77NCQNQgXkt1YTMqh4ge6iqr/Zmbgxjxj9rWZfrZPXzw7wIZxv
	NCN8uEqH/TNL64u4RRrLw==
Date: Tue, 3 Mar 2009 13:35:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: enforce cpuset restrictions for cpu slabs
In-Reply-To: <alpine.DEB.1.10.0903031509380.25612@qirst.com>
Message-ID: <alpine.DEB.2.00.0903031330090.23523@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903022009490.17284@chino.kir.corp.google.com> <alpine.DEB.2.00.0903022011430.17284@chino.kir.corp.google.com> <alpine.DEB.1.10.0903031136380.26454@qirst.com> <alpine.DEB.2.00.0903030900580.6643@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0903031345150.9466@qirst.com> <alpine.DEB.2.00.0903031057110.15900@chino.kir.corp.google.com> <alpine.DEB.1.10.0903031509380.25612@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009, Christoph Lameter wrote:

> SLUB is also "dismissing" lots of other NUMA locality requirements since
> it relies on the page allocators for this. SLUB does *not* realize memory
> policy and/or cpuset support for individual objects.

Right, and this patch adds that.

> NUMA locality is
> implemented only (aside from explicit requests of memory from a
> certain node) when slab page allocations are performed.
> 

Yes, that is the current implementation.

For systems that use multiple cpusets, this allows objects for a task to 
be allocated on its assigned cpuset node(s); the only reasonable use case 
would be for memory isolation and/or NUMA optimizations.

Unfortunately, we can't add a slab hardwall flag to the cpuset to 
configure this behavior since that would require locking to dereference 
in the fastpath.  
