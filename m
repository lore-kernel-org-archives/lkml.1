Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648Ab0AMC2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0AMC2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 21:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219Ab0AMC2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 21:28:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:40434 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab0AMC2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 21:28:05 -0500
Message-ID: <4B4D2F49.6070509@kernel.org>
Date: Tue, 12 Jan 2010 18:26:17 -0800
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
References: <1263338274-6485-1-git-send-email-yinghai@kernel.org>	 <1263338274-6485-5-git-send-email-yinghai@kernel.org>	 <1263340563.2854.1011.camel@sbs-t61.sc.intel.com>	 <4B4D0E39.10200@kernel.org>	 <1263347315.2854.1296.camel@sbs-t61.sc.intel.com>	 <4B4D2811.7000001@kernel.org>	 <1263348363.2854.1360.camel@sbs-t61.sc.intel.com>	 <4B4D2C44.2060709@kernel.org> <1263349268.2854.1386.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1263349268.2854.1386.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 06:21 PM, Suresh Siddha wrote:
> On Tue, 2010-01-12 at 18:13 -0800, Yinghai Lu wrote:
>> On 01/12/2010 06:06 PM, Suresh Siddha wrote:
>>> On Tue, 2010-01-12 at 17:55 -0800, Yinghai Lu wrote:
>>>> you mean this blacklist could be too long?
>>>
>>> yes.
>>>
>>>>
>>>> switch to whitelist for the box can treat disabled cpus as hotplug
>>>> cpus?
>>>
>>> Do we really need all this? Systems which support physical hotplug
>>> typically have lot's of cpu's (mostly will have atleast > 8). Even if we
>>> really need to identify, then perhaps we can check if ACPI has any hints
>>> regarding the physical hotplug support at boot time (we should check
>>> with Andi Kleen or Len Brown on this).
>>>
>>> For now, I think we can keep it simple by using the detected enabled
>>> cpu's.
>>
>> sth like this ?
> 
> Well, I was referring more to the apic model selection than the prefill
> case. About this possible cpu's, will the wastage be more than few kb
> for few disabled cpu's.

for 8 sockets systems if only have two cpus instatalled.

that disabled cpus will be 6 * 8 * 2 = 96.

and per_cpu area is about per cpu 2M, so will waste about 96 x 2M

YH
