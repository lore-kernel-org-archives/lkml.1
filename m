Return-Path: <linux-kernel-owner+w=401wt.eu-S939294AbXHJTZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939294AbXHJTZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbXHJTZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:25:18 -0400
Received: from mail.tmr.com ([64.65.253.246]:33129 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbXHJTZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:25:16 -0400
Message-ID: <46BCBC97.2080507@tmr.com>
Date: Fri, 10 Aug 2007 15:29:27 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Vlad <vladc6@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Noatime vs relatime
References: <233939.75965.qm@web54403.mail.yahoo.com>
In-Reply-To: <233939.75965.qm@web54403.mail.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vlad wrote:
> Linus Torvalds wrote:
>> What we could do is to make "relatime" updates a bit smarter.
>>
>> A bit smarter would be:
>>
>> - update atime if the old atime is <= than mtime/ctime
>>
>> Logic: things like mailers can care about whether some
>> new state has 
>> been read or not. This is the current relatime.
>>
>> - update atime if the old atime is more than X seconds
>> in the past (defaulting to one day or something)
>>
>> Logic: things like tmpwatch and backup
>> software may want to remove 
>> stuff that hasn't been touched in a long time, but they
>> sure don't care about "exact" atime.
> 
> Relatime seems to be wasteful of both IO resources _and_ CPU cycles.
> Instead of performing a single IO operation (as atime does), relatime
> performs at least three IO operations and three CPU-dependent
> operations:
> 
> 1) a read IO operation to find out the old atime
> 2) a read IO operation to find out the old ctime
> 3) a read IO operation to find out the old mtime

Reading a value in memory into a CPU register is not normally considered 
an I/O operation.

> 4) Comparison of "old atime is <= than mtime/ctime"
> 5) Find out current time
> 6) Comparison of "current time minus old atime is > X"
> 
> People are going to wonder why all of the sudden everything is running
> so slow due to atimes being updated after a long break.
> 
> I suggest treating atime as if it were a subsystem that is scheduled
> for an overhaul - there have been plenty of those in the past. Give
> users/distros a config option to disable atime, but default this
> option in favor of atime for a couple of kernel release cycles. Print
> a line in dmesg that states something like:
> 
> "Warning: Atime will be disabled by default in future kernel versions,
> but you will still be able to turn it on when configuring the kernel."
> 
> This should give a heads-up to the 0.001% of people who still use
> atime so that they know to customize this option or start using modern
> file-monitoring techniques like inotify.
> 
> Vlad
> 
> 
>        
> ____________________________________________________________________________________
> Pinpoint customers who are looking for what you sell. 
> http://searchmarketing.yahoo.com/


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
