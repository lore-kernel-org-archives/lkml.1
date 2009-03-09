Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbZCIJyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbZCIJyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 05:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbZCIJyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 05:54:14 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40559 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbZCIJyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 05:54:13 -0400
Date: Mon, 9 Mar 2009 10:54:11 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, martin.petersen@oracle.com
Subject: Re: [PATCH] block: fix memory leak in bio_clone()
Message-ID: <20090309095411.GL11787@kernel.dk>
References: <49B4DD9C.5030902@cn.fujitsu.com> <20090309092407.GI11787@kernel.dk> <49B4E2BA.3030809@cn.fujitsu.com> <20090309093836.GJ11787@kernel.dk> <49B4E6AE.2030302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B4E6AE.2030302@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09 2009, Li Zefan wrote:
> >>> as the mempool mask. So the leak will not occur, but it does mean that
> >>> it isn't honoring the gfp_mask passed in to bio_clone(), which is the
> >> I noticed there was a patch to do this, and seems you planed to merge
> >> it into .29?
> >>
> >> "[PATCH] Add gfp_mask to bio_integrity_clone()"
> >>
> >> http://lkml.org/lkml/2008/10/30/11
> > 
> > Hmm strange, apparently that never got queued up and I had forgotten all
> > about that issue until your email. I'll add it asap.
> > 
> 
> I found bio_integrity_clone() is not using the gfp_mask passed by bio_clone(),
> so I googled it in LKML before I fix it. :)

I've got both patches queued up now:

http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=refs/heads/for-linus

> >>> first bug. The second bug is that it should be using its own bioset, as
> >>> it is illegal to do multiple __GFP_WAIT allocations on a single mempool
> >>> and always expect progress.
> > 
> > That one still stands.
> > 
> 
> Yes, and I'd leave it to you or Martin. ;)

I'll let Martin sort that out, it can easily wait for the next release.

-- 
Jens Axboe

