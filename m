Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbXI1RBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbXI1RBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbXI1RBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:01:06 -0400
Received: from pat.uio.no ([129.240.10.15]:49083 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbXI1RBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:01:05 -0400
Subject: Re: A unresponsive file system can hang all I/O in the system on
	linux-2.6.23-rc6 (dirty_thresh problem?)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chakri n <chakriin5@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20070927235034.ae7bd73d.akpm@linux-foundation.org>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	 <20070927235034.ae7bd73d.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 13:00:53 -0400
Message-Id: <1190998853.6702.17.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 669E6E5A7C0775C829276C15C50DBFF932B2F31D
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 8 total 4177266 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-27 at 23:50 -0700, Andrew Morton wrote:

> Actually we perhaps could address this at the VFS level in another way. 
> Processes which are writing to the dead NFS server will eventually block in
> balance_dirty_pages() once they've exceeded the memory limits and will
> remain blocked until the server wakes up - that's the behaviour we want.
> 
> What we _don't_ want to happen is for other processes which are writing to
> other, non-dead devices to get collaterally blocked.  We have patches which
> might fix that queued for 2.6.24.  Peter?

Do these patches also cause the memory reclaimers to steer clear of
devices that are congested (and stop waiting on a congested device if
they see that it remains congested for a long period of time)? Most of
the collateral blocking I see tends to happen in memory allocation...

Cheers
  Trond

