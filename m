Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab0BEJ1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 04:27:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756767Ab0BEJ1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 04:27:00 -0500
Message-ID: <4B6BE4E7.6050800@redhat.com>
Date: Fri, 05 Feb 2010 17:29:11 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org
Subject: Re: [Patch v2] sysfs: add lockdep class support to s_active
References: <20100205064622.4141.72867.sendpatchset@localhost.localdomain> <m14olwjc0n.fsf@fess.ebiederm.org>
In-Reply-To: <m14olwjc0n.fsf@fess.ebiederm.org>
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
>> problem. Based on his work and Peter's suggestion, I write this patch,
>> hopefully we can fix the warning completely.
>>
>> This patch put sysfs s_active into two classes, one is for PM, the other
>> is for the rest, so lockdep will distinguish them.
>>
>> 1. http://lkml.org/lkml/2010/1/10/282
> 
> What testing has this patch seen?
> 
> In particular does this work to actually clear up the pm case?
> 

Sorry, it seems that my machine doesn't support s2ram, I am still
trying to make it working...

I hope the reporters of this bug can help to test this patch.

Thanks.
