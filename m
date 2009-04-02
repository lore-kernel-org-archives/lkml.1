Return-Path: <linux-kernel-owner+w=401wt.eu-S1764335AbZDBTOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764335AbZDBTOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbZDBTOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:14:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58919 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbZDBTOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:14:23 -0400
Message-ID: <49D50E4E.20103@redhat.com>
Date: Thu, 02 Apr 2009 22:13:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>,
       Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Define a UNIQUE value for AS_UNEVICTABLE flag
References: <1238690835.7359.16.camel@lts-notebook>	 <20090402095315.1098b6c3.akpm@linux-foundation.org> <2f11576a0904021102r19165d89le45563b438621e08@mail.gmail.com>
In-Reply-To: <2f11576a0904021102r19165d89le45563b438621e08@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> (cc to Avi)
>
>   
>>> [PATCH] Define UNIQUE value of AS_UNEVICTABLE
>>>
>>> Needed in 2.6.28, 2.6.29, ...
>>>
>>> A new "address_space flag"--AS_MM_ALL_LOCKS--was defined to use the next
>>> available AS flag while the Unevictable LRU was under development.  The
>>> Unevictable LRU was using the same flag and "no one" noticed.  Current
>>> mainline, since 2.6.28, has same value for two symbolic flag names.
>>>       
>> argh.
>>
>> What are the user-observable effects of the bug, and why didn't anyone
>> notice it until now?
>>     
>
> AS_MM_ALL_LOCKS is used by mmu_notifier. it mean it is used by only kvm.
> In the other hand,  AS_UNEVICTABLE mean unevictable shmem or ramfs.
>
> Then, if shmem opend process use ioctl(KVM_CREATE_VM), unevictable
> flag on the shmem accidentally turn off.
> but, fortunatelly, In modern desktop environment, only KVM control
> program use above ioctl. then, we can assume this doesn't use shmem
> and ramfs.
>
> Am I missing anything?
>   

Qemu, the main kvm user, indeed doesn't use shm or ramfs.  However it is 
not inconceivable that one day it will, as a way to share memory among 
guests.

It isn't surprising that no bug was observed, but let's fix it.

(If hugetlbfs is considered unevictable, then qemu can trigger this bug 
today)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

