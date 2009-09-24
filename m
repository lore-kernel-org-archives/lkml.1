Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134AbZIXWK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbZIXWK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZIXWKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:10:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369AbZIXWKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:10:55 -0400
Date: Thu, 24 Sep 2009 15:09:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, graff.yang@gmail.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com,
       penberg@cs.helsinki.fi, lethal@linux-sh.org, mel@csn.ul.ie,
       gerg@snapgear.com, stable@kernel.org
Subject: Re: [PATCH] NOMMU: Fix MAP_PRIVATE mmap() of objects where the data
 can be mapped directly
Message-Id: <20090924150925.06f4fa23.akpm@linux-foundation.org>
In-Reply-To: <20090924141310.19746.31678.stgit@warthog.procyon.org.uk>
References: <20090924141310.19746.31678.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 15:13:10 +0100
David Howells <dhowells@redhat.com> wrote:

> Fix MAP_PRIVATE mmap() of files and devices where the data in the backing store
> might be mapped directly.  Use the BDI_CAP_MAP_DIRECT capability flag to govern
> whether or not we should be trying to map a file directly.  This can be used to
> determine whether or not a region has been filled in at the point where we call
> do_mmap_shared() or do_mmap_private().
> 
> The BDI_CAP_MAP_DIRECT capability flag is cleared by validate_mmap_request() if
> there's any reason we can't use it.  It's also cleared in do_mmap_pgoff() if
> f_op->get_unmapped_area() fails.
> 

The patch seems -stable-worthy but I see no cc:stable here?

> Note that this fix does the following commit differently:
> 
> 	commit a190887b58c32d19c2eee007c5eb8faa970a69ba
> 	Author: David Howells <dhowells@redhat.com>
> 	Date:   Sat Sep 5 11:17:07 2009 -0700
> 	nommu: fix error handling in do_mmap_pgoff()

I don't understand what you're saying here.

> Reported-by: Graff Yang <graff.yang@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Greg Ungerer <gerg@snapgear.com>

