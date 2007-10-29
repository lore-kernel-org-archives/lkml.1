Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbXJ2JVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbXJ2JVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 05:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbXJ2JVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 05:21:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43205 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbXJ2JVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 05:21:14 -0400
Date: Mon, 29 Oct 2007 09:21:03 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scatterlist fallout: drivers/scsi/arm/
Message-ID: <20071029092103.GE8181@ftp.linux.org.uk>
References: <20071027184404.GQ8181@ftp.linux.org.uk> <20071027201700.GC22235@flint.arm.linux.org.uk> <20071029085935.GD5467@kernel.dk> <20071029090710.GB7801@flint.arm.linux.org.uk> <20071029091206.GE5467@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029091206.GE5467@kernel.dk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 10:12:06AM +0100, Jens Axboe wrote:
> > > Russell, will you be merging this yourself or do you want me to include
> > > it in the sg fixup branch?
> > 
> > It's already merged into the ARM git tree as of Friday.  Waiting for
> > ack's from various people for other merged patches before sending the
> > set to Linus.
> 
> Great, thanks.

Speaking of sg fixups...  What should be done about zfcp_address_to_sg()?
You've added the third argument to all calls, but not to definition...

static inline void
zfcp_address_to_sg(void *address, struct scatterlist *list, size_t size)
{
	sg_set_buf(list, address, size);
}
seems to be a plausible guess at what you meant to do, but that's a guess
without anything to back it - I really have not looked into the area at all.
