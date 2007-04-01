Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbXDAGy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbXDAGy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 02:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbXDAGy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 02:54:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49562 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbXDAGyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 02:54:25 -0400
Date: Sun, 1 Apr 2007 08:51:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: amanda-hackers@amanda.org, linux-kernel@vger.kernel.org,
       amanda-users@amanda.org, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
Message-ID: <20070401065101.GA17729@elte.hu>
References: <200704010100.19016.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704010100.19016.gene.heskett@verizon.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gene Heskett <gene.heskett@verizon.net> wrote:

> Hi Ingo;
> 
> Running 2.6.21-rc5 tonight.
> 
> It appears that as of 2.6.21-rc5, (actually anything with a 2.6.21 in 
> its version string) amanda is still a loser. [...]

here 'is a loser' means: "tries to back up way too much stuff instead of 
doing a nice incremental backup like it does on 2.6.20.4", correct?

since it appears to be caused by a kernel change, this is a serious 
regression in v2.6.21-to-be.

> Good, 2.6.20.4 was running
> sendsize.20070331000507.debug:sendsize[762]: time 248.361: getting size via gnutar for /usr/music level 0
> sendsize.20070331000507.debug:sendsize[762]: estimate time for /usr/music level 0: 1.239
> sendsize.20070331000507.debug:sendsize[762]: estimate size for /usr/music level 0: 2466050 KB
> sendsize.20070331000507.debug:sendsize[762]: time 249.605: getting size via gnutar for /usr/music level 1
> sendsize.20070331000507.debug:sendsize[762]: estimate time for /usr/music level 1: 0.027
> sendsize.20070331000507.debug:sendsize[762]: estimate size for /usr/music level 1: 80 KB
> 
> Bad, 2.6.21-rc5 is running
> sendsize.20070401000504.debug:sendsize[18465]: time 167.371: getting size via gnutar for /usr/music level 0
> sendsize.20070401000504.debug:sendsize[18465]: estimate time for /usr/music level 0: 0.398
> sendsize.20070401000504.debug:sendsize[18465]: estimate size for /usr/music level 0: 2466050 KB
> sendsize.20070401000504.debug:sendsize[18465]: time 167.773: getting size via gnutar for /usr/music level 1
> sendsize.20070401000504.debug:sendsize[18465]: estimate time for /usr/music level 1: 0.049
> sendsize.20070401000504.debug:sendsize[18465]: estimate size for /usr/music level 1: 2448290 KB
> 
> Yesterdays run, dated 20070331000507 were correct as that directory 
> hasn't been write accessed in a couple of months.
> 
> Today's, dated 20070401000504, shows totally bogus figures for exactly 
> the same data.

'totally bogus figures' needs to be analyzed further. What system call 
or library calls returns incorrect data?

> This effect I have isolated down to something in the 31 patches from 
> 2.6.20.4 to 2.6.20.5-rc1, but I'm going to need additional guidance in 
> setting up the bisect to find it.  If indeed its a kernel problem.
> 
> This same effect has been present in any and every 2.6.21.* release.

maybe it's some sort of timestamp problem, on the FS level?

	Ingo
