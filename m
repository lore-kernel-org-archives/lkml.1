Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbZGVBnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbZGVBnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 21:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZGVBnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 21:43:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48204 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414AbZGVBnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 21:43:00 -0400
Message-ID: <4A666E91.4090405@redhat.com>
Date: Wed, 22 Jul 2009 09:42:41 +0800
From: Danny Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: balbir@linux.vnet.ibm.com, Zefan Li <lizf.kernel@gmail.com>,
       menage@google.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: fix reverse unlock sequence in cgroup_get_sb
References: <1248171926-20232-1-git-send-email-dfeng@redhat.com> <20090721111019.GV24157@balbir.in.ibm.com> <8522a3d30907210438u6fce081fi835bf964d0c01e8a@mail.gmail.com> <20090721120106.GW24157@balbir.in.ibm.com> <4A66630C.3030303@cn.fujitsu.com>
In-Reply-To: <4A66630C.3030303@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2009 08:53 AM, Li Zefan wrote:
>>>> Seems reasonable to me. You might also want to mention that elsewhere
>>>> the sequence is unlock cgroup_mutex followed by inode->i_mutex.
>>>>
>>>> Acked-by: Balbir Singh balbir@linux.vnet.ibm.com
>>>>          
>>> No, the unlock order is irrelevant. It's the lock order that matters. So
>>> this patch
>>> fixes nothing.
>>>
>>> Xiaotian, you didn't run into deadlock, did you?
>>>
>>>        
>> Li, Consider the following
>>
>>
>> lock(A)
>> lock(B)
>> unlock(A)
>> unlock(B)
>>
>> Tomorrow if a unsuspecting programmer does this
>>
>> lock(A)
>> lock(B)
>> unlock(A)
>>
>> code block
>>
>> unlock(B)
>>
>>
>> What protects code block? lock B? Is that the intention?
>>
>>      
>
> I won't worry about that. If unlock order is a concern,
> we should have taught lockdep to detect it.
>
> Here's a reply from Linus on this issue:
>
> 	http://lkml.org/lkml/2008/10/8/150
>    
OK, this patch is trivial. Just for consistency with previous unlock 
sequence:-)
