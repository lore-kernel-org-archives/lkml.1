Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbZBSTZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbZBSTZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 14:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZBSTZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 14:25:06 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:40479 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbZBSTZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 14:25:05 -0500
Subject: Re: [RFC][PATCH 1/5] create fs flag to mark c/r supported fs's
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090219190009.GC28490@infradead.org>
References: <20090219182007.B4B47C1F@kernel>
	 <20090219190009.GC28490@infradead.org>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 11:24:51 -0800
Message-Id: <1235071491.26788.67.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 14:00 -0500, Christoph Hellwig wrote:
> On Thu, Feb 19, 2009 at 10:20:07AM -0800, Dave Hansen wrote:
> > 
> > There are plenty of filesystems that are not supported for
> > c/r at this point.  Think of things like hugetlbfs which
> > are externally visible or pipefs which are kernel-internal.
> > 
> > This provides a quick way to make the "normal" filesystems
> > which are currently supported.  This is also safe if any
> > new code gets added.  We assume that a fs is non-supported
> > unless someone takes explicit action to the contrary.
> > 
> > I bet there are some more filesystems that are OK, but
> > these probably cover 99% of the users for now.
> 
> Given that a normal fs should be checkpointable you should
> make those exposing internal state, not the other way around.

In general I agree with you.  But, I think practicality gets in the way
here.  Here's the cscope output from file_system_type and
FS_REQUIRES_DEV (basically grepping the tree for them):

$ wc -l file_system_type FS_REQUIRES_DEV 
  256 file_system_type
   41 FS_REQUIRES_DEV

So, (very) roughly 1/6 of the filesystems are the "normal" block-based
ones that we all know and love.  The rest are ones that I'd have to at
the very least think about before saying that they're supported.

I guess we could say that FS_REQUIRES_DEV by default implies
FS_CHECKPOINTABLE:

#define __FS_REQUIRES_DEV 1
#define FS_REQUIRES_DEV (__FS_REQUIRES_DEV|FS_CHECKPOINTABLE)

I really don't mind doing it *that* much either way, but I'd sure like
to go specifically tag ~40 filesystems rather than 200.  

-- Dave

