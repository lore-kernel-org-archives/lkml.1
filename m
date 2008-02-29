Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbYB2Rab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbYB2Rab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYB2RaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:30:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:43906 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752182AbYB2RaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:30:22 -0500
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX190oR1mRs90ydRnGz0Y/Hc9UCG1Iu+vXe3iXeSn01
	8bmEfd3tRMkhmz
Message-ID: <47C84111.6030103@gmx.net>
Date: Fri, 29 Feb 2008 19:29:53 +0200
From: Dimitrios Apostolou <jimis@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070301 SeaMonkey/1.0.8
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: swap file over jffs2 partition
References: <47C772E9.2000000@gmx.net> <20080229084345.GA16507@lazybastard.org>
In-Reply-To: <20080229084345.GA16507@lazybastard.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Fri, 29 February 2008 04:50:17 +0200, Dimitrios Apostolou wrote:
>> I intend to build a diskless linux system (root over NFS). Because it
>> has 1GB of embedded flash storage, I'm thinking of using this as swap 
>> (I've been bitten many times by the problems linux has with *no* 
>> swap...). And to avoid wearing out the flash storage too fast, I 'm 
>> thinking to format the 1GB partition as JFFS2, and create the swapfile 
>> on top of it.
>>
>> I'm not so experienced with JFFS and I don't know if it's too heavy for
>> the CPU, for swapping. Or if there are other issues I 'll face. What do
>> you think about it? Any other ways you 'd propose?
>>
>> Sorry for sending this at LKML but jffs-dev mailing list seems to be 
>> off. And JFFS is the only in-kernel filesystem that does wear-leveling, 
>> right?
> 
> Replying in reverse order...
> 
> The relevant mailing list is linux-mtd, added to Cc:.  JFFS and JFFS2
> are two different things, JFFS is older and was removed from the kernel
> not too long ago.

Thanks and sorry for intruding LKML. It seems that even wikipedia has 
wrong address for the mailing list, see the last link of the article:

http://en.wikipedia.org/wiki/JFFS2

> 
> The real fun comes not from CPU usage, but from interactions with the
> memory management subsystem.  In a nutshell, JFFS2 may require memory in
> order to write data.  When the system is under memory pressure, it needs
> JFFS2 to write out pages, which will try to allocate memory.  It is
> theoretically possible to deadlock the system in this way.

Interesting. I guess nobody has experimented with it yet so I'll try. 
Unfortunately it seems I'll face another problem, that JFFS2 doesn't 
support having a swap-file at all. Why would this happen? More info:

http://dev.laptop.org/ticket/6469

> 
> On the plus side, the write path of JFFS2 is relatively simple and
> extremely low-latency.  It shouldn't be too hard to review the code and
> handle all problem cases wrt. memory allocations.
> 
> One issue that is hard to solve is space reservation.  JFFS2 compresses
> data and allows users to write as long as there is space remaining.  It
> is possible to swap out data that compresses well, have some other
> process fill up the filesystem, then try to swap out data that
> compresses badly and get -ENOSPC in return.  As a system administrator
> you can prevent others from ever writing to JFFS2 - and you better do!

Of course! I intend to use all the 1GB of flash only for swap, the 
system will be practically diskless. And I don't think enabling 
compression for such a task would be wise.

> 
> Jörn
> 

Thanks for the help,
Dimitris
