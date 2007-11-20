Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbXKTNS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbXKTNS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 08:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757640AbXKTNSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 08:18:22 -0500
Received: from smtp-dmz-232-tuesday.dmz.nerim.net ([195.5.254.232]:62821 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757548AbXKTNSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 08:18:21 -0500
Date: Tue, 20 Nov 2007 14:16:17 +0100
From: Damien Wyart <damien.wyart@free.fr>
To: David Chinner <dgc@sgi.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Peter Zijlstra <peterz@infradead.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: writeout stalls in current -git
Message-ID: <20071120131617.GA24166@localhost.localdomain>
References: <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com> <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins> <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com> <394340668.31055@ustc.edu.cn> <64bb37e0711061353g4a8b881cgd78fef3a11378b9c@mail.gmail.com> <20071106233114.GB995458@sgi.com> <20071107021324.GD995458@sgi.com> <64bb37e0711062315jef9efd7xc2ffc11b6d6c60fa@mail.gmail.com> <20071108003811.GP995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071108003811.GP995458@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > > Ok, so it's not synchronous writes that we are doing - we're just
> > > submitting bio's tagged as WRITE_SYNC to get the I/O issued
> > > quickly. The "synchronous" nature appears to be coming from higher
> > > level locking when reclaiming inodes (on the flush lock). It
> > > appears that inode write clustering is failing completely so we
> > > are writing the same block multiple times i.e. once for each inode
> > > in the cluster we have to write.

> > Works for me. The only remaining stalls are sub second and look
> > completely valid, considering the amount of files being removed.
> ....
> > Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>

* David Chinner <dgc@sgi.com> [2007-11-08 11:38]:
> Great - thanks for reporting the problem and testing the fix.

This patch has not yet made its way into 2.6.24 (rc3). Is it intended?
Maybe the fix can wait for 2.6.25, but wanted to make sure...

-- 
Damien Wyart
