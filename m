Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab0BPNFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 08:05:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab0BPNFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 08:05:04 -0500
Message-ID: <4B7A98C7.3070107@redhat.com>
Date: Tue, 16 Feb 2010 21:08:23 +0800
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
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com> <1266271241-6293-2-git-send-email-opurdila@ixiacom.com> <4B7A5A23.3080309@redhat.com> <201002161248.56598.opurdila@ixiacom.com>
In-Reply-To: <201002161248.56598.opurdila@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila wrote:
> On Tuesday 16 February 2010 10:41:07 you wrote:
> 
>>> +
>>> +     if (!write && !first && left && !err)
>>> +             err = proc_put_newline(&buffer, &left);
>>> +     if (write && !err)
>>> +             err = proc_skip_wspace(&buffer, &left);
>>> +     if (err == -EFAULT /* do we really need to check for -EFAULT? */ ||
>>> +         (write && first))
>>> +             return err ? : -EINVAL;
>> The logic here seems messy, adding one or two goto's may help?
>>
> 
> OK, I'll give it a try. 
> 
> What about the EFAULT check, is that really required?

I think so, it means to keep the errno to user-space when it is EFAULT,
right? This seems reasonable.

