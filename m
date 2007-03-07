Return-Path: <linux-kernel-owner+w=401wt.eu-S1422908AbXCGRUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422908AbXCGRUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:20:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422905AbXCGRT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:19:57 -0500
Received: from verein.lst.de ([213.95.11.210]:52909 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422940AbXCGRTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:19:08 -0500
Date: Wed, 7 Mar 2007 18:15:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: Michael Nishimoto <miken@agami.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com, ecashin@coraid.com,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: stop using kmalloc in xfs_buf_get_noaddr
Message-ID: <20070307171547.GA22641@lst.de>
References: <20070307101324.GC30587@lst.de> <45EEF0B5.40905@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EEF0B5.40905@agami.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 09:04:53AM -0800, Michael Nishimoto wrote:
> Incore log buffers are not always a power of two of the page size.
> In particular, when xfs is running over software raid devices, the
> log buffers are allocated to match the size of a stripe.
> 
> However, they are always a multiple of PAGE_SIZE, so we are still safe.

It's not actually about beeing safe - any allocation is still safe
with this patch.  The issue is just that we waste memory because
we round up allocations to the next page size.

The power of two bit is actually wrong in this mail, it was about
another optimization I have that needs some more testing first.

