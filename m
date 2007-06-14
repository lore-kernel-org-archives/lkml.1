Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbXFNXzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbXFNXzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbXFNXzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:55:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41850 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752810AbXFNXy7 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:54:59 -0400
Date: Fri, 15 Jun 2007 09:54:50 +1000
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large Blocksize support
Message-ID: <20070614235450.GH86004887@sgi.com>
References: <20070614193839.878721298@sgi.com> <20070614130645.cabdff1b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614130645.cabdff1b.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 01:06:45PM -0700, Andrew Morton wrote:
> On Thu, 14 Jun 2007 12:38:39 -0700
> clameter@sgi.com wrote:
> 
> > This patchset cleans up the page cache handling by replacing
> > open coded shifts and adds through inline function calls.
> 
> If we never inflict variable PAGE_CACHE_SIZE upon the kernel, these changes
> become pointless obfuscation.

The open coding of shifts, masks, and other associated cruft is a real
problem. It leads to ugly and hard to understand code when you have to do
anything complex. That means when you come back to that code 6 months later,
you've got to take to the time to understand exactly what all that logic is
doing again.

IMO, xfs_page_state_convert() is a great example of where open coding
of PAGE_CACHE_SIZE manipulations lead to eye-bleeding code. This
patch set would go a long way to help clean up that mess.

IOWs, like hch, I think this patch set stands on it's own merit
regardless of concerns over variable page cache page sizes....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
