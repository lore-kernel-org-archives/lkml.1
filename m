Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbXCBS2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbXCBS2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 13:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932305AbXCBS2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 13:28:17 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:43035 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbXCBS2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 13:28:15 -0500
Message-ID: <45E86CBA.3070905@us.ibm.com>
Date: Fri, 02 Mar 2007 10:28:10 -0800
From: Mingming Cao <cmm@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.3) Gecko/20040910
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: nscott@aconex.com, "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, alex@clusterfs.com,
       suzuki@in.ibm.com, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070301142537.b5950cd7.akpm@linux-foundation.org> <1172788855.26078.294.camel@edge> <20070301145256.3e999932.akpm@linux-foundation.org>
In-Reply-To: <20070301145256.3e999932.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> On Fri, 02 Mar 2007 09:40:54 +1100
> Nathan Scott <nscott@aconex.com> wrote:
> 
> 
>>On Thu, 2007-03-01 at 14:25 -0800, Andrew Morton wrote:
>>
>>>On Fri, 2 Mar 2007 00:04:45 +0530
>>>"Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
>>>
>>>
>>>>This is to give a heads up on few patches that we will be soon coming up
>>>>with. These patches implement a new system call sys_fallocate() and a
>>>>new inode operation "fallocate", for persistent preallocation. The new
>>>>system call, as Andrew suggested, will look like:
>>>>
>>>>  asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);
>>>
>>>...
>>>
>>>I'd agree with Eric on the "command" flag extension.
>>
>>Seems like a separate syscall would be better, "command" sounds
>>a bit ioctl like, especially if that command is passed into the
>>filesystems..
>>
> 
> 
> madvise, fadvise, lseek, etc seem to work OK.
> 
> I get repeatedly traumatised by patch rejects whenever a new syscall gets
> added, so I'm biased.
> 
> The advantage of a command flag is that we can add new modes in the future
> without causing lots of churn, waiting for arch maintainers to catch up,
> potentially adding new compat code, etc.
> 
> Rename it to "mode"? ;)
> 
I am wondering if it is useful to add another mode to advise block 
allocation policy? Something like indicating which physical block/block 
group to allocate from (goal), and whether ask for strict contigous 
blocks. This will help preallocation or reservation to choose the right 
blocks for the file.

Right now neither ext4 preallocation implementation or reservation are 
guranteed to allocate/reserve contigugous extents. If the application 
told it so, it could do more searching to satisfy the requirement.

Or fadvise is the right interface?

Mingming
> I'm inclined to merge this patch nice and early, so the syscall number is
> stabilised.  Otherwise the people who are working on out-of-tree code (ie:
> ext4) will have to keep playing catchup.
> 


