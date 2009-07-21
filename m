Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbZGULNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbZGULNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 07:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZGULNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 07:13:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38751 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbZGULNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 07:13:51 -0400
Message-ID: <4A65A2B6.6050404@redhat.com>
Date: Tue, 21 Jul 2009 19:12:54 +0800
From: Danny Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: menage@google.com, lizf@cn.fujitsu.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: fix reverse unlock sequence in cgroup_get_sb
References: <1248171926-20232-1-git-send-email-dfeng@redhat.com> <20090721111019.GV24157@balbir.in.ibm.com>
In-Reply-To: <20090721111019.GV24157@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2009 07:10 PM, Balbir Singh wrote:
> * Xiaotian Feng<dfeng@redhat.com>  [2009-07-21 18:25:26]:
>
>> In cgroup_get_sb, the lock sequence is:
>> 	mutex_lock(&inode->i_mutex);
>> 	mutex_lock(&cgroup->mutex);
>> so the last unlock sequence should be:
>> 	mutex_unlock(&cgroup->mutex);
>> 	mutex_unlock(&inode->i_mutex);
>>
>> Signed-off-by: Xiaotian Feng<dfeng@redhat.com>
>> ---
>>   kernel/cgroup.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 3737a68..11ef162 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -1140,8 +1140,8 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>>   		BUG_ON(root->number_of_cgroups != 1);
>>
>>   		cgroup_populate_dir(root_cgrp);
>> -		mutex_unlock(&inode->i_mutex);
>>   		mutex_unlock(&cgroup_mutex);
>> +		mutex_unlock(&inode->i_mutex);
>>   	}
>>
>
> Seems reasonable to me. You might also want to mention that elsewhere
> the sequence is unlock cgroup_mutex followed by inode->i_mutex.
Yep, thank you very much:-)
>
> Acked-by: Balbir Singh<balbir@linux.vnet.ibm.com>
>
>

