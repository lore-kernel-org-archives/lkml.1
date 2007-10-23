Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbXJWWLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbXJWWLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbXJWWL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:11:29 -0400
Received: from waste.org ([66.93.16.53]:59726 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbXJWWL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:11:29 -0400
Date: Tue, 23 Oct 2007 17:11:16 -0500
From: Matt Mackall <mpm@selenic.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Message-ID: <20071023221116.GL17536@waste.org>
References: <1193173966-3550-1-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193173966-3550-1-git-send-email-matthew@wil.cx>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 05:12:43PM -0400, Matthew Wilcox wrote:
> Consecutive calls to printk are non-atomic, which leads to various
> implementations for accumulating strings which can be printed in one call.
> This is a generic string buffer which can also be used for non-printk
> purposes.  There is no sb_scanf implementation yet as I haven't identified
> a user for it.

You might want to consider growing the buffer by no less than a small
constant factor like 1.3x. This will keep things that do short concats
in a loop from degrading to O(n^2) performance due to realloc and
memcpy.

> + * No locking is performed, although memory allocation is done with
> + * GFP_ATOMIC to allow it to be called when you're holding a lock.

Should probably just bite the bullet and pass a flag.

> +#define INITIAL_SIZE 32

Too small. That will guarantee that most users end up doing a realloc.
Can we have 128 instead?

-- 
Mathematics is the supreme nostalgia of our time.
