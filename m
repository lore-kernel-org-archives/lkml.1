Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbXI2Os1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbXI2Os1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 10:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbXI2OsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 10:48:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52703 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbXI2OsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 10:48:19 -0400
Subject: Re: A unresponsive file system can hang all I/O in the system on
	linux-2.6.23-rc6 (dirty_thresh problem?)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Chakri n <chakriin5@gmail.com>, Krzysztof Oledzki <olel@ans.pl>,
       akpm@linux-foundation.org,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <391068925.28146@ustc.edu.cn>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	 <391063897.19256@ustc.edu.cn> <1191066481.18147.115.camel@lappy>
	 <391068925.28146@ustc.edu.cn>
Content-Type: text/plain
Date: Sat, 29 Sep 2007 16:43:55 +0200
Message-Id: <1191077035.18147.118.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-09-29 at 20:28 +0800, Fengguang Wu wrote:
> On Sat, Sep 29, 2007 at 01:48:01PM +0200, Peter Zijlstra wrote:

> > On the patch itself, not sure if it would have been enough. As soon as
> > there is a single dirty inode on the list one would get caught in the
> > same problem as before.
> 
> That should not be a problem.  Normally the few new dirty inodes will
> be all cleaned in one go and there are no more dirty inodes left(at
> least for a moment). Hmm, I guess the new 'break' should be moved
> immediately after writeback_inodes()...
> 
> > That is, if NFS_dirty+NFS_unstable+NFS_writeback > dirty_limit this
> > break won't fix it.
> 
> In fact this patch exactly targets at this condition.
> When NFS* < dirty_limit, Chakri won't see the lockup at all.
> The problem was, there are only two 'break's in the loop, and neither
> one evaluates to true for his dd command.

Yeah indeed, when put in the loop, after writeback_inodes() it makes
sense.

No idea what I was thinking, must be one of those days... :-/



