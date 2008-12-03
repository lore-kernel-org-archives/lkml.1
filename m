Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYLCAsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYLCAsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbYLCAsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:48:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65385 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754807AbYLCAsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:48:15 -0500
Message-ID: <4935D763.8020807@cn.fujitsu.com>
Date: Wed, 03 Dec 2008 08:48:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: sudhir kumar <imsudhirkumar@gmail.com>
CC: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
       bharata@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, skumar@linux.vnet.ibm.com,
       Peter <a.p.zijlstra@chello.nl>, Paul Menage <menage@google.com>,
       mingo@elte.hu
Subject: Re: BUG: CGROUPS [2.6.28-rc6] Task migration does not clean reference
 to group
References: <3da2c0120812020100u66a94f9bk3c0e8a705bb6347e@mail.gmail.com>	 <49353322.6090802@cn.fujitsu.com> <3da2c0120812020536h31136aeemf56c2e71c0920c38@mail.gmail.com>
In-Reply-To: <3da2c0120812020536h31136aeemf56c2e71c0920c38@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sudhir kumar wrote:
> On Tue, Dec 2, 2008 at 6:37 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> sudhir kumar wrote:
>>> Hi,
>>> I see an interesting bug in the cgroups. I found that cat /proc/cgroups
>>> does not decrease the num_cgroups field when a group is deleted. It looks
>>> to me that somewhere we miss to delete the reference, which leads to a failure
>>> to unmount the cgroups filesystem.
>> Ah, it's not a bug. :)
> Oh Sorry!
>>> The steps to produce the bug are:
>>>
>>> mkdir /cpu
>>> mount -t cgroup -ocpu cgroup /cpu
>>> cd cpu
>>> mkdir group1;
>>> cd group1;
>>> /./while &              # an infinite loop
>> Seems whenever we create a background job, we'll have a pin to the directory where
>> the job is created. So though rmdir() removed the directory, the dentry's refcnt
> Thanks for that.
> Should not rmdir fail in such a case ? Otherwise there is no other way
> for the user than to kill his task and unmount the cgroup fs, in case
> he needs to do so. Or shall we change the pin to point to the target
> directory? No idea if I am demanding too much ;(
> 

You don't have to remove all the sub-dirs before umount cgroup fs. But if a process
has some pins to a directory, it's sure you can't umount the underlying fs, this
has nothing to do with cgroup.

