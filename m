Return-Path: <linux-kernel-owner+w=401wt.eu-S969525AbXILTHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969525AbXILTHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 15:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757830AbXILTHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 15:07:00 -0400
Received: from mail.fieldses.org ([66.93.2.214]:49962 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860AbXILTG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 15:06:59 -0400
Date: Wed, 12 Sep 2007 15:06:53 -0400
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Memory shortage can result in inconsistent flocks state
Message-ID: <20070912190653.GA13792@fieldses.org>
References: <46E68C35.7040001@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E68C35.7040001@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 04:38:13PM +0400, Pavel Emelyanov wrote:
> This is a known feature that such "re-locking" is not atomic,
> but in the racy case the file should stay locked (although by
> some other process), but in this case the file will be unlocked.

That's a little subtle (I assume you've never seen this actually
happen?), but it makes sense to me.

> The proposal is to prepare the lock in advance keeping no chance
> to fail in the future code.

And the patch certainly looks correct.

I can add it to my (trivial) lock patches, if that's helpful--it'll
get folded into the branch -mm pulls from and I can pass it along to
Linus for 2.6.24.

What I don't have that I wish I did is good regression tests for the
flock or lease code (for posix locks I've been using connectathon,
though that misses some important things too).

--b.
