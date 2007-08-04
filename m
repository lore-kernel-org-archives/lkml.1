Return-Path: <linux-kernel-owner+w=401wt.eu-S1764992AbXHDQiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764992AbXHDQiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 12:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764931AbXHDQhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 12:37:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56051 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760886AbXHDQhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 12:37:53 -0400
Date: Sat, 4 Aug 2007 18:37:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070804163733.GA31001@elte.hu>
References: <20070803123712.987126000@chello.nl> <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org> <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > hm, it turns out that it's due to vim doing an occasional fsync not 
> > only on writeout, but during normal use too. "set nofsync" in the 
> > .vimrc solves this problem.
> 
> Yes, that's independent. The fact is, ext3 *sucks* at fsync. I hate 
> hate hate it. It's totally unusable, imnsho.

yeah, it's really ugly. But otherwise i've got no real complaint about 
ext3 - with the obligatory qualification that "noatime,nodiratime" in 
/etc/fstab is a must. This speeds up things very visibly - especially 
when lots of files are accessed. It's kind of weird that every Linux 
desktop and server is hurt by a noticeable IO performance slowdown due 
to the constant atime updates, while there's just two real users of it: 
tmpwatch [which can be configured to use ctime so it's not a big issue] 
and some backup tools. (Ok, and mail-notify too i guess.) Out of tens of 
thousands of applications. So for most file workloads we give Windows a 
20%-30% performance edge, for almost nothing. (for RAM-starved kernel 
builds the performance difference between atime and noatime+nodiratime 
setups is more on the order of 40%)

	Ingo
