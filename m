Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553Ab0A2IgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0A2IgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 03:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338Ab0A2IgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 03:36:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab0A2IgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 03:36:01 -0500
Message-ID: <4B629E7F.5020200@redhat.com>
Date: Fri, 29 Jan 2010 16:38:23 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
References: <20100129070516.4058.77227.sendpatchset@localhost.localdomain> <m1eil9v0j9.fsf@fess.ebiederm.org>
In-Reply-To: <m1eil9v0j9.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Amerigo Wang <amwang@redhat.com> writes:
> 
>> Recently we met a lockdep warning from sysfs during s2ram or cpu hotplug.
>> As reported by several people, it is something like:
>>
>> [ 6967.926563] ACPI: Preparing to enter system sleep state S3
>> [ 6967.956156] Disabling non-boot CPUs ...
>> [ 6967.970401]
>> [ 6967.970408] =============================================
>> [ 6967.970419] [ INFO: possible recursive locking detected ]
>> [ 6967.970431] 2.6.33-rc2-git6 #27
>> [ 6967.970439] ---------------------------------------------
>> [ 6967.970450] pm-suspend/22147 is trying to acquire lock:
>> [ 6967.970460]  (s_active){++++.+}, at: [<c10d2941>]
>> sysfs_hash_and_remove+0x3d/0x4f
>> [ 6967.970493]
>> [ 6967.970497] but task is already holding lock:
>> [ 6967.970506]  (s_active){++++.+}, at: [<c10d4110>]
>> sysfs_get_active_two+0x16/0x36
>> [...]
>>
>> Eric already provides a patch for this[1], but it still can't fix the
>> problem. I add the missing part of Eric's patch and send these two patches
>> together, hopefully we can fix the warning completely.
>>
>> 1. http://lkml.org/lkml/2010/1/10/282
>>
>>
>> Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Reported-by: Miles Lane <miles.lane@gmail.com>
>> Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Thanks for following up on this.
> 
> I suspect we may want to create a separate class for each sysfs file
> instead of playing whack-a-mole and creating a subclass each time we
> have problems.
> 
> I don't see why the rules for one sysfs file should be the same as for
> any other sysfs file.
> 

I am confused, we don't know who created sysfs files unless we
separate them by subclasses, the way of your patch is very straight
ward.

