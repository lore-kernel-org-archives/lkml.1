Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbXIQNzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbXIQNzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 09:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbXIQNzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:55:48 -0400
Received: from pat.uio.no ([129.240.10.15]:57061 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbXIQNzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:55:47 -0400
Subject: Re: [PATCH] Wake up mandatory locks waiter on chmod (v2)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, "J. Bruce Fields" <bfields@fieldses.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
In-Reply-To: <46EE3724.80200@openvz.org>
References: <46EE3724.80200@openvz.org>
Content-Type: text/plain
Date: Mon, 17 Sep 2007 09:55:31 -0400
Message-Id: <1190037331.6700.14.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, AWL=0.020)
X-UiO-Scanned: 43676BF14A2869C492B0503A8AD53250815FC696
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1963 total 3924233 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-17 at 12:13 +0400, Pavel Emelyanov wrote:
> When the process is blocked on mandatory lock and someone changes 
> the inode's permissions, so that the lock is no longer mandatory,
> nobody wakes up the blocked process, but probably should.

Please explain in more detail why we need this patch.

I don't see why changing a file from taking mandatory locks to advisory
locks is really a useful operation that we need to support. For one
thing, we don't support changing a file from using advisory locking to
mandatory locking on-the-fly. Secondly, changing the locking type
certainly isn't a documented operation and quite frankly, it doesn't
even appear to make sense: if the file needs mandatory locking, then
that means that you have a need to protect against some untrusted
application that isn't following the locking rules. Then suddenly, you
declare that you will trust that application after all???

Cheers,
  Trond

