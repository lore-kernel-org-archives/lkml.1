Return-Path: <linux-kernel-owner+w=401wt.eu-S933548AbXJROST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548AbXJROST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760264AbXJROSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:18:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758194AbXJROSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:18:07 -0400
Date: Thu, 18 Oct 2007 10:17:15 -0400
From: Rik van Riel <riel@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Vasily Averin <vvs@sw.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, devel@openvz.org
Subject: Re: How Inactive may be much greather than cached?
Message-ID: <20071018101715.13c92b6e@bree.surriel.com>
In-Reply-To: <200710181727.01128.nickpiggin@yahoo.com.au>
References: <4716FC04.6070107@sw.ru>
	<200710181627.27827.nickpiggin@yahoo.com.au>
	<471707BD.4000203@sw.ru>
	<200710181727.01128.nickpiggin@yahoo.com.au>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 17:27:00 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Some filesystems, including I believe, ext3 with data=ordered,
> can leave orphaned pages around after they have been truncated
> out of the pagecache. These pages get left on the LRU and vmscan
> reclaims them pretty easily.

How can the VM recognize those pages?  Are they part of
the buffer cache, part of the page cache, or different?

I think it would make sense to at least try to rotate
those pages to the end of the LRU so kswapd can get rid
of them quickly.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
