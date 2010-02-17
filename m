Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab0BQQdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:33:11 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:33538 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab0BQQdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:33:09 -0500
To: Cong Wang <amwang@redhat.com>
Cc: Octavian Purdila <opurdila@ixiacom.com>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>
Subject: Re: [net-next PATCH v4 1/3] sysctl: refactor integer handling proc code
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com>
	<201002161341.56206.opurdila@ixiacom.com>
	<4B7A991F.3040601@redhat.com>
	<201002161544.33086.opurdila@ixiacom.com>
	<4B7C178A.8010708@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 17 Feb 2010 08:33:03 -0800
In-Reply-To: <4B7C178A.8010708@redhat.com> (Cong Wang's message of "Thu\, 18 Feb 2010 00\:21\:30 +0800")
Message-ID: <m1zl37256o.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang <amwang@redhat.com> writes:

> Octavian Purdila wrote:
>> On Tuesday 16 February 2010 15:09:51 you wrote:
>>> Octavian Purdila wrote:
>>>> On Tuesday 16 February 2010 10:41:07 you wrote:
>>>>>> +static int proc_skip_wspace(char __user **buf, size_t *size)
>>>>>> +{
>>>>>> +     char c;
>>>>>> +
>>>>>> +     while (*size) {
>>>>>> +             if (get_user(c, *buf))
>>>>>> +                     return -EFAULT;
>>>>>> +             if (!isspace(c))
>>>>>> +                     break;
>>>>>> +             (*size)--; (*buf)++;
>>>>>> +     }
>>>>>> +
>>>>>> +     return 0;
>>>>>> +}
>>>>> In lib/string.c we have skip_spaces(), I think we can use it
>>>>> here instead of inventing another one.
>>>> I'm afraid we can't, skip_spaces does not accept userspace buffers.
>>> Well, you need to use copy_from_user() before call it.
>>>
>>
>> And how much would you copy? You need to either use a stack buffer and do a
>> loop copy or you would need to copy the whole userspace buffer which means we
>> need to allocate a kernel buffer. I think its much cleaner the way is
>> currently done.
>
> Yeah, maybe just a personal preference. :-/

There can be valid security reasons for copying all of the data before
processing it.

Semantically if we an guarantee that we either have processed the
entire buffer or failed the entire buffer and no changes have occurred
in the kernel that seems like a much easier semantic to work with in
user space.

Eric

