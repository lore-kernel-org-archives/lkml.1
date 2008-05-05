Return-Path: <linux-kernel-owner+w=401wt.eu-S1758535AbYEELLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbYEELLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbYEELL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 07:11:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52577 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbYEELL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 07:11:26 -0400
Date: Mon, 5 May 2008 07:11:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 15/15] vfs: splice remove_suid() cleanup
Message-ID: <20080505111123.GG20910@infradead.org>
References: <20080505095440.820370974@szeredi.hu> <20080505095532.980827078@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505095532.980827078@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 11:54:56AM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> generic_file_splice_write() duplicates remove_suid() just because it
> doesn't hold i_mutex.  But it grabs i_mutex inside splice_from_pipe()
> anyway, so this is rather pointless.
> 
> Move locking to generic_file_splice_write() and call remove_suid() and
> __splice_from_pipe() instead.

Looks good to me.  I wonder whether we should kill splice_from_pipe
entirely and always leave the locking to the caller.

