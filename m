Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063Ab0AMB5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab0AMB5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170Ab0AMB47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:56:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:42713 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159Ab0AMB47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:56:59 -0500
Message-ID: <4B4D2811.7000001@kernel.org>
Date: Tue, 12 Jan 2010 17:55:29 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 5/5] x86: use dmi check to treat disabled cpus as
 hotplug cpus.
References: <1263338274-6485-1-git-send-email-yinghai@kernel.org>	 <1263338274-6485-5-git-send-email-yinghai@kernel.org>	 <1263340563.2854.1011.camel@sbs-t61.sc.intel.com>	 <4B4D0E39.10200@kernel.org> <1263347315.2854.1296.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1263347315.2854.1296.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 05:48 PM, Suresh Siddha wrote:
> On Tue, 2010-01-12 at 16:05 -0800, Yinghai Lu wrote:
>> On 01/12/2010 03:56 PM, Suresh Siddha wrote:
>>> On Tue, 2010-01-12 at 15:17 -0800, Yinghai Lu wrote:
>>>> some systems that have disable cpus entries because same
>>>>   BIOS will support 2 sockets and 4 sockets and more at
>>>>   same time, BIOS just leave some disable entries, but
>>>>   those system do not support cpu hotplug. we don't need
>>>>   treat disabled_cpus as hotplug cpus.
>>>> so we can make nr_cpu_ids smaller and save more space
>>>>   (pcpu data allocations), and could make some systems run
>>>>   with logical flat instead of physical flat apic mode
>>>>
>>>> -v2: change to black list instead
>>>
>>> I don't think this list will work because every HT system with HT
>>> disabled in the bios shows that logical cpu as disabled.
>>
>> so you want to treat those disabled cpus in the those system as hotplug cpus or not?
> 
> They are really not hot plug cpus, so they can also take advantage of
> what you are trying to provide with this patch.

you mean this blacklist could be too long?

switch to whitelist for the box can treat disabled cpus as hotplug cpus?

> 
> Also I am very confused with what exactly you are doing with the dmi
> list..
> 
> +        printk(KERN_NOTICE "%s detected: treat disabled cpus as hotplug ones\n", d->ident);
> +        treat_disabled_cpus_as_hotplug = 0;
> 
sorry, forget to change the print out.

YH
