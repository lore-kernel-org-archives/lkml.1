Return-Path: <linux-kernel-owner+w=401wt.eu-S932456AbXHDRSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbXHDRSA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 13:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932798AbXHDRRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 13:17:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56772 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757AbXHDRRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 13:17:43 -0400
Date: Sat, 4 Aug 2007 19:17:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Diego Calleja <diegocg@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070804171724.GA4740@elte.hu>
References: <20070803123712.987126000@chello.nl> <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org> <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <20070804190210.8b1530dd.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070804190210.8b1530dd.diegocg@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Diego Calleja <diegocg@gmail.com> wrote:

> El Sat, 4 Aug 2007 18:37:33 +0200, Ingo Molnar <mingo@elte.hu> escribió:
> 
> > thousands of applications. So for most file workloads we give 
> > Windows a 20%-30% performance edge, for almost nothing. (for 
> > RAM-starved kernel builds the performance difference between atime 
> > and noatime+nodiratime setups is more on the order of 40%)
> 
> Just curious - do you have numbers with relatime?

nope. Stupid question, i just tried it and got this:

 EXT3-fs: Unrecognized mount option "relatime" or missing value

i've got util-linux-2.13-0.46.fc6 and 2.6.22 on that box, shouldnt that 
be recent enough? As far as i can see it from the kernel-side code, this 
works on the general VFS level and hence should be supported by ext3 
already.

even relatime means one extra write IO after a file has been created, 
but at least for read-mostly files it avoids the continuous atime 
update.

	Ingo
