Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbZDOG1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbZDOG1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbZDOG1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:27:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43514 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214AbZDOG1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:27:04 -0400
Date: Wed, 15 Apr 2009 08:27:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: tiobench read 50% regression with 2.6.30-rc1
Message-ID: <20090415062702.GP5178@kernel.dk>
References: <1239265763.2567.769.camel@ymzhang> <20090409095706.GD5178@kernel.dk> <1239330541.2567.779.camel@ymzhang> <20090414121431.GH5178@kernel.dk> <1239758861.2567.813.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239758861.2567.813.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15 2009, Zhang, Yanmin wrote:
> On Tue, 2009-04-14 at 14:14 +0200, Jens Axboe wrote:
> > On Fri, Apr 10 2009, Zhang, Yanmin wrote:
> > > On Thu, 2009-04-09 at 11:57 +0200, Jens Axboe wrote:
> > > > On Thu, Apr 09 2009, Zhang, Yanmin wrote:
> > > > > Comparing with 2.6.29's result, tiobench (read) has about 50% regression
> > > > > with 2.6.30-rc1 on all my machines. Bisect down to below patch.
> > > > > 
> > > > > b029195dda0129b427c6e579a3bb3ae752da3a93 is first bad commit
> > > > > commit b029195dda0129b427c6e579a3bb3ae752da3a93
> > > > > Author: Jens Axboe <jens.axboe@oracle.com>
> > > > > Date:   Tue Apr 7 11:38:31 2009 +0200
> 
> > > > 
> > > > It's not a huge surprise that we regressed there. I'll get this fixed up
> > > > next week. Can you I talk you into trying to change the 'quantum' sysfs
> > > > variable for the drive? It's in /sys/block/xxx/queue/iosched where xxx
> > > > is your drive(s). It's set to 4, if you could try progressively larger
> > > > settings and retest, that would help get things started.
> > > I tried 4,8,16,64,128 and didn't find result difference.
> > 
> > Can you try with this patch?
> The new patch does fix it.

Great, thanks for retesting.

-- 
Jens Axboe

