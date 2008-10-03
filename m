Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbYJCQHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbYJCQHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 12:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYJCQHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 12:07:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061AbYJCQHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 12:07:08 -0400
Message-ID: <48E642CA.2050405@linux-foundation.org>
Date: Fri, 03 Oct 2008 11:05:30 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org,
       penberg@cs.helsinki.fi
Subject: Re: [patch 2/3] cpu alloc: Use in slub
References: <20081003152436.089811999@quilx.com> <20081003152500.102106878@quilx.com> <48E63E76.1010702@cosmosbay.com>
In-Reply-To: <48E63E76.1010702@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
>
> Then maybe change MAX_NUMNODES to 0 or 1 to reflect
> node[] is dynamically sized ?

See kmem_cache_init(). It only allocates the used bytes. If you only have a
single nodes then only 1 pointer will be allocated.

#ifdef CONFIG_NUMA
        kmem_size = offsetof(struct kmem_cache, node) +
                                nr_node_ids * sizeof(struct kmem_cache_node *);
#else


That does not work for the statically allocated kmalloc array though.



