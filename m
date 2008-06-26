Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbYFZLVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbYFZLVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbYFZLVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:21:40 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:57316 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753818AbYFZLVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:21:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEGANexXkh5LG+uZWdsb2JhbACSahICHpsi
X-IronPort-AV: E=Sophos;i="4.27,708,1204464600"; 
   d="scan'208";a="143488518"
Date: Thu, 26 Jun 2008 21:21:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, matthew@wil.cx, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
Message-ID: <20080626112133.GJ11558@disturbed>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	matthew@wil.cx, linux-kernel@vger.kernel.org
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <20080626074636.GB7064@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626074636.GB7064@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 03:46:36AM -0400, Christoph Hellwig wrote:
> On Thu, Jun 26, 2008 at 02:41:12PM +1000, Dave Chinner wrote:
> > XFS object flushing doesn't quite match existing completion semantics.  It
> > mixed exclusive access with completion. That is, we need to mark an object as
> > being flushed before flushing it to disk, and then block any other attempt to
> > flush it until the completion occurs.
> > 
> > To do this we introduce:
> > 
> > void init_completion_flush(struct completion *x)
> > 	which initialises x->done = 1
> > 
> > void completion_flush_start(struct completion *x)
> > 	which blocks if done == 0, otherwise decrements done to zero and
> > 	allows the caller to continue.
> > 
> > bool completion_flush_start_nowait(struct completion *x)
> > 	returns a failure status if done == 0, otherwise decrements done
> > 	to zero and returns a "flush started" status. This is provided
> > 	to allow flushing to begin safely while holding object locks in
> > 	inverted order.
> > 
> > This replaces the use of semaphores for providing this exclusion
> > and completion mechanism.
> 
> Given that the only API call shared with normal completions is
> complete() I'd rather make this a primitive of it's own, even if
> internally implemented as completions.

Ok, so that involves exactly what? A new header file, a new API name
(ideas anyone?) and kerneldoc comments?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
