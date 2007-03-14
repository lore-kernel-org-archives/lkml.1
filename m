Return-Path: <linux-kernel-owner+w=401wt.eu-S1422650AbXCNPRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422650AbXCNPRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422649AbXCNPRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:17:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53834 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422646AbXCNPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:17:31 -0400
Date: Wed, 14 Mar 2007 15:17:03 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Mark Fasheh <mark.fasheh@oracle.com>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/3] fs: introduce perform_write aop
Message-ID: <20070314151703.GA5428@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <npiggin@suse.de>, Mark Fasheh <mark.fasheh@oracle.com>,
	Linux Filesystems <linux-fsdevel@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070208105458.26443.41479.sendpatchset@linux.site> <20070309103913.GA4503@infradead.org> <20070309233301.GC18555@ca-server1.us.oracle.com> <20070310092541.GA22182@infradead.org> <20070314133023.GA5103@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314133023.GA5103@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 02:30:24PM +0100, Nick Piggin wrote:
> So I've tried a different approach - the 2-op API rather than an actor.
> 
> perform_write stays around as a higher performance API, but it isn't
> required if the filesystem implements the 2-op API. I've called them
> write_begin/write_end for now.
> 
> There are a few upshots to doing this rather than the actor approach.
> First of all, this is what callers expect, they want to write into the
> page directly rather than making an actor.
> 
> More importantly, it allows us to implement generic block versions of
> the API which is much more reusable than block_perform_write (which was
> basically useless for anything more than ext2).

Generally thiis look pretty cool.  But even if we go with perform_write
as aop for now (which I think is a bad idea aswell, but moving it out
would better be done after all filesystems are converted) these should
just stay callbacks passed to generic_perform_write.
