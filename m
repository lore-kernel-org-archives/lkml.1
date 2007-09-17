Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbXIQQBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbXIQQBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 12:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbXIQQBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 12:01:05 -0400
Received: from pat.uio.no ([129.240.10.15]:60025 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbXIQQBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 12:01:04 -0400
Subject: Re: [PATCH] Wake up mandatory locks waiter on chmod (v2)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, "J. Bruce Fields" <bfields@fieldses.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
In-Reply-To: <46EE8C52.80503@openvz.org>
References: <46EE3724.80200@openvz.org>
	 <1190037331.6700.14.camel@heimdal.trondhjem.org>
	 <46EE8C52.80503@openvz.org>
Content-Type: text/plain
Date: Mon, 17 Sep 2007 12:00:50 -0400
Message-Id: <1190044850.6700.81.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.058)
X-UiO-Scanned: 2D79FFE9C25352E57E63F0FFBFBBFCA263A86907
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 13 total 3926973 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-17 at 18:16 +0400, Pavel Emelyanov wrote:
> Trond Myklebust wrote:
> > On Mon, 2007-09-17 at 12:13 +0400, Pavel Emelyanov wrote:
> >> When the process is blocked on mandatory lock and someone changes 
> >> the inode's permissions, so that the lock is no longer mandatory,
> >> nobody wakes up the blocked process, but probably should.
> > 
> > Please explain in more detail why we need this patch.
> 
> From "this fixes an OOPs/deadlock/leak" POV we do not. This is
> just an attempt to make the locking code be more consistent and
> clean.

Why do you think we get a deadlock or leak? AFAICS if the user turns off
mandatory locks on the file, then the existing locks default back into
advisory locks which use the same notification mechanism as the
mandatory locks.

IOW: the process that is waiting in locks_mandatory_area() will be
released as soon as the advisory lock is dropped. If that theory is
broken in practice, then that is the bug that we need to fix. We neither
want to add a load of locking crap to notify_change(), nor should we
need to.

Cheers
   Trond

