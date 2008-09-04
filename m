Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYIDXPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYIDXPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 19:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbYIDXPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 19:15:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbYIDXPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 19:15:08 -0400
Date: Thu, 4 Sep 2008 16:14:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: hamid.jahanjou@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
Message-Id: <20080904161433.5b020bd9.akpm@linux-foundation.org>
In-Reply-To: <48BFCECE.90103@gmail.com>
References: <48BFCECE.90103@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2008 15:34:30 +0330
"Hamid R. Jahanjou" <hamid.jahanjou@gmail.com> wrote:

> Implements the idea of swap-out page clustering from *BSD for
> Linux. Each time a candidate page is to be swapped out,
> virtually-nearby pages are scanned to find eligible pages to be
> swapped out too as a cluster. This technique increases the likelihood of
> bringing in related data on a page fault and decreases swap space
> fragmentation in the long run. Currently, Linux searches only
> physically-nearby pages which is not optimal since, over time, physically-
> adjacent pages may become unrelated.

I tried that once.  The code all worked as-designed but didn't seem to
improve performance much across a spread of workloads.

> The code can be statically tuned. No benchmarks. I'm not sure whether
> the added complexity is acceptable.

Benchmarks are essential, please.  Good ones.

The whole point of the patch is to improve performance.  If we don't
know whether it improves performance, we cannot proceed in any way.


Secondly, please don't just dump a pile of new code in our laps and
expect us to pick through it and work out what it does and how it does
it.  Please at least provide a carefully-written english-language
description of the design and implementation.

Thirdly, I'd suggest that this code be converted into vaguely standard
kernel coding style sooner rather than later.  Convert it to use
eight-column hard tabs then check it with scripts/checkpatch.pl,
thanks.


