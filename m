Return-Path: <linux-kernel-owner+w=401wt.eu-S1763923AbXKTVKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763923AbXKTVKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763494AbXKTVKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:10:35 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40472 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763251AbXKTVKd (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:10:33 -0500
Date: Wed, 21 Nov 2007 08:09:59 +1100
From: David Chinner <dgc@sgi.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: David Chinner <dgc@sgi.com>, Torsten Kaiser <just.for.lkml@googlemail.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Peter Zijlstra <peterz@infradead.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: writeout stalls in current -git
Message-ID: <20071120210959.GB995458@sgi.com>
References: <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins> <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com> <394340668.31055@ustc.edu.cn> <64bb37e0711061353g4a8b881cgd78fef3a11378b9c@mail.gmail.com> <20071106233114.GB995458@sgi.com> <20071107021324.GD995458@sgi.com> <64bb37e0711062315jef9efd7xc2ffc11b6d6c60fa@mail.gmail.com> <20071108003811.GP995458@sgi.com> <20071120131617.GA24166@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120131617.GA24166@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 02:16:17PM +0100, Damien Wyart wrote:
> Hello,
> 
> > > > Ok, so it's not synchronous writes that we are doing - we're just
> > > > submitting bio's tagged as WRITE_SYNC to get the I/O issued quickly.
> > > > The "synchronous" nature appears to be coming from higher level
> > > > locking when reclaiming inodes (on the flush lock). It appears that
> > > > inode write clustering is failing completely so we are writing the
> > > > same block multiple times i.e. once for each inode in the cluster we
> > > > have to write.
> 
> > > Works for me. The only remaining stalls are sub second and look
> > > completely valid, considering the amount of files being removed.
> > ....
> > > Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> 
> * David Chinner <dgc@sgi.com> [2007-11-08 11:38]:
> > Great - thanks for reporting the problem and testing the fix.
> 
> This patch has not yet made its way into 2.6.24 (rc3). Is it intended?
> Maybe the fix can wait for 2.6.25, but wanted to make sure...

The patch is in the XFS dev tree being QA'd, and we will push it
to 2.6.24-rcX in the next few days.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
