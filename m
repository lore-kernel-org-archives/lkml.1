Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYHSSPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYHSSPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYHSSPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:15:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbYHSSPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:15:10 -0400
Message-ID: <48AB0D69.4090703@linux-foundation.org>
Date: Tue, 19 Aug 2008 13:14:01 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
CC: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       rdunlap@xenotime.net, mpm@selenic.com, tglx@linutronix.de,
       rostedt@goodmis.org, mathieu.desnoyers@polymtl.ca, tzanussi@gmail.com
Subject: Re: [PATCH 3/5] SLUB: Replace __builtin_return_address(0) with _RET_IP_.
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro> <1219167807-5407-2-git-send-email-eduard.munteanu@linux360.ro> <1219167807-5407-3-git-send-email-eduard.munteanu@linux360.ro>
In-Reply-To: <1219167807-5407-3-git-send-email-eduard.munteanu@linux360.ro>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard - Gabriel Munteanu wrote:

>  void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
>  {
> -	return slab_alloc(s, gfpflags, -1, __builtin_return_address(0));
> +	return slab_alloc(s, gfpflags, -1, (void *) _RET_IP_);
>  }

Could you get rid of the casts by changing the type of parameter of slab_alloc()?

