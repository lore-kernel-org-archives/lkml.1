Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbYJIIlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbYJIIlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 04:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYJIIkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 04:40:53 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:45136 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbYJIIkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 04:40:53 -0400
Date: Thu, 9 Oct 2008 10:40:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] ide: locking improvements
Message-ID: <20081009084020.GB19428@kernel.dk>
References: <20081008202930.19112.90371.sendpatchset@localhost.localdomain> <20081009065141.GV19428@kernel.dk> <58cb370e0810090136t327734cerf6eb933422b9791c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58cb370e0810090136t327734cerf6eb933422b9791c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09 2008, Bartlomiej Zolnierkiewicz wrote:
> On Thu, Oct 9, 2008 at 8:51 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Wed, Oct 08 2008, Bartlomiej Zolnierkiewicz wrote:
> >>
> >> Locking improvements in preparation for replacing the global ide_lock
> >> spinlock by per-hwgroup spinlocks [1].
> >>
> >> [1] patch (which is partially based on 2005 patch from Scalex86) for this
> >> is also ready but it needs some more audit and testing
> >>
> >> diffstat:
> >>  drivers/ide/ide-cd.c     |   38 ++++++-------
> >>  drivers/ide/ide-io.c     |  129 ++++++++++++++++++++---------------------------
> >>  drivers/ide/ide-ioctls.c |    3 -
> >>  drivers/ide/ide-lib.c    |    7 --
> >>  drivers/ide/ide-proc.c   |   25 +--------
> >>  drivers/ide/ide.c        |    7 --
> >>  6 files changed, 80 insertions(+), 129 deletions(-)
> >
> > Sorry, but I just have to ask 'why'? IDE is seeing a whole lot of churn
> > for something that should essentially be a stable code base in
> > maintenance mode, and now scalability improvements?
> 
> It is the stable code but being in "maintenance only mode" has never
> been true and as long as there are active users & developers there is
> really no reason to change it.

Well, maybe then it's just me who thinks that it definitely SHOULD be in
deep maintenance mode...

> > Just doesn't make ANY sense to me, sorry. We may end up with a cleaner
> > code base, but likely also a buggier one. It's not like hardware
> > coverage testing is all that great, considering some of the ancient
> > stuff it supports :-)
> 
> The changes above are relatively safe/simple and are not hardware specific.
> 
> Thanks for worring about IDE but we should be fine. :)
> 
> Bart

-- 
Jens Axboe

