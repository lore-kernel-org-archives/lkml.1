Return-Path: <linux-kernel-owner+w=401wt.eu-S932307AbXLQGjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbXLQGjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 01:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757646AbXLQGji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 01:39:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756838AbXLQGjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 01:39:37 -0500
Date: Sun, 16 Dec 2007 22:39:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: mpm@selenic.com, m.kozlowski@tuxland.pl, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1: problems with cat /proc/kpageflags
Message-Id: <20071216223917.873e34bf.akpm@linux-foundation.org>
In-Reply-To: <20071216.202611.226170474.davem@davemloft.net>
References: <200712161948.42656.m.kozlowski@tuxland.pl>
	<200712162010.11028.m.kozlowski@tuxland.pl>
	<20071217021149.GC19691@waste.org>
	<20071216.202611.226170474.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Dec 2007 20:26:11 -0800 (PST) David Miller <davem@davemloft.net> wrote:

> From: Matt Mackall <mpm@selenic.com>
> Date: Sun, 16 Dec 2007 20:11:49 -0600
> 
> > But as the function doesn't actually show up in your stack trace,
> > something else is probably wrong. So I'd also try commenting out
> > pieces of that function until it started working.
> 
> Some piece of state is being indirectly corrupted and this
> is showing up later in some unrelated operation.
> 
> Can someone send me this kpageflags patch under seperate
> cover?  I'll try figure out why it farts on sparc64.

hm, non trivial.  It's the third-from-last patch in:

maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch

from
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/broken-out

That patch series does apply OK to mainline though.
