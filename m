Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbXIEMzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbXIEMzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 08:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbXIEMyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 08:54:54 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:42653 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754865AbXIEMyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 08:54:54 -0400
X-Greylist: delayed 4145 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2007 08:54:54 EDT
Date: Wed, 5 Sep 2007 14:45:46 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel 2.6.22: what IS the VM doing?
Message-ID: <20070905114545.2hydqpasqx56afkf@m.safari.iki.fi>
Mail-Followup-To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070830115429.w2puzet5sllhccdk@m.safari.iki.fi> <46DE085F.2040306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DE085F.2040306@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2007 at 21:37:35 -0400, Rik van Riel wrote:
> Sami Farin wrote:
>> Using SMP kernel 2.6.22.6pre-CFS-v20.5 on Pentium D (IA-32).
>> I think this bug (or whatever you want to call it) got triggered
>> when you first allocate several megabytes of memory in a kernel module
>> and then free them, and then run e.g. X and when memory gets tight,
>> you end up with this situation...
>> Top 2 /proc/vmstat Biggest Winners:
>> pgrefill_normal:49900/second
>> pgrefill_high:20810/second
>
> That means the pageout code was scanning about 70000 pages
> per second on your system during peak stress.  You may have
> run into a scalability problem in the Linux kernel, where it
> wants to clear the referenced bit off all the anonymous pages
> before swapping something out.

Thanks for analysis...

Why turning off swap did not make any difference?
Why does is not keep e.g. xterm in memory (which I had 700MB free)?

> To make matters worse, that unlucky page gets chosen because
> it was the page where kswapd started scanning.  It has little
> to do with being the least recently used page, because every
> anonymous page tends to have its referenced bit set by the time
> we start scanning.
>
> On truly enormous systems, say with 256GB of memory, kswapd
> sometimes needs to scan hundreds of thousands or even millions
> of pages before finding something to swap out.  Not fun.
>
>> Did I forget to include some info???
>> Oh, and I need to reboot in order to get usable system
>> when this bug happens.
>
> Is the system trying to evict pages like crazy when your
> system becomes unusable?

I think so..

> If so, I wonder if kswapd is simply doing the wrong thing
> and trying to evict data from all zones, simply because the
> highmem zone is low on free pages...

*shrug*

-- 
"If we put the Pentagon's personnel managers in charge of the Sahara
Desert, they would run out of sand in five years." -Sayen Report

