Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbXESG2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbXESG2h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 02:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbXESG2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 02:28:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37662 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754338AbXESG23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 02:28:29 -0400
Date: Fri, 18 May 2007 23:23:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Jens Axboe <jens.axboe@oracle.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Pratt <slpratt@austin.ibm.com>, Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 5/9] readahead: on-demand readahead logic
Message-Id: <20070518232335.8a4c8247.akpm@linux-foundation.org>
In-Reply-To: <379355696.61291@ustc.edu.cn>
References: <20070516224752.500812933@mail.ustc.edu.cn>
	<379355696.61291@ustc.edu.cn>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 06:47:57 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> This is a minimal readahead algorithm that aims to replace the current one.
> It is more flexible and reliable, while maintaining almost the same behavior
> and performance. Also it is full integrated with adaptive readahead.
> 
> It is designed to be called on demand:
> 	- on a missing page, to do synchronous readahead
> 	- on a lookahead page, to do asynchronous readahead
> 
> In this way it eliminated the awkward workarounds for cache hit/miss,
> readahead thrashing, retried read, and unaligned read. It also adopts the
> data structure introduced by adaptive readahead, parameterizes readahead
> pipelining with `lookahead_index', and reduces the current/ahead windows
> to one single window.
> 
> HEURISTICS
> 
> The logic deals with four cases:
> 
> ...
>

That would have to be the best changelog I've ever seen ;) Thanks for
persisting with this.

> sysbench oltp (trans/sec): up to 8% gain

Have you given any thought to identifying workloads which may be worsened
by your changes?  Attempt to deliberately expose any weak spots?

