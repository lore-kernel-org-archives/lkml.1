Return-Path: <linux-kernel-owner+w=401wt.eu-S935928AbXHHBPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935928AbXHHBPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757805AbXHHBPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:15:41 -0400
Received: from waste.org ([66.93.16.53]:36506 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102AbXHHBPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:15:41 -0400
Date: Tue, 7 Aug 2007 20:16:21 -0500
From: Matt Mackall <mpm@selenic.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com
Subject: Re: [RFC][PATCH 1/5] pagemap: remove file header
Message-ID: <20070808011620.GF30556@waste.org>
References: <20070807223300.9228E0E0@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807223300.9228E0E0@kernel>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:33:00PM -0700, Dave Hansen wrote:
> 
> The /proc/<pid>/pagemap file has a header containing:
>  * first byte:   0 for big endian, 1 for little
>  * second byte:  page shift (eg 12 for 4096 byte pages)
>  * third byte:   entry size in bytes (currently either 4 or 8)
>  * fourth byte:  header size
> 
> The endianness is only useful when examining a raw dump of
> pagemap from a different machine when you don't know the
> source of the file.  This is pretty rare, and the programs
> or scripts doing the copying off-machine can certainly be
> made to hold this information.
> 
> The page size is available in userspace at least with libc's
> getpagesize().  This will also never vary across processes,
> so putting it in a per-process file doesn't make any difference.
> If we need a "kernel's page size" exported to userspace,
> perhaps we can put it in /proc/meminfo.
> 
> The entry size is the really tricky one.  This can't just
> be sizeof(unsigned long) from userspace because we can have
> 32-bit processes on 64-bit kernels.  But, userspace can
> certainly derive this value if it lseek()s to the end of
> the file, and divides the file position by the size of its
> virtual address space.

I'd really strongly prefer to have no header. It was added to
futureproof the thing.

One downside to this is that dumps are no longer portable. But
that's not a showstopper, I suppose.

-- 
Mathematics is the supreme nostalgia of our time.
