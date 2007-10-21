Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589AbXJUSxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbXJUSxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 14:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbXJUSxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 14:53:46 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:48655 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbXJUSxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 14:53:46 -0400
Message-ID: <471BA1D1.5040905@linux.vnet.ibm.com>
Date: Mon, 22 Oct 2007 00:30:33 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question about free/used memory on Linux
References: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847B@xmb-sjc-214.amer.cisco.com>
In-Reply-To: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847B@xmb-sjc-214.amer.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ravinandan Arakali (rarakali) wrote:
> Hi kernel gurus,
> I am trying to find out the memory that's used on my linux box.
> I find that there are quite a few confusing metrics. How do
> I find out the "true" used memory ?

pagecache pages may be the reason for the confusion.  Most free memory can
be consumed under 'Cached' in /proc/meminfo

Most of this memory is easily reclaimable and can be considered 'free'.
However the cost of reclaim increases if the pages are memory mapped and/or
dirty.

Cached-Mapped-Dirty in /proc/meminfo can be seen as a easily freeable
memory and can be added to the 'Free' in /proc/meminfo count

What is your intention of finding free memory in the system?  Linux kernel
takes the best decision of using available RAM for file cache or
applications code/data as and when needed.  Ideally the 'Free' count will
be  a very low value on a heavily used system.  If application needs more
memory, then the kernel will shrink the caches and give the reclaimed
memory to the application.

> 
> 1. For eg. "free -m" shows free memory (excluding buffers/caches) 
> as 308 MB while I can see(from "df" output) that the the tmpfs 
> partitions take up about 400 MB. So, does "free -m" not consider 
> the tmpfs partitions ?

Pages used from tmpfs should come under Mapped or Cached.  They are not
counted as free.

> 2. I try to add up RSS field of all processes reported by
> "ps aux" command. But is it true that this would be misleading
> in that, shared memory used by, say 2 processes would show
> up twice here although there's only one copy in memory. Also
> does this consider the fact that there's only one copy
> of shared libraries ?
>

RSS is from each process point of view.  If the page is present in RAM, it
is counted.  If the pages is shared, then it is counted in both process
address space.

> 3. I guess "free -m" and "top" commands use /proc/meminfo 
> and hence all these outputs are same ?

Yes, all of them parse /proc/meminfo

--Vaidy
