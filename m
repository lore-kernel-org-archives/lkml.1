Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbYIVCvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbYIVCvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 22:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbYIVCvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 22:51:35 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:48402 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751295AbYIVCve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 22:51:34 -0400
Date: Sun, 21 Sep 2008 22:51:29 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: akpm@linux-foundation.org,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext3/jbd: Avoid WARN() messages when failing to write
	to the superblock
Message-ID: <20080922025129.GB9914@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	akpm@linux-foundation.org,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
References: <1221946547-9873-1-git-send-email-tytso@mit.edu> <20080921173328.GB23547@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080921173328.GB23547@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 07:33:28PM +0200, Jan Kara wrote:
> > This fixes some very common warnings reported by kerneloops.org
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>   The patch looks nice but does it really fix the warnings? I see
> at least ext3_put_super() calling mark_buffer_dirty() before calling
> ext3_commit_super(). We should just remove that mark_buffer_dirty()
> call.

I tested it, and in practice it works, since mark_buffer_dirty() only
causes a problem if an attempt to write to the superblock has already
failed.  I agree that we should just remove that mark_buffer_dirty()
call, though, since ext3_put_super() calls ext3_commit_super() which
calls mark_buffer_dirty() anyway.  I'll respin the patch.

>   BTW: Do you plan doing a similar fix for ext2 and ext4?

I have a similar fix for ext4 that is queued up to be pushed once the
merge window opens.  I haven't back-ported it to ext2 yet, but I will.

						- Ted
