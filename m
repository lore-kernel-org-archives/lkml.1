Return-Path: <linux-kernel-owner+w=401wt.eu-S1760025AbZA2X0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025AbZA2X0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbZA2XZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:25:54 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:16412 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbZA2XZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:25:53 -0500
Message-ID: <49823AD7.3000502@oracle.com>
Date: Thu, 29 Jan 2009 15:25:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: allow 8 more cpus could be used
References: <49822B1D.9070708@kernel.org> <20090129224236.GD1465@elte.hu> <49823166.4010702@oracle.com> <20090129231259.GB29611@elte.hu> <49823869.4010406@oracle.com> <20090129232207.GC30601@elte.hu>
In-Reply-To: <20090129232207.GC30601@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49823ADB.0151:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> Ingo Molnar wrote:
>>> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>
>>>> Ingo Molnar wrote:
>>>>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>>>>
>>>>>> Impact: fix left out MARCO
>>>>>>
>>>>>> X86_PC will be always enabled. so need to check if we have bigsmp 
>>>>>> support built in before cut off more than 8 cpus.
>>>>> ah, that's a leftover reference to X86_PC. It can now be removed, together 
>>>>> with the Kconfig X86_PC option.
>>>>>
>>>>>> -#if defined(CONFIG_X86_PC) && defined(CONFIG_X86_32)
>>>>>> +#if defined(CONFIG_X86_PC) && !defined(CONFIG_X86_BIGSMP)
>>>>>>  	if (def_to_bigsmp && nr_cpu_ids > 8) {
>>>>>>  		unsigned int cpu;
>>>>>>  		unsigned nr;
>>>>> Could you please send a patch that removes both X86_PC and X86_BIGSMP - 
>>>>> and removes the above cutoff code too, so that it will be built-in all the 
>>>>> time?
>>>> and at what cost, please?
>>> the size difference between a bigsmp and a normal-smp x86 defconfig kernel 
>>> is 0.011%. Zero difference on a UP kernel. (And UP is what most of the 
>>> ultra-embedded systems are using)
>> That's static size?  how about cpu and apic table space?
> 
> What do you mean? What is your point and what is your exact question?

There used to be large CPU and APIC tables (depending on the MAX
number of these devices that are supported in a kernel).  Are those gone?

If not, then I agree with YH and CONFIG_BIGSMP is still needed/wanted
by small systems.

-- 
~Randy
