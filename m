Return-Path: <linux-kernel-owner+w=401wt.eu-S937232AbXHIAzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937232AbXHIAzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763424AbXHIAzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:55:00 -0400
Received: from dvhart.com ([64.146.134.43]:48001 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763806AbXHIAy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:54:59 -0400
Message-ID: <46BA65E1.8010704@mbligh.org>
Date: Wed, 08 Aug 2007 17:54:57 -0700
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, J??rn Engel <joern@logfs.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070804070737.GA940@elte.hu>	<20070804103347.GA1956@elte.hu>	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>	<20070804163733.GA31001@elte.hu>	<alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>	<46B4C0A8.1000902@garzik.org>	<20070804191205.GA24723@lazybastard.org>	<20070804192130.GA25346@elte.hu>	<20070804192615.GA25600@lazybastard.org>	<20070804194259.GA25753@lazybastard.org>	<20070805203602.GB25107@infradead.org>	<46BA3137.3020701@mbligh.org> <20070808142146.c85ab8d7.akpm@linux-foundation.org>
In-Reply-To: <20070808142146.c85ab8d7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 08 Aug 2007 14:10:15 -0700
> "Martin J. Bligh" <mbligh@mbligh.org> wrote:
> 
>> Why isn't this easily fixable by just adding an additional dirty
>> flag that says atime has changed? Then we only cause a write
>> when we remove the inode from the inode cache, if only atime
>> is updated.
> 
> I think that could be made to work, and it would fix the performance
> issue.
> 
> It is a behaviour change.  At present ext3 (for example) commits everything
> every five seconds.  After a change like this, a crash+recovery could cause
> a file's atime to go backwards by an arbitrarily large time interval - it
> could easily be months.

A second pdflush / workqueue at a slower rate would alleviate that.

Yes, it's a semantic change ... but only in an incredibly small
corner-case ?

