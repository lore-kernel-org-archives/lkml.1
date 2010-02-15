Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab0BOT2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 14:28:54 -0500
Received: from thunk.org ([69.25.196.29]:33702 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031Ab0BOT2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 14:28:52 -0500
Date: Mon, 15 Feb 2010 14:28:49 -0500
From: tytso@mit.edu
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: ext4_xattr_ibody_set() error ignored in
 ext4_expand_extra_isize_ea()
Message-ID: <20100215192849.GM5337@thunk.org>
Mail-Followup-To: tytso@mit.edu, Roel Kluin <roel.kluin@gmail.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <4B6AF1AF.3010008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6AF1AF.3010008@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 05:11:27PM +0100, Roel Kluin wrote:
> The error handling was missing.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Is this needed?

Yep, it's added, thanks.  I'm not entirely right the error handling is
completely correct in this function; in particular, if we fail after
this point in the function, and we've already changed the status of
EXT4_STATE_XATTR flag, but then we fail due to some error (maybe an
I/O error), it's not clear the cleanup section is properly unwinding
all of the side effects made so far in this function.

Still, adding the error check clearly makes the code better than it
was before, so I've added it to the ext4 patch queue.

    	       	    	     	    - Ted
