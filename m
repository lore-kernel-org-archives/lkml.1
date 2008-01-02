Return-Path: <linux-kernel-owner+w=401wt.eu-S1757091AbYABXmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbYABXmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757590AbYABXl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:41:59 -0500
Received: from rtr.ca ([76.10.145.34]:3404 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197AbYABXl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:41:57 -0500
Message-ID: <477C2143.8090406@rtr.ca>
Date: Wed, 02 Jan 2008 18:41:55 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org>	<924EFEDD5F540B4284297C4DC59F3DEE2FAE6A@orsmsx423.amr.corp.intel.com>	<20071130142058.816d1693.akpm@linux-foundation.org>	<924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>	<4750CC78.9070105@rtr.ca>	<20071130190227.1976e682@laptopd505.fenrus.org>	<4750D180.6080001@rtr.ca> <20071130191816.3e744205@laptopd505.fenrus.org> <4750D585.1030200@rtr.ca>
In-Reply-To: <4750D585.1030200@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Fri, 30 Nov 2007 22:31:17 -0500
> Mark Lord <lkml@rtr.ca> wrote:
> 
>> Arjan van de Ven wrote:
>>> On Fri, 30 Nov 2007 22:14:08 -0500
>>> Mark Lord <lkml@rtr.ca> wrote:
>>>
>>>>> in -mm there is.. the QoS stuff allows you to set maximum
>>>>> tolerable
>>>> ..
>>>>
>>>> That's encouraging, I think, but not for 2.6.24.
>>>>
>>>>> latency. If your app cant take any latency, you should set
>>>>> those... and the side effect is that the kernel will not do
>>>>> long-latency C-states or P-state transitions..
>>>> ..
>>>>
>>>> I don't mind the cpufreq changing (actually, I want it to drop in
>>>> cpugfreq to save power and keep the fan off), but the C-states just
>>>> kill this app.
>>>>
>>>> The app is VMware.  I force the max_state=1 when launching,
>>> ah but then its' even easier... and can be done in 2.6.24 already.
>>> VMWare after all has a kernel module, and the latency stuff is in
>>> 2.6.23 and 2.6.24 available inside the kernel already.
>> ..
>>
>> Oh, I'm perfectly happy to write my own kernel module if that's what
> 
> all you need to do in your kernel module is call
> 
> add_latency_constraint("mark_wants_his_mouse", 5);
> 
> or so
..

Dredging up an old regression again now:

The "make my own module to replace /sys/.../max_cstate" doesn't work
for the single-core machine we use a lot around here.

VMware is totally sluggish unless I go to another text window and do this:

    while ( true ); do echo -n ; done

At which point VMware performs well again,
the same as with "echo 1 > max_cstate" in 2.6.23.

Anyone got any suggestions on how to fix this regression
or work around it for 2.6.24 ?

Thanks 


