Return-Path: <linux-kernel-owner+w=401wt.eu-S934860AbZJNQEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934860AbZJNQEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934838AbZJNQEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:04:36 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:42142 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934850AbZJNQEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:04:35 -0400
Date: Wed, 14 Oct 2009 11:56:29 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Mel Gorman <mel@csn.ul.ie>, David Rientjes <rientjes@google.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
 operations in the hotpaths
In-Reply-To: <4AD5F3F8.8080603@cs.helsinki.fi>
Message-ID: <alpine.DEB.1.10.0910141154320.26476@gentwo.org>
References: <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131041450.21608@gentwo.org> <alpine.DEB.1.10.0910131509170.32394@gentwo.org> <4AD4D8B6.6010700@cs.helsinki.fi> <alpine.DEB.1.10.0910131541290.7246@gentwo.org>
 <alpine.DEB.1.00.0910131305440.3529@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131625370.13756@gentwo.org> <alpine.DEB.1.00.0910131550050.15347@chino.kir.corp.google.com> <20091014133457.GB5027@csn.ul.ie> <alpine.DEB.1.10.0910141003590.9944@gentwo.org>
 <20091014154944.GD5027@csn.ul.ie> <4AD5F3F8.8080603@cs.helsinki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Pekka Enberg wrote:

> SLAB is able to queue lots of large objects but SLUB can't do that because it
> has no queues. In SLUB, each CPU gets a page assigned to it that serves as a
> "queue" but the size of the queue gets smaller as object size approaches page
> size.
>
> We try to offset that with higher order allocations but IIRC we don't increase
> the order linearly with object size and cap it to some reasonable maximum.

You can test to see if larger pages have an influence by passing

slub_max_order=6

or so on the kernel command line.

You can force a large page use in slub by setting

slub_min_order=3

f.e.

Or you can force a mininum number of objecxcts in slub through f.e.

slub_min_objects=50



slub_max_order=6 slub_min_objects=50

should result in pretty large slabs with lots of in page objects that
allow slub to queue better.




