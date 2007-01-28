Return-Path: <linux-kernel-owner+w=401wt.eu-S932157AbXA1AMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbXA1AMk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 19:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932160AbXA1AMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 19:12:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39474 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157AbXA1AMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 19:12:39 -0500
Date: Sat, 27 Jan 2007 16:12:29 -0800
From: Andrew Morton <akpm@osdl.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, hugh@veritas.com, clameter@sgi.com
Subject: Re: [PATCH] slab: cache_grow cleanup
Message-Id: <20070127161229.11637b80.akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0701091539160.10824@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0701091539160.10824@sbz-30.cs.Helsinki.FI>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jan 2007 15:40:03 +0200 (EET)
Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> The current implementation of cache_grow() has to either (1) use pre-allocated
> memory for the slab or (2) allocate the memory itself which makes the error
> paths messy. Move __GFP_NO_GROW and __GFP_WAIT processing to kmem_getpages()
> and introduce a new __cache_grow() variant that expects the memory for a new
> slab to always be handed over in the 'objp' parameter.

This gets its local interrupt state mucked up.

BUG: sleeping function called from invalid context at mm/slab.c:3038
in_atomic():0, irqs_disabled():1
no locks held by init/1.
irq event stamp: 656902
hardirqs last  enabled at (656901): [<c015f48b>] mod_zone_page_state+0x4b/0x50
hardirqs last disabled at (656902): [<c0171f54>] cache_alloc_refill+0x384/0x6a0
softirqs last  enabled at (650628): [<c03a6317>] unix_release_sock+0x67/0x220
softirqs last disabled at (650626): [<c03cfe8e>] _write_lock_bh+0xe/0x40
 [<c0103f7a>] show_trace_log_lvl+0x1a/0x30
 [<c0104682>] show_trace+0x12/0x20
 [<c0104736>] dump_stack+0x16/0x20
 [<c01175ea>] __might_sleep+0xba/0xd0
 [<c017262f>] kmem_cache_alloc+0xaf/0xd0
 [<c0172131>] cache_alloc_refill+0x561/0x6a0
 [<c0172574>] kmem_cache_zalloc+0xe4/0xf0
 [<c011cb49>] copy_process+0x89/0x1280
 [<c011dfcb>] do_fork+0x6b/0x1c0
 [<c0100e13>] sys_clone+0x33/0x40
 [<c0102edc>] sysenter_past_esp+0x5d/0x99
 =======================
