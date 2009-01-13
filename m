Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbZAMBht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbZAMBht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758571AbZAMB3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:29:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35803 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758556AbZAMB3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:29:48 -0500
Date: Tue, 13 Jan 2009 02:29:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Robert Richter <robert.richter@amd.com>,
       Steven Rostedt <rostedt@redhat.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ring_buffer: NUMA aware page allocations
Message-ID: <20090113012937.GB15492@elte.hu>
References: <496B97F1.70200@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496B97F1.70200@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4999]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> Hi Robert & Steven
> 
> While browsing oprofile code in current tree, I discovered 
> drivers/oprofile/cpu_buffer.c was using new ring_buffer code.
> 
> Apparently we lost in the conversion NUMA allocations, unless
> I am mistaken, since rb_allocate_pages() uses plain
> __get_free_page(GFP_KERNEL) calls to allocate pages.
> 
> All "buffer_page" structs are allocated with kzalloc_node(),
> but not the pages themselves.
> 
> Thank you
> 
> [PATCH] ring_buffer: NUMA aware page allocations
> 
> rb_allocate_pages() & ring_buffer_resize() should use alloc_pages_node()
> instead of __get_free_page() to allocate pages.

nice improvement!

	Ingo
