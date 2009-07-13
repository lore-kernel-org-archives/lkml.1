Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZGMKV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZGMKV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 06:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZGMKV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 06:21:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38815 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbZGMKV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 06:21:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1245850216-31653-5-git-send-email-tj@kernel.org>
References: <1245850216-31653-5-git-send-email-tj@kernel.org> <1245850216-31653-1-git-send-email-tj@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
       hpa@zytor.com, tglx@linutronix.de, cl@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 04/10] percpu: make 4k first chunk allocator map memory
Date: Mon, 13 Jul 2009 11:12:53 +0100
Message-ID: <24253.1247479973@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> +	pr_info("PERCPU: %d 4k pages per cpu, static data %zu bytes\n",
> +		pcpu4k_unit_pages, static_size);

It occurs to me that this is may include a bad assumption.  Page size need not
be 4K.  I don't know that it matters, but looking at this:

> +	vm.size = num_possible_cpus() * pcpu4k_unit_pages << PAGE_SHIFT;
> +	vm_area_register_early(&vm, PAGE_SIZE);

It might.

David
