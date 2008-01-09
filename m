Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbYAIJbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbYAIJbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbYAIJbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:31:22 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44235 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYAIJbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:31:20 -0500
Date: Wed, 9 Jan 2008 09:31:07 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, chris.mason@oracle.com,
       linux-fsdevel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080109093107.GA5023@infradead.org>
References: <20080109085231.GE6650@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109085231.GE6650@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 09:52:32AM +0100, Jens Axboe wrote:
> - The file block mappings must not change while loop is using the file.
>   This means that we have to ensure exclusive access to the file and
>   this is the bit that is currently missing in the implementation. It
>   would be nice if we could just do this via open(), ideas welcome...

And the way this is done is simply broken.  It means you have to get
rid of things like delayed or unwritten hands beforehand, it'll be
a complete pain for COW or non-block backed filesystems.

The right way to do this is to allow direct I/O from kernel sources
where the filesystem is in-charge of submitting the actual I/O after
the pages are handed to it.  I think Peter Zijlstra has been looking
into something like that for swap over nfs.

