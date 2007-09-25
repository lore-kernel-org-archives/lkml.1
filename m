Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbXIYOTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbXIYOTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbXIYOTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:19:42 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:39042 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751350AbXIYOTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:19:41 -0400
Message-ID: <46F918F8.1080808@suse.de>
Date: Tue, 25 Sep 2007 18:19:36 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alexey Starikovskiy <aystarik@gmail.com>,
       Damien Wyart <damien.wyart@free.fr>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Frans Pop <elendil@planet.nl>, linux-acpi@vger.kernel.org
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
References: <20070925065109.GA3080@localhost.localdomain> <200709251525.11752.rjw@sisk.pl> <46F909E0.4020000@suse.de> <200709251618.06064.rjw@sisk.pl>
In-Reply-To: <200709251618.06064.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday, 25 September 2007 15:15, Alexey Starikovskiy wrote:
>> Rafael J. Wysocki wrote:
>>> On Tuesday, 25 September 2007 14:53, Alexey Starikovskiy wrote:
>>>> Rafael J. Wysocki wrote:
>>>>> On Tuesday, 25 September 2007 14:05, Alexey Starikovskiy wrote:
>>>>>> Rafael J. Wysocki wrote:
>>>>>>> On Tuesday, 25 September 2007 13:45, Rafael J. Wysocki wrote:
>>>>>>>> On Tuesday, 25 September 2007 11:58, Damien Wyart wrote:
>>>>>>>>>>> No, I do not have CONFIG_ACPI_SLEEP set,
>>>>>>>>>>> because I do not have CONFIG_PM_SLEEP set,
>>>>>>>>>>> because I do not want SUSPEND and/or HIBERNATION.
>>>>>>>>>> Same answer from my side: I do not have CONFIG_ACPI_SLEEP for the same
>>>>>>>>>> reason (and this worked fine without them in rc7). I do not think
>>>>>>>>>> these settings should have changed between rc7 and rc8.
>>>>>>>> Well, we haven't changed much.
>>>>>>>>
>>>>>>>>> Also, another test I just did: on another computer, rc8 is fine
>>>>>>>>> regarding ACPI power off, even if CONFIG_ACPI_SLEEP is not set. I can
>>>>>>>>> provide config if needed.
>>>>>>>> On the box that fails to power off, can you please test -rc8 with these two
>>>>>>>> commits reverted:
>>>>>>>>
>>>>>>>> commit 5a50fe709d527f31169263e36601dd83446d5744
>>>>>>>> ACPI: suspend: consolidate handling of Sx states addendum
>>>>>>>>
>>>>>>>> commit f216cc3748a3a22c2b99390fddcdafa0583791a2
>>>>>>>> ACPI: suspend: consolidate handling of Sx states.
>>>>>>>>
>>>>>>>> and see if it works?
>>>>>>> If it does, please test the patch from this message
>>>>>>>
>>>>>>> http://marc.info/?l=linux-kernel&m=119052978117735&w=4
>>>>>>>
>>>>>>> on top of vanilla 2.6.23-rc8.
>>>>>> You will need one more patch on top of just mentioned one.
>>>>> Hm, why did you put acpi_target_sleep_state under CONFIG_SUSPEND?
>>>>>
>>>>> CONFIG_HIBERNATION needs acpi_target_sleep_state  too.
>>>> Agree, attaching updated patch.
>>> Well, please use "ifdef CONFIG_PM_SLEEP" instead of
>>> "if defined(CONFIG_SUSPEND)||defined(CONFIG_HIBERNATION)",
>>> as you did with the second block.
>> I was thinking about that, but it seem to be less clear... 
>> We need this variable only for suspend or hibernation, nothing else.
>> with pm_sleep it is not visible at all.
>>
>> Thoughts?
> 
> Well, PM_SLEEP is defined as (SUSPEND || HIBERNATION), please have a look
> at kernel/power/Kconfig, and it was introduced exactly for the conditions like
> this.
I've seen this then I wrote the patch :) See my point, it is not clear, 
that PM_SLEEP is equivalent to SUSPEND || HIBERNATION, one needs to 
grep Kconfig files to find that -- it means that code becomes less readable, 
and I would like to avoid that.
> 
> IOW, if we want something to be used for anything else than suspend or
> hibernation, it shouldn't be defined under PM_SLEEP.
Agree, but we should distinguish there it is better to use PM_SLEEP, 
and there it is better to use (SUSPEND || HIBERNATION) just to be more expressive...

Regards,
Alex.
