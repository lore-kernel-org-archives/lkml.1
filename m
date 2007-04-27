Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbXD0Uz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbXD0Uz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbXD0Uzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:55:54 -0400
Received: from waste.org ([66.93.16.53]:46010 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757238AbXD0Uzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:55:42 -0400
Date: Fri, 27 Apr 2007 15:41:55 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: - maps2-add-proc-pid-pagemap-interface-fix.patch removed from -mm tree
Message-ID: <20070427204155.GT11115@waste.org>
References: <200704270814.l3R8EnFJ023047@shell0.pdx.osdl.net> <20070427104533.GA6001@localhost.sw.ru> <20070427132713.fc9d82c0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427132713.fc9d82c0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 01:27:13PM -0700, Andrew Morton wrote:
> On Fri, 27 Apr 2007 14:45:33 +0400
> Alexey Dobriyan <adobriyan@sw.ru> wrote:
> 
> > > maps2-add-proc-pid-pagemap-interface.patch
> > 
> > Ohhh, you're repeating december mincore() bug
> > 2f77d107050abc14bc393b34bdb7b91cf670c250
> > 
> > pagemap_read() takes ->mmap_sem for reading
> > walk_page_range
> > pagemap_pte_range
> > add_to_pagemap
> > flush_pagemap
> > copy_to_user
> 
> argh.  I think it's always a bug to run uaccess functions while holding
> mmap_sem, isn't it?

Yep, looks that way.

> I'll see if I can get something like this working as a -mm-only thing:

I was wondering if there was a sensible way to do this. This looks
pretty good.
 
> +	no+_mmap_sem();						\

Except for this bit. Maybe put it in the same config bucket as might_sleep?

-- 
Mathematics is the supreme nostalgia of our time.
