Return-Path: <linux-kernel-owner+w=401wt.eu-S1763379AbXGXDxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763379AbXGXDxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 23:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbXGXDxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 23:53:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43822 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751021AbXGXDxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 23:53:12 -0400
Date: Mon, 23 Jul 2007 20:52:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/10] readahead: combine
 file_ra_state.prev_index/prev_offset into prev_pos
Message-Id: <20070723205241.c50624ed.akpm@linux-foundation.org>
In-Reply-To: <385243122.57859@ustc.edu.cn>
References: <20070724020009.677809022@mail.ustc.edu.cn>
	<385243122.57859@ustc.edu.cn>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 10:00:12 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> -	ra->prev_index = page->index;
> +	ra->prev_pos = page->index << PAGE_CACHE_SHIFT;

bug!  The rhs will get truncated befire it gets assigned to
the lhs.  Need to cast page->index to loff_t.

I'll fix this one up.  Please review the other patches for this?


I decided to merge this ahead of that great pile of Nick's patches
(pagecache write deadlocks) and gto a number of easy-to-fix rejects as a
result.  Hopefully it all landed OK.


