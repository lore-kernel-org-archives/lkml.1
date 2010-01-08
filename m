Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140Ab0AHVVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab0AHVVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 16:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088Ab0AHVV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 16:21:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44920 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab0AHVV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 16:21:28 -0500
Message-ID: <4B479F9D.7060907@zytor.com>
Date: Fri, 08 Jan 2010 13:11:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86: update nr_irqs according cpu num
References: <1262951595-1729-1-git-send-email-yinghai@kernel.org>	 <1262951595-1729-5-git-send-email-yinghai@kernel.org>	 <m1bph4o1il.fsf@fess.ebiederm.org> <4B4785C3.4030505@zytor.com> <86802c441001081206r1df18abdhbb9a882868cc6b39@mail.gmail.com>
In-Reply-To: <86802c441001081206r1df18abdhbb9a882868cc6b39@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2010 12:06 PM, Yinghai Lu wrote:
>>>
>>> Ouch!  Unless I misread this code this will leave nr_irqs at
>>> NR_IRQS_LEGACY. aka 16.
>>>
>>> Let's do something stupid and simple.
>>> nr_irqs = nr_cpus_ids * 256;  /* Semi-arbitrary number */
>>
>> This would be 1048576 on the biggest machines we currently support.
>> Now, the number of IRQ *vectors* is limited to
>> (224-system vectors)*(cpu count), so one could argue that if there is
>> anything that is not semi-arbitrary it would be that number, but that
>> doesn't account for vector sharing.
> 
> (256 - 32 - 16 - system_vectors) * cpu_count + 16
> 
> the 16 is legacy from IRQ0 to 15 has domain with all cpus set.
> 

... assuming you're on a platform with a legacy PIC.  I would like to
see the legacy PIC hard-coded assumptions to go away, and instead be
done as runtime allocations on the relevant platforms.

> some interface in /proc/interrupts need it to make sure sth in sequence.

I can't even parse this sentence, never mind figuring out what it would
mean.  Certainly there is a better way to do that?

	-hpa

