Return-Path: <linux-kernel-owner+w=401wt.eu-S965578AbXDVJRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965578AbXDVJRE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 05:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965584AbXDVJRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 05:17:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33284 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965578AbXDVJRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 05:17:01 -0400
Date: Sun, 22 Apr 2007 10:16:58 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
Message-ID: <20070422091658.GB1558@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	"David S. Miller" <davem@davemloft.net>
References: <46247427.6000902@redhat.com> <20070422011810.e76685cc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070422011810.e76685cc.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 01:18:10AM -0700, Andrew Morton wrote:
> On Tue, 17 Apr 2007 03:15:51 -0400 Rik van Riel <riel@redhat.com> wrote:
> 
> > Make it possible for applications to have the kernel free memory
> > lazily.  This reduces a repeated free/malloc cycle from freeing
> > pages and allocating them, to just marking them freeable.  If the
> > application wants to reuse them before the kernel needs the memory,
> > not even a page fault will happen.
> > 
> > This patch, together with Ulrich's glibc change, increases
> > MySQL sysbench performance by a factor of 2 on my quad core
> > test system.
> > 
> 
> In file included from include/linux/mman.h:4,
>                  from arch/sparc64/kernel/sys_sparc.c:19:
> include/asm/mman.h:36:1: "MADV_FREE" redefined
> In file included from include/asm/mman.h:5,
>                  from include/linux/mman.h:4,
>                  from arch/sparc64/kernel/sys_sparc.c:19:
> include/asm-generic/mman.h:32:1: this is the location of the previous definition
> 
> sparc32 and sparc64 already defined MADV_FREE:
> 
> 
> #define MADV_FREE       0x5             /* (Solaris) contents can be freed */
> 
> I'll remove the sparc definitions for now, but we need to work out what
> we're going to do here.  Your patch changes the values of MADV_FREE on
> sparc.
> 
> Perhaps this should be renamed to MADV_FREE_LINUX and given a different
> number.  It depends on how close your proposed behaviour is to Solaris's.

Why isn't MADV_FREE defined to 5 for linux?  It's our first free madv
value?  Also the behaviour should better match the one in solaris or BSD,
the last thing we need is slightly different behaviour from operating
systems supporting this for ages.
