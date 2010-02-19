Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab0BSAHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:07:41 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36897 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab0BSAHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:07:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 19 Feb 2010 09:04:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/12] Memory compaction core
Message-Id: <20100219090406.d3903e05.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002181335270.7351@router.home>
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie>
	<1265976059-7459-6-git-send-email-mel@csn.ul.ie>
	<20100216170014.7309.A69D9226@jp.fujitsu.com>
	<20100216084800.GC26086@csn.ul.ie>
	<alpine.DEB.2.00.1002160849460.18275@router.home>
	<20100216145943.GA997@csn.ul.ie>
	<alpine.DEB.2.00.1002181335270.7351@router.home>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Feb 2010 13:37:35 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Tue, 16 Feb 2010, Mel Gorman wrote:
> 
> > > Oh there are numerous ZONE_DMA pressure issues if you have ancient /
> > > screwed up hardware that can only operate on DMA or DMA32 memory.
> > >
> >
> > I've never ran into the issue. I was under the impression that the only
> > device that might care these days are floopy disks.
> 
> Kame-san had an issue a year or so ago.
> 
Yes. But my customer doesn't use the newest things...
In server area, recent hardware(64bit) and drivers tend not to cause the issue.
I'm not sure there are some driver which still set their DMA mask wrong and
require bounce buffer. But I guess that I'll have to see DMA-zone issue in
customer support still in (early) RHEL6.

Considering other area, I hear OOM-issue from notebook/desktop users, they don't
equip swap. I think some of devices are still 32bit if 64bit isn't required for them.
I wonder problems on lower-zone still exists for 32bit devices users.
In the view point as kernels for x86-32 still support ZONE_DMA
for ISA bus...we shouldn't assume there are no legacy. 

But yes, it may not be very important to implement inter-zone moving. It's not
for compaction, but just for memory-reclaim. And it has some complication.


Thanks,
-Kame

