Return-Path: <linux-kernel-owner+w=401wt.eu-S1765199AbXHJARq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765199AbXHJARq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 20:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbXHJARd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 20:17:33 -0400
Received: from main.gmane.org ([80.91.229.2]:55990 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbXHJARc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 20:17:32 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Date: Thu, 09 Aug 2007 20:21:22 -0400
Message-ID: <46BBAF82.7020702@tmr.com>
References: <20070804070737.GA940@elte.hu>	<20070804103347.GA1956@elte.hu>	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>	<20070804163733.GA31001@elte.hu>	<alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>	<46B4C0A8.1000902@garzik.org>	<20070804191205.GA24723@lazybastard.org>	<20070804192130.GA25346@elte.hu>	<20070804192615.GA25600@lazybastard.org>	<20070804194259.GA25753@lazybastard.org>	<20070805203602.GB25107@infradead.org>	<46BA3137.3020701@mbligh.org> <20070808142146.c85ab8d7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: pool-70-109-119-137.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <20070808142146.c85ab8d7.akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
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
> 
I would think that (really) updating atime on open would be enough, 
hopefully without being too much. The "lazyatime" thing I was playing 
with only updated on open, final close, write, and fork.

I like the idea of updating once in a while, but one of the benefits of 
noatime is allowing drives to spin down via inactivity. If something 
does get done in the area of less but non-zero atime tracking, perhaps 
that could be taken into account. I have to check what "laptop_mode 
actually does, since my laptops are old installs.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

