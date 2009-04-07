Return-Path: <linux-kernel-owner+w=401wt.eu-S1761430AbZDGVrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761430AbZDGVrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758338AbZDGVre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:47:34 -0400
Received: from smtp-out.google.com ([216.239.45.13]:21462 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbZDGVrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:47:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=m0PtXSVTrAPHeq1mcM7DTUb01JNdtR3XGOLeNENh2q23DToW+NfOsm39CrB+X3ser
	MMN/50LakUIk19Njqwiww==
Date: Tue, 7 Apr 2009 14:46:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: default min_partial to at least highest cpus per
  node
In-Reply-To: <alpine.DEB.1.10.0904071728240.12192@qirst.com>
Message-ID: <alpine.DEB.2.00.0904071445200.27115@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0904051653420.25339@chino.kir.corp.google.com>  <49DBA23A.3000106@cs.helsinki.fi> <84144f020904071209j638aae9bv406661ec401af7af@mail.gmail.com> <alpine.DEB.2.00.0904071231500.21113@chino.kir.corp.google.com> <49DBAF7E.30704@cs.helsinki.fi>
 <alpine.DEB.2.00.0904071302430.32321@chino.kir.corp.google.com> <49DBB373.5050800@cs.helsinki.fi> <alpine.DEB.2.00.0904071316460.21748@chino.kir.corp.google.com> <49DBB929.4080205@cs.helsinki.fi> <alpine.DEB.1.10.0904071641390.12192@qirst.com>
 <49DBBC1F.6000407@cs.helsinki.fi> <alpine.DEB.1.10.0904071728240.12192@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, Christoph Lameter wrote:

> The partial list sizes cannot be adjusted.

It's adjustable via /sys/kernel/slab/cache/min_partial.

> There is just a mininum size
> that is set via MIN_PARTIAL. Currently we use that to avoid trips to the
> page allocator by keeping the list artificially long. This should not be
> done because it increases memory overhead by keeping slab pages around
> with no objects.

That memory is easily reclaimed with kmem_cache_shrink().

> If the page allocator trips are not that expensive
> anymore then there is no reason to keep these slab pages around. A hot
> page can be reused by any other subsystemm in the kernel.
> 

Right, but right now allocating new slabs is extremely slow compared to 
using a partial slab.
