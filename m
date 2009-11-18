Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbZKRI4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbZKRI4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbZKRI4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:56:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43287 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbZKRI4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:56:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7] xfs: Don't use PF_MEMALLOC
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       xfs-masters@oss.sgi.com, xfs@oss.sgi.com
In-Reply-To: <20091117221108.GK9467@discord.disaster>
References: <20091117162235.3DEB.A69D9226@jp.fujitsu.com> <20091117221108.GK9467@discord.disaster>
Message-Id: <20091118153302.3E20.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 18 Nov 2009 17:56:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Nov 17, 2009 at 04:23:43PM +0900, KOSAKI Motohiro wrote:
> > 
> > Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
> > memory, anyone must not prevent it. Otherwise the system cause
> > mysterious hang-up and/or OOM Killer invokation.
> 
> The xfsbufd is a woken run by a registered memory shaker. i.e. it
> runs when the system needs to reclaim memory. It forceѕ the
> delayed write metadata buffers (of which there can be a lot) to disk
> so that they can be reclaimed on IO completion. This IO submission
> may require ѕome memory to be allocated to be able to free that
> memory.
> 
> Hence, AFAICT the use of PF_MEMALLOC is valid here.

Thanks a lot. 
I have one additional question, may I ask you?

How can we calculate maximum memory usage in xfsbufd?
I'm afraid that VM and XFS works properly but adding two makes memory exhaust.

And, I conclude XFS doesn't need sharing reservation memory with VM,
it only need non failed allocation. right? IOW I'm prefer perter's
suggestion.


