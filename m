Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbZCIJTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbZCIJTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 05:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZCIJTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 05:19:20 -0400
Received: from smtp-out.google.com ([216.239.33.17]:34191 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbZCIJTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 05:19:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ZyHS9vCj36udM6hQpCyhWZInQjHGxEFohYzjLPb6dBVQpbk+0+fubUCAUpv03J1lu
	dqC825rjxtOLd6eK7TGYw==
Date: Mon, 9 Mar 2009 02:18:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Menage <menage@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
In-Reply-To: <6599ad830903090008u4418e7efie137c87c6ac42e55@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0903090212250.24605@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com>  <6599ad830903080953na692dcfh7f455bfe46a895c3@mail.gmail.com>  <alpine.DEB.2.00.0903081438180.30551@chino.kir.corp.google.com>
 <6599ad830903090008u4418e7efie137c87c6ac42e55@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, Paul Menage wrote:

> Another thought - it would probably be better to call this flag
> kernel_mem_hardwall or mem_hardwall_kernel, to avoid hard-coding its
> name to be slab-specific.
> 

The change only affects slab allocations, it doesn't affect all kernel 
memory allocations.  With slub, for example, allocations that are larger 
than SLUB_MAX_ORDER (was formerly PAGE_SIZE) simply use compound pages 
from the page allocator where the cpuset memory policy was already 
enforced.

While there are a few different options for slab allocators in mainline 
and slqb on the way, these are still generally referred to as "slab" 
allocations regardless of which one is configured.

Prefixing the name with `memory_' just seemed natural considering the 
tunables already in place such as memory_spread_page and 
memory_spread_slab.  The user also already understands `hardwall' since 
mem_hardwall has existed for quite some time.
