Return-Path: <linux-kernel-owner+w=401wt.eu-S965640AbXJQRhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965640AbXJQRhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763929AbXJQRgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:36:53 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10382 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765017AbXJQRgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:36:52 -0400
Date: Wed, 17 Oct 2007 19:36:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017173647.GK15552@kernel.dk>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017173408.GA1960@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > OK, it is fine, as long as the sglist is cleared initially. And I 
> > don't think there's anyway around that, clearly I didn't think long 
> > enough before including the memset() removal from Tomo.
> > 
> > Ingo, please try this rolled up version.
> > 
> > Linus, this should work. It would probably be best if you first did a 
> > git revert on f5c0dde4c66421a3a2d7d6fa604a712c9b0744e5 and then 
> > applied the ll_rw_blk.c bit alone. Do you want me to stuff that 
> > (revert + patch) into a branch for you to pull?
> 
> yep, this one did the trick, it booted up fine twice in a row already!
> 
>  Tested-by: Ingo Molnar <mingo@elte.hu>
> 
> thanks!

Great! Thanks a lot for reporting and testing... Linus, care to pull

  git://git.kernel.dk/data/git/linux-2.6-block.git for-linus

Jens Axboe (2):
      Revert "[SCSI] Remove full sg table memset()"
      [BLOCK] blk_rq_map_sg() next_sg fixup

 block/ll_rw_blk.c       |   10 ++++++----
 drivers/scsi/scsi_lib.c |    2 ++
 2 files changed, 8 insertions(+), 4 deletions(-)

-- 
Jens Axboe

