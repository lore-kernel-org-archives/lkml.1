Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbYJ1RsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbYJ1RsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbYJ1Rqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:46:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:35553 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbYJ1Rqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:46:33 -0400
Subject: Re: [patch 1/7] cpusets: add dirty map to struct address_space
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 18:46:25 +0100
Message-Id: <1225215985.15763.36.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 09:08 -0700, David Rientjes wrote:
> @@ -487,6 +488,12 @@ void generic_sync_sb_inodes(struct super_block *sb,
>                         continue;               /* blockdev has wrong queue */
>                 }
>  
> +               if (!cpuset_intersects_dirty_nodes(mapping, wbc->nodes)) {
> +                       /* No node pages under writeback */
> +                       requeue_io(inode);
> +                       continue;
> +               }

So, aside from all the dirty limit and passing node masks around, this
is the magic bit?

I totally missed it first time around, a short mention in the changelog
might not be undeserved.

