Return-Path: <linux-kernel-owner+w=401wt.eu-S1751418AbXE2S2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbXE2S2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbXE2S2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:28:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39532 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbXE2S2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:28:11 -0400
Message-ID: <465C71EA.5040706@oracle.com>
Date: Tue, 29 May 2007 11:33:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] FILESYSTEMS:  Delete unused "int dummy[5]" from inodes_stat_t.
References: <Pine.LNX.4.64.0705291307001.32601@localhost.localdomain> <20070529110041.49bf57f1.akpm@linux-foundation.org> <Pine.LNX.4.64.0705291406040.4617@localhost.localdomain> <20070529111902.27055fd0.randy.dunlap@oracle.com> <Pine.LNX.4.64.0705291416470.4736@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0705291416470.4736@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Tue, 29 May 2007, Randy Dunlap wrote:
> 
>> On Tue, 29 May 2007 14:07:01 -0400 (EDT) Robert P. J. Day wrote:
>>
>>> On Tue, 29 May 2007, Andrew Morton wrote:
>>>
>>>> kernel/sysctl.c:
>>>>
>>>> 	{
>>>> 		.ctl_name	= FS_STATINODE,
>>>> 		.procname	= "inode-state",
>>>> 		.data		= &inodes_stat,
>>>> 		.maxlen		= 7*sizeof(int),    <-----
>>>> 		.mode		= 0444,
>>>> 		.proc_handler	= &proc_dointvec,
>>>> 	},
>>>>
>>>> akpm:/home/akpm> cat /proc/sys/fs/inode-state
>>>> 608039  178454  0       0       0       0       0
>>>>
>>>> So it _is_ used: to present those five zeroes.  I think this is
>>>> for back-compatibility with some cretaceous-era kernel.
>>> ah, gotcha.  well, i'll leave this up to someone else to do
>>> anything with if they are so inclined.
>> There's little to be done, except possibly put a /* comment */ on
>> the struct's dummy line so that we don't go thru this again in N
>> years.
> 
>   so, just to clarify, what *is* the value of those trailing five
> zeroes?  andrew suggests it's to be backward-compatible with an old
> kernel, which doesn't make much sense to me.  it would make more sense
> to say that that's backward-compatible with some old userspace app
> that always wants to see seven values and just ignores the last five.

Agreed, it's for compat with some (unknown) userspace app that reads
/proc/sys/fs/inode-state and scans for 7 (or more than 2) numbers there.
The mantra is "don't break userspace," so we leave the numbers there...

>   in any event, from Documentation/filesystems/proc.txt:
> 
> "inode-state contains two actual numbers and five dummy values. The
> numbers are nr_inodes and nr_free_inodes (in order of appearance)."
> 
> if even the documentation calls them dummy values, do they really have
> any residual value at this point?  and on that note, i'll stop harping
> on this and move on.
> 
> rday


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
