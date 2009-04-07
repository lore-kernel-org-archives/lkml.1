Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbZDGUKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbZDGUKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZDGUKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:10:20 -0400
Received: from smtp-out.google.com ([216.239.33.17]:6395 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbZDGUKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:10:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Xu8qaT6VlUuuEoTx0nQHHknUSBvMHJcR3bPkQ2DRtBC6svrRt3JaAs3d2pfRKetVq
	+t7/e8ZgWBQhbIiVK1W8g==
Date: Tue, 7 Apr 2009 13:09:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: default min_partial to at least highest cpus per
  node
In-Reply-To: <49DBAF7E.30704@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.0904071302430.32321@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0904051653420.25339@chino.kir.corp.google.com>  <49DBA23A.3000106@cs.helsinki.fi> <84144f020904071209j638aae9bv406661ec401af7af@mail.gmail.com> <alpine.DEB.2.00.0904071231500.21113@chino.kir.corp.google.com>
 <49DBAF7E.30704@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, Pekka Enberg wrote:

> > I'd be just as happy with the following, although it would require changing
> > MIN_PARTIAL to be greater than its default of 5 if a node supports more cpus
> > for optimal performance (the old patch did that automatically up to
> > MAX_PARTIAL).
> 
> Hmm but why not move ->min_partial to struct kmem_cache_node as I suggested
> and make sure it's adjusted properly as with nr_cpus_node()?
> 

Sure, that's also possible except we'd lose the ability to tune 
min_partial with /sys/kernel/slab/cache/min_partial, unless it would then 
change n->min_partial for each N_NORMAL_MEMORY node.  We lack an interface 
to change the per-node min_partial.

If you think that's acceptable, I'd be just as satisfied with that 
approach as long as all archs have valid cpu_to_node() mappings at the 
time of CPU_UP_PREPARE.

Aside: we're lacking in the documentation of these sysfs tunables such as 
remote_node_defrag_ratio to begin with, the only way to figure out what it 
does is by reading the code or making assumptions based on its name.  I'd 
be happy to add some documentation but it'd be good to keep it separate 
from Documentation/vm/slub.txt.
