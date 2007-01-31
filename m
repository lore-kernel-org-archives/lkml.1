Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbXAaEwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbXAaEwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 23:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbXAaEwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 23:52:17 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:42051 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbXAaEwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 23:52:16 -0500
Message-ID: <45C0206E.9030505@in.ibm.com>
Date: Wed, 31 Jan 2007 10:21:58 +0530
From: Srinivasa DS <srinivasa@in.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, ashok.raj@intel.AU.IBM.COM,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com
Subject: Re: [Need Help] Cpuhotplug operations on 32-bit mode of xeon-64bit
 processor crashes the system.
References: <45B47200.6030908@in.ibm.com> <20070130163049.D32010@unix-os.sc.intel.com>
In-Reply-To: <20070130163049.D32010@unix-os.sc.intel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Siddha, Suresh B wrote:
> Sorry for my delayed response. I was away on vacation.
>
> What platform is this? what do you mean by crashing? Do you see a
> system freeze or oops?
>   
Its xeon-64 bit processor,running in 32-bit compatibility 
mode(i386-code). We have not seen this problem in x86_64 envioronment. 
It happens in 32-bit compatibility mode.

Problem is in calculation of apicid's and delivery of IPI's.

I saw a oops,when I do cpuhotplug operations on it.

If you want any further information,please free to ask.

Thanks
Srinivasa Ds

> thanks,
> suresh
>
> On Mon, Jan 22, 2007 at 01:42:48PM +0530, Srinivasa Ds wrote:
>   
>> I saw cpuhotplug operations on 32-bit mode of xeon-64bit processors 
>> crashing the system. This happens on latest 2.6.20-rc5 kernel also. Same 
>> (i386 cpuhotplug code) runs fine on xeon-32bit processors.
>> Steps to reproduce.
>> ====================
>> echo 0 > /sys/devices/system/cpu/cpu6/online
>> echo 1 > /sys/devices/system/cpu/cpu6/online
>> ================================
>> dmesg shows.
>> ==============
>> Breaking affinity for irq 4
>> cpu_mask_to_apicid: Not a valid mask!
>> CPU 6 is now offline
>> =======================
>>
>> On debugging the problem, I found that problem is not in cpuhotplug code 
>> but in apic part. Execution of  "stale" IPI's by onlined cpus(which we 
>> offlined earlier) is causing the crash. Now we need to debug,why IPI's 
>> are reaching the offlined cpu's too.
>>
>> 1)   During the calculation of apicid's, if cpu to which IPI has to 
>> deliver is not in
>> same apic cluster,it prints "Not a valid mask" error and returns "0xFF" 
>> which means broadcast the IPI's to all cpus(which are offlined too) and 
>> hence the problem.
>>
>> 2) I booted the system with maxcpus=2 boot parameter, and tried cpu 
>> hotplugging on it.
>> but still problem recreates(I think there is no concept of apic clusters 
>> if there are only 2 cpus). Hence it makes me to conclude that problem is 
>> in delivery of IPI's.
>>
>> So Iam completely stuck here. Iam not able to move forward in debugging. 
>> So could someone(may be intel folks) please throw some light on this.
>>
>> Thanks in advance
>>   Srinivasa DS
>>   LTC-IBM
>>     

