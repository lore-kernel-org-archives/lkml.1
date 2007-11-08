Return-Path: <linux-kernel-owner+w=401wt.eu-S1759868AbXKHAiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868AbXKHAiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 19:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbXKHAim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 19:38:42 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33419 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753831AbXKHAil (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 19:38:41 -0500
Date: Thu, 8 Nov 2007 11:38:11 +1100
From: David Chinner <dgc@sgi.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Peter Zijlstra <peterz@infradead.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: writeout stalls in current -git
Message-ID: <20071108003811.GP995458@sgi.com>
References: <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com> <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com> <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins> <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com> <394340668.31055@ustc.edu.cn> <64bb37e0711061353g4a8b881cgd78fef3a11378b9c@mail.gmail.com> <20071106233114.GB995458@sgi.com> <20071107021324.GD995458@sgi.com> <64bb37e0711062315jef9efd7xc2ffc11b6d6c60fa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0711062315jef9efd7xc2ffc11b6d6c60fa@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 08:15:06AM +0100, Torsten Kaiser wrote:
> On 11/7/07, David Chinner <dgc@sgi.com> wrote:
> > Ok, so it's not synchronous writes that we are doing - we're just
> > submitting bio's tagged as WRITE_SYNC to get the I/O issued quickly.
> > The "synchronous" nature appears to be coming from higher level
> > locking when reclaiming inodes (on the flush lock). It appears that
> > inode write clustering is failing completely so we are writing the
> > same block multiple times i.e. once for each inode in the cluster we
> > have to write.
> 
> Works for me. The only remaining stalls are sub second and look
> completely valid, considering the amount of files being removed.
....
> Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>

Great - thanks for reporting the problem and testing the fix.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
