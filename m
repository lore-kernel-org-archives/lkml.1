Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbYBDTjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbYBDTjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYBDTjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:39:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46678 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYBDTjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:39:45 -0500
Date: Mon, 4 Feb 2008 14:39:39 -0500
From: Christoph Hellwig <hch@lst.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 0/3] add perform_write to a_ops
Message-ID: <20080204193939.GA19236@lst.de>
References: <20080204170409.991123259@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204170409.991123259@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 06:04:10PM +0100, Miklos Szeredi wrote:
> a_ops->perform_write() was left out from Nick Piggin's new a_ops
> patchset, as it was non-essential, and postponed for later inclusion.
> 
> This short series reintroduces it, but only adds the fuse
> implementation and not simple_perform_write(), which I'm not sure
> would be a significant improvement.
> 
> This allows larger than 4k buffered writes for fuse, which is one of
> the most requested features.
> 
> This goes on top of the "fuse: writable mmap" patches.

Please don't do this, but rather implement your own .aio_write.  There's
very little in generic_file_aio_write that wouldn't be handle by
->perform_write and we should rather factor those up or move to higher
layers than adding this ill-defined abstraction.

