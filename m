Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab0BQQSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:18:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab0BQQSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:18:11 -0500
Message-ID: <4B7C178A.8010708@redhat.com>
Date: Thu, 18 Feb 2010 00:21:30 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Octavian Purdila <opurdila@ixiacom.com>
CC: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [net-next PATCH v4 1/3] sysctl: refactor integer handling proc
 code
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com> <201002161341.56206.opurdila@ixiacom.com> <4B7A991F.3040601@redhat.com> <201002161544.33086.opurdila@ixiacom.com>
In-Reply-To: <201002161544.33086.opurdila@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila wrote:
> On Tuesday 16 February 2010 15:09:51 you wrote:
>> Octavian Purdila wrote:
>>> On Tuesday 16 February 2010 10:41:07 you wrote:
>>>>> +static int proc_skip_wspace(char __user **buf, size_t *size)
>>>>> +{
>>>>> +     char c;
>>>>> +
>>>>> +     while (*size) {
>>>>> +             if (get_user(c, *buf))
>>>>> +                     return -EFAULT;
>>>>> +             if (!isspace(c))
>>>>> +                     break;
>>>>> +             (*size)--; (*buf)++;
>>>>> +     }
>>>>> +
>>>>> +     return 0;
>>>>> +}
>>>> In lib/string.c we have skip_spaces(), I think we can use it
>>>> here instead of inventing another one.
>>> I'm afraid we can't, skip_spaces does not accept userspace buffers.
>> Well, you need to use copy_from_user() before call it.
>>
> 
> And how much would you copy? You need to either use a stack buffer and do a 
> loop copy or you would need to copy the whole userspace buffer which means we 
> need to allocate a kernel buffer. I think its much cleaner the way is currently 
> done.

Yeah, maybe just a personal preference. :-/

