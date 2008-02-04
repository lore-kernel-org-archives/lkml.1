Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYBDVAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYBDVAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYBDVAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:00:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48228 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbYBDVAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:00:00 -0500
Date: Mon, 4 Feb 2008 15:59:52 -0500
From: Christoph Hellwig <hch@lst.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@lst.de, npiggin@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch 0/3] add perform_write to a_ops
Message-ID: <20080204205950.GB14084@lst.de>
References: <20080204170409.991123259@szeredi.hu> <20080204193939.GA19236@lst.de> <E1JM8IQ-0003pP-Dw@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JM8IQ-0003pP-Dw@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 09:52:06PM +0100, Miklos Szeredi wrote:
> Moving up to higher layers might not be possible, due to lock/unlock
> of i_mutex being inside generic_file_aio_write().

Well some bits can be moved up.  Here's my grand plan which I plan
to implement once I get some time for it (or let someone else do
if they beat me):

 - generic_segment_checks goes to fs/read_write.c before caling into
   the filesystem
 - dito for vfs_check_frozen
 - generic_write_checks is a suitable helper already
 - dito for remove_suid
 - dito for file_update_time
 - after that there's not a whole lot left in generic_file_aio_write,
   except for direct I/O handling which will probably be very fs-specific
   if you have your own buffered I/O code

generic_file_buffered_write is an almost trivial wrapper around what's
->perform_write in Nick's earlier patches and a helper for the syncing
activity.



> 
> But with fuse being the only user, it's not a huge issue duplicating
> some code.
> 
> Nick, were there any other candidates, that would want to use such an
> interface in the future?
> 
> Thanks,
> Miklos
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
