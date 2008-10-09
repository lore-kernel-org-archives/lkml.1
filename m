Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbYJIGw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbYJIGw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYJIGwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:52:16 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46726 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbYJIGwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:52:15 -0400
Date: Thu, 9 Oct 2008 08:51:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] ide: locking improvements
Message-ID: <20081009065141.GV19428@kernel.dk>
References: <20081008202930.19112.90371.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008202930.19112.90371.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> Locking improvements in preparation for replacing the global ide_lock
> spinlock by per-hwgroup spinlocks [1].
> 
> [1] patch (which is partially based on 2005 patch from Scalex86) for this
> is also ready but it needs some more audit and testing
> 
> diffstat:
>  drivers/ide/ide-cd.c     |   38 ++++++-------
>  drivers/ide/ide-io.c     |  129 ++++++++++++++++++++---------------------------
>  drivers/ide/ide-ioctls.c |    3 -
>  drivers/ide/ide-lib.c    |    7 --
>  drivers/ide/ide-proc.c   |   25 +--------
>  drivers/ide/ide.c        |    7 --
>  6 files changed, 80 insertions(+), 129 deletions(-)

Sorry, but I just have to ask 'why'? IDE is seeing a whole lot of churn
for something that should essentially be a stable code base in
maintenance mode, and now scalability improvements?

Just doesn't make ANY sense to me, sorry. We may end up with a cleaner
code base, but likely also a buggier one. It's not like hardware
coverage testing is all that great, considering some of the ancient
stuff it supports :-)

-- 
Jens Axboe

