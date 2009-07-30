Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbZG3WnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbZG3WnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 18:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbZG3WnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 18:43:09 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51468 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbZG3WnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 18:43:08 -0400
Date: Fri, 31 Jul 2009 00:43:08 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Martin Bligh <mbligh@google.com>
Cc: Chad Talbott <ctalbott@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, wfg@mail.ustc.edu.cn,
       Michael Rubin <mrubin@google.com>, Andrew Morton <akpm@google.com>,
       sandeen@redhat.com
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
Message-ID: <20090730224308.GJ12579@kernel.dk>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com> <20090730213956.GH12579@kernel.dk> <33307c790907301501v4c605ea8oe57762b21d414445@mail.gmail.com> <20090730221727.GI12579@kernel.dk> <33307c790907301534v64c08f59o66fbdfbd3174ff5f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33307c790907301534v64c08f59o66fbdfbd3174ff5f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30 2009, Martin Bligh wrote:
> > The test case above on a 4G machine is only generating 1G of dirty data.
> > I ran the same test case on the 16G, resulting in only background
> > writeout. The relevant bit here being that the background writeout
> > finished quickly, writing at disk speed.
> >
> > I re-ran the same test, but using 300 100MB files instead. While the
> > dd's are running, we are going at ~80MB/sec (this is disk speed, it's an
> > x25-m). When the dd's are done, it continues doing 80MB/sec for 10
> > seconds or so. Then the remainder (about 2G) is written in bursts at
> > disk speeds, but with some time in between.
> 
> OK, I think the test case is sensitive to how many files you have - if
> we punt them to the back of the list, and yet we still have 299 other
> ones, it may well be able to keep the disk spinning despite the bug
> I outlined.Try using 30 1GB files?

If this disk starts spinning, then we have bigger bugs :-)
> 
> Though it doesn't seem to happen with just one dd streamer, and
> I don't see why the bug doesn't trigger in that case either.
> 
> I believe the bugfix is correct independent of any bdi changes?

Yeah I think so too, I'll run some more tests on this tomorrow and
verify it there as well.

-- 
Jens Axboe

