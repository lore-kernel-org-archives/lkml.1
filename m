Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbXHQDpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbXHQDpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 23:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbXHQDon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 23:44:43 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:52201 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752863AbXHQDom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 23:44:42 -0400
Message-ID: <387322278.03147@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 17 Aug 2007 11:44:37 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] maps: /proc/<pid>/pmaps interface - memory maps in
	granularity of pages
Message-ID: <20070817034437.GC5521@mail.ustc.edu.cn>
References: <20070816220516.782145952@mail.ustc.edu.cn> <20070816220849.472883642@mail.ustc.edu.cn> <20070817023846.GJ30556@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070817023846.GJ30556@waste.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 09:38:46PM -0500, Matt Mackall wrote:
> On Fri, Aug 17, 2007 at 06:05:20AM +0800, Fengguang Wu wrote:
> > Show a process's page-by-page address space infomation in /proc/<pid>/pmaps.
> > It helps to analyze applications' memory footprints in a comprehensive way.
> > 
> > Pages share the same states are grouped into a page range.
> > For each page range, the following fields are exported:
> > 	- first page index
> > 	- number of pages in the range
> > 	- well known page/pte flags
> > 	- number of mmap users
> > 
> > Only page flags not expected to disappear in the near future are exported:
> > 
> > 	Y:young R:referenced A:active U:uptodate P:ptedirty D:dirty W:writeback
> ...
> 
> > The concern of dataset size is taken care of by working in a sparse way:
> > 
> > 1) It will only generate output for resident pages, that normally is
> > much smaller than the mapped size. Take my shell for example, the
> > (size:rss) ratio is (7:1)!
> > 
> > wfg ~% cat /proc/$$/smaps |grep Size|sum
> > sum      50552.000
> > avg        777.723
> > 
> > wfg ~% cat /proc/$$/smaps |grep Rss|sum
> > sum       7604.000
> > avg        116.985
> > 
> > 2) The page range trick suppresses more output.
> > 
> > It's interesting to see that the seq_file interface demands some
> > more programming efforts, and provides such flexibility as well.
> 
> I'm so-so on this. 

Not that way! It's a good thing that people have different experiences
and hence viewpoints. Maybe the concept of PFN sharing are
straightforward to you, while I have been playing with seq_file a lot.

> On the downside:
> 
> - requires lots of parsing
> - isn't random-access
> - probably significantly slower than pagemap

That could be true.  Maybe some user with huge datasets will give us
some idea about the performance. I don't know, maybe it's application
dependent.

Anyway I don't think it's fair to merge a binary interface without the
challenge from a textual one ;)

Thank you,
Fengguang

