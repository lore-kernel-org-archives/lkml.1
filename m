Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZJLKmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZJLKmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbZJLKmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:42:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:59702 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbZJLKmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:42:23 -0400
Message-ID: <4AD307A5.105@kernel.org>
Date: Mon, 12 Oct 2009 19:40:37 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: cl@linux-foundation.org
CC: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
 operations in the hotpaths
References: <20091007211024.442168959@gentwo.org> <20091007211053.378634196@gentwo.org>
In-Reply-To: <20091007211053.378634196@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 10:40:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cl@linux-foundation.org wrote:
> Use this_cpu_* operations in the hotpath to avoid calculations of
> kmem_cache_cpu pointer addresses.
> 
> On x86 there is a trade off: Multiple uses segment prefixes against an
> address calculation and more register pressure. Code size is reduced
> also therefore it is an advantage icache wise.
> 
> The use of prefixes is necessary if we want to use a scheme
> for fastpaths that do not require disabling interrupts.
> 
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

The rest of the patches look good to me but I'm no expert in this area
of code.  But you're the maintainer of the allocator and the changes
definitely are percpu related, so if you're comfortable with it, I can
happily carry the patches through percpu tree.

Thanks.

-- 
tejun
