Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbZBHJGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbZBHJGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 04:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZBHJGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 04:06:30 -0500
Received: from verein.lst.de ([213.95.11.210]:51117 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbZBHJG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 04:06:28 -0500
Date: Sun, 8 Feb 2009 10:05:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 3/4] Move FASYNC bit handling to f_op->fasync()
Message-ID: <20090208090550.GC18521@lst.de>
References: <1234037217-16124-1-git-send-email-corbet@lwn.net> <1234037217-16124-4-git-send-email-corbet@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234037217-16124-4-git-send-email-corbet@lwn.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 01:06:56PM -0700, Jonathan Corbet wrote:
> Removing the BKL from FASYNC handling ran into the challenge of keeping the
> setting of the FASYNC bit in filp->f_flags atomic with regard to calls to
> the underlying fasync() function.  Andi Kleen suggested moving the handling
> of that bit into fasync(); this patch does exactly that.  As a result, we
> have a couple of internal API changes: fasync() must now manage the FASYNC
> bit, and it will be called without the BKL held.
> 
> As it happens, every fasync() implementation in the kernel with one
> exception calls fasync_helper().  So, if we make fasync_helper() set the
> FASYNC bit, we can avoid making any changes to the other fasync()
> functions - as long as those functions, themselves, have proper locking.
> Most fasync() implementations do nothing but call fasync_helper() - which
> has its own lock - so they are easily verified as correct.  The BKL had
> already been pushed down into the rest.
> 
> The networking code has its own version of fasync_helper(), so that code
> has been augmented with explicit FASYNC bit handling.

> +	/* Maintaining the FASYNC bit is our job now */

Not sure this comment is a good idea.  All comments of the style
something has changes and is this now get stale really soon.  If you
want to document that change in more details it should probably go
into Documentation/filesystems/Locking near the fasync part.


But the actual good changes look good, so:


Reviewed-by: Christoph Hellwig <hch@lst.de>

