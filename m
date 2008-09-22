Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbYIVOy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbYIVOy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYIVOyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:54:45 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42554 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbYIVOyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:54:44 -0400
Subject: Re: [PATCH 9/13] memcg: lookup page cgroup (and remove pointer
	from struct page)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080922201206.e73d9ce6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080922201206.e73d9ce6.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 07:52:56 -0700
Message-Id: <1222095177.8533.14.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-22 at 20:12 +0900, KAMEZAWA Hiroyuki wrote:
> +       /* we don't need too large hash */
> +       default_pcg_hash_size = (max_pfn/ENTS_PER_CHUNK);
> +       default_pcg_hash_size *= 2;
> +       /* if too big, use automatic calclation */
> +       if (default_pcg_hash_size > 1024 * 1024)
> +               default_pcg_hash_size = 0;
> +
> +       pcg_hashtable = alloc_large_system_hash("PageCgroup Hash",
> +                               sizeof(struct pcg_hash_head),
> +                               default_pcg_hash_size,
> +                               13,
> +                               0,
> +                               &pcg_hashshift,
> +                               &pcg_hashmask,
> +                               0);

The one thing I don't see here is much explanation about how large this
structure will get.

Basing it on max_pfn makes me nervous because of what it will do on
machines with very sparse memory.  Is this like sparsemem where the
structure can be small enough to actually span all of physical memory,
or will it be a large memory user?

Can you lay out how much memory this will use on a machine like Dave
Miller's which has 1GB of memory at 0x0 and 1GB of memory at 1TB up in
the address space?

Also, how large do the hash buckets get in the average case?

-- Dave

