Return-Path: <linux-kernel-owner+w=401wt.eu-S1762512AbZLKLsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762512AbZLKLsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762587AbZLKLsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:48:21 -0500
Received: from nat.nue.novell.com ([195.135.221.3]:47939 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761013AbZLKLsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:48:20 -0500
Message-ID: <4B223185.80202@suse.de>
Date: Fri, 11 Dec 2009 14:48:21 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Xiaotian Feng <dfeng@redhat.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, "Moore, Robert" <robert.moore@intel.com>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH -V2] acpi: don't cond_resched if irq is disabled
References: <20091210100907.GA2446@ucw.cz>	 <1260446205-16868-1-git-send-email-dfeng@redhat.com>	 <4B20E7B2.1010208@suse.de> <1260510373.10543.17.camel@minggr.sh.intel.com>
In-Reply-To: <1260510373.10543.17.camel@minggr.sh.intel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lin Ming пишет:
> On Thu, 2009-12-10 at 20:21 +0800, Alexey Starikovskiy wrote:
>> Hi Xiaotian,
>>
>> I think, this is another round of "armor vs. bullet" race... It will hold until
>> might_sleep() logic changes again.
>>
>> Please consider using preemptible() -- IMHO this is the check we should perform 
>> in our case of voluntary preemption.
> 
> preemptible() may not work here because it always returns 0 for
> non-preemptible kernel.
Right, and it means that this machine does not care about low latency that much.
The reason we introduced the preemption point in the first place, was unacceptable latency
due to very long AML methods on some machines. We don't need this preemption point for normal
operation, this is exactly what voluntary preemption does -- allows those in hurry to pass by.
If there are none, fine.
> 
> #ifdef CONFIG_PREEMPT
> # define preemptible()  (preempt_count() == 0 && !irqs_disabled())
> # define IRQ_EXIT_OFFSET (HARDIRQ_OFFSET-1)
> #else
> # define preemptible()  0
> # define IRQ_EXIT_OFFSET HARDIRQ_OFFSET
> #endif
> 
Regards,
Alex.

