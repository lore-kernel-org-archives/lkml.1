Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbXIUJPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbXIUJPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbXIUJPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:15:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49080 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215AbXIUJPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:15:40 -0400
Date: Fri, 21 Sep 2007 02:15:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What's in linux-2.6-block.git for 2.6.24
Message-Id: <20070921021505.99c37589.akpm@linux-foundation.org>
In-Reply-To: <20070921085711.GG2367@kernel.dk>
References: <20070921085711.GG2367@kernel.dk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 10:57:11 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> Hi,
> 
> This details the contents of the block git repo of items that are bound
> for a 2.6.24 merge. The SCSI data buffer accessor patch from Tomo will
> also be going in through the block tree, but it's not merged up yet.
> That's mainly due to my laziness, not because the code isn't ready. That
> will happen sometime during today.
> 
> Misc bits:
> - Various bug fixes from Neil Brown, part of his larger patchset for
>   allowing arbitrarily sized bios.
> - Various little bug fixes and documentation updates.
> 
> Barriers:
> - The empty bio barrier patches from me. These allow sending down a bio
>   with no data attached, for insertion a barrier in a request queue.
>   They are useful for dm and md, but also cleans up the sync
>   blkdev_issue_flush() interface - it's now no longer an addon hack, but
>   just a natural use of empty bio barriers.

That sounds useful.

> SG chaining bits:
> - This is the bulk of the patchset. It consists of three major
>   components:
> 
>         - sglist-core, which add helpers for iterating sg lists and
>           switches the block layer and SCSI to use those. Should not
>           have any functional changes.
>         - sglist-drivers, which converts drivers to use the sg list
>           helpers. Again, should not contain functional changes.
>         - sglist-arch, which adds support to most architectures and
>           actually enables sg chaining.
> 
> The goal of sg chaining is to allow support for very large sgtables,
> without requiring that they be allocated from one contigious piece of
> memory.

Presumably sg chaining means more overhead on the IO submission paths?  If
so, has this been quantified?

