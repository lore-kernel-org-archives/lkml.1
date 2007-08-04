Return-Path: <linux-kernel-owner+w=401wt.eu-S1765286AbXHDQwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765286AbXHDQwr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 12:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764607AbXHDQwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 12:52:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49917 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764407AbXHDQwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 12:52:40 -0400
Date: Sat, 4 Aug 2007 09:51:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-Id: <20070804095143.b8cc2c78.akpm@linux-foundation.org>
In-Reply-To: <20070804163733.GA31001@elte.hu>
References: <20070803123712.987126000@chello.nl>
	<alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
	<20070804063217.GA25069@elte.hu>
	<20070804070737.GA940@elte.hu>
	<20070804103347.GA1956@elte.hu>
	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
	<20070804163733.GA31001@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Aug 2007 18:37:33 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > hm, it turns out that it's due to vim doing an occasional fsync not 
> > > only on writeout, but during normal use too. "set nofsync" in the 
> > > .vimrc solves this problem.
> > 
> > Yes, that's independent. The fact is, ext3 *sucks* at fsync. I hate 
> > hate hate it. It's totally unusable, imnsho.
> 
> yeah, it's really ugly. But otherwise i've got no real complaint about 
> ext3 - with the obligatory qualification that "noatime,nodiratime" in 
> /etc/fstab is a must. This speeds up things very visibly - especially 
> when lots of files are accessed. It's kind of weird that every Linux 
> desktop and server is hurt by a noticeable IO performance slowdown due 
> to the constant atime updates,

Not just more IO: it will cause great gobs of blockdev pagecache to remain
in memory, too.


> while there's just two real users of it: 
> tmpwatch [which can be configured to use ctime so it's not a big issue] 
> and some backup tools. (Ok, and mail-notify too i guess.) Out of tens of 
> thousands of applications. So for most file workloads we give Windows a 
> 20%-30% performance edge, for almost nothing. (for RAM-starved kernel 
> builds the performance difference between atime and noatime+nodiratime 
> setups is more on the order of 40%)
> 
> 	Ingo
