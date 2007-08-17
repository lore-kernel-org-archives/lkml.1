Return-Path: <linux-kernel-owner+w=401wt.eu-S932736AbXHQChy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbXHQChy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 22:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761007AbXHQChr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 22:37:47 -0400
Received: from waste.org ([66.93.16.53]:40020 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760877AbXHQChq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 22:37:46 -0400
Date: Thu, 16 Aug 2007 21:38:46 -0500
From: Matt Mackall <mpm@selenic.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] maps: /proc/<pid>/pmaps interface - memory maps in granularity of pages
Message-ID: <20070817023846.GJ30556@waste.org>
References: <20070816220516.782145952@mail.ustc.edu.cn> <20070816220849.472883642@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816220849.472883642@mail.ustc.edu.cn>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 06:05:20AM +0800, Fengguang Wu wrote:
> Show a process's page-by-page address space infomation in /proc/<pid>/pmaps.
> It helps to analyze applications' memory footprints in a comprehensive way.
> 
> Pages share the same states are grouped into a page range.
> For each page range, the following fields are exported:
> 	- first page index
> 	- number of pages in the range
> 	- well known page/pte flags
> 	- number of mmap users
> 
> Only page flags not expected to disappear in the near future are exported:
> 
> 	Y:young R:referenced A:active U:uptodate P:ptedirty D:dirty W:writeback
...

> The concern of dataset size is taken care of by working in a sparse way:
> 
> 1) It will only generate output for resident pages, that normally is
> much smaller than the mapped size. Take my shell for example, the
> (size:rss) ratio is (7:1)!
> 
> wfg ~% cat /proc/$$/smaps |grep Size|sum
> sum      50552.000
> avg        777.723
> 
> wfg ~% cat /proc/$$/smaps |grep Rss|sum
> sum       7604.000
> avg        116.985
> 
> 2) The page range trick suppresses more output.
> 
> It's interesting to see that the seq_file interface demands some
> more programming efforts, and provides such flexibility as well.

I'm so-so on this. 

On the downside:

- requires lots of parsing
- isn't random-access
- probably significantly slower than pagemap

-- 
Mathematics is the supreme nostalgia of our time.
