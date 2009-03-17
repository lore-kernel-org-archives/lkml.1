Return-Path: <linux-kernel-owner+w=401wt.eu-S1761940AbZCQAKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761940AbZCQAKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZCQAKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:10:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:45648 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbZCQAKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:10:22 -0400
Message-ID: <49BEEA64.6060607@kernel.org>
Date: Tue, 17 Mar 2009 09:10:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] block: cleanup patches, take#2
References: <1237170540-19130-1-git-send-email-tj@kernel.org> <200903161853.14268.bzolnier@gmail.com>
In-Reply-To: <200903161853.14268.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 17 Mar 2009 00:10:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Bartlomiej.

Bartlomiej Zolnierkiewicz wrote:
> Patches look fine but 0002-0003 will cause pata/block merge conflicts
> for linux-next once they go into block tree so no ACK from me for this
> approach.
> 
> $ patch -p1 --dry-run < 0002.patch
> patching file drivers/ide/ide-disk.c
> Hunk #1 FAILED at 405.
> 1 out of 1 hunk FAILED -- saving rejects to file drivers/ide/ide-disk.c.rej
> patching file drivers/ide/ide-ioctls.c
> 
> $ patch -p1 --dry-run < 0003.patch
> patching file drivers/ide/ide-cd.c
> Reversed (or previously applied) patch detected!  Assume -R? [n]

Heh... for some reason, I think Stephen wouldn't have much problem
merging those conflicts.

I was hoping to push this patchset into 2.6.30.  The thing is that if
you only want to take changes from -linus and don't want to provide
git trees, your tree is kind of blocked from both sides except around
-rc1 window, so if there are multiple related changesets, they either
have to go in one after another during a -rc1 window or they need to
be split over multiple -rc1 windows, either of which isn't gonna work
very well.

Please note that this isn't exactly some overhead which is unduly
weighed on you.  Mid-layer or inter-related API changes often incur
merge conflicts and things get very difficult unless there's some
level of cooperation among related trees.

I understand that you're constrained time and resource-wise and will
be happy to make things easier on your side but options are severely
limited if you don't want to take any changes other than from
upstream.  It would be best if you can maintain IDE changes in a git
tree.  All that you lose are petty controls over change history.  The
tree might look less tidy but it makes things much easier when
multiple trees are involved.  I'll be happy to provide merge commits
between blk and ide at sync points, so that you can pull from them and
don't have to worry about conflicts.  I don't really think it will add
a lot to your workload.

That said, let's postpone this patchset post -rc1 window and see how
things can be worked out then.  Hmmm... I'll move the IDE patches on
top of linux-next/pata-2.6 with other IDE patches.

Jens, please keep reviewing.  I'll keep track of ack status.

Thanks.

-- 
tejun
