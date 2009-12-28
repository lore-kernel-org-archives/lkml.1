Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbZL1LMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbZL1LMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZL1LMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:12:35 -0500
Received: from nat.nue.novell.com ([195.135.221.3]:58903 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751168AbZL1LMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:12:35 -0500
Message-ID: <4B3892A1.9010303@suse.de>
Date: Mon, 28 Dec 2009 14:12:33 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Xiaotian Feng <dfeng@redhat.com>
CC: Pavel Machek <pavel@ucw.cz>, Alexey Starikovskiy <aystarik@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [PATCH -V2] acpi: don't cond_resched if irq is disabled
References: <20091210100907.GA2446@ucw.cz> <1260446205-16868-1-git-send-email-dfeng@redhat.com> <4B20E7B2.1010208@suse.de> <1260510373.10543.17.camel@minggr.sh.intel.com> <4B223185.80202@suse.de> <20091211161549.GA15760@elf.ucw.cz> <4B227275.5010201@gmail.com> <20091211173424.GC15760@elf.ucw.cz> <4B3849F6.1080403@redhat.com>
In-Reply-To: <4B3849F6.1080403@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaotian Feng пишет:
> On 12/12/2009 01:34 AM, Pavel Machek wrote:
>>
>>>>> If there are none, fine.
>>>>>
>>>>>> #ifdef CONFIG_PREEMPT
>>>>>> # define preemptible()  (preempt_count() == 0&&  !irqs_disabled())
>>>>>> # define IRQ_EXIT_OFFSET (HARDIRQ_OFFSET-1)
>>>>>> #else
>>>>>> # define preemptible()  0
>>>>>> # define IRQ_EXIT_OFFSET HARDIRQ_OFFSET
>>>>>> #endif
>>>>>>
>>>>
>>>> Well, normally we want low latency even for !CONFIG_PREEMPT kernels.
>>>>
>>>> Actually, explicit preemption points are NOPs for CONFIG_PREEMPT
>>>> kernels, right?
>>
>>> Right. Do you have code?
>>
>> I'd prefer to spend my time with patches to areas that actually do
>> take cleanup patches.
> 
> What's the status of this now? We can still see the sleeping function
> call warning or enable irq at resume stage.
> If acpi wants low latency even for !CONFIG_PREEMPT kernels, what's wrong
> with V2 patch?
> 
> We should not set any preemption points in irq or atomic. Since we have
> a simple fix, and it did fix bugs, why should
> we make things more complex?
We should not do anything complex here, you are right.
Consider me ACK your patch.

Thanks,
Alex

