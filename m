Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbXC2QNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbXC2QNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 12:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932267AbXC2QNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 12:13:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:51487 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203AbXC2QNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 12:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=j03FAROQlDwbgC+3VNmZSjwthidnpH7VjpQ8EE7ImP94x+TySJzPHY/Xmtgwz+OSHr1UfYugi8tSdvXNePRi6/l+3cAUJIQsPTEfr+KlNLgu4veSHOie3/O3VA9biAoP6fzy0Z0lUnv1RJb8LwxM/sE04pXIaFGi6dFiotQrDDo=
Date: Thu, 29 Mar 2007 20:04:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: [QUESTION] check for mem in slab
Message-ID: <20070329160434.GA10265@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

in file mm/slab.c and routine kmem_cache_init() I found there
is no checking for allocated memory on line:

	/* 4) Replace the bootstrap head arrays */
	{
		struct array_cache *ptr;

		ptr = kmalloc(sizeof(struct arraycache_init), GFP_KERNEL);

--> no check for ptr == NULL <--

		local_irq_disable();
		BUG_ON(cpu_cache_get(&cache_cache) != &initarray_cache.cache);
		memcpy(ptr, cpu_cache_get(&cache_cache),
		       sizeof(struct arraycache_init));

		...

is that OK? or it's a bug?

		Cyrill

