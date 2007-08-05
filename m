Return-Path: <linux-kernel-owner+w=401wt.eu-S1762005AbXHEKmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762005AbXHEKmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 06:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbXHEKmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 06:42:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52265 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312AbXHEKmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 06:42:46 -0400
Message-ID: <46B5A996.5060006@garzik.org>
Date: Sun, 05 Aug 2007 06:42:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jakob Oestergaard <jakob@unthought.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070803123712.987126000@chello.nl> <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org> <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070805102021.GA4246@unthought.net>
In-Reply-To: <20070805102021.GA4246@unthought.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jakob Oestergaard wrote:
> Oh dear.
> 
> Why not just make ext3 fsync() a no-op while you're at it?
> 
> Distros can turn it back on if it's needed...
> 
> Of course I'm not serious, but like atime, fsync() is something one

No, they are nothing alike, and you are just making yourself look silly 
if you compare them.  fsync has to do with fundamental guarantees about 
data.


> expects to work if it's there.  Disabling atime updates or making
> fsync() a no-op will both result in silent failure which I am sure we
> can agree is disasterous.

<rolls eyes>  Climb down from hyperbole mountain.

If you can show massive amounts of users that will actually be 
negatively impacted, please present hard evidence.

Otherwise all this is useless hot air.


> Why on earth would you cripple the kernel defaults for ext3 (which is a
> fine FS for boot/root filesystems), when the *fundamental* problem you
> really want to solve lie much deeper in the implementation of the
> filesystem?  Noatime doesn't solve the problem, it just makes it "less
> horrible".

atime updates -are- a fundamental problem, one you cannot solve by 
tweaking filesystem implementations.  No matter how much you try to hide 
or batch, atime dirties an inode each time on every read...  for a 
feature a tiny minority of programs care about, much less depend on.

Remember several filesystems lock atime to mtime, because they do not 
have a concept of atime, and programs continue to work just fine.  We 
already have field proof of how little atime matters in reality.

	Jeff


