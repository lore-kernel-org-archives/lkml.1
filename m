Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbZIIU6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbZIIU6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 16:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZIIU6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 16:58:33 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54431 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbZIIU6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 16:58:33 -0400
Date: Wed, 9 Sep 2009 22:58:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ed Cashin <ecashin@coraid.com>
Cc: alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org, apw@canonical.com,
       bonbons@linux-vserver.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aoe: end barrier bios with EOPNOTSUPP
Message-ID: <20090909205835.GK18599@kernel.dk>
References: <20090903063539.GH12579@kernel.dk> <2339aa04a4e8fb440a52624273728352@coraid.com> <20090904183525.GB18599@kernel.dk> <f48e25c99e41e375f2ddd85989cd39e1@coraid.com> <20090905051735.GH18599@kernel.dk> <366469f19c41e0150028b886f6859019@coraid.com> <20090908193540.GB18599@kernel.dk> <60772f633c524ba873f569966fccd6ce@coraid.com> <20090909180804.3e62331a@lxorguk.ukuu.org.uk> <30b7855d211ab5b6bef6fe2cd9b76295@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30b7855d211ab5b6bef6fe2cd9b76295@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09 2009, Ed Cashin wrote:
> On Wed Sep  9 13:06:42 EDT 2009, alan@lxorguk.ukuu.org.uk wrote:
> > > The bio in question is a barrier.  Jens Axboe suggested that such bios
> > > need to be recognized and ended with -EOPNOTSUPP by any driver that
> > > provides its own ->make_request_fn handler and does not handle
> > > barriers.
> > > 
> > > In testing the changes below eliminate the BUG.
> > 
> > Presumably AoE should actually issue an ATA cache flush for this case ?
> 
> Yes.  The aoe driver juggles a set of in-process I/O operations that
> have been sent to the AoE target but have not yet received responses.
> 
> To implement the barrier, it would stop generating new AoE write
> commands, wait for AoE write responses for all the outstanding write
> commands, issue the ATA cache flush command, wait for the response to
> the flush, and then resume normal activity.

That's how barriers work with sata to begin with, so I'd very much
recommend that you do the same in aoe instead of just not supporting it.

-- 
Jens Axboe

