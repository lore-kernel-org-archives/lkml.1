Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbXD1FX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbXD1FX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 01:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932526AbXD1FX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 01:23:27 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:51570 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbXD1FX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 01:23:26 -0400
Date: Sat, 28 Apr 2007 06:13:39 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Matt Mackall <mpm@selenic.com>, Alexey Dobriyan <adobriyan@sw.ru>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: - maps2-add-proc-pid-pagemap-interface-fix.patch removed from
 -mm tree
In-Reply-To: <20070427143131.60d0afc1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704280607330.9554@blonde.wat.veritas.com>
References: <200704270814.l3R8EnFJ023047@shell0.pdx.osdl.net>
 <20070427104533.GA6001@localhost.sw.ru> <20070427132713.fc9d82c0.akpm@linux-foundation.org>
 <20070427204155.GT11115@waste.org> <20070427143131.60d0afc1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 28 Apr 2007 05:13:51.0641 (UTC) FILETIME=[028D2090:01C78954]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABWluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWRvYnJpeWFuQHN3LnJ1AG1wbUBzZWxlbmljLmNvbQBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnAG5pY2twaWdnaW5AeWFob28uY29tLmF1AA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Andrew Morton wrote:
> 
> hm, could do.  might_sleep() is intertwined with preempt in complex ways,
> but we did decouple that at the config level.  no_mmap_sem() will dtrt for
> all preempt settings.
> 
> But I'll be keeping this as a -mm-only debug patch (which brings us up to
> about thirty of 'em), so I think it's best to make it unconfigurable so we
> get maximum coverage.
> 
> That's if it actually works.  I haven't tried running it yet, and I have a
> feeling that running it might cause a big "doh" moment.  We'll see.

Yes, I'm expecting the crucial

> +	WARN_ON(rwsem_is_locked(&mm->mmap_sem))

to give a bogus warning every time another thread (or /proc,
or swapoff, or whatever) happens to have this mmap_sem locked.
might_sleep() is quite different, works on our thread's info.

Hugh
