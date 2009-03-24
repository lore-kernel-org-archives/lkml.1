Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbZCXHcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbZCXHcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 03:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZCXHch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 03:32:37 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:35154 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbZCXHcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 03:32:36 -0400
Message-ID: <49C88C80.5010803@krogh.cc>
Date: Tue, 24 Mar 2009 08:32:16 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: David Rees <drees76@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>	 <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
In-Reply-To: <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rees wrote:
> On Mon, Mar 23, 2009 at 11:19 PM, Jesper Krogh <jesper@krogh.cc> wrote:
>> I know this has been discussed before:
>>
>> [129401.996244] INFO: task updatedb.mlocat:31092 blocked for more than 480
>> seconds.
> 
> Ouch - 480 seconds, how much memory is in that machine, and how slow
> are the disks? 

The 480 secondes is not the "wait time" but the time gone before the
message is printed. It the kernel-default it was earlier 120 seconds but
thats changed by Ingo Molnar back in september. I do get a lot of less
noise but it really doesn't tell anything about the nature of the problem.

The systes spec:
32GB of memory. The disks are a Nexsan SataBeast with 42 SATA drives in 
Raid10 connected using 4Gbit fibre-channel. I'll let it up to you to 
decide if thats fast or slow?

The strange thing is actually that the above process (updatedb.mlocate) 
is writing to / which is a device without any activity at all. All 
activity is on the Fibre Channel device above, but process writing 
outsid that seems to be effected as well.

 > What's your vm.dirty_background_ratio and
> vm.dirty_ratio set to?

2.6.29-rc8 defaults:
jk@hest:/proc/sys/vm$ cat dirty_background_ratio
5
jk@hest:/proc/sys/vm$ cat dirty_ratio
10

>> Consensus seems to be something with large memory machines, lots of dirty
>> pages and a long writeout time due to ext3.
> 
> All filesystems seem to suffer from this issue to some degree.  I
> posted to the list earlier trying to see if there was anything that
> could be done to help my specific case.  I've got a system where if
> someone starts writing out a large file, it kills client NFS writes.
> Makes the system unusable:
> http://marc.info/?l=linux-kernel&m=123732127919368&w=2

Yes, I've hit 120s+ penalties just by saving a file in vim.

> Only workaround I've found is to reduce dirty_background_ratio and
> dirty_ratio to tiny levels.  Or throw good SSDs and/or a fast RAID
> array at it so that large writes complete faster.  Have you tried the
> new vm_dirty_bytes in 2.6.29?

No.. What would you suggest to be a reasonable setting for that?

 > Everyone seems to agree that "autotuning" it is the way to go.  But no
 > one seems willing to step up and try to do it.  Probably because it's
 > hard to get right!

I can test patches.. but I'm not a kernel-developer.. unfortunately.

Jesper

-- 
Jesper
