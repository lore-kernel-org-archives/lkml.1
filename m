Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbYDGA7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbYDGA7N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 20:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbYDGA67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 20:58:59 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:42506 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbYDGA66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 20:58:58 -0400
Date: Mon, 7 Apr 2008 02:01:29 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
In-Reply-To: <1207524935.3223.39.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0804070145550.28303@blonde.site>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>
 <1207524935.3223.39.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Apr 2008, James Bottomley wrote:
> 
> This was sort of accidentally fixed in scsi-misc by commit 
> 
> commit c5f73260b289cb974928eac05f2d84e58ddfc020
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Thu Mar 13 11:16:33 2008 -0500
> 
>     [SCSI] consolidate command allocation in a single place

Thanks, yes, that looks a good substitute to me.

> Could you check that:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> and see if it alleviates the problem? ... if so, we can work out which
> pieces to backport.

Precisely that patch seems appropriate to 2.6.25-rc8-git, so I'm now
running the test with just that applied to 2.6.25-rc8 (plus cfq rcu
fix).  Not quite what you asked, but...

Strictly speaking, it'd take a couple of days to be reasonably sure
that the livelock is gone (it appeared to reproduce quicker once I
moved to -rc8 plus cfq rcu fix; but I'm not entirely convinced that
wasn't just coincidence).  But if nothing bad appears overnight,
let's assume your patch is the one to push: I'll report tomorrow.

Hugh

