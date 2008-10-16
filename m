Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbYJPI2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbYJPI2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 04:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbYJPI1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 04:27:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50014 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbYJPI1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 04:27:55 -0400
Subject: Re: no way to swapoff a deleted swap file?
From: Peter Zijlstra <peterz@infradead.org>
To: Peter Cordes <peter@cordes.ca>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       hugh <hugh@veritas.com>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20081015202141.GX26067@cordes.ca>
References: <20081015202141.GX26067@cordes.ca>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 10:28:04 +0200
Message-Id: <1224145684.28131.25.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-15 at 17:21 -0300, Peter Cordes wrote:
> I unlinked a swapfile without realizing I was still swapping on it.
> Now my /proc/swaps looks like this:
> Filename                                Type            Size    Used	Priority
> /var/tmp/EXP/cache/swap/1\040(deleted)  file            1288644 1448	-1
> /var/tmp/EXP/cache/swap/2\040(deleted)  file            1433368 0	-2
> 
>  AFAICT, there's nothing I can pass to swapoff(2) that will make the
> kernel let go of them.  If that's the case, please consider this a
> feature request for a way to do this.  Now I'm going to have to reboot
> before I can mkfs that partition.
> 
>  If kswapd0 had a fd open on the swap files, swapoff /proc/$PID/fd/3
> could possibly work.  But it looks like the files are open but with no
> user-space accessable file descriptors to them.  Which makes sense,
> except for this case.

Right, except that kswapd is per node, so we'd either have to add it to
all kswapd instances or a random one. Also, kthreads don't seem to have
a files table afaict.

But yes, I see your problem and it makes sense to look for a nice
solution.

