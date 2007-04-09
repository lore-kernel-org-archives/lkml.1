Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbXDIOA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbXDIOA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbXDIOA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:00:59 -0400
Received: from thunk.org ([69.25.196.29]:37265 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbXDIOA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:00:58 -0400
Date: Mon, 9 Apr 2007 10:00:55 -0400
From: Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Add a norecovery option to ext3/4?
Message-ID: <20070409140055.GD18580@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070409000556.GA13980@implementation> <4619B202.3050601@redhat.com> <20070409033134.GB13980@implementation> <4619B60B.6030405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4619B60B.6030405@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 08, 2007 at 10:42:03PM -0500, Eric Sandeen wrote:
> Samuel Thibault wrote:
> 
> >>Hm, so the root cause there seems that the installer found 2 legs of a 
> >>mirror and mounted them independently, recovering them independently... 
> >>But why did that cause problems?
> >
> >Because that thrashed his data (or at least it didn't help to keep data
> >safe).

Actually, reading through the Debian bug report, there is no proof
that is what actually caused the data loss.  I certainly can't think
of any explanation for why that would have happened.  See the summary
from Steve Langasek::

>Checkpoint of the IRC discussion:
>
>- The submitter says that after reboot, the RAID was reported as out of
>  sync.
>- The logs show that the ext3 filesystem was automatically mounted rw for
>  journal recovery by the kernel driver.
>- There is no evidence in the logs that the RAID was ever assembled within
>  d-i, so it shouldn't be the case that the RAID superblocks were out of
>  sync as a result of d-i itself.
>- This leaves two possible reasons for the out-of-sync state of the RAID:
>  either mounting the individual partitions as ext3 filesystems somehow
>  overwrote the RAID superblock just the right way (unlikely since it would
>  require the ext3 driver to write past the end of the declared filesystem),
>  or the RAID superblocks were out of sync /before/ booting d-i.  The latter
>  is consistent with the fact that the ext3 driver had to do a journal
>  recovery, suggesting that both the ext3 fs and the RAID were not cleanly
>  shut down.
>- If mounting as ext3 overwrote the RAID superblock, that seems to be a
>  kernel bug, and we have no good explanation for how that would happen.
>- If the RAID was unclean before booting d-i, all bets are off as to the
>  state of the filesystem at the beginning of this journal recovery, and it
>  may be difficult to ever reproduce this bug.

> The reason I suggest other options is because intentionally mounting a 
> corrupted FS may not really be the way you want to go... norecovery on 
> xfs at least is an option of last resort, not something to use by default.

This would also be true for ext3; I am extremely uncomfortable with
people thinking that a norecovery option is something that should be
routinely used by programs.  It's something that should only be used
by experts, who know what they are doing and who are willing to accept
the potential risks.

						- Ted
