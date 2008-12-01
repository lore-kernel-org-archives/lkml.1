Return-Path: <linux-kernel-owner+w=401wt.eu-S1751322AbYLAFjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbYLAFjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 00:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbYLAFjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 00:39:08 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53918 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYLAFjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 00:39:07 -0500
Date: Mon, 01 Dec 2008 14:39:03 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 01/15] kmemleak: Add the base support
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20081129104312.16726.36218.stgit@pc1117.cambridge.arm.com>
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com> <20081129104312.16726.36218.stgit@pc1117.cambridge.arm.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20081201142824.D552.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I have a question. (may be silly)

> +/*
> + * Insert a pointer into the pointer hash table.
> + */
> +static inline void create_object(unsigned long ptr, size_t size, int ref_count)
> +{
> +	unsigned long flags;
> +	struct memleak_object *object;
> +	struct prio_tree_node *node;
> +	struct stack_trace trace;
> +
> +	object = kmem_cache_alloc(object_cache, GFP_ATOMIC);
> +	if (!object)
> +		panic("kmemleak: cannot allocate a memleak_object structure\n");

IIRC, GFP_ATOMIC allocation sometimes fails. (ex. when page cache occupies all
area). It seems to be easy to panic. Is it intended? 


Thanks.
-- 
Yasunori Goto 


