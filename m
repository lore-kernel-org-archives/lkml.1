Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbYKFD6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbYKFD6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 22:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYKFD61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 22:58:27 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:31036 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbYKFD60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 22:58:26 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAM8S9kh5LDmz/2dsb2JhbADCJoFr
X-IronPort-AV: E=Sophos;i="4.33,553,1220193000"; 
   d="scan'208";a="225918695"
Date: Thu, 6 Nov 2008 14:58:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, travis@sgi.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [patch 4/7] cpu ops: Core piece for generic atomic per cpu
	operations
Message-ID: <20081106035821.GA2373@disturbed>
Mail-Followup-To: Christoph Lameter <cl@linux-foundation.org>,
	akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, travis@sgi.com,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Vegard Nossum <vegard.nossum@gmail.com>
References: <20081105231634.133252042@quilx.com> <20081105231648.462808759@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105231648.462808759@quilx.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 05:16:38PM -0600, Christoph Lameter wrote:
> +
> +#define __CPU_CMPXCHG(var, old, new)		\
> +({						\
> +	typeof(obj) x;				\
> +	typeof(obj) *p = THIS_CPU(&(obj));	\
> +	x = *p;					\
> +	if (x == (old))				\
> +		*p = (new);			\
> +	(x);					\
> +})

I don't think that will compile - s/obj/var/ perhaps?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
