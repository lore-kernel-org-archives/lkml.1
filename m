Return-Path: <linux-kernel-owner+w=401wt.eu-S933237AbZFLJ7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237AbZFLJ7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933553AbZFLJ7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:59:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48034 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933716AbZFLJ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:59:16 -0400
Date: Fri, 12 Jun 2009 12:07:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 4/5] HWPOISON: report sticky EIO for poisoned file
Message-ID: <20090612100716.GE25568@one.firstfloor.org>
References: <20090611142239.192891591@intel.com> <20090611144430.813191526@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611144430.813191526@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 10:22:43PM +0800, Wu Fengguang wrote:
> This makes the EIO reports on write(), fsync(), or the NFS close()
> sticky enough. The only way to get rid of it may be
> 
> 	echo 3 > /proc/sys/vm/drop_caches
> 
> Note that the impacted process will only be killed if it mapped the page.
> XXX
> via read()/write()/fsync() instead of memory mapped reads/writes, simply
> because it's very hard to find them.

I don't like the special case bit. Conceptually we shouldn't need
to handle hwpoison specially here; it's just like a standard error. 

It makes hwpoison look more intrusive than it really is :)

I think it would be better to simply make
the standard EIO sticky; that would fix a lot of other issues too (e.g.
better reporting of metadata errors) But that's something for post .31.

For .31 I think hwpoison can live fine with non sticky errors; it was
more a problem of the test suite anyways which we worked around.

So better drop this patch for now.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
