Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbXDYAua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbXDYAua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 20:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbXDYAua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 20:50:30 -0400
Received: from lazybastard.de ([212.112.238.170]:44153 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbXDYAu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 20:50:29 -0400
Date: Wed, 25 Apr 2007 02:46:25 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070425004625.GE6871@lazybastard.org>
References: <20070424222105.883597089@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070424222105.883597089@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 April 2007 15:21:05 -0700, clameter@sgi.com wrote:
> 
> This patchset modifies the Linux kernel so that larger block sizes than
> page size can be supported. Larger block sizes are handled by using
> compound pages of an arbitrary order for the page cache instead of
> single pages with order 0.

I like to see this.

> 2. 32/64k blocksize is also used in flash devices. Same issues.

Actually most chips I encounter these days already have 128KiB.  And
some people seem to do some kind of raid-0 in the drivers to increase
bandwidth.  FS-visible blocksize is also increased by that.

> Unsupported
> - Mmapping blocks larger than page size

Bummer.  Can this change in the future?

> Issues:
> - There are numerous places where the kernel can no longer assume that the
>   page cache consists of PAGE_SIZE pages that have not been fixed yet.
> - Defrag warning: The patch set can fragment memory very fast.
>   It is likely that Mel Gorman's anti-frag patches and some more
>   work by him on defragmentation may be needed if one wants to use
>   super sized pages.
>   If you run a 2.6.21 kernel with this patch and start a kernel compile
>   on a 4k volume with a concurrent copy operation to a 64k volume on
>   a system with only 1 Gig then you will go boom (ummm no ... OOM) fast.
>   How well Mel's antifrag/defrag methods address this issue still has to
>   be seen.

"only 1 Gig" :)

With my LogFS hat on, I don't care too much whether data is cached in
terms of pages or blocks.  What matters to me most is to get fed
blocksize chunk on writeback and be able to read blocksize'd chunks.
Compressing 64KiB at a time gives somewhere around 10% (don't remember
exact number) better compression when compared to 4KiB.  JFFS2 can
benefit from this as well.

That should also be sufficient for cross-platform compatibility,
shouldn't it?

Better performance for the pagecache is also nice to have, no doubt.
But if system stability remains an issue, I'd rather keep slow and
stable.

Jörn

-- 
More computing sins are committed in the name of efficiency (without
necessarily achieving it) than for any other single reason - including
blind stupidity.
-- W. A. Wulf
